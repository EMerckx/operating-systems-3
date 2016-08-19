# Oefening 39

# Geef voor 1 klasse uit de root/cimv2-namespace, waarvan je de naam 
# als argument opgeeft, een overzicht van alle methoden, en wel als 
# volgt:
#  * geef per methode een lijst met de invoerparameters, in de volgorde 
#    zoals ze bij de methode-aanroep moeten gespecificeerd worden. Elke 
#    invoerparameter die optioneel is plaats je bovendien tussen [ ]-tekens.
#  * indien de methode meer dan 1 uitvoerparameter heeft, vermeld deze dan 
#    op een aanvullende lijn.
#  * duid aan of dit een statische methode is, die moet worden uitgevoerd 
#    op de klasse.
# 
# Test je script met de klassen Win32_Process,Win32_Share, Win32_Volume. 
# Indien je aan het script geen argumenten meegeeft, moet je alle klassen 
# in root/cimv2 behandelen.

use strict;
use warnings;
use Win32::OLE qw(in);

#$Win32::OLE::Warn = 3;

# variables
my $computername = ".";
my $namespace = "root/cimv2";
my $classname = "Win32_Volume";

# get service
my $locator = Win32::OLE->new("wbemscripting.swbemlocator");
my $service = $locator->ConnectServer($computername, $namespace);

# get class with all qualifiers
# so we set the flag wbemFlagUseAmendedQualifiers, value 131072
my $class = $service->Get($classname, 131072);

# get all the methods from the class
my $methods = $class->{"methods_"};

printf "Found %s methods for class %s \n",
	$methods->{"count"}, $classname;

foreach my $method (in $methods){
	# print the method name
	printf "\t%s \n", $method->{"name"};

	# print the InParameters
	if($method->{"inparameters"}){
		printf "\t\tInParameters: \n";

		# loop for each property sorted property
		foreach my $prop (sort {
			$a->{"qualifiers_"}->{"id"}->{"value"} <=> 
			$b->{"qualifiers_"}->{"id"}->{"value"}}
			in $method->{"inparameters"}->{"properties_"}){
			
			# get the name of the property
			my $name = $prop->{"name"};

			# check if the property is optional or not
			if($prop->{"qualifiers_"}->{"optional"}){
				$name = "[" . $name . "]";
			}

			# print the names of the input parameters
			printf "\t\t\t%2s - %s \n", 
				$prop->{"qualifiers_"}->{"id"}->{"value"},
				$name;
		}
	}

	# print the OutParameters
	if($method->{"outparameters"} && 
		$method->{"outparameters"}->{"properties_"}->{"count"} > 1){

		printf "\t\tOutparameters: ";
		foreach my $prop (in $method->{"outparameters"}->{"properties_"}){
			printf "%s, ", $prop->{"name"};
		}
		printf "\n";
	}

	# print static or not
	if($method->{"qualifiers_"}->{"static"}){
		printf "\t\tThis method is static! \n";
	}
}