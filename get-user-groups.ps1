$results = @()
$d = "`t"

# In -SearchBase use OU's distinguishedName
$Users = Get-ADUser -Filter * -SearchBase "OU="

foreach ($User in $Users) {  
   $currentUserGroups = (Get-ADUser $User.samaccountname -properties memberof).memberof 
   foreach ($group in $currentUserGroups) {        
       $var = New-Object -TypeName psobject -Property @{
           SID = $User.SamAccountName
           Name = $User.Name
           Group = (Get-ADGroup $group).samaccountname
       } | Select-Object SID, Name, Group
       $results += $var
   }
}

$results | Export-Csv -Delimiter $d -Encoding Unicode -Path C:\Temp\results.csv 
