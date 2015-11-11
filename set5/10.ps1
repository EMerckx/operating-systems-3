# Oefening 10

# Bepaal het aantal instanties van Win32_LogicalDisk.
# Toon enkel het relatief pad van elke instantie. 
# Bekijk de mogelijkheden van het attribuut Path_

clear

# get the object
$object = Get-WmiObject -Class Win32_LogicalDisk

# count the instances
$amount = $object.Count
"Amount of instances: " + $amount

# show the relative path of every instance
# $first = $object | select -First 1
# $first
# $first.__RELPATH
$object | 
    select DeviceID, __RELPATH