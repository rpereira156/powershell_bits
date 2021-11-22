# From https://itluke.online/2017/12/06/how-to-resolve-orphan-sid-account-name/

Get-ADObject -Filter {objectSid -eq 'S-1-2-33-1111111111-4444444444-55555555555-666'} -IncludeDeletedObjects -Properties *
