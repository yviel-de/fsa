#!/bin/bash
#
# ansible wrapper script for fsa
# its usage is documented in the *.md files
#
# dynamically builds and execs playbooks with consideration to:
# - individual remote_users and become_methods through special fsa hostvars
# - dynamically generated role and tag list
# - example:
#   * role A with tags B & C
#   * role X with tags Y and C
#   * `-c A` will run role A
#   * `-c A,X` will run role A and X
#   * `-c C` will run both roles with tag C
#   * `-c Y` will run role X with tag Y
#   * WARN: `-c A,Y` will run roles A and X, both with tag Y
#
# the format for exchanging data between functions is a comma-separated list
# the following architecture applies:
#
#                               ---> genpass
#                   if genpass /
#                             /      if quick
# start --> sanity_check --> parse_args --> build_playbook --> exec_play
#                               \                   ^
#                           else \                 /
# sanity_check():                 ---> map_tags --/
# - checks for files & dirs
# - sets devmode=true/false
# - doesn't exec the next step itself
#
# parse_args():
# - parses user-supplied args
# - checks for quick actions
# - if dynamic, sets tags=bar,foo
# - sets limit=bar,baz
#
# genpass():
# - takes no args, work standalone
#
# map_tags():
# - takes: tags:bar,foo,baz,faz
# - maps them against ansible roles & tags
# - creates filteredroles=bar,baz tagslist=foo,faz
# - if tag shows up in role, add role
# - if tag shows up in rolename, remove tag for ansible
#
# build_playbook():
# - consumes filteredroles, tagslist, groupslist
# - consumes fsa host_vars, builds become_method-groups
# - builds a master playbook w/ include for each group
# - which also sets up and destroys entries in ~/.ssh/config
#
# exec_play():
# - execs $playbook
# - palpatine.jpg
#
# tf_apply():
# - execs terraform plans within ./terraform


# two small helper functions
function abort {
    echo -ne "$@"
    echo "Aborting..."
    exit 1
}

clearlist=""
function cleanup {
    echo "Cleaning up..."
    # clear the run's master playbook, include files, anything else
    rm -rf $clearlist
    exit
}
trap cleanup SIGHUP SIGINT SIGQUIT SIGABRT SIGTERM EXIT

function usage {
        cat << EOF
Usage: fsa.sh -l host1,host2 [-r role1,role2] [-f] [-u] [-v] [--debug]
       fsa.sh [-p my_file.yml] [-g mypass] [-h]

    -l [--limit] host1,host2 or "all" - runs against selected hosts
    -r [--roles] role1,role2 - limits configuration to specific roles
    -c [--config] role1,role2 - same as --roles

    -u [--updates]: perform only updates
    -f [--finder]: run the ethernet-finder
    -v [--verbose]: show precise changes made

    -g [--genpass] mypassword - generate passwords and password hashes
    -p [--playbook] my_file.yml - executes an existing playbooks/my_file.yml
    -t [--terraform] - executes actions proposed in terraform plan stored in ./terraform
    -h [--help]: display this text

    --debug: output debug info
EOF
        exit 0
}

function sanity_check {
    # dev mode switch
    if [ -d host_vars ]; then
        # we're in a regular ansible dir
        devmode=true
        varsdir="host_vars"
        ansibledir="$(pwd)"
        versionstring="v0.3.0-dev"


    elif [ -d config ]; then
        # they would be overwritten
        if [ -d $ansibledir/host_vars ]; then
            abort "Can't use FSA with .fsa/host_vars in place.\nIf you don't know why it's there, chances are you can remove it."
        fi

        devmode=false
        varsdir="config"
        ansibledir="$(pwd)"
        versionstring="v0.3.0"
    else
        abort "Configuration not found.\nMake sure you're in an fsa $versionstring or ansible directory."
    fi

    # check if we're in a pipenv
    if [ -z $VIRTUAL_ENV ]; then
        pipenv="pipenv run"
    else
        pipenv=""
    fi

    echo "# fsa $versionstring #"
    inventory="$ansibledir/inventory"
    playbookfile="$(mktemp -p $ansibledir)"
    clearlist="$clearlist $playbookfile"


    # we need to build the inventory if it doesn't already exist
    if ! [ -f "$inventory" ]; then
        clearlist="$clearlist $inventory"
        # we need to make 2 passes since they need to be grouped together
        for machine in $(find $varsdir -type f | rev | cut -d '/' -f1 | rev | grep -vE ".git|README.md"); do
            if awk '/fsa:/,/^$/' "$varsdir"/"$machine" | grep -q k8s:; then
                if ! grep -q fsa_k8sclusters "$inventory" 2>/dev/null; then
                    echo "[fsa_k8sclusters]" >> "$inventory"
                fi
                echo "$machine" >> "$inventory"
            fi
        done
        for machine in $(find $varsdir -type f | rev | cut -d '/' -f1 | rev | grep -vE ".git|README.md"); do
            if ! awk '/fsa:/,/^$/' "$varsdir"/"$machine" | grep -q k8s:; then
                if ! grep -q fsa_regularboxes "$inventory" 2>/dev/null; then
                    echo "[fsa_regularboxes]" >> "$inventory"
                fi
                echo "$machine" >> "$inventory"
            fi
        done
    fi
}

function parse_args {
    args=""
    while [ $# -gt 0 ]; do
        case "$1" in
            -g|--genpass)
                genpass=true
                shift
                pass="$@"
                break
                ;;
            -l|--limit)
                limit="$2"
                shift 2
                ;;
            -c|--config|-r|--roles)
                tags="$2"
                shift 2
                ;;
            -u|--updates)
                updateonly=true
                shift
                ;;
            -f|--finder)
                finderonly=true
                finderlimit="$2"
                shift 2
                ;;
            -h|--help)
                helponly=true
                shift
                ;;
            -v|--verbose)
                verbose=true
                shift
                ;;
            -p|--playbook)
                if [ -f playbooks/"$2".yml ]; then
                    playbook="playbooks/$2.yml"
                    shift 2
                else
                    echo "playbooks/$2.yml not found"
                    helponly= true
                fi
                ;;
            -t|--terraform)
                tf_apply_exec=true
                shift
                ;;
            --debug)
                debug=true
                shift
                ;;
            *)
                echo "Argument $1 not recognized."
                helponly=true
                break
                ;;
        esac
    done

    # switches for quick actions
    # builtin stuff
    if [ "$genpass" == "true" ]; then
        genpass
        exit 0
    fi
    if [ "$helponly" == "true" ]; then
        usage
    fi
    # individual roles
    if [ "$updateonly" == "true" ]; then
        filteredroles="fsa_update"
        build_playbook

    elif [ "$finderonly" == "true" ]; then
        filteredroles="fsa_finder"
        limit="$finderlimit"
        build_playbook

    elif [ -f "$playbook" ]; then
        # we've been given a playbook file
        # we still create a playbook with fsa_connect
        # but then jump right to exec
        cat << EOF > "$playbookfile"
# fsa $versionstring
# You can see this file because FSA is running, or crashed on the last run
# It exists so that FSA knows to re-run all the triggers
# FSA will remove it automatically on the next successful run
- name: setup connection
  import_playbook: roles/fsa_connect/hostconnect.yaml
- name: execute playbook
  import_playbook: $playbook
EOF
        playbook="$playbookfile"
        exec_play

    elif [ "$tf_apply_exec" == "true" ]; then
        tf_apply

    else
        if [ "$limit" != "" ]; then
            map_tags
        else
            echo "Error: No hosts specified to run against."
            usage
        fi
    fi
}

function genpass {
    which openssl >/dev/null || abort "OpenSSL not found, required for generating passwords. Please install."
    read -p "Select host to run against: " targethost
    [ "$targethost" == "" ] && abort "Must specify a host in the inventory to generate password against."
    $pipenv ansible-inventory --inventory=$inventory --graph | grep -v \@ | tr -d '| -' | grep -q "$targethost" || abort "Couldn't find specified host in the inventory."
    uname=$(ssh "$targethost" "uname")
    if [ -z "$pass" ]; then
        pass="$(openssl rand -base64 24)"
    fi
    if [ "$uname" == "OpenBSD" ]; then
        syspass=$(ssh "$targethost" "echo $pass | encrypt")
        mailpass=$(ssh "$targethost" "echo $pass | smtpctl encrypt")
        echo "Cleartext: $pass"
        echo "Syspass: $syspass"
        echo "Mailpass: $mailpass"
    fi
    exit 0
}

function map_tags {
    echo "Reading configuration..."

    rawroles=$(find $ansibledir/roles -maxdepth 1 -type d | sort)
    availableroles=""
    filteredroles=""
    internal=""
    k8s=""
    vms=""

    # we need to add roles to their corresponding lists based on being internal or executable
    for role in $rawroles; do
        works_against=$(awk -v RS= '/### Works Against/' $role/README.md 2>/dev/null | grep -v 'Works Against')
        role_name=$(echo $role | rev | cut -d '/' -f1 | rev)
        echo $works_against | grep -q 'FSA-Internal' && internal+=",$role_name" || availableroles+=",$role_name"
    done;

    # removing leading and trailing commas
    internal=$(echo $internal | sed 's/^,//g' | sed 's/,$//g')
    availableroles=$(echo $availableroles | sed 's/^,//g' | sed 's/,$//g')

    if [ -z "$tags" ]; then
        filteredroles=$availableroles

    else
        # easiest way seems to be ansible-playbook --list-tags
        # write each role separately into the book such as to easily parse the output
        for role in $(echo "$availableroles" | tr ',' '\n'); do
            roletests="$roletests
# dummy hostname, not important here
- hosts: $role
  roles:
   - $role
"
        done

        testfile="$(mktemp -p $ansibledir)"
        clearlist="$clearlist $testfile"
        echo "$roletests" > "$testfile"
        # this cmd alone is half the runtime. might have to find a more efficient way
        results="$($pipenv ansible-playbook --list-tags $testfile 2>/dev/null)"

        # parse the results
        for role in $(echo "$availableroles" | tr ',' '\n'); do
            roletasks=$(echo "$results" | grep -A1 ": $role" | tail -1 | cut -d '[' -f2 | cut -d ']' -f1)

            for tag in $(echo "$tags" | tr ',' '\n'); do
                if echo "$role, $roletasks," | grep -q "$tag,"; then
                    filteredroles="$filteredroles,$role"
                fi
                if [ "$role" != "$tag" ]; then
                    if echo "$roletasks" | grep -q "$tag,"; then
                        if ! echo "$tagslist" | grep -q "$tag"; then
                            tagslist="$tagslist,$tag"
                        fi
                    fi
                fi
            done
        done
    fi

    tagslist="$(echo $tagslist | sed 's/^,//g' | sed 's/,$//g')"
    filteredroles="$(echo $filteredroles | sed 's/^,//g' | sed 's/,$//g')"

    # we need to add roles to their corresponding lists based on hosts they run against
    for role in $(echo $filteredroles | tr ',' '\n' ); do
        works_against=$(awk -v RS= '/### Works Against/' roles/$role/README.md 2>/dev/null | grep -v 'Works Against')
        role_name=$(echo $role | rev | cut -d '/' -f1 | rev)
        echo $works_against | grep -q 'Kubernetes' && k8s+=",$role_name"
        echo $works_against | grep -qe 'OpenBSD' -e 'Alpine' && vms+=",$role_name"
    done;

    vms=$(echo $vms | sed 's/^,//g' | sed 's/,$//g')
    k8s=$(echo $k8s | sed 's/^,//g' | sed 's/,$//g')

    build_playbook
}

function build_playbook {
    echo "Building playbooks..."
    playbookdir="$ansibledir"

    if [ -z "$limit" ]; then
        hostlist="$($pipenv ansible-inventory --inventory=$inventory --graph all | grep -v '@' | tr -d ' ','|','-' | tr '\n' ',')"
    else
        hostlist="$limit"
    fi

    # build the master playbook
    echo "# You can see this file because FSA crashed on the last run
# It exists so that FSA knows to re-run all the triggers
# FSA will remove it automatically on the next successful run
- name: setup connection
  import_playbook: roles/fsa_connect/hostconnect.yaml" > $playbookfile

    [ ! -z $vms ] && echo "
- hosts: fsa_regularboxes
  gather_facts: true
  roles:
$(echo $vms | tr ',' '\n' | sed 's/^/   - /g')" >> $playbookfile

    [ ! -z $k8s ] && echo "
- hosts: fsa_k8sclusters
  gather_facts: false
  roles:
$(echo $k8s | tr ',' '\n' | sed 's/^/   - /g')" >> $playbookfile

    playbook="$playbookfile"
    exec_play
}

function exec_play {
    args="--force-handlers"
    if ! [ -z "$limit" ]; then
        args="$args -l $limit"
    fi
    if ! [ -z "$tagslist" ]; then
        args="$args -t $tagslist"
    fi
    if [ "$debug" == "true" ]; then
        args="$args -vvv"
    elif [ "$verbose" == "true" ]; then
        args="$args --diff"
    fi
    if [ "$askpass" == "true" ]; then
        args="$args -K"
    fi
    if [ "$args" != "" ]; then
        ansiblecmd="$ansiblecmd $args"
    fi

    # peg parallel execution to nr of cpu cores
    procs=$(echo "2*$(cat /proc/cpuinfo | grep processor | wc -l)" | bc)
    args="$args -f $procs"

    # everythings there, just exec
    if ! [ "$devmode" == "true" ]; then
        cp -r config $ansibledir/host_vars
        clearlist="$clearlist $ansibledir/host_vars"
    fi
    ANSIBLE_CONFIG=$ansibledir/utils/ansible.cfg $pipenv ansible-playbook --inventory=$inventory $playbook $args
}

function tf_apply {
    tfdir="$ansibledir/terraform"
    if [ ! -d $tfdir ]; then
        echo "ERROR: $tfdir does not exist" && exit 1
    fi
    cd $tfdir && terraform apply
    exit 0
}

sanity_check
parse_args "$@"

