# Checks Windows registry for an application and its version.
function Check_Program_Installed {
    [CmdletBinding()]
    Param(
        [Parameter(Position = 0, Mandatory=$true, ValueFromPipeline = $true)]
        $Name        
    )
    $app = Get-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*" | 
                Where-Object { $_.DisplayName -like $Name } | 
                Select-Object DisplayName, DisplayVersion, InstallDate, Version
    if ($app) {
        return $app.DisplayVersion | Out-String
    }
}

$back = Check_Program_Installed "ApplicationName"