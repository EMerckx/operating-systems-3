# Oefening 54

# Verwijder alle objecten in verband met permanente eventregistratie. 
# Zoek een methode van SWemObject die het object zelf verwijdert. 
# Met LastError() kan je opvragen of dit gelukt is.

use strict;
use warnings;
use Win32::OLE qw(in);

# variables
my $computername = ".";
my $namespace = "root/cimv2";

# init the class name
# in WMI CIM Studio we can find in the derivations
# the superclass for all permanent event registrations
# which is __IndicationRelated
my $classname = "__indicationrelated";

# get the service
my $locator = Win32::OLE->new("wbemscripting.swbemlocator");
my $service = $locator->ConnectServer($computername, $namespace);

# get all the instances
my $instances = $service->InstancesOf($classname);

# loop all instances 
foreach my $instance (in $instances) {
	printf "Deleting: %s \n",
		$instance->{"systemproperties_"}->{"__class"}->{"value"};

	$instance->Delete_();

	if(Win32::OLE->LastError() == 0){
		printf "\tSUCCES! \n";
	}
	else {
		printf "\tFailed... \n";
	}
}

#$_->Delete_() foreach in $WbemServices->InstancesOf($ClassName);
#print Win32::OLE->LastError();
