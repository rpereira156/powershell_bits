# Function to check if a computer account is active in Active Directory
function Check-ComputerAccountStatus {
    param (
        [Parameter(Mandatory = $true)]
        [string]$ComputerName
    )

    try {
        # Import the Active Directory module if it's not already loaded
        if (-not (Get-Module -Name ActiveDirectory)) {
            Import-Module ActiveDirectory
        }

        # Get the computer account from Active Directory
        $computer = Get-ADComputer -Identity $ComputerName -Properties Enabled

        # Prepare the result object
        $result = New-Object PSObject -property @{
            ComputerName = $ComputerName
            Status       = if ($computer.Enabled) { 'Active' } else { 'Disabled' }
            Found        = $true
        }
    } catch {
        # If an error occurs (e.g., computer not found)
        $result = New-Object PSObject -property @{
            ComputerName = $ComputerName
            Status       = 'Error'
            Found        = $false
            ErrorMessage = $_.Exception.Message
        }
    }

    return $result
}

# Main script logic
function Process-ComputerList {
    param (
        [Parameter(Mandatory = $true)]
        [string]$FilePath,
        
        [Parameter(Mandatory = $true)]
        [string]$OutputCsvPath
    )

    # Initialize an array to store the results
    $results = @()

    # Read the list of computer names from the text file
    if (Test-Path $FilePath) {
        $computerNames = Get-Content -Path $FilePath
        foreach ($computerName in $computerNames) {
            # Trim any leading or trailing spaces from the computer name
            $computerName = $computerName.Trim()
            if ($computerName) {
                # Call the function to check the account status
                $result = Check-ComputerAccountStatus -ComputerName $computerName
                # Add the result to the array
                $results += $result
            }
        }

        # Export the results to a CSV file
        $results | Export-Csv -Path $OutputCsvPath -NoTypeInformation

        Write-Host "Results have been exported to '$OutputCsvPath'" -ForegroundColor Green
    } else {
        Write-Host "Error: The file '$FilePath' does not exist." -ForegroundColor Red
    }
}

# Example usage: Provide the path to the text file containing the list of computer names and the output CSV file
$filePath = Read-Host "Enter the path to the text file with computer names"
$outputCsvPath = Read-Host "Enter the path where you want to save the CSV file"

Process-ComputerList -FilePath $filePath -OutputCsvPath $outputCsvPath
