#Source https://serverfault.com/questions/601813/powershell-finding-all-of-users-group-memberships-and-kicking-it-out-of-them
#Removes user from all groups that he is a member of.
#Needs improvment since the user must remain a member of at least one group (primary group)

# 1. Retrieve the user in question:
$User = Get-ADUser "username" -Properties memberOf

# 2. Retrieve groups that the user is a member of
$Groups = $User.memberOf |ForEach-Object {
    Get-ADGroup $_
} 

# 3. Go through the groups and remove the user
$Groups | ForEach-Object { Remove-ADGroupMember -Identity $_ -Members $User -Confirm:$false}

# If you want to log every group membership you remove, just for the sake of easy recovery.
#$LogFilePath = "C:\BackupLocation\user_" + $User.ObjectGUID.ToString() + ".txt"
#Out-File $LogFilePath -InputObject $(User.memberOf) -Encoding utf8
