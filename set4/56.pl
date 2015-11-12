# Oefening 56

# Ontwikkel een semi-synchroon script dat elke verandering
# in de toestand van een service meldt. Indien er niets te melden
# is, dat moet om de vijf seconden een puntje getoond worden.
# (Stel de perl variabele $| in op een waarde verschillend van 0
# indien je elke schrijfopdracht direct op het scherm wilt zien.)
# Dit script uittesten in het command-venster zodat je het ook kan
# stoppen met Ctrl-C !

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

# create the notificationquery
my $notificationQuery =
"SELECT * FROM __InstanceOperationEvent WITHIN 5 WHERE TargetInstance ISA 'Win32_Process'";

# execute the query
my $eventNotification =
  $wbemservices->ExecNotificationQuery($notificationQuery);

# we set $| to 1
# because we want to see output to the screen$| = 1;

print "Waiting for events .";

use Data::Dumper;
print Dumper($eventNotification);


while (0) {

    # error here, perl can't find NextEvent method....
    ##my $event = $eventNotification->NextEvent(5000);

    my $event = 4;
    Win32::OLE->LastError() and print "."
      or print Dumper($event);

}

# use Win32::OLE 'in';

# my $ComputerName = ".";
# my $NameSpace = "root/cimv2";
# #test vooraf onderstaande query in WbemTest
# my $NotificationQuery = "SELECT * FROM __InstanceModificationEvent WITHIN 5
# WHERE TargetInstance ISA 'Win32_Service'";

# my $Locator=Win32::OLE->new("WbemScripting.SWbemLocator");
# my $WbemServices = $Locator->ConnectServer($ComputerName, $NameSpace);
# my $EventNotification = $WbemServices->ExecNotificationQuery($NotificationQuery);

# $|=1;
# print "Waiting for events .";

# while(1) {
# my $Event = $EventNotification->NextEvent(5000);

# Win32::OLE->LastError()
# and print "."
# or printf "\n%s changed from %s to %s\n"
# ,$Event->{TargetInstance}->{DisplayName}
# ,$Event->{PreviousInstance}->{State}
# ,$Event->{TargetInstance}->{State};
# }
