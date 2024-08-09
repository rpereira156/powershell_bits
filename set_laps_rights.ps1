# Define the path to the text file containing the OUs
$ouFilePath = "C:\folder\list.txt"

# Import the LAPS module
Import-Module AdmPwd.PS

# Read the OUs from the file
$ous = Get-Content -Path $ouFilePath

foreach ($ou in $ous) {
    # Check if OU exists
    $ouDN = Get-ADOrganizationalUnit -Filter {DistinguishedName -eq $ou} -Properties DistinguishedName
    
    if ($ouDN) {
        Write-Host "Delegating local admin password reset rights to hosts within '$ou'"

        # Allow self password reset
        Set-AdmPwdComputerSelfPermission -OrgUnit $ouDN.DistinguishedName

        Set-AdmPwdReadPasswordPermission -OrgUnit $ouDN.DistinguishedName -AllowedPrincipals "your_AD_security_group"
    } else {
        Write-Warning "OU '$ou' not found."
    }
}
