# Cleaning up a mailbox that has multiple aliases
# Said mailbox was tied to a retention policy before

Connect-ExchangeOnline

# We need the ExchangeObjectId to later apply the rentention policy, since there are other objects on the environment with the same alias johndoe@company.comm

Get-Mailbox -Identity johndoe@company.comm | ft ExchangeObjectId

# Creates the retention tag
New-RetentionPolicyTag -Name "Delete all items older than 28 days" -Type All -AgeLimitForRetention 28 -RetentionAction PermanentlyDelete

# Creates a retention policy linked with the tag previously created
New-RetentionPolicy "Delete all items older than 28 days" -RetentionPolicyTagLinks "Delete all items older than 28 days"

# Set the mailbox johndoe@company.comm with the retention policy previously created
Set-Mailbox -Identity <mailbox GUID here> -RetentionPolicy "Delete all items older than 28 days"

# This shows which retention policy is applied to the mailbox. Just for verification purposes
Get-Mailbox -Identity <mailbox GUID here> | ft RetentionPolicy
