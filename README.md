# bash_recon
Passive reconnaissance with Bash | BugBounty Automation

## Overview
This Bash script is designed for performing reconnaissance on multiple programs within a specified base directory. It utilizes various reconnaissance tools to gather information about root domains, resolved domains, webservers, and open ports.

## Dependencies
Ensure the following tools are installed and available in your system:
- [subfinder](https://github.com/projectdiscovery/subfinder)
- [dnsx](https://github.com/projectdiscovery/dnsx)
- [httpx](https://github.com/projectdiscovery/httpx)
- [anew](https://github.com/tomnomnom/anew)
- [smap](https://github.com/akamai/smap)

Install these tools before running the script.

## Usage
1. Set the `baseDir` variable to the directory containing programs you want to perform reconnaissance on.
2. Run the script: `bash recon.sh`
3. Check the log file for any errors: `/path/recon_script.log`

## Error Handling
If the script encounters any errors during execution, detailed information will be logged in the specified log file. Check the log file to troubleshoot and resolve issues.

## Log File
The script logs its output and any errors to a log file located at `/path/recon_script.log`.

Feel free to customize the script according to your specific needs.
