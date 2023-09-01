# Sincere thanks to Kathy from M365scripts: https://m365scripts.com/exchange-online/bulk-import-contacts-office-365-powershell/ and the guys from O4635 info https://o365info.com/bulk-import-contacts-to-exchange-online-office-365-using-powershell-part-1-of-2/
# Run in PowerShell 7
# If the error "New-MailContact: Cannot bind argument to parameter 'Name' because it is an empty string." pops up, check the .csv. Excel added semicolons instead of just commas
# Check the data provided by the user beforehand
# The .csv file should be formatted with at least two fields: ExternalEmailAddress,Name
# Use the email address for both fields, since most of the emails to be blocked are marketing emails should as info@company.com, marketing@info.com, noreply@info.com. Otherwise you will have to come up with unique names to each contact.

Connect-ExchangeOnline

# Reads the csv and creates the contacts
Import-Csv C:\Temp\2nd_email_list.csv | foreach {New-MailContact -Name $_.Name -DisplayName $_.Name -ExternalEmailAddress $_.ExternalEmailAddress}

# Hides the contacts from the GAL
Import-CSV C:\Temp\2nd_email_list.csv | foreach {       
 $ExternalEmailAddress=$_.ExternalEmailAddress     
 Write-Progress -Activity "Updating contact $ExternalEmailAddress..."      
 Set-MailContact -Identity $ExternalEmailAddress -HiddenFromAddressListsEnabled $true 
 If($?)       
 {       
  Write-Host $ExternalEmailAddress Successfully updated -ForegroundColor Green      
 }       
 Else       
 {       
  Write-Host $ExternalEmailAddress - Error occurred –ForegroundColor Red      
 }       
}

# Name of the distribution list to which contacts will be added
$distributionList = "NoImport@contoso.com"

# Path to the CSV file containing contact information
$csvPath = "C:\Temp\2nd_email_list.csv"

# Read the CSV and add contacts to the distribution list
$contacts = Import-Csv -Path $csvPath

foreach ($contact in $contacts) {
    $emailAddress = $contact.ExternalEmailAddress
    Add-DistributionGroupMember -Identity $distributionList -Member $emailAddress
}

# Disconnect from Exchange Online
Disconnect-ExchangeOnline -Confirm:$false
