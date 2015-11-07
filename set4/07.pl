# Oefening 7

# Bepaal het aantal instanties van netwerkadapters,
# probeer de twee methodes die hiervoor beschreven werden.
# Bepaal ook voor elke netwerkverbinding de waarde van het sleutelattribuut
# (zoek de naam van het sleutelattribuut op in de WMI-documentatie
# of in WMI CIM Studio ).

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

#-----------------------------------------------------------------------------------------

print "InstancesOf(classname) method \n\n";

# the class for the networkadapters is "Win32_NetworkAdapter"
my $class = "Win32_NetworkAdapter";

# get the instances
my $instances1 = $wbemservices->InstancesOf($class);

# print info
print "->InstancesOf() has object type: "
  . join( " / ", Win32::OLE->QueryObjectType($instances1) ) . "\n";
print "Total instances of the object: " . $instances1->{Count} . "\n\n";

# print each instance
foreach ( in $instances1) {
    print "\tWMI object with DeviceID="
      . $_->{DeviceID} . "\t "
      . $_->{Name} . "\n";
}
print "\n";

#-----------------------------------------------------------------------------------------

print "ExecQuery(WQLquery) method \n\n";

# get the instances
my $wql        = "SELECT * FROM Win32_NetworkAdapter";
my $instances2 = $wbemservices->ExecQuery($wql);

# print info
print "->ExecQuery() has object type: "
  . join( " / ", Win32::OLE->QueryObjectType($instances2) ) . "\n";
print "Total instances of the object: " . $instances2->{Count} . "\n\n";

# print each instance
foreach ( in $instances2) {
    print "\tWMI object with DeviceID="
      . $_->{DeviceID} . "\t "
      . $_->{Name} . "\n";
}
print "\n";

#-----------------------------------------------------------------------------------------

print "Alternative method for the DeviceIDs \n\n";

# alternative method for getting the values of the "DeviceID" property
my @deviceIds = map { $_->{DeviceID} } in $instances1;

#print the info
print "Total instances of the object: " . scalar(@deviceIds) . "\n";
print "\tWMI object with DeviceID=";
print join( "\n\tWMI object with DeviceID=", @deviceIds ) . "\n\n";
