# Oefening 8

# CIM repository analyseren:
# Een eerste stap is steeds een WMI service initialiseren voor een bepaalde
# namespace. Je kan dan ook maar een beperkt deel van de CIM repository
# bekijken. Het is niet altijd handig dat je de naam van de namespace moet
# "hard-coderen".
# Bovendien is het niet echt haalbaar om de volledige CIM repository op die
# manier te overlopen.

# In deze oefening worden alle namespaces op een toestel recursief bepaald,
# zodat je een start hebt om later de volledige CIM repository te analyseren
# met één script.
# Geef een hiërarchisch (maar op elk niveau op naam gesorteerd) overzicht van
# alle namespaces in de CIM repository. Ontwikkel hiervoor een subroutine
# GetNameSpaces met als parameter de naam van een namespace.
# Deze namespace wordt geconnecteerd en vervolgens worden alle namespaces
# opgevraagd die in deze namespace voorkomen. Dit zijn alle instanties van de
# klasse __NAMESPACE (zie ook vraag 3 uit de vorige reeks)

# Voor elke gevonden namespace roep je de subroutine GetNameSpaces recursief
# aan. Gebruik hierbij dat de naam van de namespaces hiërarchisch wordt
# opgebouwd.
# Zoek in WMI CIM Studio het attribuut dat je hiervoor nodig hebt. Je start uiteraard
# met de root-namespace.
# Enkel met administrator-rechten kan je de volledige hiërarchie doorlopen.
# Vang de eventuele fout op, zodat dit ook lukt zonder administrator-rechten,
# maar uiteraard beperkt tot de namespaces waar je wel toegang toe hebt.

use strict;
use warnings;
use Win32::OLE::Const;

# don't add $Win32::OLE::Warn, otherwise the script will stop when an error occurs

# variables, notice that we must use "our" instead of "my"
our $computername = ".";
our $namespace    = "root";
our $locator      = Win32::OLE->new("WbemScripting.SWbemLocator");

#-----------------------------------------------------------------------------------------

# define the subroutine GetNameSpaces
sub GetNameSpaces {

    # get the next namespace
    my $namespace = shift;
    print $namespace . "\n";

    # get the services object
    my $wbemservices = $locator->ConnectServer( $computername, $namespace );

    # return when the connection to the namespace failed
    if ( Win32::OLE->LastError() ) {
        return;
    }
    else {
        my $instances = $wbemservices->InstancesOf("__NAMESPACE");

        if ( $instances->{Count} == 0 ) {
            return;
        }
        else {
            foreach (
                sort { uc($a) cmp uc($b) }
                map  { $_->{Name} } in $instances)
            {
                GetNameSpaces("$namespace/$_");
            }
        }
    }
}

#-----------------------------------------------------------------------------------------

# program
GetNameSpaces($namespace);
