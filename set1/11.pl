# Oefening 11

# Maak een script waarbij je een bestandsnaam opgeeft.
# Controleer of dit bestand gevonden wordt (in de huidige directory),
# en geef de volledige padnaam (kan op twee manieren)
# en het type van het bestand.

use strict;
use warnings;
use Win32::OLE qw(in);
use Win32::OLE::Const;

# script stops and gives error message is something goes wrong
$Win32::OLE::Warn = 3;

# get the FileSystemObject
my $fso = Win32::OLE->new("Scripting.FileSystemObject");

# set the arguments (here: filenames)
@ARGV = ( "file.txt", "non-existent-file.txt" );

foreach my $filename (@ARGV) {

    # check if the file exists
    # if not, report to the user
    if ( $fso->FileExists($filename) ) {

        print "The file " . $filename . " exists \n";

        # get the absolute path
        my $absolutepath = $fso->GetAbsolutePathName($filename);
        print "\tThe absolute path: " . $absolutepath . "\n";

        #get the file extension
        my $extension = $fso->GetExtensionName($filename);
        print "\tThe file extension: " . $extension . "\n";

        print "\n";
    }
    else {
        print "The file " . $filename . " doesn't exist \n\n";
    }
}
