# Oefening 5

# Zoek in WMI CIM Studio welk WMI object informatie bevat over het
# geïnstalleerde "servicepack". Welke andere attributen van dit WMI object
# bevatten informatie over de Windows-versie?
# Initialiseer het WMI object en schrijf deze informatie uit.

# Search for a class with "servicepack" as a propery
# Be sure to check the "Search propery names" checkbox
# We find the singleton class "Win32_OperatingSystem"
# In the instances tab we find one object
# Double click on the __CLASS attribute and we get the name
# "Win32_OperatingSystem=@"

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

# get the unique instance of the singleton class
my $instance = $wbemservices->Get("Win32_OperatingSystem=@");

# print information of the object
print "Win32_OperatingSystem=@ \n";
print "\tCaption: " . $instance->{Caption} . "\n";
print "\tVersion: " . $instance->{Version} . "\n";
# print "\tCSDVersion: " . $instance->{CSDVersion} . "\n";
print "\tOSArchitecture: " . $instance->{OSArchitecture} . "\n";
