# Met EnumAllObjects kan je een lijst maken van alle 
# OLE-objecten die geladen zijn. 
# Dit kan handig zijn bij debuggen.

use strict;
use Win32::OLE;

my $cdo = Win32::OLE->new("CDO.Message");
my $fso = Win32::OLE->new("Scripting.FileSystemObject");
my $excel = Win32::OLE->new("Excel.Sheet");

# check perldoc for code (copy paste)
my $count = Win32::OLE->EnumAllObjects(
	sub {
		my $object = shift;
		my $class = Win32::OLE->QueryObjectType($object);
		print ref($object) . " - " . join(" / ", $class) . "\n";
	}
);

print "\nTotal amount of OLE-objects loaded: " . $count . "\n";

# ERROR: only 2 objects shown, Excel.Sheet is not loaded!