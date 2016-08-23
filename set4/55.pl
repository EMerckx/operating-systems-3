# Oefening 55

# Ontwikkel een script dat geparametriseerd wordt met een lijst van 
# een aantal klassenamen. Periodiek moeten de WMI gegevens van alle 
# instanties van die klassen (of de enige instantie van eventuele 
# singletonklassen) opgefrist worden, en de naam en waarde van alle 
# ingestelde attributen ervan uitgeschreven worden. 
# 
# Dergelijk script is ondermeer interessant om toegepast te worden 
# op klassen die gegevens representeren die men meestal met de 
# Performance Monitor analyseert (cfr. cursus Architectuur van 
# Besturingssystemen). 
# 
# Je kan deze klassen herkennen aan een naam met 
# Win32_PerfFormattedData_ prefix). 
# Test het script dan ook op dergelijke klassen uit 
# (bijvoorbeeld op klassen met PerfOS_System, PerfOS_Processor, 
# PerfDisk_LogicalDisk, PerfOS_Memory, … als naamsuffix).

use strict;
use warnings;
use Win32::OLE qw(in);

# classnames
my @classnames = qw(
	Win32_PerfFormattedData_PerfOS_System
	Win32_PerfFormattedData_PerfOS_Processor
	Win32_PerfFormattedData_PerfDisk_LogicalDisk
	Win32_PerfFormattedData_PerfOS_Memory
	);


print join(", ", @classnames);
print "\n";

# variables
my $computer = ".";
my $namespace = "root/cimv2";

# get the service
my $locator = Win32::OLE->new("wbemscripting.swbemlocator");
my $service = $locator->ConnectServer($computer, $namespace);
# also get the refresher!
my $refresher = Win32::OLE->new("wbemscripting.swbemrefresher");

# get the objects of the supplied classes
# and store them in the refresher
foreach my $classname (@classnames) {
	# get the current class
	my $class = $service->Get($classname);
	# check if singleton object or not
	if($class->{"qualifiers_"}->Item("singleton") &&
		$class->{"qualifiers_"}->Item("singleton")->{"value"}){
		# add only the singleton object to the refresher
		$refresher->Add($service, $classname . "=@")->{"object"};
	}
	else{
		# add only the whole objectset to the refresher
		$refresher->AddEnum($service, $classname)->{"objectset"};
	}
}

# see how many we have added in the refresher
printf "\nThe number of items in the refresher is: %s \n",
	$refresher->{"count"};

# set auto reconnect to true
$refresher->{"autoreconnect"} = 1;

#--------------------------------------------------------------------

# infinite loop part
# exit with CTRL C
while(1) {
	print "******************************************************\n";

	# refresh the refresher
	$refresher->Refresh();

	# loop the refreshable items in the refresher
	foreach my $refitem (in $refresher){
		if($refitem->{"isset"}){
			# loop every item in the set
			foreach my $setitem (in $refitem->{"objectset"}){
				showProperties($setitem);
			}
		}
		else {
			showProperties($refitem->{"object"})
		}
	}

	# timeout in miliseconds
	Win32::Sleep(5000);
}

#--------------------------------------------------------------------

# use this method as showProperties($object)
sub showProperties {
	# get the object
	my $object = shift;

	# print the object's path
	printf "OBJECT PATH: %s \n", $object->{"path_"}->{"path"};

}




