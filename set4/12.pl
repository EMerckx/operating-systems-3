# Oefening 12

# Geef een op naam gesorteerde lijst van environment variabelen en hun waarde.
# Voor elke environment variabele geef je de naam, de inhoud en de naam
# van de user die de variabele initialiseert. Merk het onderscheid op tussen
# SYSTEEM-variabelen en gewone variabelen.

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

# we search in WMI CIM Studio for "Environment"
# we find the class "Win32_Environment"
my $classname = "Win32_Environment";

# get the instances
my $instances = $wbemservices->InstancesOf($classname);

# print the instances
print "Environment variables: \n";
foreach ( sort { uc( $a->{Name} ) cmp uc( $b->{Name} ) } in $instances) {
    print "\tName: " . $_->{Name} . "\n";
    print "\tVariable value: " . $_->{VariableValue} . "\n";
    print "\tUser name: " . $_->{UserName} . "\n";
    print "\tSystem variable: " . $_->{SystemVariable} . "\n";
    print "\n";
}
