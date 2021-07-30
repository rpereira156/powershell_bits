#Get a list with old UPNs
Connect-AzureAD
Get-AzureADUser -All $true | ? {$_.UserPrincipalName -like '*old.upn.com'}  | Select DisplayName,ObjectId | Export-Csv -Path D:\aFile.csv

#Change UPNs
$LocalUsers = Get-ADUser -Filter {UserPrincipalName -like '*old.upn.com'} –SearchBase "OU=CORP,DC=OLD,DC=UPN,DC=COM" -Properties UserPrincipalName -ResultSetSize $null
$LocalUsers | foreach {$newUpn = $_.UserPrincipalName.Replace("old.upn.com","new.upn.com"); $_ | Set-ADUser -UserPrincipalName $newUpn}

#Check if the attribute syncronized
Get-AzureADUser -All $true | ? {$_.UserPrincipalName -like '*new.upn.com'}  | Select DisplayName,UserPrincipalName,ObjectId | Export-Csv -Path D:\file.csv

#Revoke old auth tokens so users are forced to use new UPN in previouly logged devices (and potentially avoid file sharing problems in Teams/OneDrive)
#When in doubt, read https://masterandcmdr.com/2019/03/27/force-teams-to-sign-out/
Revoke-AzureADUserAllRefreshToken -ObjectId 111111aaa2222bbbb3333ccccc444444
