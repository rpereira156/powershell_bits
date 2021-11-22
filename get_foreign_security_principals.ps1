# Shows a list with all of the foreign security principals and its group membership in the domain

Get-ADObject -Filter {ObjectClass -eq "foreignSecurityPrincipal"} -Properties msds-principalname,memberof
