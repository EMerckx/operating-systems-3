# Oefening 9

# Bepaal enkel het aantal klassen die kunnen geassociëerd worden
# aan een Directory-klasse, zie oefening 31 uit reeks 3.
# Controleer met de informatie in WMI CIM Studio.
# Merk op dat, net als in WMI CIM Studio geen rekening wordt gehouden
# met de associatorklassen die via overerving beschikbaar zijn.

use strict;
use warnings;
use Win32::OLE::Const;

# script stops and gives error message is something goes wrong
$Win32::OLE::Warn = 3;

# variables
my $computername = ".";
my $namespace    = "root/cimv2";
my $locator      = Win32::OLE->new("WbemScripting.SWbemLocator");
my $wbemservices = $locator->ConnectServer( $computername, $namespace );
my $classname    = "Win32_Directory";

#-----------------------------------------------------------------------------------------

print "->AssociatorsOf() \n\n";

# get the associators
# if the sixth optional parameter is not defined, we get an empty set of "instances"
my $associators1 =
  $wbemservices->AssociatorsOf( $classname, undef, undef, undef, undef, undef,
    1 );

# print the info
print "\tAmount of associators: " . $associators1->{Count} . "\n";
foreach ( in $associators1) {
    print "\tClass: " . $_->{Path_}->{Class} . "\n";
}
print "\n";

#-----------------------------------------------------------------------------------------

print "\$class->Associators_() \n";

# get the associators
# if the sixth optional parameter is not defined, we get an empty set of "instances"
my $class = $wbemservices->Get($classname);
my $associators2 = $class->Associators_( undef, undef, undef, undef, undef, 1 );

# print the info
print "\tAmount of associators: " . $associators2->{Count} . "\n";
foreach ( in $associators2) {
    print "\tClass: " . $_->{Path_}->{Class} . "\n";
}
print "\n";
