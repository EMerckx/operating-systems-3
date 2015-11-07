# De volledige WMI infrastructuur kan, ondermeer vanuit scripttalen,
# benaderd worden via COM objecten met een automation interface.
# De verzameling van deze COM objecten wordt de WMI Scripting Library genoemd.
# Zoek informatie over de COM objecten en hun onderlinge relatie op
# in de WMI Reference / Scripting API for WMI subtak van de WMI-documentatie.
# Bekijk in de subtak Scripting API Object Model het Scripting API Object Model.
# Deze bestaat uit een twintigtal COM klassen, die in deze reeks in diverse stappen
# zullen bestudeerd worden.
# In het register vind je meerdere componenten, de naam begint met WbemScripting.

# Zoek in het register de ProgId van het Locator-object. Is er ook een TypeLibrary?
# Initialiseer met het SWbemLocator-object de WMI-infrastructuur.
# Bepaal alle constanten van de typelibrary die hoort bij dit COM-object
# (zie oefening 10 van reeks 1).
# Initialiseer de typelibrary ook rechtstreeks (zie oefening 8 van reeks 1)
# en schrijf de waarde uit van een zelfgekozen constante.

# De tak WMI Reference / Scripting API for WMI / Scripting API Constants
# beschrijft deze constanten.

# We vinden het Locator-object terug in
# Win32 and COM Development
#	> Administration and Management
#	> Windows Management Instrumentation
#	> WMI Reference
#	> Scripting API for WMI
#	> Scripting API Objects
# 	> SWbemLocator

use strict;
use warnings;
use Win32::OLE::Const;

# init the SWbemLocator object
my $locator = Win32::OLE->new("WbemScripting.SWbemLocator")
  || die "Can't create SWbemLocator object: ", Win32::OLE->LastError;

# import the constants from the SWbemLocator object
my %locatorConstants = %{ Win32::OLE::Const->Load($locator) };

# sort and print the constants from the hash
foreach ( sort { $a cmp $b } keys %locatorConstants ) {

    # for each key, reserve a space of 40 characters
    printf( "%40s - %s \n", $_, $locatorConstants{$_} );
}

# example: check for errors
# init the typelibrary and writ the value of the constant
use Win32::OLE::Const ".*WMI";
printf( "\nError check: nwbemNoErr = " . wbemNoErr . "\n" );
