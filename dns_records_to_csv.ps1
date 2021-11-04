# Source https://chentiangemalc.wordpress.com/2018/10/17/extract-dns-records-to-csv-with-powershell/

[CmdletBinding()]
param(
[Parameter(Position=0)]
[String]$DNSServer)
 
$Zones = @(Get-DnsServerZone -ComputerName $DNSServer)
$Data = @() 
ForEach ($Zone in $Zones) {
    ($Zone | Get-DnsServerResourceRecord -ComputerName $DNSServer) | `
        Select-Object -Property `
            @{Label="Zone Name";expression={( $Zone.ZoneName )}},`
            DistinguishedName,`
            HostName,`
            RecordClass,`
            RecordType,`
            Timestamp,`
            TimeToLive,`
            @{label="Data";expression={
                $r = $_.RecordData
                switch ($_.RecordType)
                {
                    "A" { $r.IPv4Address.IPAddressToString }
                    "NS" { $r.NameServer }
                    "SOA" { 
                        "ExpireLimit=$($r.ExpireLimit);"+
                        "MinimumTimeToLive=$($r.MinimumTimeToLive);"+
                        "PrimaryServer=$($r.PrimaryServer);"+
                        "RefreshInterval=$($r.RefreshInterval);"+
                        "ResponsiblePerson=$($r.ResponsiblePerson);"+
                        "RetryDelay=$($r.RetryDelay);"+
                        "SerialNumber=$($r.SerialNumber)"
 
                    }
                    "CNAME" {  $r.HostNameAlias }
                    "SRV"{ 
                        "DomainName=$($r.DomainName);"+
                        "Port=$($r.Port);"+
                        "Priority=$($r.Priority);"+
                        "Weight=$($r.Weight)"
                    }
                    "AAAA" { $r.IPv6Address.IPAddressToString }
                    "PTR" { $r.PtrDomainName } 
                    "MX" {
                        "MailExchange=$($r.MailExchange);"+
                        "Prefreence=$($r.Preference)"
                    }
                    "TXT" { $r.DescriptiveText }
                    Default { "Unsupported Record Type" }
                }}
            }
}
