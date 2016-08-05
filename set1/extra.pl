# This piece of code can be used to check whether 
# an object was initialized correctly

use strict;
use Win32::OLE;

sub testInit{
    # error detected
    if(Win32::OLE->LastError()){
        print "Error occured: \n";
        print Win32::OLE->LastError() . "\n";
    }
    # no error detected
    else{
        # call to the method with ()
        print @_;
        print "\n";
        if(@_){
            my $object = $_[0];
            my $type = ref($object);
            print "ref            : " . $type . "\n";
            print "QueryObjectType: " . Win32::OLE->QueryObjectType($object) . "\n";
        }
    }
}

my $cdo = Win32::OLE->new("CDO.Message");
testInit();