# Source https://stackoverflow.com/questions/56484733/get-samaccountname-from-display-name-into-csv
Import-Csv C:\Scripts\displaynames.csv | ForEach {Get-ADUser -Filter "DisplayName -eq '$($_.DisplayName)'" -Properties Name, SamAccountName, City, mail, DistinguishedName | 
Select Name,SamAccountName, City, mail, DistinguishedName} | Export-CSV -path C:\output\paininthebut.csv -NoTypeInformation
