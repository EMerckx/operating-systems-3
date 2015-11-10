# Oefening 17

# Je kan zelf een aantal andere mogelijkheden uitproberen,
# zoals een attachment toevoegen.
# Zoek de nodige attributen en methodes op in de documentatie.

use strict;
use warnings;
use Win32::OLE qw(in);
use Win32::OLE::Const;

# script stops and gives error message is something goes wrong
$Win32::OLE::Warn = 3;

# create the mail and configuration objects
my $mail = Win32::OLE->new("CDO.Message");
my $conf = Win32::OLE->new("CDO.Configuration");

# specify the configuration
# for urls, see:
# CDO for Windows 2000
# > Reference
# > Fields
# > http://schemas.microsoft.com/cdo/configuration
$conf->Fields("http://schemas.microsoft.com/cdo/configuration/smtpserver")
  ->{Value} = "smtp.UGent.be";    # at hogent: smtp.hogent.be
$conf->Fields("http://schemas.microsoft.com/cdo/configuration/smtpserverport")
  ->{Value} = 25;
$conf->Fields("http://schemas.microsoft.com/cdo/configuration/sendusing")
  ->{Value} = 2;

# DON'T FORGET TO UPDATE !
$conf->{Fields}->Update();

# specify the message
$mail->{Configuration} = $conf;
$mail->{From}          = '...@ugent.be';
$mail->{To}            = '...@ugent.be';
$mail->{Subject}       = "Attachment via COM";
$mail->{TextBody} =
  "This is the mail with the attachment via COM infrastructure";
print "Mail constructed \n";

# add an attachement if the file exists
my $filename = "file.txt";
my $fso      = Win32::OLE->new("Scripting.FileSystemObject");
if ( $fso->FileExists($filename) ) {

    # get the absolute path
    my $absolutepath = $fso->GetAbsolutePathName($filename);

    # add the file as an attachement to the mail
    $mail->AddAttachment($absolutepath);
    print "Attachement added \n";
}

# send the mail
$mail->Send();
print "Mail has been sent \n";
