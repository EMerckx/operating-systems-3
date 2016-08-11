# Oefening 8

# Bepaal het aantal "eigen" WMI-attributen van de klasse 
# Win32_LogicalDisk (met WMI-COM objecten en PS-WMI objecten).

clear

# WMI-COM object
$location = New-Object -ComObject "WbemScripting.SWbemLocator"
$service = $location.ConnectServer(".","root\cimv2")
$class = $service.Get("Win32_LogicalDisk")

# Get the properties and count them
echo "WMI-Object count:"
$class.Properties_.Count

echo " "

# PS-WMI object
# Get-WmiObject -Class "Win32_LogicalDisk" | Get-Member
$obj = Get-WmiObject -Class "Win32_LogicalDisk" | select -First 1

# Get the property count
echo "PS-WMI object"
$obj.__PROPERTY_COUNT

# This gives a wrong result
#$prop = $obj | Get-Member -MemberType "Property"
#$prop.Count
