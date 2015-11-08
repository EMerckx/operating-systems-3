# Oefening 5

# Delen van een worksheet ophalen. Hieronder een paar voorbeelden
# die een beperkter deel van een worksheet ophalen.
# $range=$nsheet->Range("A1:C3");
# $range=$nsheet->Cells(2,3);
# $range=$nsheet->Range($nsheet->Cells(1,1),$nsheet->Cells(2,3));

# Schrijf de inhoud van deze range-objecten uit.

use strict;
use warnings;
use Win32::OLE qw(in);

# set the parameters
@ARGV = ("my-excel.xlsx");

# open the current application or a new one
my $excelAppl = Win32::OLE->GetActiveObject("Excel.Application")
  || Win32::OLE->new( "Excel.Application", "Quit" );
$excelAppl->{Visible} = 0;    # 0 = excel is invisible ; 1 = excel is visible

# create a filesystem object
my $fso = Win32::OLE->new("Scripting.FileSystemObject");

for my $workbookname (@ARGV) {

    # check if file exists
    if ( $fso->FileExists($workbookname) ) {

        # get the absolute path to the file
        my $workbookpath = $fso->GetAbsolutePathName($workbookname);

        # open the given workbook
        print "Opening workbook " . $workbookpath . "\n\n";
        my $workbook = $excelAppl->{Workbooks}->Open($workbookpath);

        foreach my $sheet ( in $workbook->{Worksheets} ) {

            # get the sheet name
            print "Sheet: " . $sheet->{Name} . "\n";

            # get the range of the sheet
            my $range = $sheet->{UsedRange};

            # get the value of the range
            my $rangeValue = $range->{Value};

            # check for empty worksheet
            if ( ref $rangeValue ) {
                print "Matrix with "
                  . $range->{Rows}->{Count}
                  . " rows and "
                  . $range->{Columns}->{Count}
                  . " columns \n";

                foreach ( @{$rangeValue} ) {
                    print join( " \t", @{$_} ) . "\n";
                }
                print "\n";

                #----------------------------------------------------

                # get the range between from A1 to C3
                my $range1      = $sheet->Range("A1:C3");
                my $rangeValue1 = $range1->{Value};

                # print the range
                print "\tContent of range A1:C3 \n\t";
                foreach ( @{$rangeValue1} ) {
                    print join( " \t", @{$_} ) . " \n\t";
                }
                print "\n";

                #----------------------------------------------------

                # get the Cells(4, 1)
                my $range2 = $sheet->Cells( 2, 3 );
                my $rangeValue2 = $range2->{Value};

                # print the range
                print "\tContent of Cells(2,3) \n";
                print "\tValue = " . $rangeValue2 . "\n";
                print "\n";

                #----------------------------------------------------

                # get the Range( Cells( 1, 1 ), Cells( 2, 3 ) )
                my $range3 =
                  $sheet->Range( $sheet->Cells( 1, 1 ), $sheet->Cells( 2, 3 ) );
                my $rangeValue3 = $range3->{Value};

                # print the range
                print "\tContent of range (Cells(1,1), Cells(2,3)) \n\t";
                foreach ( @{$rangeValue3} ) {
                    print join( " \t", @{$_} ) . " \n\t";
                }
                print "\n";

                #----------------------------------------------------

            }
            else {
                if ($rangeValue) {
                    print "Content: " . $rangeValue . "\n";
                }
                else {
                    print "Empty worksheet \n";
                }
            }

            print "\n-----------------------------------\n\n";
        }
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
