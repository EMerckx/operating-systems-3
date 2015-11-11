# Oefening 30

# Bepaal alle attribuutqualifiers van alle attributen die specifiek zijn
# voor een klasse. Voor bijna alle attributen beschik je over de
# attribuutqualifier CIMTYPE, vergelijk zijn waarde met de waarde
# van het attribuut CIMType dat je hebt voor elk SWbemProperty object.
# Wat kan je hieruit besluiten ?
# De naam van de klasse kan bijvoorbeeld als enig argument worden
# opgegeven.

# Merk op: in de TypeLybrary 'Microsoft WMI Scripting' vind je ook
# informatie over de WbemCimTypes. Gebruik oefening 10 uit reeks1
# om een hash te maken die de cimtypes kan converteren van numeriek
# naar tekst. Verwerk die informatie ook in deze oefening.

use strict;
use warnings;
use Win32::OLE 'in';
use Win32::OLE::Const;

# script stops and gives error message is something goes wrong
$Win32::OLE::Warn = 3;

# variables
my $computername = ".";
my $namespace    = "root/cimv2";
my $locator      = Win32::OLE->new("WbemScripting.SWbemLocator");
my $wbemservices = $locator->ConnectServer( $computername, $namespace );

#-----------------------------------------------------------------------------------------

# get the type library
my $typeLibrary = Win32::OLE::Const->Load($wbemservices);

# put it in a hash
# hash{ value as integer } = type as string
my %cimTypes;
while ( my ( $key, $value ) = each %{$typeLibrary} ) {
    if ( $key =~ /wbemCim/ ) {
	$cimTypes{$value} = substr($key,11);
    }
}

#-----------------------------------------------------------------------------------------

# get the class
# we use the loaded variable wbemFlagUseAmendedQualifiers in the Get method
# this way, we get all the qualifiers
# but we can't find the flag, so set it to 0
my $classname = "Win32_LogicalDisk";
my $class = $wbemservices->Get($classname, 0);
# print here