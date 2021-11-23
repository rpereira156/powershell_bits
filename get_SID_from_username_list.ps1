# Thanks to vonPryz at https://stackoverflow.com/questions/19904086/powershell-script-for-ad-users-sid
# Get SIDs from users in userlist.txt (each user in its own row)

# Array for name&sid tuples
$users = @()

cat C:\temp\userlist.txt | % {
  # Syntax sugar
  $spSid = [Security.Principal.SecurityIdentifier]
  # Custom object for name, sid tuple
  $user = new-object psobject
  $user | Add-Member -MemberType noteproperty -name Name -value $null
  $user | Add-Member -MemberType noteproperty -name Sid -value $null
  $user.Name = $_
  $user.Sid = (New-Object Security.Principal.NTAccount($_)).Translate($spSid).Value
  # Add user data tuple to array
  $users += $user
}
# Export array contents into a CSV file
$users | Select-Object -Property Name,Sid | Export-Csv -NoTypeInformation C:\temp\sidlist.txt
