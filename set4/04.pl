# Oefening 4

# Zoek in WMI CIM Studio welk WMI object de directory voorstelt
# die gekoppeld is aan de rootdirectory van de C:partitie (zie oefening 17 uit reeks3).
# Initialiseer een WMI object met deze directory,
# en schrijf het 'filetype uit' (zoek het attribuut op in WMI CIM Studio).

# If we search in WMI CIM Studio for the WMI object that represents a directory,
# we find the class "Win32_Directory"

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
# when using '' -> no escaping
# when using "" -> escaping
my $instance = $wbemservices->Get("Win32_Directory.Name='c:\\'");

# print the file type of the instance
print "File Type = " . $instance->{FSName} . "\n";
