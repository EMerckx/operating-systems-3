# Openen van een Excel-bestand. Schrijf een script dat als enige parameter de naam van een
# (excel-) bestand meekrijgt. Indien dit bestand niet bestaat in de huidige directory wordt
# een nieuw werkboek aangemaakt die onder die naam wordt opgeslagen. Toon in beide gevallen
# het aantalwerkbladen (sheets) van het bestand.
# Je zal ondervinden dat de Excel-toepassing het bestand niet gaat zoeken in de directory van
# waaruit je het script aanroept, maar wel in de ingestelde default-directory van Excel.
# Gebruik het FSO-object om de absolute padnaam te bepalen.

use strict;
use warnings;
use Win32::OLE::Const;

# set the parameters
@ARGV = ( "my-excel.xlsx", "excel-not-found.xlsx" );

# open the current application or a new one
my $excelAppl = Win32::OLE->GetActiveObject('Excel.Application')
  || Win32::OLE->new( 'Excel.Application', 'Quit' );
$excelAppl->{visible} = 1;    # 0 = excel is invisible ; 1 = excel is visible

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
    }
    else {

        # create the name for the new workbook
        my $directorypath = $fso->GetAbsolutePathName(".");
        my $workbookpath  = $directorypath . "\\" . $workbookname;

        # open a new workbook
        print "Could not find " . $workbookpath . "\n";
        print "Opening new workbook \n";
        my $workbook = $excelAppl->{Workbooks}->Add();

        # save the new workbook
        $workbook->SaveAs($workbookpath);
    }
}

# wait for user input before closing
print "Press any key to close Excel...";
<STDIN>;

# close the Excel application
$excelAppl->Quit;
