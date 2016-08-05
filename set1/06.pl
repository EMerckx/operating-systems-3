# Indien een fout optreedt zal het perlScript niet stoppen. 
# Je kan echter met behulp van LastError() de foutmelding 
# opvragen. Probeer dit zelf uit door een fout ProgId in te 
# geven.

use strict;
use Win32::OLE;

my $excel = Win32::OLE->new("Excel.Sheet");
print "Last error: " . Win32::OLE->LastError() . "\n";