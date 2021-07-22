$LocalUsers = Get-ADUser -Filter {UserPrincipalName -like '*old.upn.com'} –SearchBase "OU=CORP,DC=OLD,DC=UPN,DC=COM" -Properties UserPrincipalName -ResultSetSize $null
$LocalUsers | foreach {$newUpn = $_.UserPrincipalName.Replace("old.upn.com","new.upn.com"); $_ | Set-ADUser -UserPrincipalName $newUpn}

#Check if the attributed syncronized
Connect-AzureAD
Get-AzureADUser -All $true | ? {$_.UserPrincipalName -like '*new.upn.com'}  | Select DisplayName,UserPrincipalName,ObjectId | Export-Csv -Path D:\file.csv
