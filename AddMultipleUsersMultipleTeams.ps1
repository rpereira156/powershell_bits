# Thanks to Salaudeen Rajack from SharePoint Diary https://www.sharepointdiary.com/2018/05/add-members-to-office-365-group-using-powershell.html
# Prepare a .csv file with two headers: GroupID and Member
# GroupID being either the groupid itself or the group email
# Member being the user's UPN

#Connect to Exchange Online
Connect-ExchangeOnline
 
#PowerShell to Import Members to office 365 group from CSV
Import-CSV "C:\temp\grouplist.csv" | ForEach-Object {
    Add-UnifiedGroupLinks -Identity $_.GroupID -LinkType Members -Links $_.Member
    Write-host -f Green "Added Member '$($_.Member)' to Office 365 Group '$($_.GroupID)'"
}
 
#Disconnect Exchange Online
Disconnect-ExchangeOnline -Confirm:$False