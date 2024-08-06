# Define the path to the text file containing the OUs
$ouFilePath = "C:\Temp\OUlist.txt"

# Define the name of the GPO you want to link
$gpoName = "Your_GPO_Name"

# Import the Active Directory module
Import-Module ActiveDirectory

# Retrieve the GPO by name
$gpo = Get-GPO -Name $gpoName

if (-not $gpo) {
    Write-Error "GPO '$gpoName' not found."
    exit
}

# Read the OUs from the file
$ous = Get-Content -Path $ouFilePath

foreach ($ou in $ous) {
    # Check if OU exists
    $ouDN = Get-ADOrganizationalUnit -Filter {DistinguishedName -eq $ou} -Properties DistinguishedName
    
    if ($ouDN) {
        Write-Host "Linking GPO '$gpoName' to OU '$ou'"

        # Link the GPO to the OU
        New-GPLink -Name $gpoName -Target $ouDN.DistinguishedName -LinkEnabled Yes
    } else {
        Write-Warning "OU '$ou' not found."
    }
}
