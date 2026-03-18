# Disable-OneDriveContentApproval.ps1

A PnP PowerShell script that disables content approval (moderation) on the Documents library for a batch of OneDrive for Business sites supplied via CSV.

## Prerequisites

- [PnP.PowerShell](https://pnp.github.io/powershell/) module installed
- An account with SharePoint Admin rights on the target OneDrive sites
- A registered Entra ID app for interactive login (see setup below)
- Tenant ID

## One-Time App Registration

Run the following once as a Global Admin or SharePoint Admin to register the app and obtain a Client ID:
```powershell
Register-PnPEntraIDAppforInteractiveLogin -ApplicationName "PnP Interactive Login" -Tenant "contoso.onmicrosoft.com" -Interactive
```

Note the Client ID output — you will need it to run the script.

## Input CSV Format

The CSV must contain a single column with the header `OneDriveSiteUrl`:
```csv
OneDriveSiteUrl
https://contoso-my.sharepoint.com/personal/user1_contoso_com
https://contoso-my.sharepoint.com/personal/user2_contoso_com
```

## Usage
```powershell
.\Disable-OneDriveContentApproval.ps1 -CsvPath .\Version_flag_sites.csv -ClientId "your-client-id-here"
```

## Output

The script prints a status line per site to the console:

- 🟢 **Content approval disabled** — flag was on and has been turned off
- ⚪ **Already off** — no change needed
- 🔴 **Error** — connection or permission issue, with error message

## Notes

- The script authenticates interactively on the first site and reuses the cached token for all subsequent sites — no repeated prompts.
- Only the **Documents** library is targeted. Custom libraries with content approval enabled are not affected.
