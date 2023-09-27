# https://woshub.com/killing-windows-services-that-hang-on-stopping/

# Replace wuauserv with the service that is hanging
taskkill /F /FI "SERVICES eq wuauserv"

# Kills all processes that are hanging
taskkill /F /FI "status eq not responding"

# force stop the hang services on a remote computer
taskkill /S srv-fs01 /F /FI "SERVICES eq wuauserv"
