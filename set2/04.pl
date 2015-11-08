# Oefening 4

# Inhoud van een werkblad. Om de inhoud van een werkblad te manipuleren,
# initialiseer je een Range object, en je vraagt de waarde van het default attribuut Value op.
# Dit is geen object maar een gewone variabele !
# Meestal is het een array (éen- of twee- dimensionaal) maar het kan ook leeg zijn
# of slechts 1 getal bevatten !!
# In Perl(Script) bekom je eigenlijk een referentie en kan je met ref nagaan of het een
# referentie naar een array betreft.
# Pas het script aan zodat nu ook de inhoud getoond wordt (in matrix-vorm) van elk werkblad.
# Zoek uit hoe je kan herkennen dat een werkblad leeg is,
# en controleer of je oplossing altijd correct werkt.

# Tip: In de Perl-documentatie vind je een goed voorbeeld in de tak
# ActivePerl FAQ / Windows Specific FAQ / Using OLE with Perl,
# onder How do I extract a series of cells from Microsoft Excel?

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
