# Openen van een Excel-bestand. Schrijf een script dat als enige parameter de naam van een
# (excel-) bestand meekrijgt. Indien dit bestand niet bestaat in de huidige directory wordt
# een nieuw werkboek aangemaakt die onder die naam wordt opgeslagen. Toon in beide gevallen
# het aantalwerkbladen (sheets) van het bestand.
# Je zal ondervinden dat de Excel-toepassing het bestand niet gaat zoeken in de directory van
# waaruit je het script aanroept, maar wel in de ingestelde default-directory van Excel.
# Gebruik het FSO-object om de absolute padnaam te bepalen.

use strict;
use warnings;
use Win32::OLE qw(in);
use Cwd qw();

# set the parameters
@ARGV = ("my-excel.xlsx");

# open the current application or a new one
my $excelAppl = Win32::OLE->GetActiveObject('Excel.Application')
  || Win32::OLE->new( 'Excel.Application', 'Quit' );
$excelAppl->{visible} = 1;    # 0 = excel is invisible ; 1 = excel is visible

for my $workbookname (@ARGV) {

    my $path = Cwd::cwd();
    print "\n$path/" . $workbookname;

    # open the given workbook
    my $workbook = $excelAppl->Workbooks->Open($path . "/" . $workbookname);
}

<STDIN>
