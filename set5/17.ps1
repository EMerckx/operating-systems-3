# Oefening 17

# Bepaal de naam van alle WMI-methodes van de klasse Win32_LogicalDisk

clear

$object = Get-WmiObject -List Win32_LogicalDisk
$methods = $object.Methods
$methods | select Name
