#!/bin/bash

baseDir="/opt/bounty"
logFile="/var/log/recon_script.log"


if [[ -d "$baseDir" ]]; then
    for programDir in "$baseDir"/*/; do
        if [[ -f "${programDir}/roots.txt" ]]; then
            programName=$(basename "$programDir")
            echo "Recon for $programName:"
            
            # Perform reconnaissance tasks and log output
	{
	    subfinder -dL "${programDir}/roots.txt" -silent | dnsx -silent | anew -q "${programDir}/resolveddomains.txt"
            httpx -l "${programDir}/resolveddomains.txt" -t 75 -silent | anew "${programDir}/webservers.txt" | notify -silent -bulk
            smap -iL "${programDir}/resolveddomains.txt" | anew "${programDir}/openports.txt"
    	} >> "$logFile" 2>&1
        else
            programName=$(basename "$programDir")
            echo "No root domains found for $programName!"
        fi
    done
else
    echo "Directory '$baseDir' does not exist."
fi
