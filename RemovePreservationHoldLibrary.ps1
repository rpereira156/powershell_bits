<# Many thanks to
https://www.reddit.com/r/Office365/comments/r1420f/exclude_a_users_onedrive_from_a_retention_policy/
https://www.sharepointdiary.com/2021/10/how-to-delete-files-from-preservation-hold-library.html
https://www.sharepointdiary.com/2019/04/empty-recycle-bin-onedrive-for-business-powershell.html
#>

# Connect to the Security & Compliance section
Connect-IPPSSession

#Define SiteURL with the user's OneDrive URL
$SiteURL = "https://company-my.sharepoint.com/personal/user_company_com/"
# Define the name of the library that needs ti be cleaned up
$ListName = "Preservation Hold Library"

# Set the user's OneDrive as an exception to the applicable compliance/retention/DLP rule
Set-RetentionCompliancePolicy -Identity "OneDrive for Business" -AddOneDriveLocationException $SiteURL

#Connect to the tenant, passing the user's private OneDrive URL as an parameter
Connect-PnPOnline -Url $SiteURL

# Clean the Preservation Hold Library
Get-PnPList -Identity $ListName | Get-PnPListItem -PageSize 100 -ScriptBlock {
    Param($items) Invoke-PnPQuery } | ForEach-Object { $_.Recycle() | Out-Null
}

#empty first stage recycle bin in onedrive for business site
Get-PnPRecycleBinItem -FirstStage -RowLimit 5000 | Clear-PnpRecycleBinItem -Force
 
#PowerShell to empty 2nd Stage recycle bin in onedrive for business
Get-PnPRecycleBinItem -SecondStage -RowLimit 5000 | Clear-PnpRecycleBinItem -Force

# Remove the exception
Set-RetentionCompliancePolicy -Identity "OneDrive for Business" -RemoveOneDriveLocationException $SiteURL
