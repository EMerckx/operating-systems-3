# Oefening 58

# We gaan hier een asynchroon script maken.
# Echter houden we het hier eenvoudig.
# Zo is het hier de bedoeling om een query op te stellen voor
# enerzijds het opstarten/afsluiten van een notebook applicatie,
# en anderzijds voor het opstarten van een calculator
# applicatie.

use strict;
use warnings;
use Win32::OLE qw(EVENTS);
use Win32::Console;

# variables
my $computername = ".";
# namespaces are defined below, because each query has its possible
# different namespaces

# get the locator object
my $locator = Win32::OLE->new("wbemscripting.swbemlocator");

# get the sink object
my $sink = Win32::OLE->new("wbemscripting.swbemsink");
# add the callback
Win32::OLE->WithEvents($sink, \&eventCallBack);

# EVENT 1
# get service via namespace
my $namespace1 = "root/cimv2";
my $service1 = $locator->ConnectServer($computername, $namespace1);
# notification query
my $notiquery1 = 
	"SELECT * FROM __InstanceOperationEvent WITHIN 5 " .
	"WHERE TargetInstance ISA 'Win32_Process' " .
	"AND TargetInstance.Name='notepad.exe'";
# execute notification query asynchronously
$service1->ExecNotificationQueryAsync($sink, $notiquery1);

# EVENT 2
# get service via namespace
my $namespace2 = "root/cimv2";
my $service2 = $locator->ConnectServer($computername, $namespace2);
# notification query
my $notiquery2 = 
	"SELECT * FROM __InstanceCreationEvent WITHIN 5 " .
	"WHERE TargetInstance ISA 'Win32_Process' " .
	"AND TargetInstance.Name='calc.exe'";
# execute notification query asynchronously
$service2->ExecNotificationQueryAsync($sink, $notiquery2);

#--------------------------------------------------------------------

# create console object
my $console = Win32::Console->new(STD_INPUT_HANDLE);

# infinite loop (sort of)
# loop until the console receives input
until ($console->GetEvents() && ($console->Input())[1]) {
	# DOCUMENTATION:
	# This class method retrieves all pending messages from the 
	# message queue and dispatches them to their respective window 
	# procedures. Calling this method is only necessary when not 
	# using the COINIT_MULTITHREADED model. All OLE method calls and 
	# property accesses automatically process the message queue.
	Win32::OLE->SpinMessageLoop();

	# add a timeout
	Win32::Sleep(1000);
}

# when we come here, the console got an input and so we need to
# cancel all outstanding asynchronous operations that are 
# associated with this object sink
$sink->Cancel();

# DOCUMENTATION:
# Win32::OLE->WithEvents(OBJECT[, HANDLER[, INTERFACE]])
# This class method enables and disables the firing of events by 
# the specified OBJECT. If no HANDLER is specified, then events are 
# disconnected.
Win32::OLE->WithEvents($sink);

#--------------------------------------------------------------------

# callback method
# method used as eventCallBack($source, $eventname, $event, $context)
sub eventCallBack {
	# get the parameters
	my $source = shift;
	my $eventname = shift;
	my $event = shift;
	my $context = shift;

	if($eventname eq "OnObjectReady"){
		# get the classname of the event
		my $classname = 
			$event->{"systemproperties_"}->{"__class"}->{"value"};

		# return if the event is a modification event
		if($classname eq "__InstanceModificationEvent"){
			return;
		}

		# handle result from query 1
		if($event->{"targetinstance"}->{"name"} eq "notepad.exe"){
			if($classname eq "__InstanceCreationEvent"){
				printf "%-20s started - handle: %s \n", 
					$event->{"targetinstance"}->{"name"},
					$event->{"targetinstance"}->{"handle"};
			}
			elsif($classname eq "__InstanceDeletionEvent"){
				printf "%-20s stopped - handle: %s \n", 
					$event->{"targetinstance"}->{"name"},
					$event->{"targetinstance"}->{"handle"};
			}
		}

		# handle result from query 2
		if($event->{"targetinstance"}->{"name"} eq "calc.exe"){
			printf "%-20s started - handle: %s \n", 
				$event->{"targetinstance"}->{"name"},
				$event->{"targetinstance"}->{"handle"};
		}
	}
}
