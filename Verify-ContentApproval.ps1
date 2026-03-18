# Verify-ContentApproval.ps1
# Requires: PnP.PowerShell module
# CSV expected columns: OneDriveSiteUrl

param(
    [Parameter(Mandatory)]
    [string]$CsvPath,

    [Parameter(Mandatory)]
    [string]$ClientId  # Entra ID App Registration Client ID
)

$logPath = ".\ContentApprovalReport_$(Get-Date -Format 'yyyyMMdd_HHmmss').csv"
$results = [System.Collections.Generic.List[PSCustomObject]]::new()
$sites = Import-Csv -Path $CsvPath

foreach ($site in $sites) {
    try {
        Connect-PnPOnline -Url $site.OneDriveSiteUrl -Interactive -ClientId $ClientId

        $lib = Get-PnPList -Identity "Documents"

        if ($lib.EnableModeration) {
            Write-Host "$($site.OneDriveSiteUrl) — Content approval ON." -ForegroundColor Yellow
            $status = "On"
        } else {
            Write-Host "$($site.OneDriveSiteUrl) — Content approval off." -ForegroundColor Gray
            $status = "Off"
        }
    }
    catch {
        Write-Host "$($site.OneDriveSiteUrl) — Error: $($_.Exception.Message)" -ForegroundColor Red
        $status = "Error: $($_.Exception.Message)"
    }

    $results.Add([PSCustomObject]@{
        OneDriveSiteUrl = $site.OneDriveSiteUrl
        ContentApproval = $status
        Timestamp       = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
    })
}

$results | Export-Csv -Path $logPath -NoTypeInformation -Encoding UTF8
Write-Host "`nReport written to: $logPath" -ForegroundColor Green
