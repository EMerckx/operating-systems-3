# Oefening 6

# Herneem de vorige opgave, maar gebruik de twee methodes
# die hiervoor beschreven werden om het WMI object te initialiseren.

# Vorige opgave:
# Zoek in WMI CIM Studio welk WMI object informatie bevat over het
# geïnstalleerde "servicepack". Welke andere attributen van dit WMI object
# bevatten informatie over de Windows-versie?
# Initialiseer het WMI object en schrijf deze informatie uit.

# The searched class is the singleton class "Win32_OperatingSystem"

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

# get the instances
my $instances1 = $wbemservices->InstancesOf("Win32_OperatingSystem");

# get the unique instance as a hash
my ($instance1) = in $instances1;

# print information of the instance
print "\tWin32_OperatingSystem=@ \n";
print "\tCaption: " . $instance1->{Caption} . "\n";
print "\tVersion: " . $instance1->{Version} . "\n";

# print "\tCSDVersion: " . $instance1->{CSDVersion} . "\n";
print "\tOSArchitecture: " . $instance1->{OSArchitecture} . "\n\n";

#-----------------------------------------------------------------------------------------

print "\$class->Instances_() method \n\n";

# get the instances
my $class      = $wbemservices->get("Win32_OperatingSystem");
my $instances2 = $class->Instances_();

# get the unique instance as a hash
my ($instance2) = in $instances2;

# print information of the instance
print "\tWin32_OperatingSystem=@ \n";
print "\tCaption: " . $instance2->{Caption} . "\n";
print "\tVersion: " . $instance2->{Version} . "\n";

# print "\tCSDVersion: " . $instance2->{CSDVersion} . "\n";
print "\tOSArchitecture: " . $instance2->{OSArchitecture} . "\n\n";

#-----------------------------------------------------------------------------------------

print "ExecQuery(WQLquery) method \n\n";

# get the instances
my $wql        = "SELECT * FROM Win32_OperatingSystem";
my $instances3 = $wbemservices->ExecQuery($wql);

# get the unique instance as a hash
my ($instance3) = in $instances3;

# print information of the instance
print "\tWin32_OperatingSystem=@ \n";
print "\tCaption: " . $instance3->{Caption} . "\n";
print "\tVersion: " . $instance3->{Version} . "\n";

# print "\tCSDVersion: " . $instance3->{CSDVersion} . "\n";
print "\tOSArchitecture: " . $instance3->{OSArchitecture} . "\n\n";
