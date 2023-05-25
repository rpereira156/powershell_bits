# This was tested with PowerShell 7 and the PnP module
# The idea behind it was to get a list of all of the public sites (Visibility property) in a certain tenant, and if such sites had a Teams channel available (HasTeam property)
# Many thanks to Marc from https://sympmarc.com/2022/01/27/get-all-the-public-or-private-team-sites-in-sharepoint-with-pnp-powershell/

Connect-PnPOnline -Interactive
Get-PnPMicrosoft365Group -IncludeSiteUrl | Where-Object { $_.Visibility -eq "Public"} | Export-Csv -Path C:\temp\ms365groups_public.csv
