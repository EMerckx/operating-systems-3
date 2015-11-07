# Oefening 3

# Het WMI object (klasse of instantie)
# Voor elk WMI object dat je wilt raadplegen, moet een SWbemObject geïnitialiseerd worden.
# Dit kan ook op twee manieren:
# - Gebruik de Win32::OLE->GetObject(moniker) methode van PerlScript.
# De monikerstring bevat nu de volledige absolute padnaam
# (zoek dit op in WMI CIM Studio in het juiste systeemattribuut van de klasse of de instantie).
# Deze methode is maar beperkt bruikbaar, zie hiervoor.
# - Gebruik de Get(relpad) methode van het SWbemServices object.
# De parameter is de kortere relatieve padnaam.
# Een SWbemObject zal, afhankelijk van de moniker of het relpad dat werd opgegeven,
# een WMI klasse of een instantie ervan voorstellen.

# Initialiseer op twee manieren het WMI object dat de klasse van een netwerkadapter voorstelt.
# Creeer een tweede WMI object dat 1 instantie van die klasse voorstelt
# (zoek de naam van de klasse en het sleutelattribuut op in de WMI-documentatie of in WMI CIM Studio).
# Schrijf ook de waarde uit van het attribuut Name voor deze instantie.
# Je kan dit attribuut opvragen met ->{Name} (zie verder).
# Verifiëer met de Win32::OLE->QueryObjectType methode welk type object je bekomt.
# Merk op dat SWbemObjectEx het extended objecttype is.
# Ook hier kan je een foutmelding geven indien het niet lukt.

use strict;
use warnings;
use Win32::OLE::Const;

# script stops and gives error message is something goes wrong
$Win32::OLE::Warn = 3;

# variables
my $computername = ".";
my $namespace    = "root/cimv2";
my $classname    = "Win32_NetworkAdapter";

#-----------------------------------------------------------------------------------------

print "CLASS OBJECT \n\n";

# init WMI object with Win32::OLE->GetObject(moniker)
my $moniker1 = "winmgmts://$computername/$namespace:$classname";
my $class1   = Win32::OLE->GetObject($moniker1);

# print the object
print "First method: Win32::OLE->GetObject(moniker) \n";
print "Object type of the class: "
  . join( " / ", Win32::OLE->QueryObjectType($class1) ) . "\n\n";

# init WMI object with the Get(relative-path) of the SWbemServices object
my $locator1      = Win32::OLE->new("WbemScripting.SWbemLocator");
my $wbemservices1 = $locator1->ConnectServer( $computername, $namespace );
my $class2        = $wbemservices1->Get($classname);

# print the object
print "Second method: Get(relative-path) of the SWbemServices object \n";
print "Object type of the class: "
  . join( " / ", Win32::OLE->QueryObjectType($class2) ) . "\n\n";

#-----------------------------------------------------------------------------------------

print "INSTANCE OBJECT \n\n";

# set the instance variable: idmy $deviceId = "0":

# instance with Win32::OLE->GetObject(moniker)
my $moniker2  = "winmgmts://$computername/$namespace:$classname.DeviceID=\"0\"";
my $instance1 = Win32::OLE->GetObject($moniker2);

# print the object
print "First method: Win32::OLE->GetObject(moniker) \n";
print "Object type of the instance: "
  . join( " / ", Win32::OLE->QueryObjectType($instance1) ) . "\n";
print "Name: " . $instance1->{Name} . "\n\n";

# instance with the Get(relative-path) of the SWbemServices object
my $locator2      = Win32::OLE->new("WbemScripting.SWbemLocator");
my $wbemservices2 = $locator2->ConnectServer( $computername, $namespace );
my $instance2     = $wbemservices2->Get("$classname.DeviceID=\"0\"");

# print the object
print "Second method: Get(relative-path) of the SWbemServices object \n";
print "Object type of the instance: "
  . join( " / ", Win32::OLE->QueryObjectType($instance2) ) . "\n";
print "Name: " . $instance1->{Name} . "\n\n";
