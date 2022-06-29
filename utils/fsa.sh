#!/bin/sh
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
# - creates roleslist=bar,baz tagslist=foo,faz
# - if tag shows up in role, add role
# - if tag shows up in rolename, remove tag for ansible
#
# build_playbook():
# - consumes roleslist, tagslist, groupslist
# - consumes fsa host_vars, builds become_method-groups
# - builds a master playbook w/ include for each group
# - which also sets up and destroys entries in ~/.ssh/config
#
# exec_play():
# - execs $playbook
# - palpatine.jpg
#

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
trap cleanup SIGHUP SIGINT SIGQUIT SIGABRT SIGKILL SIGTERM EXIT

function sanity_check {
    # dev mode switch
    if [ -d host_vars ]; then
        # we're in a regular ansible dir
        devmode=true
        varsdir="host_vars"
        ansibledir="$(pwd)"
        versionstring="v0.2.0-dev"


    elif [ -d config ]; then
        # they would be overwritten
        if [ -d $ansibledir/host_vars ]; then
            abort "Can't use FSA with .fsa/host_vars in place.\nIf you don't know why it's there, chances are you can remove it."
        fi

        devmode=false
        varsdir="config"
        ansibledir="$(pwd)"
        versionstring="v0.2.0"
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

    # we need to build the inventory if it doesn't already exist
    if ! [ -f "$inventory" ]; then
        clearlist="$clearlist $inventory"
        for machine in $(find $varsdir -type f | rev | cut -d '/' -f1 | rev); do
            # exempt the example host
            if ! echo "$machine" | grep -qE "^fsa-example-[A-Za-z]+-[A-Za-z]+$"; then
                echo "$machine" >> "$inventory"
            fi
        done
    fi
}

function parse_args {
    args=""
    while [ $# -gt 0 ]; do
        case $1 in
            -g|--genpass)
                genpass=true
                shift
                pass="$@"
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
                playbook="$2"
                shift 2
                ;;
            --debug)
                debug=true
                shift
                ;;
            *)
                echo "Unknown argument: $1"
                exit 1
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
        cat << EOF
#### $versionstring ####
-l [--limit] host1,host2 - limits execution to specific hosts
-c [--config] key1,key2 - limits configuration to specific keys
-r [--roles] key1,key2 - same as --config
-p [--playbook] my_file.yaml - executes an existing playbook file
-g [--genpass] mypassword - generate passwords and password hashes
-u [--updates]: perform only updates
-f [--finder]: run the fact-finder
-v [--verbose]: show detailed information about proceedings
--debug: show super-detailed information
-h [--help]: display this information
EOF
        exit 0
    fi
    # individual roles
    if [ "$updateonly" == "true" ]; then
        roleslist="fsa_update"
        build_playbook

    elif [ "$finderonly" == "true" ]; then
        roleslist="fsa_finder"
        limit="$finderlimit"
        build_playbook

    elif ! [ -z "$playbook" ]; then
        # we've been given a playbook file
        # we still create a playbook with fsa_connect
        # but then jump right to exec
        cat << EOF > "$ansibledir/.LASTRUN.fsa.tmp"
# fsa $versionstring
# You can see this file because FSA is running, or crashed on the last run
# It exists so that FSA knows to re-run all the triggers
# FSA will remove it automatically on the next successful run
- name: setup connection
  import_playbook: roles/fsa_connect/connect.yaml
- name: execute playbook
  import_playbook: $playbook
EOF
        playbook="$ansibledir/.LASTRUN.fsa.tmp"
        exec_play

    else
        map_tags
    fi
}

function genpass {
    which openssl >/dev/null || abort "OpenSSL not found, required for generating passwords. PLease install."
    read -p "Select host to run against: " targethost
    [ "$targethost" == "" ] && abort "Must specify a host in the inventory to generate password against."
    $pipenv ansible-inventory --inventory=$inventory --graph | grep -v \@ | tr -d '| -' | grep -q "$targethost" || abort "Couldn't find specified host in the inventory."
    uname=$(ssh "$targethost" "uname")
    if [ -z $pass ]; then
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
    # put all roles into a nice comma-separated list
    rawroles="$(find $ansibledir/roles/ -maxdepth 1 -type d | rev | cut -d '/' -f1 | rev | sed '/^$/d' | sort | tr '\n' ',')"
    # remove fsa-prefixed internal roles from selection
    availableroles="$(echo $rawroles | tr ',' '\n' | grep -v ^fsa_ | tr '\n' ',' | sed 's/,,/,/g')"

    if [ -z "$tags" ]; then
        # no tags defined, play all
        roleslist="$availableroles"

    else
        # easiest way seems to be ansible-playbook --list-tags
        # write each role separately into the book such as to easily parse the output
        for role in $(echo "$availableroles" | tr ',' '\n'); do
            roletests="$roletests
- hosts: $role
  roles:
   - $role
"
        done

        testfile="$(mktemp -p $ansibledir)"
        echo "$roletests" > "$testfile"
        # the cmd alone is half the runtime. might have to find a more efficient way
        results="$($pipenv ansible-playbook --list-tags $testfile 2>/dev/null)"
        rm -f "$testfile"

        # parse the results
        for role in $(echo "$availableroles" | tr ',' '\n'); do
            roletasks=$(echo "$results" | grep -A1 ": $role" | tail -1 | cut -d '[' -f2 | cut -d ']' -f1)

            for tag in $(echo "$tags" | tr ',' '\n'); do
                if echo "$role, $roletasks," | grep -q "$tag,"; then
                    roleslist="$roleslist,$role"
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
    # remove leading & trailing comma
    tagslist="$(echo $tagslist | sed 's/^,//g' | sed 's/,$//g')"
    roleslist="$(echo $roleslist | sed 's/^,//g' | sed 's/,$//g')"
    build_playbook
}

function build_playbook {
    echo "Building playbooks..."
    playbookdir="$ansibledir"
    playbookroles="$(echo $roleslist | tr ',' '\n' | sed 's/^/   - /g')"

    if [ -z "$limit" ]; then
        hostlist="$($pipenv ansible-inventory --inventory=$inventory --graph all | grep -v '@' | tr -d ' ','|','-' | tr '\n' ',')"
    else
        hostlist="$limit"
    fi

    # build the master playbook
    cat << EOF > "$ansibledir/.LASTRUN.fsa.tmp"
# fsa $versionstring
# You can see this file because FSA crashed on the last run
# It exists so that FSA knows to re-run all the triggers
# FSA will remove it automatically on the next successful run
- name: setup connection
  import_playbook: roles/fsa_connect/connect.yaml
- hosts: all
  gather_facts: false
  roles:
$playbookroles
EOF

    playbook="$ansibledir/.LASTRUN.fsa.tmp"
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
        args="$args -v --diff"
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
    # dont remove if run failed
    if [ "$?" -eq 0 ]; then
        clearlist="$clearlist $ansibledir/.LASTRUN.fsa.tmp"
    fi
}

sanity_check
parse_args "$@"

