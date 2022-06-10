#!/bin/sh
#
# performs testing for the fsa codebase
# requires linux-sed, time, script, and running pipenv shell
# usage: test.sh [lint/test] [role1 role2 role3]
# if nothing is specified everything is done

if [ -z $VIRTUAL_ENV ]; then
    echo "Please run pipenv shell before executing tests"
    exit 1
fi

# molecule produces a lot of output, we're using this to cut through the noise
function prettyprint {
    padding="$1"
    shift
    string="$@"
    length="$(echo -n $string | wc -c)"
    boxlength="$(echo $length + $padding + 2| bc)"

    box=$(for i in $(seq 1 $boxlength); do echo -n '#'; done)
    pad=$(for i in $(seq 1 $padding); do echo -n '#'; done)

    # bottom box only for molecule which produces a f* ton of output
    if [ "$action" == "test" ]; then echo "$box"; fi
    echo "$pad $string"
    if [ "$action" == "test" ]; then echo "$box"; fi
}

# we're using this to collect errors and print them together
errorlist="dummy,dummy,dummy"
function error {
    if ! [ "$1" == "results" ]; then
        # register the error
        role="$1"
        step="$2"
        substep="$3"
        errorlist="$errorlist;$role,$step,$substep"
    else
        if [ "$errorlist" != "dummy,dummy,dummy" ]; then
            # if any errors, output and quit
            prettyprint 2 "The following failures have occurred:"
            for failure in $(echo "$errorlist" | tr ';' '\n' | grep -v 'dummy,dummy,dummy'); do
                role=$(echo $failure | cut -d ',' -f1)
                step=$(echo $failure | cut -d ',' -f2)
                substep=$(echo $failure | cut -d ',' -f3)
                echo "## - $role failed $step $substep"
            done
            echo ""
            echo "## The failures have been logged in the roles' folders."
            exit 1
        fi
    fi
}

# we're using this to keep error logs
function record {
    # we're already in the `for role in` loop
    # but better safe than sorry
    name="$1"
    shift
    if [ "$cmdname" == "molecule" ]; then
        cmdname="$1"
        cmdparam="$2"
        filename="$cmdname-$cmdparam.log"
    else
        cmdname="$1"
        cmdparam=""
        filename="$cmdname.log"
    fi
    fullcmd="$@"
    logfile="$filename"
    script -efq -c "$fullcmd 2>&1" "$logfile" 2>/dev/null
    if [ "$?" -eq 0 ]; then
        # clean up the logfile if successful
        rm "$logfile"
    else
        # into the errorlist
        error $name $cmdname $cmdparam
    fi
}

# linting/testing switch
if [ "$1" == "lint" ]; then
    lintonly="true"
    shift
elif [ "$1" == "test" ]; then
    testonly="true"
    shift
fi

pwd="$(pwd)"

# if no role name is given we do all
if [ "$#" == 0 ]; then
    roles="$(find roles/ -maxdepth 1 -type d | sed 's/roles\///g' | grep -v '^$')"
else
    roles="$@"
fi
rolecount="$(echo $roles | wc -w)"

prettyprint 4 "STARTING TESTING RUN"
echo "Found $rolecount roles to test"

# we go one role at a time esp bc of testing resources, cant run 100 VMs in parallel
if ! [ "$testonly" == "true" ]; then
    action=lint
    for role in $roles; do
        prettyprint 2 "Linting Role $role"
        #record $role yamllint . -c $pwd/.yamllint
        #record $role ansible-lint -x yaml --write=all
        record $role ansible-lint roles/$role -c ./.ansible-lint
    done
fi
error results

if ! [ "$lintonly" == "true" ]; then
    action=test
    for role in $roles; do
        cd roles/$role
        if [ -d "molecule" ]; then
            prettyprint 4 "Testing role $role"
            prettyprint 2 "Destroying previous state"
            record $role molecule destroy
            prettyprint 2 "Creating test instances"
            record $role molecule create
            prettyprint 2 "Applying role"
            record $role molecule converge
            prettyprint 2 "Verifying idempotence"
            record $role molecule idempotence
            prettyprint 2 "Executing tests"
            record $role molecule verify
            prettyprint 2 "Destroying environment"
            record $role molecule destroy
        else
            prettyprint 4 "No role tests configured"
        fi
        cd $pwd
    done
fi
error results

prettyprint 4 "TESTING RUN COMPLETE"
echo "No errors detected"
