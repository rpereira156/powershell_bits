Get-Content -Path ListOfAccounts.txt |
ForEach-Object {
Get-ADUser -LDAPFilter "(samaccountname=$_)" |
Select-Object -Property samaccountname,enabled
} | Out-File List.csv
