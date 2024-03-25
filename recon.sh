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

# Function to execute a command with verbose logging
execute_command() {
    print_verbose "Executing: $1"
    eval "$1"
    local exit_code=$?
    if [ $exit_code -eq 0 ]; then
        print_verbose "Command succeeded: $1"
    else
        print_verbose "Command failed: $1"
    fi
    return $exit_code
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
                execute_command "subfinder -dL '${programDir}/roots.txt' -silent | dnsx -silent | anew -q '${programDir}/resolveddomains.txt'"
                execute_command "httpx -l '${programDir}/resolveddomains.txt' -t 75 -silent | anew '${programDir}/webservers.txt' | notify -silent -bulk"
                execute_command "smap -iL '${programDir}/resolveddomains.txt' | anew '${programDir}/openports.txt'"
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
