# REEKS 1 : COM programmatie in de praktijk

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


[10]: https://github.com/EMerckx/operating-systems-3/blob/master/set1/10.pl
[11]: https://github.com/EMerckx/operating-systems-3/blob/master/set1/11.pl
[14]: https://github.com/EMerckx/operating-systems-3/blob/master/set1/14.pl