# Special thanks to Acer4605 at https://community.spiceworks.com/topic/2303446-how-can-i-delete-all-ad-groups-for-a-list-of-users
# In the csv file make sure you have a header with your samaccountname.

$users = import-csv c:\temp\toRemove.csv

foreach($user in $users){
$adgroups = Get-ADPrincipalGroupMembership -Identity $user.SamAccountName

foreach ($singlegroup in $adgroups)
{ # removing all groups except the domain user group
    if ($singlegroup.SamAccountName -notlike "*Domain Users*")
    {
      Remove-ADPrincipalGroupMembership -Identity $user.SamAccountName -MemberOf $singlegroup.SamAccountName -confirm:$TRUE
    }
}
}
