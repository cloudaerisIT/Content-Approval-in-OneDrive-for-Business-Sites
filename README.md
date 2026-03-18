# Verify-Content-Approval-in-SPO

Checks whether content approval (moderation) is enabled on the Documents library for a list of OneDrive for Business sites via CSV. Outputs a color-coded status per site to the console and writes a timestamped CSV report to the directory where the script is run.

Expects .csv filename of "Version_flag_sites.csv" with header "OneDriveSiteURL" and contents of OneDrive Site URL:

(eg. https://[domain].sharepoint.com/personal/[sitepath]
