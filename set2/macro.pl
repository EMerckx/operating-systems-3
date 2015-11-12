# Macro

use strict;
use warnings;
use Win32::OLE qw(in);

# set the parameters
@ARGV = ("my-excel-macro.xlsx");

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

     # get a range of cells
    my $cell1 = $newsheet->Cells( 1, 1 );
    my $cell2 = $newsheet->Cells( 2, 4 );
    my $range = $newsheet->Range( $cell1, $cell2 );
    
    # should work, but can't find macro
    $range->run('my-excel-macro!Macro1');
    
    $workbook->Save();
}

# wait for user input before closing
print "Press any key to close Excel...";
<STDIN>;

# close the Excel application
$excelAppl->Quit;