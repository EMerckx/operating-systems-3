# Oefening 28

# Bepaal hoeveel klassen in de root\cimv2 namespace:
#  * abstract zijn, of niet,
#  * associatorklassen zijn, of niet,
#  * dynamisch zijn, of niet,
#  * singletonklassen zijn, of niet,
# Zoek eerst op welke klassequalifier de gevraagde informatie bevat, 
# en gebruik de functie uit de vorige oefening.

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

# get classes with all qualifiers
# use the flag wbemFlagUseAmendedQualifiers, with value 131072
my $classes = $service->SubclassesOf("", 131072);

# keep track of each amount
my $abstract = 0;
my $notabstract = 0;
my $associator = 0;
my $notassociator = 0;
my $dynamic = 0;
my $notdynamic = 0;
my $singleton = 0;
my $notsingleton = 0;

# check each class
foreach my $class (in $classes) {
	IsSetAndTrue($class, "abstract")    ? $abstract++   : $notabstract++;
	IsSetAndTrue($class, "association") ? $associator++ : $notassociator++;
	IsSetAndTrue($class, "dynamic")     ? $dynamic++    : $notdynamic++;
	IsSetAndTrue($class, "singleton")   ? $singleton++  : $notsingleton++;
}

printf "Amount of classes in the %s namespace are: \n", $namespace;
printf "\tABSTRACT   : %5s - NOT ABSTRACT   : %5s  \n", $abstract, $notabstract;
printf "\tASSOCIATOR : %5s - NOT ASSOCIATOR : %5s  \n", $associator, $notassociator;
printf "\tDYNAMIC    : %5s - NOT DYNAMIC    : %5s  \n", $dynamic, $notdynamic;
printf "\tSINGLETON  : %5s - NOT SINGLETON  : %5s  \n", $singleton, $notsingleton;


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
