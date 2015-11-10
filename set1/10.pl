# Oefening 10

# De Load methode kan ook een OLE object als argument hebben.
# In Perl(Script) beschik je dus heel eenvoudig over alle constanten
# van een typelibrary die hoort bij een specifiek COM-object,
# ook al ken je de juiste naam niet.
# Gebruik deze methode om een overzicht te tonen van alle constanten
# van de drie COM-object die we tot nu toe gezien hebben.
# Orden nu ook dit overzicht op de constantennaam.

use strict;
use warnings;
use Win32::OLE::Const;

# script stops and gives error message is something goes wrong
$Win32::OLE::Warn = 3;

# set the COM-objects
# we have seen:
# - "Excel.Sheet"
# - "Scripting.FileSystemObject"
# - "CDO.Message"
@ARGV = ("Excel.Sheet");

for my $comObjectName (@ARGV) {

    # show the COM-object name
    print $comObjectName . "\n\n";

    # create the COM-object
    my $object = Win32::OLE->new($comObjectName);

    # load the constants of the COM-object
    # and put it in a hash
    my %constants = %{ Win32::OLE::Const->Load($object) };

    # sort the hash and loop over each key
    foreach ( sort { $a cmp $b } keys %constants ) {

        printf( "%40s - %s \n", $_, $constants{$_} );

        # to search for a specific key, eg xlEdgeRight, use:
        # if (/xlEdgeRight/) {
        #       printf( "%40s - %s \n", $_, $constants{$_} );
        # }
    }
}
