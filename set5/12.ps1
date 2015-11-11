# Oefening 12

# Herneem oefening 14 uit reeks p4
# Geef van de SNMP service een op naam gesorteerde 
# lijst van alle attributen en systeemattributen, 
# en hun waarden. Zorg er ook voor dat meervoudige 
# waarden geconcateneerd op één lijn getoond worden.
# Wijzig je oplossing zodat je die informatie ophaalt 
# voor de bijhorende klasse. Wat merk je op ?

clear

# get the Win32-Service with the name 'Browser'
$object = Get-WmiObject -Class Win32_Service -Filter "Name='Browser'"

# show for each property the name and value
"PROPERTIES `n"
$object.Properties | 
    foreach {
        "`t" + $_.Name + " - " + $_.Value + "`n"
    }

# show for each system property the name and value
"SYSTEM PROPERTIES `n"
$object.SystemProperties | 
    foreach {
        "`t" + $_.Name + " - " + $_.Value + "`n"
    }