# Oefening 14

# Een eerste stap is het initialiseren van een mail-object met een
# Message Object - zie hiervoor. Vul gegevens in voor de afzender,
# de bestemmeling, het onderwerp en de inhoud.
# Zoek de juiste attribuutnamen op in de interface IMessage.
# In PerlScript bevat de variabele een referentie naar het Message Object,
# en moet je ->{attributeName} gebruiken.

use strict;
use warnings;
use Win32::OLE qw(in);
use Win32::OLE::Const;

# script stops and gives error message is something goes wrong
$Win32::OLE::Warn = 3;

# create a message object
my $mail = Win32::OLE->new("CDO.Message");

# add the source address
# careful for the @ symbol -> use single quotes
$mail->{From} = '...@ugent.be';

# add the destination address
# careful for the @ symbol -> use single quotes
$mail->{To} = '...@ugent.be';

# add the subject
$mail->{Subject} = "Subject";

# add the content of the mail
$mail->{TextBody} = "This is the body.";
