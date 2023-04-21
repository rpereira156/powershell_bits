# Source https://stackoverflow.com/questions/56484733/get-samaccountname-from-display-name-into-csv
Import-Csv C:\Scripts\displaynames.csv | ForEach {Get-ADUser -Filter "DisplayName -eq '$($_.DisplayName)'" -Properties Name, SamAccountName, mail, DistinguishedName | 
Select Name,SamAccountName, mail, DistinguishedName} | Export-CSV -path C:\output\file.csv -NoTypeInformation
