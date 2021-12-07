# Source: https://activedirectorypro.com/create-active-directory-security-groups-with-powershell/
# Create a csv file containing these columns: name, path, scope, category, description

Import-Module ActiveDirectory

#Import CSV
$groups = Import-Csv 'c:\temp\groupList.csv'


# Loop through the CSV
    foreach ($group in $groups) {

    $groupProps = @{

      Name          = $group.name
      Path          = $group.path
      GroupScope    = $group.scope
      GroupCategory = $group.category
      Description   = $group.description

      }#end groupProps

    New-ADGroup @groupProps
    
} #end foreach loop
