# Oefening 7

# Herneem vorige oefening voor één instantie van de klasse 
# (maakt niet uit welke instantie).
# Toon ook de inhoud van een beperkt aantal WMI-eigenschappen 
# (DeviceID, VolumeName, Description) van deze instantie. 
# Vraag ook de waarde van een systeemattribuut van deze instantie.
# Als je deze WMI-eigenschappen wilt ophalen voor alle instanties, 
# gebruik je dan best WMI-COM objecten of PS-WMI objecten?

clear

# get the service
$location = New-Object -ComObject "WbemScripting.SWbemLocator"
$service = $location.ConnectServer(".","root\cimV2")

# we need to find an instance of the Win32_LogicalDisk class
# for this, we need to open the WMI CIM Studio, and find the class
# once found, we can click on the Instances button on the right
# we pick one of these instances to proceed

# get the instance
$instance = $service.Get("Win32_LogicalDisk.DeviceID='C:'")

# see what the members are
$instance | Get-Member

# see what the properties are
$instance.Properties_ | select Name

# SOLUTION
$service.Get("Win32_LogicalDisk.DeviceID='C:'").Properties_ | 
	where { $_.Name -eq "DeviceID" -or 
			$_.Name -eq "VolumeName" -or 
			$_.Name -eq "Description" } | 
	select Name, Value

# Final question: get these properties for all the instances
# of the class
# Here, it's faster to use the PS-WMI objects (and not WMI-COM)

# get the instances
Get-WmiObject -Class "Win32_LogicalDisk"

# get the properties
Get-WmiObject -Class "Win32_LogicalDisk" | select DeviceId, 
	VolumeName, Description
