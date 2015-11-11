# Oefening 22

# Schrijf een recursieve functie DirectorySize(directory, depth ) die de som
# berekent van de groottes van alle bestanden die zich in de opgegeven
# directory, op een willekeurig niveau diep.
# Schrijf op het scherm ook de detailinformatie van alle subniveau's,
# beperkt tot de opgegeven depth .
# Indien bijvoorbeeld deze depth op 0 ingesteld is, dan mag enkel de globale
# informatie van de directory getoond worden.
# Test uit op een lokale directory met weinig submappen.

# Bij het initialiseren van een string met \-tekens moet je een dubbele \\ geven.
# my $DirectoryName="c:\\emacs";
# Indien je deze string wilt gebruiken in een query moet je vier \\\\ ingeven.

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

#-----------------------------------------------------------------------------------------

# directory
my $classname     = "Win32_Directory";
my $directoryname = "C:\\\\Perl";

# get the directory
my $directory =
  $wbemservices->Get( $classname . ".Name=\"" . $directoryname . "\"" );

# get the directory size
my $directorysize = DirectorySize( $directory, 6 );

print "The size of directory "
  . $directoryname . " = "
  . $directorysize . " \n";

#-----------------------------------------------------------------------------------------

sub DirectorySize {

    # get the given variables
    my ( $directory, $depth ) = @_;
    my $size = 0;

    print "dir: " . $directory->{Name} . " - depth: " . $depth . "\n";

    # construct query to get the files
    my $wql =
        "ASSOCIATORS OF { Win32_Directory.Name=\""
      . $directory->{Name}
      . "\" } WHERE AssocClass = CIM_DirectoryContainsFile";

    # add the size of each file to the directory size
    foreach ( in $wbemservices->ExecQuery($wql) ) {
        $size += $_->{FileSize};
    }

    # construct query to get the subdirectories
    # this works in wbemtest
    # associators of {Win32_Directory.Name='c:\perl'}
    # where assocclass=Win32_SubDirectory Role=groupcomponent
    $wql =
        "ASSOCIATORS OF { Win32_Directory.Name=\""
      . $directory->{Name}
      . "\" } WHERE AssocClass = Win32_SubDirectory Role=GroupComponent";

    # add the size of each subdirectory to the directory size
    # ERROR: PROGRAM DOESN'T GO IN TO THIS FOREACH !!
    foreach ( in $wbemservices->ExecQuery($wql) ) {
        if ( $depth >= 0 ) {
            $size += DirectorySize( $_->{Name}, $depth - 1 );
        }
    }

    return $size;
}
