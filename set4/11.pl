# Oefening 11

# Zoek in WMI CIM Studio de instantie die een Interrupt Request beschrijft,
# met IRQNumber=18. Deze instantie is geassocieerd met objecten van
# verschillende klassen.
# Bepaal enkel de netwerkverbinding(en) die gekoppeld zijn aan deze
# instantie. Geef de "beschrijving" van elke netwerkverbinding - zoek het
# juiste attribuut op in WMI CIM Studio.

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

# we search in WMI CIM Studio for "Interrupt Request" and
# we check the checkbox "Search class descriptions",
# then we find the class "Win32_IRQResource"
# which has the "Win32_IRQResource"  property as the key qualifier

# set IRQNumber
# this is the key attribute of the associator class
# my $irqNumber = 18; has 0 associators
my $irqNumber = 19;

# we need to get the network connections from the instances of the searched class
# so our classname is "Win32_NetworkAdapter"
my $classname = "Win32_NetworkAdapter";

#-----------------------------------------------------------------------------------------

print "AssociatorsOf() \n\n";

# set the relative path
my $relpath1 = "Win32_IRQResource.IRQNumber=" . $irqNumber;

# get the associator instances
my $instances1 = $wbemservices->AssociatorsOf( $relpath1, undef, $classname );

# print info
print "\tAmount of associators: " . $instances1->{Count} . "\n";
foreach ( in $instances1) {
    print "\tNetConnectionID: " . $_->{NetConnectionID} . "\n";
}
print "\n";

#-----------------------------------------------------------------------------------------

print "->Associators_() \n\n";

# set the relative path
my $relpath2 = "Win32_IRQResource.IRQNumber=" . $irqNumber;

# get the WbemObject
my $wbemObject = $wbemservices->Get($relpath2);

# get the associator instances
my $instances2 = $wbemObject->Associators_( undef, $classname );

# print info
print "\tAmount of associators: " . $instances2->{Count} . "\n";
foreach ( in $instances2) {
    print "\tNetConnectionID: " . $_->{NetConnectionID} . "\n";
}
print "\n";
