# Get a list of users filtered by OU with mail and departmentNumber attributes. Strips out the header
$var = Get-ADUser -Filter * -SearchBase "OU=" -Properties * | Select-Object mail,@{N='Departmentnumber';E={$_.Departmentnumber[0]}} | ConvertTo-Csv -NoTypeInformation | Select-Object -Skip 1 | Out-File -FilePath C:\temp\batch_ALL.csv
