# Oefening 27

# Hoe kan je van een klasse opvragen of het een Singleton klasse is. 
# Geef een lijst met klassenamen mee als argumenten.
# 
# Test je script uit met de klasses Win32_LocalTime, Win32_DiskDrive, 
# Win32_CurrentTime, Win32_WMISetting en CIM_LogicalDevice.
# Waarom kan je hier geen gebruik maken van het "IsSingleton" attribuut 
# van "Path_" (zie oefening 17).
# 
# Tip: Schrijf een functie die nagaat of een bepaalde klassequalifier 
# in ingesteld voor een bepaalde klasse (== de klassequalifier komt voor 
# EN is ingesteld op TRUE).

# Antwoord op de vraag: Niet alle properties zijn correct ingevuld. 
# IsSingleton is altijd 0

use strict;
use warnings;
use Win32::OLE qw(in);

#$Win32::OLE::Warn = 3;

# variables
my $computername = ".";
my $namespace = "root/cimv2";
my $classname = "Win32_DiskDrive";

# get service
my $locator = Win32::OLE->new("wbemscripting.swbemlocator");
my $service = $locator->ConnectServer($computername, $namespace);

# get class
# we also want all qualifiers, so flag wbemFlagUseAmendedQualifiers 
# is needed, with value 131072
my $class = $service->Get($classname, 131072);

if($class->{"qualifiers_"}->{"singleton"}) {
	if($class->{"qualifiers_"}->{"singleton"}->{"value"}){
		printf "%s is a singleton. \n", $classname;
	}
	else {
		printf "%s is not a singleton. \n", $classname;
	}
}
else {
	printf "The singleton qualifier of %s was not found. \n", $classname;
}
