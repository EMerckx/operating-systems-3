# Oefening 15

# Bepaal voor het actief "Operating System" de waarde van alle attributen
# (ook systeemattributen). Om een datum mooi voor te stellen kan je gebruik
# maken van het SWbemDateTime COM object - zoek dit op in de
# WMI-documentatie. Bovendien moet je hiervoor het Variant type inladen.

use strict;
use warnings;
use Win32::OLE qw(in);
use Win32::OLE::Const;

# script stops and gives error message is something goes wrong
$Win32::OLE::Warn = 3;

# variables
my $computername = ".";
my $namespace    = "root/cimv2";
my $locator      = Win32::OLE->new("WbemScripting.SWbemLocator");
my $wbemservices = $locator->ConnectServer( $computername, $namespace );

# the class name
my $classname = "Win32_OperatingSystem";

#-----------------------------------------------------------------------------------------

# create DateTime object
my $datetime = Win32::OLE->new("WbemScripting.SWbemDateTime");

# get the instance
# this is the unique instance of the singleton class
my $instance = $wbemservices->get( $classname . "=@" );

print $classname . "\n\n";

# show the properties
print "\tAmount of properties: " . $instance->{Properties_}->{Count} . "\n";
foreach ( in $instance->{Properties_} ) {
    print "\t\tName: " . $_->{Name} . "\n";
    if ( $_->{Value} ) {
        print "\t\tValue: " . $_->{Value} . "\n";
    }
    print "\t\tCIMType: " . $_->{CIMType} . "\n";
    if ( $_->{CIMType} == 101 ) {
        $datetime->{Value} = $_->{Value};
        print "\t\tVarDate: " . $datetime->GetVarDate() . "\n";
    }
    print "\n";
}

#-----------------------------------------------------------------------------------------

# show the system properties
print "\tAmount of systemproperties: "
  . $instance->{SystemProperties_}->{Count} . "\n";
foreach ( in $instance->{SystemProperties_} ) {
    print "\t\tName: " . $_->{Name} . "\n";
    if ( $_->{Value} ) {
        print "\t\tValue: " . $_->{Value} . "\n";
    }
    print "\t\tIsArray: " . $_->IsArray() . "\n";
    print "\t\tCIMType: " . $_->{CIMType} . "\n";
    if ( $_->{CIMType} == 101 ) {
        $datetime->{Value} = $_->{Value};
        print "\t\tVarDate: " . $datetime->GetVarDate() . "\n";
    }
    print "\n";
}
