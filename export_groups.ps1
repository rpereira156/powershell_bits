# Export all groups to a CSV file
# Does not export group members
# Source https://techtips.tv/windows/powershell/powershell-export-all-active-directory-groups-to-csv/
# Source https://stackoverflow.com/questions/21518906/list-all-groups-and-their-descriptions-for-a-specific-user-in-active-directory-u

$file = "C:\temp\groupList.csv"
Get-ADGroup -Filter * -Properties * | Select-Object samAccountName, DistinguishedName, description | Export-Csv -NoTypeInformation -LiteralPath $file
