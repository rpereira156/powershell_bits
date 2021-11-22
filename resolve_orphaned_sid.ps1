# From https://itluke.online/2017/12/06/how-to-resolve-orphan-sid-account-name/

Get-ADObject -Filter {objectSid -eq 'S-1-5-21-2646872981-483399078-1445048048-512'} -IncludeDeletedObjects -Properties *
