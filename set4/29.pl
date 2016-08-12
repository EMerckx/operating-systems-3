# Oefening 29 

# Van een aantal klassen, vb Win32_Process kan je zelf ook instanties 
# toevoegen en/of verwijderen, van andere klassen vb Win32_Product kan 
# dit niet. Zoek op welke klassequalifiers deze informatie bevatten.
# 
# Meer hierover in de subtak WMI Reference / WMI Infrastructure Objects 
# and Values / WMI Qualifiers / Standard Qualifiers van de WMI-documentatie.
# 
# Bepaal nu voor alle klassen in de root\cimv2 namespace of je zelf 
# instanties kan maken en/of verwijderen van die klasse, en indien dit kan, 
# bepaal dan ook welke methode je hiervoor zal moeten gebruiken. 
# We komen hier later op terug.

# Answer to why Win32_Process allows the creation of instances and 
# Win32_Product doesn't, is because the Win32_Process class has the 
# qualifier SupportsCreate 
# Documentation of SupportsCreate: (Data type: boolean)
# Applies to: classes 
# Indicates whether the class supports the creation of instances. 
# The default is FALSE.

use strict;
use warnings;
use Win32::OLE qw(in);

# comment out
#$Win32::OLE::Warn = 3;

# variables
my $computername = ".";
my $namespace = "root/cimv2";

# get the service
my $locator = Win32::OLE->new("wbemscripting.swbemlocator");
my $service = $locator->ConnectServer($computername, $namespace);

# get all classes
# all the qualifiers aren't needed here, but it might be good to 
# have them, so use flag wbemFlagUseAmendedQualifiers (131072)
# WQL: SELECT * FROM meta_class
my $classes = $service->SubclassesOf("", 131072);

printf "%30s %10s %10s \n", "", "Creation", "Deletion"; 
foreach my $class (in $classes) {
	# check if creation and deletion is supported
	my $creation = IsSetAndTrue($class, "supportscreate") ? "YES" : "";
	my $deletion = IsSetAndTrue($class, "supportsdelete") ? "YES" : "";

	# give output
	if($creation || $deletion){
		printf "%30s %10s %10s \n", 
			$class->{"systemproperties_"}->{"__CLASS"}->{"value"},
			$creation, $deletion;
	}
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