# Oefening 7

# Maak een nieuw excel-bestand, voud.xlsx,
# waarvan je 9 kolommen in het eerste werkblad invult.
# De eerste kolom bevat alle tweevouden kleiner dan 100,
# de tweede kolom alle drievouden kleiner dan honderd,...
# Op de eerste rij staan de waarden 2,3,4,...,10 in vet.
# Plaats ook border-lijnen, zowel vertikaal tussen de kolommen,
# als horizontaal onder de eerste regel.

# De gewenste opmaak laat je best in Excel genereren
# door een macro op te nemen met de gewenste opmaak.
# Het bespaart je wel veel opzoekwerk over de naam van de
# methodes en constanten. De VBA-code van de macro gebruikt
# namelijk dezelfde methodes en attributen.

# De Type Library van Excel moet wel ingeladen worden om de
# constanten te kunnen gebruiken.
# Het belangrijkste verschil is dat in de macro steeds een range
# "geselecteerd" wordt - je vervangt dus Selection door het range-object.

use strict;
use warnings;
use Win32::OLE qw(in);
use Win32::OLE::Const ".*Excel";

# script stops and gives error message is something goes wrong
$Win32::OLE::Warn = 3;

# set the parameters
@ARGV = ("voud.xlsx");

# open the current application or a new one
my $excelAppl = Win32::OLE->GetActiveObject("Excel.Application")
  || Win32::OLE->new( "Excel.Application", "Quit" );
$excelAppl->{Visible} = 1;    # 0 = excel is invisible ; 1 = excel is visible

# create a filesystem object
my $fso = Win32::OLE->new("Scripting.FileSystemObject");

for my $workbookname (@ARGV) {

    # the workbook variable
    my $workbook;

    # check if file exists,
    # if not, create the file
    if ( $fso->FileExists($workbookname) ) {

        # get the absolute path to the file
        my $workbookpath = $fso->GetAbsolutePathName($workbookname);

        # open the given workbook
        print "Opening workbook " . $workbookpath . " \n\n";
        $workbook = $excelAppl->{Workbooks}->Open($workbookpath);
    }
    else {

        # create the name for the new workbook
        my $directorypath = $fso->GetAbsolutePathName(".");
        my $workbookpath  = $directorypath . "\\" . $workbookname;

        #open a new workbook
        print "Could not find " . $workbookpath . "\n";
        print "Opening new workbook \n\n";
        $workbook = $excelAppl->{Workbooks}->Add();

        # save the new workbook
        $workbook->SaveAs($workbookpath);
    }

    #-----------------------------------------------------

    print "Calclulating the multiples from 2 to 10 \n";

    # get the first worksheet
    my $sheet = $workbook->{Worksheets}->Item(1);
    $sheet->{Name} = "Multiples from 2 to 10";

    # get the range
    my $cell1 = $sheet->Cells( 1,  1 );
    my $cell2 = $sheet->Cells( 50, 9 );
    my $range = $sheet->Range( $cell1, $cell2 );
    my $rangeValue = $range->{Value};

    # edit the range
    my $i = 1;    # the index for the rows
    for my $rangeRow (@$rangeValue) {

        # the value of the columns
        my $j = 2;

        # calculate the value of the cells on the row
        for my $rangeCell (@$rangeRow) {
            if ( $i * $j <= 100 ) {
                $rangeCell = $i * $j;
            }

            # calculate value of the next column
            $j++;
        }

        # calculate index of the next row
        $i++;
    }

    # write the range to the sheet
    $range->{Value} = $rangeValue;

    # save the workbook
    $workbook->Save();

    #-----------------------------------------------------

    print "Making the first row bold \n";

    # get the row and make it bold
    $range->Rows(1)->{Font}->{Bold} = 1;

    # save the workbook
    $workbook->Save();

    #-----------------------------------------------------

    print "Drawing vertical border lines -> DOESN'T WORK \n";

    # draw the vertical borders
    # $range->Borders(xlInsideVertical)->{LineStyle} = xlContinuous;
    # $range->Borders(xlEdgeRight)->{LineStyle} = xlContinuous;
    # $range->Borders(xlEdgeLeft)->{LineStyle} = xlContinuous;

    # save the workbook
    $workbook->Save();

    #-----------------------------------------------------

    print "Drawing first row horizontal border line -> DOESN'T WORK \n";

    # draw the horizontal border
    # $range->rows(1)->Borders(xlEdgeBottom)->{LineStyle} = xlContinuous;

    # save the workbook
    $workbook->Save();

}

# wait for user input before closing
print "Press any key to close Excel...";
<STDIN>;

# close the Excel application
$excelAppl->Quit;
