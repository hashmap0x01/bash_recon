#!/bin/bash

# Define default directory and log file paths
baseDir="$HOME/bounty"
logFile="$HOME/bounty/recon_script.log"
verbose=false

# Function to print verbose messages
print_verbose() {
    if [[ "$verbose" == "true" ]]; then
        echo "$1"
    fi
}

# Parse command-line options
while getopts ":v" opt; do
  case $opt in
    v)
      verbose=true
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
  esac
done

if [[ -d "$baseDir" ]]; then
    print_verbose "Starting reconnaissance..."
    for programDir in "$baseDir"/*/; do
        if [[ -f "${programDir}/roots.txt" ]]; then
            programName=$(basename "$programDir")
            echo "Recon for $programName:"
            print_verbose "Running reconnaissance tasks for $programName..."
            
            # Perform reconnaissance tasks with error handling and logging
            {
                subfinder -dL "${programDir}/roots.txt" -silent | dnsx -silent | anew -q "${programDir}/resolveddomains.txt"
                httpx -l "${programDir}/resolveddomains.txt" -t 75 -silent | anew "${programDir}/webservers.txt" | notify -silent -bulk
                smap -iL "${programDir}/resolveddomains.txt" | anew "${programDir}/openports.txt"
            } >> "$logFile" 2>&1 || echo "Error during reconnaissance for $programName!" >> "$logFile"

        else
            programName=$(basename "$programDir")
            echo "No root domains found for $programName!"
        fi
    done
    print_verbose "Reconnaissance completed."
else
    echo "Directory '$baseDir' does not exist."
fi

