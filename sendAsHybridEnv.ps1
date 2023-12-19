# In order to enable a user to 'send as' a distribution group synced from on-premises, you have to both add the rights on both environments
# https://learn.microsoft.com/en-us/powershell/module/exchange/add-recipientpermission?view=exchange-ps
# https://learn.microsoft.com/en-us/exchange/permissions#mailbox-permissions-and-capabilities-not-supported-in-hybrid-environments

Add-ADPermission -Identity DistributionGroupName -User JohnDoe -AccessRights ExtendedRight -ExtendedRights "Send As"

Connect-ExchangeOnline
Add-RecipientPermission "DistributionGroupName" -AccessRights SendAs -Trustee "John Doe"
