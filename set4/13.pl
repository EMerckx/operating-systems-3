# Oefening 13

# Geef een overzicht van alle attributen (ook systeemattributen) van een klasse,
# waarvoor je de naam meegeeft als enig argument. Bepaal ook het CIMtype
# van elk attribuut (haal de tekstuele beschrijving op - zie oefening 1),
# en geef aan of de inhoud samengesteld (een array) is.
# Test dit uit voor de klasse Win32_Directory
# en ook voor de associatorklasse Win32_Subdirectory.

use strict;
use warnings;
use Win32::OLE::Const;
use Win32::OLE 'in';

# script stops and gives error message is something goes wrong
$Win32::OLE::Warn = 3;

# variables
my $computername = ".";
my $namespace    = "root/cimv2";
my $locator      = Win32::OLE->new("WbemScripting.SWbemLocator");
my $wbemservices = $locator->ConnectServer( $computername, $namespace );

#-----------------------------------------------------------------------------------------
# import the constants from the SWbemLocator object
my %locatorConstants = %{ Win32::OLE::Const->Load($locator) };

# map the locator constants to the types hash
# that way we get all the CIM types in the types hash
# this is needed to lookup the CIM type name
my %types;
foreach ( keys %locatorConstants ) {

    # use a regular expression to only map the CIM types
    # we don't need the other constants
    if (/Cimtype/) {

        # add the CIM type to the types hash
        # key = number - value = name
        # print $_ . " - " . $locatorConstants{$_} . "\n";
        $types{ $locatorConstants{$_} } = $_;
    }
}

#-----------------------------------------------------------------------------------------

print "class Win32_Directory \n\n";

# get the Win32_Directory class
my $classname1 = "Win32_Directory";
my $class1     = $wbemservices->Get($classname1);

# print properties info
# to execute the foreach we must add "use Win32::OLE 'in';" !!!
print "\tAmount of properties: " . $class1->{Properties_}->{Count} . "\n";
foreach ( in $class1->{Properties_} ) {
    print "\t\tName: " . $_->{Name} . "\n";
    print "\t\tCIMType: " . $_->{CIMType} . "\n";
    print "\t\tCIMType name: " . $types{ $_->{CIMType} } . "\n";
    print "\t\tIsArray: " . $_->{IsArray} . "\n";
    print "\n";
}

# print system properties info
# to execute the foreach we must add "use Win32::OLE 'in';" !!!
print "\tAmount of system properties: "
  . $class1->{SystemProperties_}->{Count} . "\n";
foreach ( in $class1->{SystemProperties_} ) {
    print "\t\tName: " . $_->{Name} . "\n";
    print "\t\tCIMType: " . $_->{CIMType} . "\n";
    print "\t\tCIMType name: " . $types{ $_->{CIMType} } . "\n";
    print "\t\tIsArray: " . $_->{IsArray} . "\n";
    print "\n";
}

#-----------------------------------------------------------------------------------------

print "class Win32_SubDirectory \n\n";

# get the Win32_SubDirectory class
my $classname2 = "Win32_SubDirectory";
my $class2     = $wbemservices->Get($classname2);

# print properties info
# to execute the foreach we must add "use Win32::OLE 'in';" !!!
print "\tAmount of properties: " . $class2->{Properties_}->{Count} . "\n";
foreach ( in $class2->{Properties_} ) {
    print "\t\tName: " . $_->{Name} . "\n";
    print "\t\tCIMType: " . $_->{CIMType} . "\n";
    print "\t\tCIMType name: " . $types{ $_->{CIMType} } . "\n";
    print "\t\tIsArray: " . $_->{IsArray} . "\n";
    print "\n";
}

# print system properties info
# to execute the foreach we must add "use Win32::OLE 'in';" !!!
print "\tAmount of system properties: "
  . $class2->{SystemProperties_}->{Count} . "\n";
foreach ( in $class2->{SystemProperties_} ) {
    print "\t\tName: " . $_->{Name} . "\n";
    print "\t\tCIMType: " . $_->{CIMType} . "\n";
    print "\t\tCIMType name: " . $types{ $_->{CIMType} } . "\n";
    print "\t\tIsArray: " . $_->{IsArray} . "\n";
    print "\n";
}
