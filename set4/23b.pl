# Oefening 23

# Vertrek van oefening 8 waarbij je alle namespaces overloopt. 
# Pas dit aan zodat voor elke namespace ook het totaal aantal 
# klassen bepaald wordt. Vergelijk dit met het aantal klassen die 
# in de eerste tak van de hiërarchie staan (onmiddellijke subklassen).
# Vang de eventuele fout op, zodat dit ook lukt zonder administrator-rechten
# 
# Met een kleine aanpassing kan je ook alle namespaces bepalen die 
# een bepaalde klasse, bijvoorbeeld "StdRegProv", bevatten.

use strict;
use warnings;
use Win32::OLE qw(in);

use Data::Dumper;

# create locator
our $locator = Win32::OLE->new("wbemscripting.swbemlocator");

# use as method GetNameSpaces($computername, $namespace, $classname)
sub GetNameSpaces {
	my $computername = shift;
	my $namespace = shift;
	my $classname = shift;

	# get the wbem service
	my $service = $locator->ConnectServer($computername, $namespace);
	# return when no connection to namespace could be made
	if(Win32::OLE->LastError()){
		return;
	}

	# get all the classes
	# WQL-query: SELECT * FROM meta_class
	my $classes = $service->SubclassesOf();
	# see if the namespace contains the class
	foreach my $class (in $classes) {
		my $cur = $class->{"systemproperties_"}->Item("__CLASS")->{"value"};
		if($cur eq $classname){
			printf "%s in %s \n",
				$classname,
				$namespace;
		}
	}

	# get all the namespaces
	# WQL-query: SELECT * FROM __NAMESPACE
	my $namespaces = $service->InstancesOf("__NAMESPACE");
	# use recursion to get to the following namespaces
	if($namespaces->{"count"}){
		# for sorting
		# sort {uc($a) cmp uc($b)} map {$_->{"Name"}} in $namespaces;
		foreach (in $namespaces) {
		#foreach sort {uc($a) cmp uc($b)} map {$_->{"Name"}} in $namespaces {
			my $newnamespace = $namespace . "/" . $_->{"name"};
			GetNameSpaces($computername, $newnamespace, $classname);
		}
	}
}

# variables
my $computername = ".";
my $namespace = "root";
my $classname = "StdRegProv";

# call method
GetNameSpaces($computername, $namespace, $classname);
