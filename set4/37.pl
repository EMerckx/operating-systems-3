# Oefening 37

# Geef voor 1 klasse uit de root/cimv2-namespace, waarvan je de naam 
# als argument opgeeft, een overzicht van alle methoden , aangevuld met 
# een lijst van methodequalifiers en hun waarde.
# Test je script uit met de klassen Win32_Process,Win32_Share, Win32_Volume.
#
# Merk op dat in de beschrijving van elke methode ook de juiste overeenkomst 
# wordt getoond tussen de methodequalifiers ValueMap en Values. 
# (dit ontbreekt indien er enkel Values zijn)
# (Als je start van een instantie i.p.v. een klasse bekom je soms minder 
# methodequalifiers). (zie 37b.pl)

use strict;
use warnings;
use Win32::OLE qw(in);

$Win32::OLE::Warn = 3;

# variables
my $computername = ".";
my $namespace = "root/cimv2";
my $classname = "Win32_Process";

# get service
my $locator = Win32::OLE->new("wbemscripting.swbemlocator");
my $service = $locator->ConnectServer($computername, $namespace);

# get class with all qualifiers
# so we set the flag wbemFlagUseAmendedQualifiers, value 131072
my $class = $service->Get($classname, 131072);

# get all the methods
my $methods = $class->{"methods_"};

printf "Amount of methods for class %s: %s \n", 
	$classname, $methods->{"count"};

# print all the methods and their qualifiers
foreach my $method (in $methods){
	printf "\t%s \n", $method->{"name"};

	foreach my $qualifier (in $method->{"qualifiers_"}){
		printf "\t\t%10s : ", $qualifier->{"name"};

		if(ref $qualifier->{"value"} eq "ARRAY"){
			printf "%s \n", join(", ", @{$qualifier->{"value"}});	
		}
		else {
			printf "%s \n", $qualifier->{"value"};
		}
	}
}

