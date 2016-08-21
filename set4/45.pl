# Oefening 45

# In oefening 40 werd een script geschreven dat alle notepad 
# processen afbreekt. Indien je een proces wilt afbreken dat 
# je niet zelf hebt opgestart moet je ook hiervoor privileges 
# instellen (Je kan dit nalezen in de beschrijving van de 
# Terminate()-methode van de Win32_Process klasse in de tak 
# WMI Reference / WMI Classes / Win32 Classes)
# 
# Omdat de methode Terminate() niet altijd dit Privilege moet 
# hebben is deze qualifier blijkbaar niet ingesteld.
# Pas de oplossing van oefening 40 aan, zodat alle notepad 
# processen worden afgebroken.

# The documentation states:
# To terminate a process that you do not own, enable the 
# SeDebugPrivilege privilege. In VBScript, you can enable this 
# privilege with the following lines of code:
#     Set objLoc = createobject("wbemscripting.swbemlocator")
#     objLoc.Security_.privileges.addasstring "sedebugprivilege", true
# 
# Via moniker:
# winmgmts:{(Debug)}!//./root/cimv2
# and in Perl code:
# my $ComputerName = '.';
# my $Privileges="{(Debug)}!";
# my $WbemServices = 
#     Win32::OLE->GetObject("winmgmts:$Privileges//$ComputerName/root/cimv2");

use strict;
use warnings;
use Win32::OLE qw(in);

#$Win32::OLE::Warn = 3;

# variables
my $computername = ".";
my $namespace = "root/cimv2";
my $classname = "Win32_Process";
my $processname = "notepad.exe";

# get the locator
my $locator = Win32::OLE->new("wbemscripting.swbemlocator");
# IMPORTANT: set the privilege
my $privilege = "sedebugprivilege";
$locator->{"security_"}->{"privileges"}->addasstring($privilege, 1);
# get the service
my $service = $locator->ConnectServer($computername, $namespace);

# get the class
my $class = $service->Get($classname, 131072);

# get the instances
my $instances = $class->Instances_();

# get the methods
my $methods = $class->{"methods_"};
# create hash
my %returnvals = createReturnValueHash($methods->{"terminate"});

# loop instances
foreach my $instance (in $instances) {
	# if the instance is the right one
	if($instance->{"name"} eq $processname){

		# print the instance's name
		printf "%s \n", $instance->{"name"};

		# get the input parameters
		my $inparam = $methods->{"terminate"}->{"inparameters"};
		# execute method and retrieve output parameters
		my $outparam = $instance->ExecMethod_("terminate", $inparam);

		# also possible to use
		# $instance->Terminate(); 

		printf "\tReturn value: %s \n", $outparam->{"returnvalue"};
		printf "\tMeaning     : %s \n", 
			$returnvals{$outparam->{"returnvalue"}};
	}
}

#--------------------------------------------------------------------

# use method as createReturnValueHash($method)
# maps the valuemap to the readable values
# returns a hash
sub createReturnValueHash {
	# get the method
	my $method = shift;
	# create empty hash
	my %hash = ();

	# map the valuemap values on the values
	@hash{ @{$method->{"qualifiers_"}->Item("valuemap")->{"value"}} }
		= @{$method->{"qualifiers_"}->Item("values")->{"value"}};

	# return the created hash
	return %hash;
}