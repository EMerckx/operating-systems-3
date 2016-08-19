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
# methodequalifiers).

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
# so we set the flag wbemFlagUseAmendedQualifiers, value 
my $class = $service->Get($classname, 131072);

# get all the methods
my $methods = $class->{"methods_"};

printf "Amount of methods for class %s: %s \n", 
	$classname, $methods->{"count"};

printf "\nCLASS: \n";

# print all the methods and their qualifiers
foreach my $method (in $methods){
	printf "\t%s \n", $method->{"name"};

	foreach my $qualifier (in $method->{"qualifiers_"}){
		printf "\t\t%s \n", $qualifier->{"name"};
	}
}

# get the instances, also use the flag
my $instances = $class->Instances_(131072);
# get the first instance
my ($instance) = (in $instances);
# get the methods
my $methods2 = $instance->{"methods_"};

printf "\nINSTANCE: \n";

# print all methods
foreach my $method (in $methods2){
	printf "\t%s \n", $method->{"name"};

	foreach my $qualifier (in $method->{"qualifiers_"}){
		printf "\t\t%s \n", $qualifier->{"name"};
	}
}



