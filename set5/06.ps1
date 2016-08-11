# Oefening 6

# Toon alle beschikbare properties van het WMI-COM-object 
# dat de klasse Win32_LogicalDisk representeert, vergelijk 
# dit met de properties van het PS-WMI-object dat deze klasse 
# representeert.
# Hoe kan je alle WMI-properties tonen van deze klasse.
# Toon de waarde van het WMI-attribuut __DERIVATION

# This is also possible with the Get-WmiObject method

clear

# first get the service
$location = New-Object -ComObject "WbemScripting.SWbemLocator"
$service = $location.ConnectServer(".","root\cimV2")

# get the class from the service
$class = $service.Get("Win32_LogicalDisk")

# view the members of the class
$class | Get-Member

# here we can see the properties Properies_ and SystemProperties_
# list the names of these two properties
$class.Properties_ | select Name
$class.SystemProperties_ | select Name

# in SystemProperties_ we see __DERIVATION
# via Item, we can view the values of this property
$class.SystemProperties_.Item("__DERIVATION")

# we can also see the full list of values with
$class.SystemProperties_.Item("__DERIVATION").Value


# OTHER SOLUTION (but not resulting in full list!)

# in SystemProperties_ we see __DERIVATION
# via the where clausule, we can view the values of this property
#$class.SystemProperties_ | where { $_.Name -eq "__DERIVATION" }

# now we can select the value of the specific property
#$class.SystemProperties_ | where { $_.Name -eq "__DERIVATION" } | select Value