# Many thanks to https://adamtheautomator.com/powershell-foreach/
# and https://www.commandline.ninja/use-powershell-to-find-windows-svcs-configured-to-run-as-another-user/
# Usage .\GetServicesRunAs.ps1 -ServerList serverL.txt

# Set script parameter
param(
[parameter(Mandatory = $true)]
[String]$ServerList
)

# Get list of servers to check
$servers = Get-Content $ServerList

# Readability improvments
$ServiceName =  @{ Name = 'ServiceName'; Expression = {$_.Name}}
$ServiceDisplayname = @{ Name = 'Service DisplayName';  Expression = {$_.Caption}}

# Querioes each servers and appends the results to a .csv, else it fails
foreach ($server in $servers) {
    try {
	$result = Invoke-Command $server -ScriptBlock {
	Get-CimInstance -Class Win32_Service -filter "StartName != 'LocalSystem' AND NOT StartName LIKE 'NT Authority%' " } | Select-Object SystemName, $ServiceName, $ServiceDisplayname, StartMode, StartName, State | Export-Csv "C:\temp\ScheduledTaskExportTest.csv" -NoTypeInformation -Append
    }
    catch {
        Write-Output "$server - $($_.Exception.Message)"
    }
}
