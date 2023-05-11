# Troubleshooting legacy exchange retention tags. What to do if after 7 days retention policy has not kicked in yet
# My sincere thanks to
# https://o365info.com/manage-retention-policy-by-using/
# https://office365itpros.com/2018/12/10/reporting-the-managed-folder-assistant/
# https://techcommunity.microsoft.com/t5/exchange-team-blog/troubleshooting-compliance-retention-policies-in-exchange-online/ba-p/3754209
# https://techcommunity.microsoft.com/t5/exchange-team-blog/troubleshooting-retention-policies-in-exchange-online/ba-p/3750197
# https://learntechfuture.com/2018/08/10/find-oldest-email-in-a-exchange-mailbox/
# https://www.exchangeitup.net/2017/01/exchange-search-mailbox-delete-more.html

Connect-ExchangeOnline
# Make sure that the retention policy is set as expected
Get-RetentionPolicy -Identity "MyRetentionPolicy" | select -ExpandProperty retentionpolicytaglinks
$tags = Get-RetentionPolicy -Identity "MyRetentionPolicy" | select -ExpandProperty retentionpolicytaglinks
$tags | foreach {Get-RetentionPolicyTag $_ | ft Name, Type, Age*, Retention*}

# Get ExchangeObjectId of the troublesome mailbox
Get-Mailbox -Identity johndoe@company.com | ft ExchangeObjectId

# This will check when and if MFA has run. If it did ran, it will also show how many items were deleted (add -Identity if you want to run for only one mailbox)
$Mbx = Get-Mailbox -RecipientTypeDetails UserMailbox -ResultSize Unlimited
$Report = @()
ForEach ($M in $Mbx) {
   $LastProcessed = $Null
   Write-Host "Processing" $M.DisplayName
   $Log = Export-MailboxDiagnosticLogs -Identity $M.Alias -ExtendedProperties
   $xml = [xml]($Log.MailboxLog)  
   $LastProcessed = ($xml.Properties.MailboxTable.Property | ? {$_.Name -like "*ELCLastSuccessTimestamp*"}).Value   
   $ItemsDeleted  = $xml.Properties.MailboxTable.Property | ? {$_.Name -like "*ElcLastRunDeletedFromRootItemCount*"}
   If ($LastProcessed -eq $Null) {
      $LastProcessed = "Not processed"}
   $ReportLine = [PSCustomObject]@{
           User          = $M.DisplayName
           LastProcessed = $LastProcessed
           ItemsDeleted  = $ItemsDeleted.Value}      
    $Report += $ReportLine
  }
$Report | Select User, LastProcessed, ItemsDeleted

# In case you need to extract a report with the age of the items on the mailbox
# This will give you a .csv, apply filter as needed
Get-MailboxFolderStatistics -Identity johndoe@company.com -IncludeOldestAndNewestItems | select Identity, Name, FolderPath, ItemsInFolder, FolderSize, OldestItemReceivedDate | Export-Csv c:\temp\mbxStats.csv -NoTypeInformation

# Force start of MFA assistant in the mailbox if needed
Start-ManagedFolderAssistant -Identity johndoe@company.com -FullCrawl -AggMailboxCleanup

# If you need to forcefully delete items older than x days on a mailbox
# Bear in mind that since the marketingcloudbcc mailbox was at capacity, the command took a long time to run and timed out due to throttling policies on the EXO.
# But not to worry, you can simply execute the command again.
$Days=100
$date = (get-date).AddDays( - ($Days)).ToString("MM/dd/yyyy")
Search-Mailbox -Identity johndoe@company.com -SearchQuery received<=$date -DeleteContent -Force -ErrorAction Stop -WarningAction SilentlyContinue
