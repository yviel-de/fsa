#!/bin/bash
#
# exports .box from existing qemu vm
# - generates box.img
# - adds box.img to vagrant
# - can connect to remove libvirtd host

# shows script usage
function usage {
    cat << EOF
Usage: vagrant-fsa.sh --domain domain [--vagrant] [--boxname boxname] [--force] [--virthost] [--boxdir]

	--domain specifies the libvirt vm to export
	--vagrant adds box to vagrant
	--boxname the name in which it's added to vagrant, required if --vagrant is specified. defaults to domain name
	--force forcefully replaces any existing box with same name
	--virthost specifies the name of the reomte libvirt host
	--boxdir specifies where to store the .box file in the remote libvirt host. Defaulting to current dir.
EOF
	exit 0
}

# main function
function main {
	installation_checks
	parse_args "$@"
	check_domain
	generate_box
	if [ "$vagrant" == "true" ]; then
		vagrant_add
	fi
}

function run_cmd {
	if [ "$ssh" != "" ]; then
		$ssh "$@"
	else
		eval "$@"
	fi
}

# checks if necessary packages are installed
function installation_checks {
	# libvirt check
	if ! run_cmd which virsh; then
		echo "Please install libvirt."
		exit 1
	fi

	# vagrant check
	if ! run_cmd which vagrant; then
		echo "Please install vagrant."
		exit 1
	fi
}

# parses shell arguments
function parse_args {
	# if no argument is specified, show usage
	[ $# == 0 ] && usage

	# store arguments
	while [ $# -gt 0 ]; do
		case $1 in
			--domain)
				export domain="$2"
				shift 2
				;;
			--vagrant)
				export vagrant="true"
				shift
				;;
			--boxname)
				export boxname="$2"
				shift 2
				;;
			--force)
				export force="true"
				shift
				;;
			--virthost)
				export ssh="ssh $2"
				shift 2
				;;
			--boxdir)
				export box_dir="$2"
				shift 2
				;;
			*)
				usage
				;;
		esac
	done

	# checks if --domain argument is specified
	if [ "$domain" == "" ]; then
		echo "Error: Domain is not specified"
		exit 1
	fi

	# checks if --boxname argument is specified
	if [ "$boxname" == "" ]; then
		export boxname=$domain
	fi

	if [ "$ssh" == "" ]; then
		export ssh=""
	fi

	if [ "$box_dir" == "" ]; then
		export box_dir=$($ssh pwd)
	fi

	# privesc check
	if [ "$($ssh whoami)" != "root" ]; then
		if [ "$($ssh uname)" == "Linux" ]; then
			sudo="sudo"
		else
			sudo="doas"
		fi
	else
		sudo=""
	fi

	export qemu_uri="qemu:///system"
}

# checks existence of domain on machine and retrieves info
function check_domain {
	# checks if domain exists
	if [ "$(run_cmd virsh --connect $qemu_uri list --all | grep -we $domain)" == "" ]; then
		echo "Error: Specified domain does not exist on machine"
		exit 1
	fi

	# checks if domain is running
	if run_cmd virsh --connect $qemu_uri list --all | grep -we "$domain" | grep "running" &>/dev/null; then
		echo "Box is running. Will be shut down (and then started again)."
		# turn off domain if it's running (for copying disk file)
		run_cmd virsh --connect $qemu_uri destroy $domain
		export box_stopped="true"
	fi

	# gets domain's disk path
	export disk_img=$(run_cmd virsh --connect $qemu_uri dumpxml $domain | grep -m 1 -e 'img' | cut -d "'" -f 2)
	# gets domain's disk size
	echo "Getting disk size with qemu-img. Might require root access."
	export disk_size=$(run_cmd $sudo qemu-img info $disk_img | grep 'virtual size' | cut -d ' ' -f 3)
}

# generates .box file from the disk file
function generate_box {
	# makes temporary directory for the files
	temp_dir="$($ssh mktemp -d)"
	# writes metadata.json file in temporary directory
	echo "
{
	\"provider\": \"libvirt\",
	\"format\": \"qcow2\",
	\"virtual_size\": $disk_size
}" | run_cmd "cat > $temp_dir/metadata.json"

	echo "
Vagrant.configure(\"2\") do |config|
  config.vm.provider :libvirt do |libvirt|
    libvirt.driver = \"kvm\"
    libvirt.host = \"\"
    libvirt.connect_via_ssh = false
    libvirt.storage_pool_name = \"default\"
  end
    config.vm.synced_folder \".\", \"/vagrant\", disabled: true
end" | run_cmd "cat > $temp_dir/Vagrantfile"

	# copies the disk file to the temporary directory
	run_cmd $sudo cp $disk_img $temp_dir/box.img && $ssh $sudo chown $USER:$USER $temp_dir/box.img
	# generate the box file
	run_cmd "cd $temp_dir && tar cv metadata.json Vagrantfile box.img | gzip -c > $box_dir/$boxname.box"

	# deletes temporary directory
	run_cmd rm -rf $temp_dir

	# start the domain if it was stopped
	[ "box_stopped" == "true" ] && run_cmd virsh --connect $qemu_uri start $domain
}

# adds box to vagrant
function vagrant_add {
	if [ "$force" != "true" ] && $(run_cmd vagrant box list | grep -we $boxname); then
		echo "Error: A Vagrantbox with name \`$boxname\` already exists on your system. To forcefully replace it please specify --force flag."
		exit 1
	fi

	[ "$force" == "true" ] && run_cmd vagrant box add $box_dir/$boxname.box --name $boxname --force || vagrant box add $box_dir/$boxname.box --name $boxname
}

main $@
