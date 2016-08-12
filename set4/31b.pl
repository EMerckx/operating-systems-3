# Oefening 31

# Zoek de attribuutqualifier die bepaalt of een attribuut als 
# sleutelattribuut wordt gebruikt. Geef een overzicht van alle 
# klassen in de root\cimv2 namespace met een samengestelde index, 
# en toon dan meteen ook welke attributen in die index opgenomen 
# zijn.
# (Waarom kan je hier geen gebruik maken van het attribuut "Keys" 
# van het "Path_" attribuut ?)
# 
# Met een minimale aanpassing kan je enkel de associatorklassen 
# ophalen, bepaal nu ook het "CIMTYPE" van de sleutelattributen 
# - wat merk je dan op? (zie 31b.pl)

use strict;
use warnings;
use Win32::OLE qw(in);

# comment out
#$Win32::OLE::Warn = 3;

# variables
my $computername = ".";
my $namespace = "root/cimv2";

# get service
my $locator = Win32::OLE->new("wbemscripting.swbemlocator");
my $service = $locator->ConnectServer($computername, $namespace);

# get all classes
my $classes = $service->SubclassesOf("");

# specify for each class the key properties
# and print them
foreach my $class (in $classes) {

	# AANPASSING: only for associator classes
	if(! IsSetAndTrue($class, "association")) {
		next;
	}

	printf "%s \n", $class->{"systemproperties_"}->{"__class"}->{"value"};
	foreach my $prop (in $class->{"properties_"}) {
		if(IsSetAndTrue($prop, "key")){
			printf "\t%s \n", $prop->{"name"}; 
		}
	}
	printf "\n";
}

#--------------------------------------------------------------------

# use this method as IsSetAndTrue($object, $qualifiername)
sub IsSetAndTrue {
	my $object = shift;
	my $qualifiername = shift;

	if($object->{"qualifiers_"}->{$qualifiername} &&
		$object->{"qualifiers_"}->{$qualifiername}->{"value"}){
		# if the qualifier is set, return true
		return 1;
	}
	else {
		# if not, return false
		return 0;
	}
}
