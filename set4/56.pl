# Oefening 56

# Ontwikkel een semi-synchroon script dat elke verandering
# in de toestand van een service meldt. Indien er niets te melden
# is, dat moet om de vijf seconden een puntje getoond worden.
# 
# (Stel de perl variabele $| in op een waarde verschillend van 0
# indien je elke schrijfopdracht direct op het scherm wilt zien.)
# Dit script uittesten in het command-venster zodat je het ook kan
# stoppen met Ctrl-C !

# To test this script once it's up and running, you can open the 
# task manager and go to the Services tab page.
# Choose one service that isn't important and alternate between 
# running and stopping the service.

use strict;
use warnings;
use Win32::OLE qw(in);

# we set $| to 1
# because we want to see output to the screen
$| = 1;

# script stops and gives error message is something goes wrong
# don't use this here because the timeout error of the 
# eventnotification will terminate the infinite loop...
#$Win32::OLE::Warn = 3;

# variables
my $computername = ".";
my $namespace    = "root/cimv2";

# get the service
my $locator = Win32::OLE->new("wbemscripting.swbemlocator");
my $service = $locator->ConnectServer($computername, $namespace);

# create the notification query
my $notificationQuery =
	"SELECT * " .
	"FROM __InstanceOperationEvent " . 
	"WITHIN 3 " .
	"WHERE TargetInstance ISA 'Win32_Service'";

# execute the query
my $eventnotification =
  $service->ExecNotificationQuery($notificationQuery);

#--------------------------------------------------------------------

print "Waiting for events .";

# infinite loop, terminate with CTRL C
while (1) {

	# check for a next event
	my $event = $eventnotification->NextEvent(5000);

	# if timeout error, because nothing happend
	if(Win32::OLE->LastError()) {
		print ".";
	}
	else {
		# print the display name of the service
		# and print the previous state and the current state
		printf "\n%s changed from %s to %s",
			$event->{"targetinstance"}->{"displayname"},
			$event->{"previousinstance"}->{"state"},
			$event->{"targetinstance"}->{"state"};
	}
}
