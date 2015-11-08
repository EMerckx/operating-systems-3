# Oefening 10

# Bepaal het aantal objecten(instanties) die geassocieerd zijn met de rootdirectory
# van de C:partitie. Bepaal ook het aantal verschillende klasse(n) voor deze
# geassocieerde objecten. Controleer je antwoorden met de informatie die je in
# WMI CIM Studio terugvindt.

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

# get the instance
my $instance = $wbemservices->Get("Win32_Directory.Name='c:\\'");

# my $instances =
# $wbemservices->ExecQuery("SELECT * FROM Win32_Directory WHERE Name = 'c:\\'");
# my ($instance) = (in $instances);

#-----------------------------------------------------------------------------------------

# get the associators

# get all the instances, associated with this instance
my $associators1 = $instance->Associators_();

# print info
print "\$instance->Associators_() \n";
print "\tAmount of associators: " . $associators1->{Count} . "\n";
foreach ( in $associators1) {
    print "\tClass: " . $_->{Path_}->{Class} . "\n";
}
print "\n";

# only get the classes for the associated objects
# fifth optional parameter = ClassDefsOnly
my $associators2 = $instance->Associators_( undef, undef, undef, undef, 1 );

# print info
print "\$instance->Associators_(undef, undef, undef, undef, undef, 1) \n";
print "\tAmount of associators: " . $associators2->{Count} . "\n";
foreach ( in $associators2) {
    print "\tClass: " . $_->{Path_}->{Class} . "\n";
}
print "\n";
