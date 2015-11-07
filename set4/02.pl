# Oefening 2

# Connecteren aan een WMI namespace
# De eerste stap in een consumerscript is het initialiseren van de WMI service van een toestel
# (al dan niet hetzelfde toestel als waarop het script uitgevoerd wordt).
# Net als in WMI CIM Studio moet je hierbij connecteren aan één WMI namespace.
# Het SWbemServices object is de COM representatie van de WMI service voor een
# bepaalde namespace op een bepaald toestel.
# De naam van het toestel wordt met de DNS-naam of het IP-adres vastgelegd.
# Indien het doeltoestel het lokale toestel is, dan gebruik je localhost of "." als identificatie.

# Het SWbemServices object initialiseren kan op twee manieren:
# De methode ConnectServer(Server,Namespace) van een SWbemLocator object resulteert in
# een SWbemServices object. De eerste twee parameters zijn de DNS-naam (of het IP-adres)
# van het doeltoestel, en de naam van de namespace. De ConnectServer methode aanvaardt
# optioneel ook een gebruikersnaam en bijhorend paswoord. Hierdoor kan je connecteren aan
# een WMI service in een andere gebruikerscontext dan deze waarin het consumerscript uitgevoerd
# wordt (vb thuis). Dit kan je niet gebruiken om op het lokale toestel te connecteren in een
# andere gebruikerscontext.
# Je kan elk WMI-object direct initialiseren met de moniker string die het object beschrijft.
# In Perl gebruik je hiervoor de functie Win32::OLE->GetObject(moniker). De monikerstring
# vb. "winmgmts://./root" bestaat uit 3 delen:
# - de protocolspecificatie, winmgmts:
# - de DNS-naam of het IP-adres van het doeltoestel
# - de namespace
# Deze techniek is niet bruikbaar indien je in een andere gebruikerscontext wilt connecteren.
# Bovendien zijn er situaties waar, om beveiligingsredenen, het gebruik van de GetObject niet
# toegelaten wordt. Bijvoorbeeld indien Internet Explorer de rol van scripting host vervult.

# Connecteer je achtereenvolgens:
# - aan de root/cimv2 namespace van het toestel waarop je ingelogd bent,
# in je eigen gebruikerscontext
# - aan de root/cimv2 namespace van een ander labotoestel (dan het toestel waarop je ingelogd bent),
# in de gebruikerscontext van de (lokale) administrator van dat toestel.
# Probeer de twee methodes uit.
# Verifiëer in beide gevallen met de Win32::OLE->QueryObjectType methode welk type object
# geconnecteerd is. Geef een foutmelding indien het connecteren niet gelukt is
# (zie labo1 voor een aantal alternatieven)

use strict;
use warnings;
use Win32::OLE::Const;

# init the namespace
my $namespace = "root/cimv2";

# the script stops and gives a warning if something doesn't succeed
# The value of $Win32::OLE::Warn determines what happens when an OLE error occurs.
# - If it's 0, the error is ignored.
# - If it's 2, or if it's 1 and the script is running under -w, the Win32::OLE module invokes Carp::carp().
# - If $Win32::OLE::Warn is set to 3, Carp::croak() is invoked and the program dies immediately.$Win32::OLE::Warn = 3;

# set the current computer name
my $computerName = ".";    # or "localhost"
# get the locator and services
my $locator = Win32::OLE->new("WbemScripting.SWbemLocator");
my $wbemServices = $locator->ConnectServer( $computerName, $namespace );

# print the object via QueryObjectType()
# The QueryObjectType() class method returns a list of the type library name 
# and the objects class name. In a scalar context it returns the class name only. 
# It returns undef when the type information is not available.
print join(" / ", Win32::OLE->QueryObjectType($wbemServices) ) . "\n";


#------------------------------------------------------------------------------------------------------------------# or init directly
# my $wbemServices = Win32::OLE->GetObject("winmgmts://$computerName/$namespace");
# print join(" / ",Win32::OLE->QueryObjectType($WbemServices)) , "\n";

# alternative for error messages without using Warn
# if ref($WbemServices){
	# print "connection succeeded\n " 
# }
# Win32::OLE->LastError() ==0 || die "failed\n";

# connect to other computer
# my $computerName = "mozart";              # name random
# my $locator=Win32::OLE->new("WbemScripting.SWbemLocator");
# my $wbemServices = $Locator->ConnectServer($computerName, $namespace,
	# "$computerName\\administrator","...."); #fill in
# print join(" / ",Win32::OLE->QueryObjectType($WbemServices)) , "\n";
