# Oefening 19

# Bepaal voor de klasse Win32_Directory een overzicht 
# met alle methodes, en het aantal in- en uit-parameters.
# Informatie over in- en uit-parameters is enkel beschikbaar 
# via WMI-com objecten.

clear

# variables
$computername = "."
$namespace = "root/cimv2"
$locator = New-Object -ComObject "WbemScripting.SWbemLocator"
$wbemservice = $locator.ConnectServer($computername, $namespace)

# get the class
$classname = "Win32_Directory"
$class = $wbemservice.Get($classname)

# get the methods
$methods = $class.Methods_

# how to find the names of the child elements
# take the first of last one and try to go deeper
# $last = $methods | select -Last 1
# $last
# $last.InParameters
# $last.InParameters.Properties_
# $last.InParameters.Properties_.Count

# show the methods on screen
# with their in and out parameters
$methods | 
    select Name, 
        @{
            Name="In"; 
            Expression={$_.InParameters.Properties_.Count}
        },
        @{
            Name="Out"; 
            Expression={$_.OutParameters.Properties_.Count}
        }