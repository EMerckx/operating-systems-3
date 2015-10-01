# Aantal rijen en kolommen van elk werkblad. Schrijf een script dat als enige parameter
# de naam van een (excel-) bestand meekrijgt. Geef voor elke werkblad het aantal rijen en
# het aantal kolommen getoond dat ingevuld is in elk werkblad. Je mag veronderstellen dat
# het bestand een leesbaar excel-bestand is.
# Merk op dat een "leeg" werkblad niet herkend wordt. Er is altijd 1 rij en 1 kolom.

use strict;
use warnings;
use Win32::OLE qw(in);

# set the parameters
@ARGV = ("my-excel.xlsx");

# open the current application or a new one
my $excelAppl = Win32::OLE->GetActiveObject('Excel.Application')
  || Win32::OLE->new( 'Excel.Application', 'Quit' );
$excelAppl->{visible} = 0;    # 0 = excel is invisible ; 1 = excel is visible

# create a filesystem object
my $fso = Win32::OLE->new("Scripting.FileSystemObject");

for my $workbookname (@ARGV) {

    # check if file exists
    if ( $fso->FileExists($workbookname) ) {

        # get the absolute path to the file
        my $workbookpath = $fso->GetAbsolutePathName($workbookname);

        # open the given workbook
        print "Opening workbook " . $workbookpath . "\n";
        my $workbook = $excelAppl->{Workbooks}->Open($workbookpath);

        # foreach sheet in the workbook
        for my $sheet ( in $workbook->{Worksheets} ) {

            # get the sheet name
            print "Sheet: " . $sheet->{name} . "\n";

            # get the range of the sheet
            # get the column and row count from the range
            my $range = $sheet->{UsedRange};
            print "\tcolumns = " . $range->{columns}->{count} . "\n";
            print "\trows = " . $range->{rows}->{count} . "\n";
        }

        print "\n";
    }
    else {

        print "Workbook " . $workbookname . " not found \n";
    }
}

# wait for user input before closing
print "Press any key to close Excel...";
<STDIN>;

# close the Excel application
$excelAppl->Quit;
