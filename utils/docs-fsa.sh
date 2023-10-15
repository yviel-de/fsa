#!/bin/bash
#
# helper util to test documentation
#  - traverses the repo in search for *.md files
#  - checks them for dead links
#  - checks ``` codeblocks for lang spec (for syntax highlighting)
#  - checks the individual role references against the full reference document

function usage {
    cat << EOF
Usage: docs-fsa.sh FILE [-v]

    FILE may be:
    - the relative path to a file
    - the keyword "all"

    -v will show passing checks in addition to the failed ones

    Checks ran:
    LINK: dead link, either weblink or to another .md file or folder with a README.md
    REF:  mismatching reference between <role>/README.md and docs/REFERENCE.md
    CODE: missing language spec at the start of a triple-backtick code block
EOF
    exit 0
}

if ! [ -d ./roles ]; then
    echo "Please run from the main folder"
    exit 1
elif [ "$#" -eq 0 ]; then
    usage
else
    while [ $# -gt 0 ]; do
        case "$1" in
            -v)
                verbose=true
                shift
                ;;
            all)
                targetfile="$(find ./ -type f -name "*.md")"
                shift
                ;;
            *)
                if [ -f "$1" ]; then
                    targetfile="$1"
                else
                    usage
                fi
                ;;
        esac
    done
    # required for link testing
    pwd=$(pwd)
    if [ "$1" == "-v" ]; then
        verbose=true
    elif [ -f "$1" ]; then
        targetfile="$1"
    fi
fi

# a couple functions to help for link checking
function check_url {
    url="$1"
    # wget is installed by default so we use that
    # it might randomly fail so we do multiple passes
    counter=0
    while true; do
        if ! wget "$url" -O /dev/null >/dev/null 2>&1; then
            let counter=counter+1
            if [ "$counter" -eq 5 ]; then
                echo "LINK: Checking $url ...FAIL!"
                let failcounter=failcounter+1
                failed=true
                break
            fi
        else
            if [ "$verbose" == "true" ]; then
                echo "LINK: Checking $url ...pass"
                let passcounter=passcounter+1
            else
                let passcounter=passcounter+1
            fi
            break
        fi
    done
}

function check_folder {
    folder="$(echo $1 | cut -d '/' -f1)"
    if ! [ -f "$folder/README.md" ]; then
        echo "LINK: $folder/ ...FAIL!"
        let failcounter=failcounter+1
    elif [ "$verbose" == "true" ]; then
        echo "LINK: $folder/ ...pass"
        let passcounter=passcounter+1
    else
        let passcounter=passcounter+1
    fi
}

function check_file {
    mdfile="$1"
    if ! [ -f "$mdfile" ]; then
        echo "LINK: $mdfile ...FAIL!"
        let failcounter=failcounter+1
    elif [ "$verbose" == "true" ]; then
        echo "LINK: $mdfile ...pass"
        let passcounter=passcounter+1
    else
        let passcounter=passcounter+1
    fi
}

# main loop
passcounter=0
failcounter=0
echo "################"
echo "STARTING CHECKS"
echo "################"
for file in $targetfile; do
    # since the links are relative we have to go there
    filename=$(echo "$file" | rev | cut -d '/' -f1 | rev)
    filepath=$(echo "$file" | rev | cut -d '/' -f2- | rev)

    echo "checking $(echo $file | cut -d '/' -f2-)"

    # find dead links in the file
    cd "$filepath" 2>/dev/null
    for linkline in $(cat $filename | grep '\[' | tr '(' '\n' | grep ')' | cut -d ')' -f1 | grep -v '#'); do
        # filter out edge cases
        if ! echo "$linkline" | grep -qE '<LINK>'; then
            # check contents and call function
            if echo "$linkline" | grep -q 'https://'; then
                check_url "$linkline"
            elif [ "$(echo $linkline | rev | cut -c1)" == "/" ]; then
                check_folder "$linkline"
            elif echo "$linkline" | grep -q '\.md'; then
                check_file "$linkline"
            fi
        fi
    done
    # and go back after we're done
    cd "$pwd"

    # check every codeblock marker's odd occurence for syntax marker
    if grep -q '```' "$file"; then
        if ! grep '```' "$file" | sed -n 'p;n' | grep -qE '```[a-z]+'; then
            echo "CODE: code blocks ...FAIL!"
            let failcounter=failcounter+1
        elif [ "$verbose" == "true" ]; then
            echo "CODE: code blocks ...pass"
            let passcounter=passcounter+1
        else
            let passcounter=passcounter+1
        fi
    fi

    # check every documentation key against the full reference
    oldifs=$IFS
    IFS="
"
    # couple of hardcoded exceptions unfortunately
    if ! echo "$file" | grep -qE "REFERENCE.md|fsa_molecule"; then
        for docline in $(grep -e '^|`' "$file"); do
            dockey="$(echo $docline | cut -d '`' -f2)"
            refline="$(grep ^\|\`$dockey\` ./docs/REFERENCE.md | cut -d '|' -f1-6)|"
            if [ "$docline" != "$refline" ]; then
                echo "REF: $dockey ...FAIL!"
                let failcounter=failcounter+1
            elif [ "$verbose" == "true" ]; then
                echo "REF: $dockey ...pass"
                let passcounter=passcounter+1
            else
                let passcounter=passcounter+1
            fi
        done
    fi
    IFS=$oldifs
done

echo "#### DONE ####"
echo "$(echo $passcounter + $failcounter | bc) total tests ran"
echo "$passcounter tests passed"
echo "$failcounter tests failed"
if [ "$failcounter" != "0" ]; then
    # for CICD purposes
    exit 1
fi
