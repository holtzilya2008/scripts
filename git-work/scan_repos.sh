#!/bin/bash

# check if exactly two arguments are given
if [ "$#" -ne 2 ]; then
    echo "Usage: ./search_repos.sh repos.txt keywords.txt"
    exit 1
fi

# read the list of repositories and keywords from the provided files
repos=($(<"$1"))
keywords=($(<"$2"))

# get the total number of keywords
total_keywords=${#keywords[@]}

# iterate over the list of repositories
for repo in "${repos[@]}"; do
    # clone the repo
    git clone --depth 1 "$repo"

    # extract the repo name from the repo URL
    repo_name=$(basename "$repo" .git)

    # change to the cloned repository directory
    cd "$repo_name" || exit

    # iterate over the list of keywords
    for i in "${!keywords[@]}"; do
        keyword=${keywords[$i]}
        echo "Scanning for $keyword in $repo_name"

        # calculate the progress as a percentage
        progress=$(( (i+1) * 100 / total_keywords ))

        # print the progress on the same line, clearing the previous output
        echo -ne "Scanning repo $progress% \r"

        # search for the keyword in the source code
        grep -rnw '.' -e "$keyword" >> "../$repo_name.log"
    done

    # print a newline to separate the outputs from different repositories
    echo

    # change back to the parent directory
    cd .. || exit

    # if the repo directory exists, delete it
    if [ -d "$repo_name" ]; then
        rm -rf "$repo_name"
    fi
done
