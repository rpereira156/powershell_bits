# Get a list of users filtered by OU with mail and departmentNumber attributes. Strips out the header
$var = Get-ADUser -Filter * -SearchBase "OU=" -Properties * | Select-Object mail,@{N='Departmentnumber';E={$_.Departmentnumber[0]}} | ConvertTo-Csv -NoTypeInformation | Select-Object -Skip 1 | Out-File -FilePath C:\temp\batch_ALL.csv

#Get a list of all users in the domain with the lastLogon attribute
Get-ADUser -Filter * -Properties Name,LastLogon,Displayname, EmailAddress, Title | select Name,@{Name=’LastLogon’;Expression={[DateTime]::FromFileTime($_.LastLogon)}},DisplayName, EmailAddress, Title | Export-CSV “C:\temp\Email_Addresses.csv”

# Get a list of all users in the domain using lastLogonDate (this attribute search on both lastLogon and lastLogonTimestamp and shows up the most recent)
Get-ADUser -Filter {((Enabled -eq $true))} -Properties LastLogonDate | select samaccountname, Name, lastLogonTimestamp | Sort-Object lastLogonTimestamp | Export-CSV "C:\temp\users_lasLogonDate.csv"
