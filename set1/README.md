# REEKS 1 : COM programmatie in de praktijk

Thuis:

1. Oleview  installeren.
2. Perl: Download perl (Windows versie) - inclusief perlscript en ActivePerl documentatie.
3. De MSDN Library van VisualStudio 2008 : beschikbaar op WWW of CD - deze versie verschilt minimaal van de MSDN Library op de labotoestellen. Druk dit overzicht af, dan vind je sneller informatie in de MSDN Library.

De ActivePerl documentatie en MSDN Library zijn lokaal beschikbaar op de labocomputers en kan je raadplegen tijdens de testen.
Je stelt best in dat er niet online wordt gezocht (geeft problemen als er geen netwerk is). Dit is instelbaar in Tools / Options / Help / Online
Je kan er veel informatie terugvinden en kopiëren. Je mag ook de cursus Perl van vorig jaar gebruiken op de testen.

## COM programmatie in de praktijk

We bespreken in deze reeks de basisprincipes van COM programmatie met scripts.

Een Windows script is een tekstfile, geschreven in een scripttaal (Script Engine). Een Windows script wordt niet gecompileerd in .exe vorm, maar is volledig aangewezen op een Scripting Host om zijn code at runtime uit te voeren.
Elke scripting host biedt een omgeving aan die zorgt voor de correcte uitvoering van elk script, geschreven in een taal waarvoor de ActiveX script engine geïnstalleerd is. De meeste scripting hosts zijn toepassingen (zoals Internet Explorer zie hoofdstuk 5).

De volgende Scripting Hosts, die vanuit een Command Prompt console worden opgestart, zijn uitermate geschikt voor operating systeem verwante taken:

* WSH: Window Scripting Host  , gecombineerd met VBScript, JavaScript of Perlscript als scripting Engine.
* Perl: enkel in combinatie met engine PerlScript

### Modules gebruiken in PerlScript

Perl(Script) stelt een enorme hoeveelheid extra functionaliteit ter beschikking met behulp van modules. Je kan een overzicht raadplegen en ook PerlScript modules downloaden op CPAN, of met de ppm opdracht.

Informatie over de ingeladen modules vind je in de hash %INC, zoals in onderstaand voorbeeld wordt geïllustreerd. Je krijgt hierdoor toegang tot de geëxporteerde functies uit de module.
In de inleiding werd de module strict reeds vermeld. Als je deze module inlaadt worden declaraties verplicht gemaakt. Welke submodules worden hierdoor ingeladen? (Je moet nu wel alle variabelen ook declareren.)

* [Oefening 2][2]

Met Perl als host kan je niet automatisch COM-objecten initialiseren. In de Perl-documentatie, de sectie Using OLE with Perl, staat beschreven dat je hiervoor de OLE-module inlaadt met:

```
use Win32::OLE qw(in with);
```

Onderzoek welke sub-modules nu worden ingeladen.

* [Oefening 2b][2b]

Deze module bevat een aantal interessante/noodzakelijke functies en methodes om COM objecten te initialiseren en te gebruiken vanuit Perlscript. De beschrijving van alle beschikbare functies en methodes zoek je op in dezelfde Perl-documentatie in de sectie Modules / Win32 / OLE (in de linkerkolom bijna helemaal naar beneden scrollen).
Een korte bespreking van de interessantste functies:

* [Oefening 10][10]

## FileSystemObject model

Om bestanden, folders, drives,... te bewerken/beheren in een script gebruik je het run-time object <b>FileSystemObject (FSO)</b>. Een overzicht hiervan vind je in de MSDN Library in Web Development / Scripting / Windows Script Technologies / Script Runtime / FileSystemObject Object

Het FSO object model is een hiërarchie met objecten en collecties (die allen non-exposed zijn). Zoek de methode waarmee je een Folder, File, Drive kan ophalen. Een aantal eigenschappen van een bestand, map of drive kan je direct ophalen met een methode van het FSO object. Je kan die eigenschappen ook terugvinden in het object dat gekoppeld kan worden aan het bestand, folder of drive. Dat object heeft nog meer eigenschappen en methodes ter beschikking.

* [Oefening 11][11]

(...)

## Collaboration Data Objects (CDO) : mail versturen

(...)

In deze paragraaf versturen we de mail door enkel gebruik te maken van COM-objecten. We gebruiken nog steeds perl als "host", en perlScript als "scripttaal", maar ook met een andere host of engine blijft deze oplossing correct werken. We beperken ons tot het versturen van een eenvoudige tekstboodschap naar één mail-adres, met behulp van het SMTP-protocol.
De hoofdbedoeling van deze oefening is dat je leert werken met COM-objecten, leert opzoeken in de documentatie en de mogelijkheden van de module Win32::OLE begrijpt.

Alle noodzakelijke informatie over de COM-objecten die we hiervoor nodig hebben, vind je in de MSDN Library terug in de tak WIN32 and COM Development / Messaging and Collaboration / Collaboration Data Objects (CDO) / CDO for Windows 2000

De subtak About CDO for Windows 2000 / CDO for Windows 2000 Object Model toont de volledige hiërarchie.
De verdere beschrijving van alle klassen vind je terug in de subtak Reference / COM Classes . 

Voor onze eenvoudige mail gebruik je twee COM-klassen :

| COM klasse     | ProgId             |
|----------------|--------------------|
| Message        | CDO.Message        |
| Configuration  | CDO.Configuration  |

Voor de "Message" klasse beperken we ons tot de interface IMessage. De beschikbare attributen/methodes kan je ook direct terugvinden in de tak Reference / Interfaces.

* [Oefening 14][14]

De methode Send() uit de interface IMessage is verantwoordelijk voor het verzenden van de mail. Als je dit uitprobeert, dan zal de mail waarschijnlijk niet toekomen: je hebt immers niet opgegeven hoe dit moet gebeuren. (Indien Outlook Express correct geconfigureerd is via smtp, kan dit wel werken.) Toon de foutmelding voor extra informatie.
De "Configuration" klasse is verantwoordelijk voor de instellingen. Voor deze klasse bestaat enkel de interface IConfiguration, met als enige attribuut de Fields collectie, die de "configuration settings" instelt. We bespreken eerst algemeen wat collecties zijn.

(...)

Waarschijnlijk bevat dit configuratie object geen informatie over de uitgaande server. In de paragraaf CDO for Windows 2000 / Messaging / Messaging Programming Tasks / Configuring the Message Object / Sending or Posting Using the Network wordt beschreven welke instellingen noodzakelijk zijn om een mail te versturen over het netwerk met het SMTP-protocol : sendusing en smtpserver. Bekijk ook het voorbeeldje onderaan (in VbScript).
Omdat het Configuration object zijn informatie haalt bij het mail-programma Outlook Express, kan je de instellingen gewoon instellen door dit programma te initialiseren met een juiste account. Het belangrijkste is het instellen van de uitgaande server.
Dit kan je thuis gemakkelijk uitproberen. Nu bevat het configuratie object veel meer velden, en zal het verzenden van de mail wel lukken.

(...)

### Hoe stel je zelf de configuratie in?

Voeg de volgende initialisaties toe:

``` Perl
#thuis aanpassen
$conf->Fields("http://schemas.microsoft.com/cdo/configuration/smtpserver")
	->{Value} = "smtp.hogent.be"; 

#niet noodzakelijk
$conf->Fields("http://schemas.microsoft.com/cdo/configuration/smtpserverport")
	->{Value} = 25;               

$conf->Fields("http://schemas.microsoft.com/cdo/configuration/sendusing")
	->{Value}  = 2;

#is noodzakelijk
$conf->{Fields}->Update();      
```

Tot slot moet je deze configuratie instellen op het Message Object :

```Perl
#moet ingevuld worden
$mail->{Configuration}=$conf;  
```

Nu zal het verzenden van de mail met send() altijd lukken, ook als Outlook Express niet is ingesteld.

* [Oefening 17][17]

[2]: https://github.com/EMerckx/operating-systems-3/blob/master/set1/02.pl
[2b]: https://github.com/EMerckx/operating-systems-3/blob/master/set1/02b.pl
[10]: https://github.com/EMerckx/operating-systems-3/blob/master/set1/10.pl
[11]: https://github.com/EMerckx/operating-systems-3/blob/master/set1/11.pl
[14]: https://github.com/EMerckx/operating-systems-3/blob/master/set1/14.pl
[17]: https://github.com/EMerckx/operating-systems-3/blob/master/set1/17.pl