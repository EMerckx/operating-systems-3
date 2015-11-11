# Oefening 18

# Toon alle methodes + methodequalifiers voor Win32_Process.
# De uitvoer afwerken zodat je alle qualifiers ook ziet is niet 
# zo evident. Gebruik daarvoor foreach + Write-Host.

clear

# get the object of the Win32_Process
$object = Get-WmiObject -List Win32_Process

# get all the methods of the object
$methods = $object.Methods

# show the methods and its qualifiers on screen
$methods | 
    foreach {
        $_.Name
        "`n"
        $_.Qualifiers
        "---------------`n"
     }