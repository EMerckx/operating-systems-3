# Oefening 6

# Range-objecten : wijzigen inhoud en opmaak
# De inhoud van een range-object kan worden gewijzigd door de Value
# te wijzigen. Hierbij moet je wel letten op de afmetingen van beiden.
# Experimenteer hiermee om de inhoud van een deel van een sheet te wijzigen.
# Houd er rekening mee dat WSH scripts geïnterpreteerd worden:
# probeer het aantal COM interacties tot een minimum te beperken.
# Schrijf dus de ganse range in één keer naar het Excel-bestand.
# Vergeet niet om het werkboek op te slaan!
# Let op! Als het Excel-bestand geopend is door Excel,
# zal het niet lukken om dit bestand aan te passen...

use strict;
use warnings;
use Win32::OLE qw(in);

# set the parameters
@ARGV = ("my-excel2.xlsx");

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

        # open a new workbook
        print "Could not find " . $workbookpath . "\n";
        print "Opening new workbook \n";
        $workbook = $excelAppl->{Workbooks}->Add();

        # save the new workbook
        $workbook->SaveAs($workbookpath);
    }

    # create a new worksheet
    my $newsheet = $workbook->{Worksheets}->Add();

    #-----------------------------------------------------

    # add a value to a cell
    my $cell = $newsheet->Cells( 4, 1 );
    $cell->{Value} = 5;

    # save the workbook
    $workbook->Save();

    #-----------------------------------------------------

    # get a range of cells
    my $cell1 = $newsheet->Cells( 1, 1 );
    my $cell2 = $newsheet->Cells( 2, 4 );
    my $range = $newsheet->Range( $cell1, $cell2 );
    my $rangeValue = $range->{Value};

    # edit the cell values in the range
    foreach my $rangeRow (@$rangeValue) {
        foreach my $rangeCell (@$rangeRow) {
            $rangeCell = "*";
        }
    }

    # set the value of the range to the edited range
    $newsheet->Range( $cell1, $cell2 )->{Value} = $rangeValue;

    # save the workbook
    $workbook->Save();

    #-----------------------------------------------------

}

# wait for user input before closing
print "Press any key to close Excel...";
<STDIN>;

# close the Excel application
$excelAppl->Quit;
