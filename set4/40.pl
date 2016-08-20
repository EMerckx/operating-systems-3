# Oefening 40

# Gebruik de methode Terminate om alle opgestarte notepad-processen 
# te killen. Je kan een WQL-query gebruiken om deze processen op te 
# halen. Schrijf voor elk process de juiste tekstuele boodschap op het 
# scherm. Werk dit uit met beide technieken (direct en formeel)
# 
# De parameter reason is een verplichte parameter, maar het lukt ook als 
# je die parameter niet invult...
#
# Kan je ook de processen killen die in een andere gebruikerscontext 
# opgestart zijn?

# Only processes that were started in the current user context will 
# be killed

use strict;
use warnings;
use Win32::OLE qw(in);

$Win32::OLE::Warn = 3;

# set variables
my $computername = ".";
my $namespace = "root/cimv2";
my $classname = "Win32_Process";
my $processname = "notepad.exe";

# get service
my $locator = Win32::OLE->new("wbemscripting.swbemlocator");
my $service = $locator->ConnectServer($computername, $namespace);

# get class
# we also want all the qualififers: wbemFlagUseAmendedQualifiers
# that's flag 131072 
my $class = $service->Get($classname, 131072);
# check which methods are available for the class
# and we can see that the method Terminate is available
my $methods = $class->{"methods_"};
printf "%s methods for class %s \n", $classname, $methods->{"count"};
foreach my $method (in $methods){
	printf "\t%s \n", $method->{"name"};
}
printf "\n";

# create a hash with all the return values of the terminate method
my %terminatereturns = 
	createReturnValueHash($methods->Item("Terminate"));
#use Data::Dumper;
#print Dumper(\%terminatereturns);

# get all instances of the class
# WQL query: "Select * From Win32_Process Where Name='notepad.exe'"
my $instances = $class->{"instances_"};

foreach my $instance (in $instances){

	# if the name of the instance equals the to kill process name
	# then kill it
	if($instance->{"name"} eq $processname){

		# print the name of the instance
		printf "%s \n", $instance->{"name"};

		# set the input parameters
		my $inparam = $methods->{"terminate"}->{"inparameters"};
		my $outparam = $instance->ExecMethod_("terminate", $inparam);

		# to see which return values are given
		#foreach my $par (in $outparam->{"properties_"}){
		#	printf "\t%s \n", $par->{"name"};
		#}
		printf "\tProcess handle: %s \n",
			$instance->{"handle"};
		printf "\tTerminate return value: %s \n",
			$outparam->{"returnvalue"};
		# print a more clear description of the return value
		printf "\t%s \n",
			$terminatereturns{$outparam->{"returnvalue"}};
	}
}

#--------------------------------------------------------------------

# use method as createReturnValueHash($method)
# maps the valuemap to the readable values
# returns a hash
sub createReturnValueHash {
	# get the method
	my $method = shift;
	# create empty hash
	my %hash = ();

	# map the valuemap values on the values
	@hash{ @{$method->{"qualifiers_"}->Item("valuemap")->{"value"}} }
		= @{$method->{"qualifiers_"}->Item("values")->{"value"}};

	# return the created hash
	return %hash;
}
