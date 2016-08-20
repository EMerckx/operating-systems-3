# Oefening 44

# Geef een overzicht van alle methoden (en de klasse waartoe ze 
# behoren) in de root\cimv2 namespace die bij aanroep expliciete 
# vermelding van één of meer specifieke rechten vereisen. 
# Vermeld deze rechten dan in het formaat zoals dit in de 
# connectiemoniker verwacht wordt.

use strict;
use warnings;
use Win32::OLE qw(in);

#$Win32::OLE::Warn = 3;

# variables
my $computername = ".";
my $namespace = "root/cimv2";

# get service
my $locator = Win32::OLE->new("wbemscripting.swbemlocator");
my $service = $locator->ConnectServer($computername, $namespace);

# get the classes
# with all qualifiers, so use the flag
my $classes = $service->SubclassesOf("", 131072);

# loop the classes
foreach my $class (in $classes){

	# init array for the privileges
	my @privileges = ();

	# loop the methods of the current class
	foreach my $method (in $class->{Methods_}){

		my $privileges = $method->{"qualifiers_"}->Item("privileges");
		if ($privileges && $privileges->{"value"}){
			printf "%s - %s \n", 
				$class->{"systemproperties_"}->{"__class"}->{"value"}, 
				$method->{"name"};

			print "\t";
			print join(", ", @{$privileges->{"value"}});
			print "\n\n";

			#push @privileges,
            #    ($method->{Name} . " {(" . (join ",",(map {/Se(.*)Privilege/} @{$privileges->{value}})) . ")}!");
		}
	}

	#printf ("\n%-33s:\n\t%s\n\n", $class->{Path_}->{RelPath}, (join "\n\t",@privileges)) if @privileges;
}