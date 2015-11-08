# REEKS 2: Het Excel object model

## Aan de slag met Excel

Uiteraard kan je deze oefeningen enkel maken als Excel geïnstalleerd is. De versie maakt niet echt veel uit. Je kan ook gebruik maken van Athena. Start een Command Shell om je perl-scripts te runnen. Excel is daar beschikbaar.
De tak Office Solutions Development / 2007 Microsoft Office System van de MSDN Library bevat uitgebreide documentatie over diverse Office-toepassingen (versie 2003 en versie 2007).
We beperken ons in deze labo's tot Excel en behandelen in deze sessie enkel een paar elementaire aspecten van het Excel object model, zonder formules of grafieken. Documentatie zoek je op in de sectie Office Solutions Development / 2007 Microsoft Office System / Excel 2007 / Excel 2007 Developer Reference , die we in deze notas de Excel 2007 Documentatie zullen noemen. In de subtak Excel Object Model Reference / Excel Object Model Map / Object Model Map vind je de volledige hiërarchie van Excel. We beperken ons tot het Application object, en gebruiken enkel sub-objecten/collecties die non-exposed zijn, dit wil zeggen dat ze geen eigen ProgID hebben, maar via een attribuut worden geïnitialiseerd. De objecten en collecties zijn Win32::OLE objecten. Je kan dus informatie bekomen over het object met de methode testConnectie uit vorig labo.

In het register zijn er meerdere COM-componenten die elk een deel van de functionaliteit van Excel implementeren. De component "Excel.Application" stelt een volledige Excel-applicatie voor. Zoek de GUID en ProgId op in het register. Bekijk verder de informatie in de bijhorende CLSID-tak. Je vindt geen subtak Typelib. Om de Type Library terug te vinden bekijk je in het register de component "Excel.Sheet". Daar vind je in de subtak Typelib de GUID van de Excel Type Library. De naam van deze Type Library is Microsoft Excel 12 Object Library (versie-afhankelijk), en kan je terugvinden in Oleview. Om de constanten uit de voorbeelden te kunnen gebruiken kan je dus best naar deze Type Library refereren, zie reeks1.

Initialiseer met het Application object een nieuwe Excel-applicatie. Hierdoor wordt Excel opgestart in embedded mode. Dit betekent dat je niet ziet dat Excel opgestart is. Bij het beëindigen van je script wordt de applicatie niet steeds automatisch afgesloten: je moet hiervoor expliciet de OLE-methode quit oproepen. Vooral indien een fout optreedt tijdens het uitvoeren van een script, kan het gebeuren dat het Excel proces in embedded mode niet correct afgesloten wordt. Sluit in die gevallen dan zelf Excel af, met behulp van de Task Manager.

In PerlScript zijn er drie interessante mogelijkheden voor het initialiseren van een referentie naar Excel. Meer informatie hierover vind je in de Perl-documentatie die hiervoor werd opgegeven:

* een OLE-methode opgeven, die moet worden uitgevoerd als het object wordt vernietigd:

```
$excelAppl = Win32::OLE->new('Excel.Application','quit');
```

* een referentie maken naar een Excel proces dat reeds is opgestart (hierdoor vermijd je dat er meerdere Excel-processen ingeladen worden):

```
$excelAppl = Win32::OLE->GetActiveObject('Excel.Application');
```

* een combinatie van beiden:

```
$excelAppl = Win32::OLE->GetActiveObject('Excel.Application') || Win32::OLE->new('Excel.Application', 'Quit');
```

In de Perl-documentatie vind je onder de tak ActivePerl FAQ / Windows Specific FAQ / Using OLE with Perl een voorbeeldje dat bovenstaande code bevat.

Een handig hulpmiddel bij het ontwikkelen van scripts is het attribuut visible instellen op 1 (true). Nu wordt Excel ook op het scherm getoond, en kan je eenvoudig Excel terug afsluiten als er iets fout gaat.

* [Oefening 1][01]
* [Oefening 2][02]

Een worksheet kan in de Worksheets-collectie zowel door zijn naam, als numeriek (startend vanaf 1, niet vanaf 0 !) aangesproken worden, en bevat de uiteindelijke informatie die we willen verwerken.
Elk Worksheet object heeft een heleboel subobjecten (o.a. ChartsObjects, PageSetup Object, ...) die we niet verder zullen bespreken. Ook de verschillende methods die je hierop kan toepassen, worden niet verder behandeld. Belangrijk voor ons is de eigenlijke inhoud van dit object: deze bestaat uit cellen. Je kan deze cellen individueel aanspreken, maar je kan ook een geheel van cellen groeperen. Het begrip Range-object staat voor een geheel van cellen in zo'n Worksheet, en je kan deze toekennen met diverse attributen van het Worksheet-object : Cells, Range, Columns, Rows, UsedRange, ... .

Overzichtelijke informatie en voorbeelden (in Visual Basic) hierover vind je in de Excel 2007 Documentatie terug in de subtakken Concepts en How do I ... in Excel 2007 .

De eenvoudigste manier, om informatie van een bestaand Excel-bestand in bekomen, gebruikt het attribuut UsedRange om alle gegevens van een bepaalde Worksheet aan een Range object toe te kennen. Je moet echter de Range niet activeren om te kunnen verwerken (alhoewel dit in veel voorbeelden in de MSDN-library wel gebeurt).
Een Range object beschikt altijd over de collectie-objecten rows en columns. Elk element van deze collectie is zelf ook een range-object. Met het attribuut Count kan je weten hoeveel rijen (resp. kolommen) de range heeft.

* [Oefening 3][03]
* [Oefening 4][04]

Delen van een worksheet ophalen. Hieronder een paar voorbeelden die een beperkter deel van een worksheet ophalen.

```
$range=$nsheet->Range("A1:D10");
$range=$nsheet->Cells(4,1);
$range=$nsheet->Range($nsheet->Cells(1,1),$nsheet->Cells(4,3));
```

* [Oefening 5][05]

[01]: https://github.com/EMerckx/operating-systems-3/blob/master/set2/01.pl
[02]: https://github.com/EMerckx/operating-systems-3/blob/master/set2/02.pl
[03]: https://github.com/EMerckx/operating-systems-3/blob/master/set2/03.pl
[04]: https://github.com/EMerckx/operating-systems-3/blob/master/set2/04.pl
[05]: https://github.com/EMerckx/operating-systems-3/blob/master/set2/05.pl