# Displays group membership for a specific SID

Get-ADObject -filter "objectsid -eq 'S-1-1-11-2222222222-33333333333-444444444444-5555'" -Properties memberof | Select-Object -ExpandProperty memberof
