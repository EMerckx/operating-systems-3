# Oefening 46

# Creëer via een WMI script een nieuwe gedeelde map (share). 
# Zoek eerst de methode op die je hiervoor ter beschikking hebt. 
# Geef ook een tekstuele melding of het aanmaken van de share gelukt is. 
# Je kan dit daarna controleren met "net share".
# Probeer de formele en informele techniek voor het uitvoeren van de 
# Create-methode.

#use strict;
#use warnings;
use Win32::OLE qw(in);

# variables
my $computername = ".";
my $namespace = "root/cimv2";
my $classname = "Win32_Share";

# get service
my $locator = Win32::OLE->new("wbemscripting.swbemlocator");
my $service = $locator->ConnectServer($computername, $namespace);

# get class, just always use the flag wbemFlagUseAmendedQualifiers
# that's flag 131072 
my $class = $service->Get($classname, 131072);

# get the methods of the class
my $methods = $class->{"methods_"};

printf "Class %s has %s methods: \n", 
	$class->{"systemproperties_"}->{"__class"}->{"value"},
	$methods->{"count"};
foreach my $method (in $methods){
	printf "\t%s \n", $method->{"name"};
}

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

# get the input parameters
my $inparam = $methods->{"create"}->{"inparameters"};

# fill in the input parameters
# see in MSDN documentation of the Create method which are needed
$inparam->{"Path"} = "C:\\shr1";
$inparam->{"Name"} = "Share1";
$inparam->{"Type"} = 0; # the value for a Disk Drive
$inparam->{"Description"} = "A shared folder created by Ewout.";
# Because we didn't supply the value for the Access parameter:
# If this parameter is not supplied or is NULL, then Everyone has  
# read access to the share.

# execute method and receive the output parameters
my $outparam = $class->ExecMethod_("create", $inparam);

# show output on screen
printf "\nExecuted the Create method \n";
printf "\tReturn value : %s \n",
	$outparam->{"returnvalue"};
printf "\tMore readable: %s \n",
	$returnvals{$outparam->{"returnvalue"}};

#--------------------------------------------------------------------

# use method as createReturnValueHash($method)
# maps the valuemap to the readable values
# returns a hash
sub createReturnValueHash{
	# get the method
	my $method = shift;
	# init the hash
	my %hash = ();

	# map the integer values of ValueMap
	# to readable string values of Values
	@hash{ @{$method->{"qualifiers_"}->Item("valuemap")->{"value"}} }
		= @{$method->{"qualifiers_"}->Item("values")->{"value"}};

	return %hash;
}
