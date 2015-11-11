# Oefening 14

# Maak oefening 30 uit p4. 
# Je mag de klasse hardcoderen. De attribuutqualifier 
# CIMTYPE vind je niet terug als je met cmdlets werkt.

# Bepaal alle attribuutqualifiers van alle attributen 
# die specifiek zijn voor een klasse. Voor bijna alle 
# attributen beschik je over de attribuutqualifier CIMTYPE, 
# vergelijk zijn waarde met de waarde van het attribuut 
# CIMType dat je hebt voor elk SWbemProperty object. 
# Wat kan je hieruit besluiten ? De naam van de klasse 
# kan bijvoorbeeld als enig argument worden opgegeven.

clear

# variables
$computername = "."
$namespace = "root/cimv2"
$locator = New-Object -ComObject "WbemScripting.SWbemLocator"
$wbemservices = $locator.ConnectServer($computername,$namespace)

# get the class
$classname = 'Win32_LogicalDisk.DeviceID="c:"'
$class = $wbemservices.Get($classname)

# get the properties
$properties = $class.Properties_

$properties | 
    select Name, CIMType,
        @{Name="Qualifiers";Expression={$_.Qualifiers_.Item("CIMTYPE").Value}}
