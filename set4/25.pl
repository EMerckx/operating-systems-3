# Oefening 25

# Bepaal voor de namespace root/CIMV2 welke providers worden aangesproken. 
# Bepaal ook voor elke provider het aantal klassen dat wordt ondersteund. 
# Geef een overzicht, geordend op aantal klassen.
# Voor hoeveel klassen is de provider niet opgegeven?

use strict;
use warnings;
use Win32::OLE qw(in);

# comment out! gives errors otherwise
#$Win32::OLE::Warn = 3;

# variables
my $computername = ".";
my $namespace = "root/cimv2";

# get service
my $locator = Win32::OLE->new("wbemscripting.swbemlocator");
my $service = $locator->ConnectServer($computername, $namespace);

# get all classes 
# we use the wbemFlagUseAmendedQualifiers flag, with value 131072
# Causes WMI to return class amendment data with the base class definition.
my $classes = $service->SubclassesOf(undef, 131072);

# init the hash for the providers and the amoun number
my %providers;

# for each class, see which provider it has
foreach my $class (in $classes) {
	if($class->{"qualifiers_"}->Item("provider")){
		# get the name of the provider
		my $provider = $class->{"qualifiers_"}->Item("provider")->{"value"};
		
		# add the provider to the hash
		$providers{$provider}++;
	}
	else{
		# add one to the not given providers
		$providers{"not given"}++;
	}
}

# give an overview, sorted on amount of classes having the provider
# here we first use $b and then $a because we want a descending list
foreach (sort {$providers{$b} <=> $providers{$a}} keys %providers) {
	printf "%40s - %s \n", 
		$_,
		$providers{$_};
}
