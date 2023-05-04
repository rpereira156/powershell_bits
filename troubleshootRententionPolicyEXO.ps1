# Troubleshooting legacy exchange retention tags. What to do if after 7 days retention policy has not kicked in yet
# My sincere thanks to
# https://o365info.com/manage-retention-policy-by-using/
# https://office365itpros.com/2018/12/10/reporting-the-managed-folder-assistant/

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

# Force start of MFA assistant in the mailbox if needed
Start-ManagedFolderAssistant -Identity johndoe@company.com -FullCrawl -AggMailboxCleanup
