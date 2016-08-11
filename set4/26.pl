# Oefening 26

# Vergelijk de SWbemQualifierSet collectie van een klasse met de 
# SWbemQualifierSet collectie van een instantie van die klasse. 
# De naam van de klasse kan bijvoorbeeld als enig argument worden 
# opgegeven. Een instantie kan je zelf ophalen.
# 
# Kan je voor de instantie ook alle qualifiers ophalen?
# Test je script uit met de klasses Win32_LocalTime, Win32_DiskDrive 
# en Win32_Product.

use strict;
use warnings;
use Win32::OLE qw(in);

# variables
my $computername = ".";
my $namespace = "root/cimv2";
my $classname = "Win32_LocalTime";

# get the service
my $locator = Win32::OLE->new("wbemscripting.swbemlocator");
my $service = $locator->ConnectServer($computername, $namespace);

# CLASS
printf "CLASS %s - qualifiers:\n", $classname;
# get the class, with all qualifiers
# here the flag wbemFlagUseAmendedQualifiers with value 131072 is needed
# otherwise not all qualifiers will be present
# Causes WMI to return class amendment data with the base class definition.
my $class = $service->Get($classname, 131072);

# output qualifiers
foreach my $qualifier (in $class->{"qualifiers_"}) {
	printf "%15s - %s \n", 
		$qualifier->{"name"},
		$qualifier->{"value"};
}

printf "\n";

# INSTANCES
printf "INSTANCES OF %s - qualifiers:\n", $classname;
# get the instances, same flag here
# this operation can take a while...
my $instances = $service->InstancesOf($classname, 131072);

# get one instance - brackets are important!
my ($instance) = (in $instances);

# print the qualifiers of the instance
foreach my $qualifier (in $instance->{"qualifiers_"}) {
	printf "%15s - %s \n", 
		$qualifier->{"name"},
		$qualifier->{"value"};
}

