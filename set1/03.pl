# Initialiseren van COM-objecten met het ProgID
# De VBScript-engine beschikt over de functie Createobject(ProgID) 
# waarmee je een COM-object kan initialiseren.
#     set cdo = CreateObject("CDO.Message")
# In PerlScript gebruik je hiervoor de functie new(ProgID) van de 
# Win32::OLE module.

#use strict;
use Win32::OLE;

# create a new instance of an OLE Automation object
# here, this object is CDO.Message
# if creation failed: $cdo has the value undef
my $cdo = Win32::OLE->new("CDO.Message");

print "Object with no ref: \n";
print $cdo . "\n\n";

print "Object with ref: \n";
print ref $cdo;
print "\n";