# Met QueryObjectType bekom je extra informatie over het 
# type van een COM object. Vergelijk dit met de informatie 
# die je met ref kon opvragen.

use strict;
use Win32::OLE;

# CDO.Message
my $cdo = Win32::OLE->new("CDO.Message");

print "CDO.Message \n";
print "ref            : ";
print ref $cdo;
print "\nQueryObjectType: ";
print Win32::OLE->QueryObjectType($cdo);
print "\nQueryObjectType: ";
print join(" / ", Win32::OLE->QueryObjectType($cdo));
print "\n\n";

# Scripting.FileSystemObject
my $fso = Win32::OLE->new("Scripting.FileSystemObject");

print "Scripting.FileSystemObject \n";
print "ref            : ";
print ref $fso;
print "\nQueryObjectType: ";
print Win32::OLE->QueryObjectType($fso);
print "\nQueryObjectType: ";
print join(" / ", Win32::OLE->QueryObjectType($fso));
print "\n\n";

# Excel.Sheet
my $excel = Win32::OLE->new("Excel.Sheet");

print "Excel.Sheet \n";
print "ref            : ";
print ref $excel;
print "\nQueryObjectType: ";
print Win32::OLE->QueryObjectType($excel);
print "\nQueryObjectType: ";
print join(" / ", Win32::OLE->QueryObjectType($excel));
print "\n";
# ERROR: object is not a Win32::OLE object (line 39 & 41)
# This error was caused by the fact that Excel wasn't installed
# After installing Excel, this script works perfectly