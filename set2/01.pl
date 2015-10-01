# Werkboek en werkblad: In Excel wordt elk excel-bestand gekoppeld aan een werkboek.
# Elk werkboek bevat één of meerdere werkbladen. Bekijk onderstaand voorbeeld en merk op :
# * de collectie Workbooks bevat alle werkboeken (-> alle geopende Excelbestanden).
# In embedded mode wordt er niet automatisch een werkbook geopend, zodat deze collectie
# voorlopig leeg is.
# * de collectie Workbooks heeft methodes Add, Open, Save, SaveAs, ... om een nieuw werkboek
# toe te voegen, een bestaand werkboek te openen, een werkboek op te slaan.
# * het workbook object (-> één Excelbestand) beschikt over een collectie van alle Worksheets
# in dit workbook. Een nieuw werkboek bevat bij een standaard configuratie telkens drie
# werkbladen.
# * Elke individuele Worksheet heeft een naam.
# * De collectie Worksheets bevat een methode Add, die (vooraan) een nieuwe worksheet toevoegt.
# Bij afsluiten van Excel zal een foutmelding getoond worden omdat dit werkboek niet werd opgeslagen.
# Met het attribuut DisplayAlerts kan je aangeven dat Excel geen foutmeldingen moet tonen.

use strict;
use warnings;
use Win32::OLE qw(in);

# use an existing process or start a new one in embedded mode
my $excelAppl = Win32::OLE->GetActiveObject('Excel.Application')
  || Win32::OLE->new( 'Excel.Application', 'Quit' );
$excelAppl->{visible} = 0;    # 0 = excel is invisible ; 1 = excel is visible

# get the amount of workbooks
print "amount of workbooks in excel: ", $excelAppl->{Workbooks}->{Count} . "\n";

print "\n--------------------------------\n\n";

# add a workbook
my $book = $excelAppl->{Workbooks}->Add();

# get the amount of workbooks and the worksheets
print "amount of workbooks in excel: ", $excelAppl->{Workbooks}->{Count} . "\n";
print "amount of worksheets in the added workbook: ",
  $book->{Worksheets}->{Count} . "\n";
for my $sheet ( in $book->{Worksheets} ) {
    print "\t" . $sheet->{name} . "\n";
}

print "\n--------------------------------\n\n";

# add a worksheet
$book->{Worksheets}->add();

# get the amount of workbooks and the worksheets
print "amount of workbooks in excel: ", $excelAppl->{Workbooks}->{Count} . "\n";
print "amount of worksheets in the added workbook: ",
  $book->{Worksheets}->{Count} . "\n";
for my $sheet ( in $book->{Worksheets} ) {
    print "\t" . $sheet->{name} . "\n";
}

print "\n--------------------------------\n\n";

# show no errors
$excelAppl->{DisplayAlerts} = 0;

# wait for user input before closing
print "Press any key to close Excel...";
<STDIN>;
