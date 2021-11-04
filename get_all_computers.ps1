# Useful code to get the name of all computers in the domain
# Thank you https://morgantechspace.com/2016/02/get-list-of-computers-in-ad-using-powershell.html

Import-Module ActiveDirectory
Get-ADComputer -Filter * -Properties * | Select -Property Name,DNSHostName,Enabled,LastLogonDate | Export-CSV "C:\Temp\AllComputers.csv" -NoTypeInformation -Encoding UTF8
