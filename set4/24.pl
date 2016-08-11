# Oefening 24

# Pas vorige oefening aan zodat niet enkel het aantal klassen, 
# maar ook de naam van alle klassen in één bepaalde namespace 
# hiërarchisch getoond wordt. 
# Zorg hierbij voor een gepaste indentering, die de niveau's 
# van overerving duidelijk weergeeft. Bovendien moet elk niveau 
# gesorteerd zijn op naam. 
# 
# Test dit uit met de namespace "root/cimv2" en "root/msapps12", 
# en vergelijk met het overzicht in WMI CIM Studio

use strict;
use warnings;
use Win32::OLE qw(in);

$Win32::OLE::Warn = 3;

# variables
my $computername = ".";
my $namespace = "root/cimv2";
my $classname = "";

# get service
our $locator = Win32::OLE->new("wbemscripting.swbemlocator");
our $service = $locator->ConnectServer($computername, $namespace);

# get all classes
GetSubClasses($classname, -1);

#--------------------------------------------------------------------

# use as method GetSubClasses($classname, $level)
sub GetSubClasses {
	# get parameters
	my $classname = shift;
	my $level = shift;

	#we're in the next level
	$level++;

	if ($classname){
		# print the current class
		print "\t" x $level;
		print $classname;
		print "\n";
	}

	# see in documentation (MSDN Library)
	# go to index and search for subclassesof
	# the parameter iFlag needs the value 1 for wbemQueryFlagShallow
	my $subclasses = $service->SubClassesOf($classname, 1);

	# sort on classname
	foreach my $subclass (sort {uc($a) cmp uc($b)} 
		map {$_->{"systemproperties_"}->Item("__class")->{"value"}} 
		in $subclasses) {

		# use this method recursively
		GetSubClasses($subclass, $level);
	}
}