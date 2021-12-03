# Export all groups to a CSV file
# Does not export group members
# Source https://techtips.tv/windows/powershell/powershell-export-all-active-directory-groups-to-csv/
# Source https://stackoverflow.com/questions/21518906/list-all-groups-and-their-descriptions-for-a-specific-user-in-active-directory-u

Get-ADGroup -Properties samAccountName, DistinguishedName, description, Members -Filter '*' |
    Select-Object -Property samAccountName, DistinguishedName, description , @{
        Name       = 'MemberCount'
        Expression = {$_.Members.Count}
    } | Export-Csv -Path 'C:\temp\groupList.csv'
