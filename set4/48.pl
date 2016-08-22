# Oefening 48

# Verwijder in een script de shares en de environment variabelen 
# die je in de vorige oefeningen aangemaakt hebt.

use strict;
use warnings;
use Win32::OLE qw(in);

# variables
my $computername = ".";
my $namespace = "root/cimv2";
my $classname = "Win32_Share";
my $instancename = "Share1";

# get service
my $locator = Win32::OLE->new("wbemscripting.swbemlocator");
my $service = $locator->ConnectServer($computername, $namespace);

# get the specific instance
# via the string "Win32_Share.Name='Share1'"
my $instancestr = $classname . ".Name=\'" . $instancename . "\'";
my $instance = $service->Get($instancestr);

# delete the instance
my $inparam = $instance->{"methods_"}->{"delete"}->{"inparameters"};
my $outparam = $instance->ExecMethod_("delete", $inparam);

# get the return values of the 
#my %returnvals = createReturnValueHash($methods->Item("create"));
# method doesn't work, hard coded based on msdn library
my %returnvals = ();
$returnvals{0} = "Success";
$returnvals{2} = "Access Denied";
$returnvals{8} = "Unknown Failure";
$returnvals{9} = "Invalid Name";
$returnvals{10} = "Invalid Level";
$returnvals{21} = "Invalid Parameter";
$returnvals{22} = "Duplicate Share";
$returnvals{23} = "Redirected Path";
$returnvals{24} = "Unknown Device or Directory";
$returnvals{25} = "Net Name Not Found";

# give output
printf "The instance %s deletion was: \n", $instancestr;
printf "\tReturn value : \n", $outparam->{"returnvalue"};
printf "\tMore readable: \n", 
	$returnvals{$outparam->{"returnvalue"}};
