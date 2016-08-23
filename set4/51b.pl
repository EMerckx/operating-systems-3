# Oefening 51

# Configureer via een script de permanente eventregistratie die er 
# voor zorgt dat er een email gestuurd wordt naar de labobegeleiders, 
# telkens je een USB stick inplugt. Verwijs in het subject van de 
# email naar de driveletter waaronder de USB stick ter beschikking is.
#
# Tip: Bij het instellen van de Event query kan je gebruik maken van 
# de typische WMI Event klassen. Deze beschikken over interessante 
# attributen waarmee je die klasse verder kan analyseren. Zoek deze 
# attributen op in WMI CIM Studio of in de WMI References / WMI Classes 
# / WMI System Classes tak. Indien de Event klasse afgeleid is van de 
# klasse __InstanceOperationEvent dan beschik je bijvoorbeeld, via het 
# TargetInstance attribuut, over het object dat het event heeft 
# veroorzaakt. Van dit object kan je dan terug de specifieke attributen 
# raadplegen. (zie ook reeks 3).

use strict;
use warnings;
use Win32::OLE qw(in);

# variables
my $computername = ".";
my $namespace = "root/cimv2";

# get service
my $locator = Win32::OLE->new("wbemscripting.swbemlocator");
my $service = $locator->ConnectServer($computername, $namespace);

# create a new event filter instance
my $eventfilter = $service->Get("__eventfilter")->SpawnInstance_();

# configure the event filter instance
$eventfilter->{"name"} = "notepad_filter";
$eventfilter->{"querylanguage"} = "WQL";
$eventfilter->{"query"} = 
	"SELECT * " .
	"FROM __InstanceCreationEvent " .
	"WITHIN 1 " .
	"WHERE TargetInstance ISA 'Win32_Process' " .
	"AND TargetInstance.Name='notepad.exe' ";
# the query means: select all of the instance creation events 
# one by one
# of which the target is an instance of the Win32_LogicalDisk class
# but doesn't have the name A:, C:, D: and E:

# use the Put_ method on the event filter instance
# this will cause the atomic and effective creation of the instance
# if an object with the same path would exist, then the attributes 
# will be overridden
# the return value of the Put_ method is a SWbemObjectPath object
# also, we use the flag wbemFlagUseAmendedQualifiers
my $eventfilterobjectpath = $eventfilter->Put_(131072);
my $eventfilterpath = $eventfilterobjectpath->{"path"};

printf "%s \n", $eventfilterpath;

# now do the same for the consumer instance
# here we are going to append a line to a log file
# and for this we use perl code!
# the configuration for email is below in the comments
my $scriptconsumer = 
	$service->Get("activescripteventconsumer")->SpawnInstance_();
# configure the consumer instance
$scriptconsumer->{"name"} = "notepad_script_consumer";
$scriptconsumer->{"scriptingengine"} = "PerlScript";
$scriptconsumer->{"scripttext"} = 
	'open FILE, ">>C:\\\\notepad.txt"; ' . 
	'print FILE "Notepad started! \n";';
# use the put method again, and get the object path
my $scriptconsumerobjectpath = $scriptconsumer->Put_(131072);
my $scriptconsumerpath = $scriptconsumerobjectpath->{"path"};

printf "%s \n", $scriptconsumerpath;

# finally, we need to bind these two through a binder
# here we use the __FilterToConsumerBinding class
my $binding = $service->Get("__filtertoconsumerbinding")->SpawnInstance_();
# configure the binding instance
$binding->{"filter"} = $eventfilterpath;
$binding->{"consumer"} = $scriptconsumerpath;
# also use the put method here
my $result = $binding->Put_(131072);

# check for errors
printf "\nErrors: %s \n", Win32::OLE->LastError();
printf "%s \n", $result->{"path"};

#my $Instance = $WbemServices->Get(SMTPEventConsumer)->SpawnInstance_();
#$Instance->{Name}       = "test";
#$Instance->{FromLine}   = q[...@ugent.be];
#$Instance->{ToLine}     = q[...@ugent.be];
#Name-attribuut van Win32_LogicalDisk
#$Instance->{Subject}    = "USB (%TargetInstance.Name%) inserted"; 
#$Instance->{SMTPServer} = "smtp.hogent.be"; #thuis anders instellen
#$Consumer=$Instance->Put_(wbemFlagUseAmendedQualifiers);
#$Consumerpad=$Consumer->{path};
