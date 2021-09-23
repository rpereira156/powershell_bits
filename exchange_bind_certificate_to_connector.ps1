# Needed this for setting up a Hybrid environment between an Exchange Server 2016 and Exchange Online
# Exchange Hybrid Agent Wizard is supposed to setup the whole thing for you, but that didn't happen in my experience
# Prior to doing the steps here, I had to manually create a connector on Exchange Server allowing traffic coming from Exchange Online to Exchange Server (port 25, only whitelisted Microsoft IPs listed in the documentation)
# Needed to enable TLS authentication on the recently created connector, since it does not come enabled by default

# To check if you already have any certificate binded to the connector
Get-ReceiveConnector "{SERVER-NAME}\Default Frontend {SERVER-NAME}" | fl TlsCertificateName

# So you can see which certificates are currently intalled in the Server
Get-ExchangeCertificate

# Get the necessary certificate info
$cert = Get-ExchangeCertificate -Thumbprint {THUMBPRINT STRING}
$tlscertificatename = "<i>$($cert.Issuer)<s>$($cert.Subject)"

# Binds the certificate to the connectors
Set-ReceiveConnector "{SERVER-NAME}\From Office 365 to Exchange On-Premises" -TlsCertificateName $tlscertificatename
Set-ReceiveConnector "{SERVER-NAME}\Default Frontend {SERVER-NAME}" -TlsCertificateName $tlscertificatename
Set-ReceiveConnector "{SERVER-NAME}\Default {SERVER-NAME}" -TlsCertificateName $tlscertificatename

# If you need to clear the certificate assigned to a specific connector
Set-ReceiveConnector "{SERVER-NAME}\Default {SERVER-NAME}" -TlsCertificateName $null

<#
Documentation used:
https://docs.microsoft.com/en-us/exchange/troubleshoot/email-delivery/cannot-receive-mail-with-new-certificate
https://www.petenetlive.com/KB/Article/0001631
https://www.azure365pro.com/replacing-send-connector-certificate/
#>
