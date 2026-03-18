# Disable-OneDriveContentApproval.ps1
# Requires: PnP.PowerShell module
# CSV expected columns: OneDriveSiteUrl

param(
    [Parameter(Mandatory)]
    [string]$CsvPath,

    [Parameter(Mandatory)]
    [string]$ClientId  # Entra ID App Registration Client ID
)

$sites = Import-Csv -Path $CsvPath

foreach ($site in $sites) {
    try {
        Connect-PnPOnline -Url $site.OneDriveSiteUrl -Interactive -ClientId $ClientId

        $lib = Get-PnPList -Identity "Documents"

        if ($lib.EnableModeration) {
            Set-PnPList -Identity "Documents" -EnableModeration $false
            Write-Host "$($site.OneDriveSiteUrl) — Content approval disabled." -ForegroundColor Green
        } else {
            Write-Host "$($site.OneDriveSiteUrl) — Already off." -ForegroundColor Gray
        }
    }
    catch {
        Write-Host "$($site.OneDriveSiteUrl) — Error: $($_.Exception.Message)" -ForegroundColor Red
    }
}
