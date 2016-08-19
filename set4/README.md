# REEKS 4: WMI scripting

## Own additions

### Printing data structures

To print a data structure, use Dumper. See the example below.

```
use Data::Dumper;

foreach (in $associators) {
	print Dumper($_);
}
print "\n";
```

### WMI Object attributes

To get the value of a property, systemproperty or qualifier, use the following syntax.

```perl
my $attr = "attributename"
$object->{"properties_"}->Items($attr)->{"value"};
$object->{"systemproperties_"}->Items($attr)->{"value"};
$object->{"qualifiers_"}->Items($attr)->{"value"};
```

### Create instances

Why does the class Win32_Process allow you to create instances of the class, and Win32_Product not? 
It's because Win32_Process has the qualifier SupportsCreate set to True, which allows the creation of instances.
The WMI documentation states:

```
SupportsCreate: 
    Data type: boolean
    Applies to: classes 
    Indicates whether the class supports the creation of instances. 
    The default is FALSE.
```

## Inleiding

De volledige WMI infrastructuur kan, ondermeer vanuit scripttalen, benaderd worden via COM objecten met een automation interface. De verzameling van deze COM objecten wordt de WMI Scripting Library genoemd. Zoek informatie over de COM objecten en hun onderlinge relatie op in de WMI Reference / Scripting API for WMI subtak van de WMI-documentatie. Bekijk in de subtak Scripting API Object Model het Scripting API Object Model. Deze bestaat uit een twintigtal COM klassen, die in deze reeks in diverse stappen zullen bestudeerd worden.
In het register vind je meerdere componenten, de naam begint met WbemScripting.

## Connecteren aan een WMI namespace

De eerste stap in een consumerscript is het initialiseren van de WMI service van een toestel (al dan niet hetzelfde toestel als waarop het script uitgevoerd wordt). Net als in WMI CIM Studio moet je hierbij connecteren aan één WMI namespace. Het SWbemServices object is de COM representatie van de WMI service voor een bepaalde namespace op een bepaald toestel. De naam van het toestel wordt met de DNS-naam of het IP-adres vastgelegd. Indien het doeltoestel het lokale toestel is, dan gebruik je localhost of "." als identificatie.

Het SWbemServices object initialiseren kan op twee manieren:

* De methode ConnectServer(Server,Namespace) van een SWbemLocator object resulteert in een SWbemServices object. De eerste twee parameters zijn de DNS-naam (of het IP-adres) van het doeltoestel, en de naam van de namespace. De ConnectServer methode aanvaardt optioneel ook een gebruikersnaam en bijhorend paswoord. Hierdoor kan je connecteren aan een WMI service in een andere gebruikerscontext dan deze waarin het consumerscript uitgevoerd wordt (vb thuis). Dit kan je niet gebruiken om op het lokale toestel te connecteren in een andere gebruikerscontext.
* Je kan elk WMI-object direct initialiseren met de moniker string die het object beschrijft. In Perl gebruik je hiervoor de functie Win32::OLE->GetObject(moniker). De monikerstring vb. "winmgmts://./root" bestaat uit 3 delen:
	* de protocolspecificatie, winmgmts:
	* de DNS-naam of het IP-adres van het doeltoestel
	* de namespace

Deze techniek is niet bruikbaar indien je in een andere gebruikerscontext wilt connecteren.
Bovendien zijn er situaties waar, om beveiligingsredenen, het gebruik van de GetObject niet toegelaten wordt. Bijvoorbeeld indien Internet Explorer de rol van scripting host vervult.

## Het WMI object (klasse of instantie)

Voor elk WMI object dat je wilt raadplegen, moet een SWbemObject geïnitialiseerd worden. Dit kan ook op twee manieren:

* Gebruik de Win32::OLE->GetObject(moniker) methode van PerlScript. De monikerstring bevat nu de volledige absolute padnaam (zoek dit op in WMI CIM Studio in het juiste systeemattribuut van de klasse of de instantie). Deze methode is maar beperkt bruikbaar, zie hiervoor.
* Gebruik de Get(relpad) methode van het SWbemServices object. De parameter is de kortere relatieve padnaam.

Een SWbemObject zal, afhankelijk van de moniker of het relpad dat werd opgegeven, een WMI klasse of een instantie ervan voorstellen.

## WMI-collecties (klassen of instanties)

In de voorgaande methodes moet je de padnaam kennen van de klasse of het object dat je wilt ophalen. Het is handiger om objecten en klassen op te halen met behulp van criteria. De eerste stap is nog steeds dat je een SWbemServices object initialiseert door te connecteren aan de gewenste namespace. In WMI Reference / Scripting API for WMI / Scripting API Objects subtak van de WMI-documentatie vind je alle methodes van het SWbemServices - object. Een aantal methodes resulteren in een WMI-collectie, een SWbemObjectSet object. Dit is een collection van SWbemObjecten. Deze methodes resulteren altijd in een SWbemObjectSet-object, ook al is er maar 1 of geen enkel object dat aan de beschrijving voldoet.

In WMI Reference / Scripting API for WMI / Scripting API Objects subtak van de WMI-documentatie vind je ook alle methodes van een SWbemObjectSet - object. Je vindt er de Count-property die het aantal objecten in de collectie bepaalt. Individuele SWbemObjecten in de SWbemObjectSet collectie kan je adresseren met de Item methode, geïndexeerd met het relatieve objectpad. Aangezien men het objectpad meestal niet kent, is dit niet erg praktisch.
Je kan echter, met behulp van de Win32::OLE::in functie, de SWbemObjectSet transformeren in een Perl array van SWbemObjecten, en vervolgens elke objectinstantie aflopen met de foreach opdracht.

Indien de SWbemObjectSet maar 1 object bevat kan je dit unieke object dus ook eenvoudig ophalen met:

```
my ($Object)=in $ObjectSet;
```

Je kan ook een numerieke index gebruiken om een welbepaald object uit een collectie op te halen:

```
my $Object=(in $ObjectSet)[2];
```

Indien je maar 1 attribuut (vb Name) nodig hebt van elk SWbemObject in de SWbemObjectSet, dan kan je gebruik maken van map, vb.

```
@Names=map{$_->{Name}} in $ObjectSet;
```

Een eerste eenvoudige methode van het SWbemServices object die een WMI-collecties ophaalt:
* de InstancesOf(classname) methode, met als parameter een klassenaam, resulteert in een SWbemObjectSet met ALLE instanties van die specifieke klasse, of met die klasse als ouderklasse.
Dezelfde collectie kan bekomen worden als je éérst het SWbemObject initialiseert dat de klasse representeert (bijvoorbeeld door de Get methode van een SWbemServices object op te roepen met als parameter de naam van de klasse) en vervolgens hiervan de Instances_( ) methode uit te voeren, zonder parameters.
Vermijd deze techniek indien er zeer veel instanties zijn van de klasse.

Een tweede interessante methode gebruikt een WQL query:
* de ExecQuery(WQLquery) methode, met als parameter een WQLquery die de gewenste WMI objecten beschrijft. Dit resulteert in een verbetering van de performantie. Het performantieverschil komt nog meer tot uiting indien de doelcomputer niet de lokale computer is: de functie wordt immers volledig op de doelcomputer uitgevoerd.
Je kan de WQL-query vooraf uittesten in WbemTest of in WMI CIM Studio.

Controleer in de MSDN-Library het type van de return-waarde van beide methodes. Merk op dat beide methodes nog andere parameters hebben, die echter optioneel zijn (zie verder).

Een andere veelgebruikte methode van het SWbemServices object die resulteert in een SWbemObjectSet (ook al voldoet er maar één enkel WMI object aan de selectie) is:

* de AssociatorsOf(relpad) methode met als eerste parameter het relatieve objectpad van het doelobject (dat overeenkomt met het argument dat tussen de akkolades van een ASSOCIATORS OF {…} WQL query geplaatst wordt).
Dezelfde collectie kan bekomen worden door eerst het SWbemObject te initaliseren en vervolgens de Associators_( ) methode uit te voeren. Beide methodes hebben nog tien optionele parameters (mogen ingevuld worden met undef, of via een anonieme hash doorgegeven worden). De eerste vier optionele parameters komen overeen met de argumenten van de diverse predikaten in de overeenkomstige WHERE clausule van de ASSOCIATORS OF {…} WQL query, nl AssocClass = …, ResultClass = …, ResultRole = …, Role = …. De vijfde en zesde optionele parameter komen overeen met de waarden van de predikaten ClassDefsOnly en SchemaOnly. Meer informatie vind je in de documentatie van deze methodes.

## Opvragen van attributen van een SWbemObject

Om een attribuutwaarde op te vragen van een SWbemObject werd in de vorige oefeningen reeds ->{"attibuteName"} gebruikt, maar deze methode werkt niet altijd. We moeten eerst opmerken dat er twee soorten attributen zijn:

* WMI systeemattributen die typisch zijn voor de fundamentele bewerking in WMI, ze zijn beschikbaar voor alle SWbemObjecten
* attributen die specifiek zijn voor de klasse waartoe het SWbemObject behoort.

De WMI systeemattributen zijn gemakkelijk te herkennen omdat de attribuutnaam begint met een dubbel _-teken, bijvoorbeeld __CLASS, __RELPATH,.... Deze attributen zijn ook altijd ingesteld, zowel voor de klasse als voor zijn instanties, en bevatten algemene informatie over het object.
De andere attributen bevatten specifieke informatie voor een bepaalde instantie of klasse, ze zijn niet altijd ingesteld. Het opvragen van een attribuut is fundamenteel verschillend voor beide types. Bovendien zijn er telkens twee verschillende technieken om de inhoud van een attribuut op te vragen.

### Formele methode

Elk SWbemObject komt overeen met een COM-object van het type SWbemObjectEx, dat zelf is afgeleid van SWbemObject. In de WMI-documentatie vind je het SystemProperties_-attribuut (van SWbemObjectEx) dat alle WMI systeemattributen opvraagt, en ook het Properties_-attribuut (van SWbemObject) waarmee alle andere attributen beschikbaar gesteld worden. Zoals je ook in de WMI-documentatie terugvindt, bekom je telkens een SWbemPropertySet collectie van SWbemProperty objecten. Elk van deze SWbemProperty objecten stelt één attribuut voor van het SWbemObject. De naam, het type,... van dit WMI attribuut te bekomen, moet men de Name, CIMType , IsArray,... attributen van het SWbemProperty object raadplegen.

Hiermee kan je programmatorisch een overzicht maken van alle attributen van een bepaald SWbemObject.

* [Oefening 13][13]

Nu kunnen we ook de uiteindelijke waarde opvragen van een bepaald attribuut. Het Value attribuut van elk SWbemProperty object bevat de uiteindelijke waarde. Zoals hiervoor beschreven kan je met het IsArray attribuut van het SWbemProperty object bepalen of de waarde een enkelvoudige of een samengestelde waarde heeft. In Perl beschik je ook over de ref operator toegepast op het Value attribuut.

* Oefening 14
* [Oefening 15][15]

Men is niet verplicht om de SWbemPropertySet collectie element per element af te lopen: de SWbemPropertySet collectie wordt geïndexeerd met het Item attribuut. Zo kan men uiteindelijk de waarde van een specifiek attribuut van een SWbemObject in Perl bekomen via volgende syntax:

```
$WbemObject->{Properties_}->Item("attribuutname")->{Value}
```

wat ingekort kan worden tot:

```
$WbemObject->Properties_("attribuutname")->{Value}
```

Analoog voor een specifiek systeemattribuut van een SWbemObject :

```
$WbemObject->SystemProperties_("systemattribuutname")->{Value}
```

### Directe methode

Deze directe methode werkt enkel met gewone attributen, en niet met systeem attributen!

(...)

## CIM repository analyseren

De WMI Scripting Library kan ook uitstekend gebruikt worden om de klassedefinities in de CIM repository te analyseren. Na connecteren met een bepaalde Namespace op een bepaald toestel, kan je met een schemaquery alle klassen ophalen.
Voor elke namespace initialiseer je een SWbemServices object en van daaruit kan je alle klassen van deze namespace verder te onderzoeken. Volgende methodes (de twee eerste methodes werden al gebruikt in de vorige oefeningen), resulteren in een SWbemObjectSet collectie van SWbemObjecten die enkel klassen representeren:

* **ExecQuery(WQLquery)** methode, met als parameter een WQL schemaquerystring (SELECT * FROM meta_class …): bepaalt alle klassen in de namespace.
* **AssociatorsOf(relpad,...,True)** methode, met een objectpad van een klasse als eerste parameter, en de zevende parameter (SchemaOnly) ingesteld op True - zie oefening 9.
* **SubclassesOf( )** methode. Zonder parameters bepaalt dit alle klassen in de namespace. Deze methode heeft twee interessante optionele parameters:
  * De eerste parameter beperkt het resultaat tot subklassen die van een specifieke klasse afgeleid zijn. In plaats van deze methode te gebruiken, kan je dan ook vertrekken van een SWbemObject dat de gewenste specifieke klasse representeert. Met de methode Subclasses_( ) bekom je dezelfde ObjectSet.
  * De tweede parameter geeft de mogelijkheid om de wbemQueryFlagShallow bit aan te zetten, dan levert de methode enkel onmiddellijke subklassen van de eerste parameter (of indien deze ontbreekt, subklassen die niet zijn afgeleid van een andere klasse). Deze WMI constante moet je correct "inladen" met de TypeLibrary.

* [Oefening 23][23]
* [Oefening 23b][23b]
* [Oefening 24][24]

## Qualifiers

Zoals we in de vorige reeks gezien hebben bevat de CIM repository ook allerlei qualifiers. Deze informatie kan je ook programmatisch onderzoeken.
Je kan geen informatie over qualifiers opnemen in een WQL-query.

Opmerkingen vooraf:

1. Indien je informatie wil opvragen over qualifiers, kan je best bij het ophalen van het WMI object de wbemFlagUseAmendedQualifiers bit van de iflags parameter van de diverse SWbem methodes (get, subclassesOf, getObject, ExecQuery...) aan zetten, anders worden niet alle qualifiers opgehaald. Deze WMI constante (die moet worden ingeladen!!) wordt op de juiste positie in de parameterlijst opgegeven (afhankelijk van de specifieke methode).
2. Aangezien qualifier-informatie enkel afhangt van de klasse waartoe een WMI object behoort is het efficiënter om de qualifiers te bepalen van het WMI object dat de bijhorende WMI klasse voorstelt: zo wordt vermeden dat men dit moet herhalen voor elk individueel WMI object van dezelfde klasse. Bovendien is de SWbemQualifierSet collectie van een instantie maar een deelset van de SWbemQualifierSet collectie van de overeenkomstige klasse!!

### Klassequalifiers

Voor elk SWbemObject vraag je met het Qualifiers_ -attribuut de SWbemQualifierSet collectie van SWbemQualifier objecten, die elk individueel een klassequalifier representeren. Deze bevatten meer gedetailleerde informatie over de klasse. Elk SWbemQualifier object heeft een Name en een Value. Je kan dus geen informatie vragen over het type van de qualifier (zie documentatie).

* [Oefening 25][25]
* [Oefening 26][26]
* [Oefening 27][27]
* [Oefening 28][28]
* [Oefening 29][29]

### Attribuutqualifiers

Elk attribuut wordt voorgesteld als een SWbemProperty object. We bespraken reeds de Name, CIMType, Value en IsArray attributen van een SWbemProperty object. Met het Qualifiers_ attribuut van dit SWbemProperty object wordt een SWbemQualifierSet opgehaald van SWbemQualifier objecten, die elk individueel een attribuutqualifier representeren. Op deze manier kunnen de attribuutqualifiers ondervraagd worden, bijvoorbeeld om via het Values/ValueMap mechanisme de waarde van de attributen op een meer informatieve manier te kunnen interpreteren.

* [Oefening 30][30]
* [Oefening 31][31]
* [Oefening 31b][31b]
* Oefening 32
* ...
* Oefening 36

## Methodes van een SWbemObject

De methodes van een SWbemObject worden beschreven met een vrij complexe objecten-hiërarchie, die alle informatie verpakt in aparte objecten, die we nu zullen bespreken.
Voor elk SWbemObject, ongeacht of dit een klasse of een object representeert, verwijst het Methods_ attribuut naar een SWbemMethodSet collectie van SWbemMethod objecten. (Dit is NIET toepasbaar op het SWbemServices object).
Elke individuele methode van een WMI klasse/object kan benaderd worden met een SWbemMethod object. Zoals je in de WMI-documentatie kan terugvinden, heeft dit SWbemMethod object volgende interessante properties:

* het Name attribuut: een string die ook kan gebruikt worden om een individueel element van de SWbemMethodSet collectie te indexeren,
* het Qualifiers_ attribuut: representeert de methodequalifiers (zie reeks3) als een SWbemQualifierSet collectie van SWbemQualifier objecten.
* de InParameters bevatten informatie over de invoerparameters als SWbemObject,
* de OutParameters bevatten informatie over de uitvoerparameters als SWbemObject.

De twee laatste attributen zijn, misschien onverwacht, ook vrij complex omdat ze refereren naar een SWbemObject (en dus niet naar een collectie!!). Van dit laatste object is enkel het Properties_ attribuut interessant. Dit resulteert in een SWbemPropertySet collectie die de uiteindelijk SWbemProperty objecten bevat, die elk een individuele invoer- of uitvoerparameter voorstellen. Deze SWbemProperty objecten, die we al in oefening 13 gebruikt hebben, beschikken over een Name, CIMType, Value en IsArray attribuut. Bovendien zal het Qualifiers_ attribuut verwijzen naar een SWbemQualifierSet van methodeparameterqualifiers die bij een specifieke parameter horen (zie reeks 3).

* [Oefening 37][37]
* [Oefening 37b][37b]
* Oefening 38
* [Oefening 39][39]

## Oproepen van methoden

De meeste methodes zijn enkel zinvol indien ze worden opgeroepen op een instantie. Een aantal klassen beschikken echter ook over 'statische' methodes, zie vorige oefening. Controleer dit voor je een methode oproept.
We hebben reeds intuïtief methodes opgeroepen van SWbemServices, en ook van een SWbemObject, door gebruik te maken van de directe techniek. Daarbij moet je alle informatie (methodenaam, argumentenlijst, ...) vooraf opzoeken.
Net zoals bij het raadplegen van attributen, is er ook een formele techniek om WMImethodes van een WMI klasse/object aan te roepen, eens men beschikt over een SWbemObject ($WbemObject) dat de klasse of het object representeert. We bespreken de twee methodes:

* De directe techniek insinueert dat het COM SWbemObject de methoden van de WMI klasse overerft. Hierdoor is een eenvoudige syntax mogelijk:

```perl
$ReturnStatus = $WbemObject->WMImethode(parameterlijst)
```

De parameterlijst moet hierbij ingevuld worden met de lijst van de actuele argumenten, in de juiste volgorde zoals die door de ID methodeparameterqualifiers opgelegd wordt. Waar nodig, moet undef gespecificeerd worden. Enkel een rij trailing undef argumenten mag weggelaten worden. Je moet hierbij de objecthiërarchie van de methodes niet gebruiken. Deze methode schiet echter soms wel tekort (zie verder).

* De meer formele techniek om een WMImethode uit te voeren op een gegeven $SWbemObject vereist volgende stappen:

1. initialiseer het SWbemMethod object voor de WMI methode
2. initialiseer, met het InParameters-attribuut, het SWbemObject dat via zijn Properties_ collectie de volledige verzameling invoerparameters voorstelt die bij deze WMI methode horen. Dit object mag enkel ontbreken indien de methode geen invoerparameters heeft. Indien er enkel optionele parameters zijn, die je niet invult, moet je dit object wel initialiseren, en meegeven als parameter.
3. vul de actuele waarden in van de noodzakelijke invoerparameters. Dit kan op een directe manier, net alsof het laatste SWbemObject de invoerparameters als attributen zou hebben overgeerfd, of via de Properties_ collectie ervan, geïndexeerd met de naam van de invoerparameter, en daarvan dan weer het Value attribuut.

```perl
$InParameters->{Name} = ...;   #directe methode
$InParameters->{Properties_}->Item(Name)->{Value} = ....;   #indirect
```

4. voer de ExecMethod_(WMImethode,[InParameters]) methode uit op het $WbemObject dat de WMI object (of klasse) representeert. De eerste verplichte parameter is de naam van de WMImethode. De tweede optionele parameter is het SWbemObject dat de verzameling invoerparameters voorstelt.
5. De terugkeerwaarde van de ExecMethod_ methode bevat alle OutParameters. Dit is dus een SWbemObject dat, via zijn Properties_ collectie, de volledige verzameling uitvoerparameters voorstelt. Het ophalen van de uitvoerparameters kan opnieuw op een directe, of op de formele manier. De meeste WMImethoden hebben maar één uitvoerparameter, die systematisch ReturnValue noemt.

De formele techniek biedt het voordeel dat men geen rekening moet houden met de correcte volgorde van de invoerparameters. Het is ook de enige mogelijkheid indien de methode meerdere uitvoerparameters vertoont, en je die waarden ook nodig hebt.
Tot slot bestaat nog de mogelijkheid om een methode te laten uitvoeren zonder eerst het SWbemObject te initialiseren: men kan namelijk gebruik maken van de ExecMethod_ methode van het SWbemServices object. In dit geval moet het SWbemObjectPath (het Path_ attribuut van het SWbemObject) als eerste argument toegevoegd worden.

[13]: https://github.com/EMerckx/operating-systems-3/blob/master/set4/13.pl
[15]: https://github.com/EMerckx/operating-systems-3/blob/master/set4/15.pl
[23]: https://github.com/EMerckx/operating-systems-3/blob/master/set4/23.pl
[23b]: https://github.com/EMerckx/operating-systems-3/blob/master/set4/23b.pl
[24]: https://github.com/EMerckx/operating-systems-3/blob/master/set4/24.pl
[25]: https://github.com/EMerckx/operating-systems-3/blob/master/set4/25.pl
[26]: https://github.com/EMerckx/operating-systems-3/blob/master/set4/26.pl
[27]: https://github.com/EMerckx/operating-systems-3/blob/master/set4/27.pl
[28]: https://github.com/EMerckx/operating-systems-3/blob/master/set4/28.pl
[29]: https://github.com/EMerckx/operating-systems-3/blob/master/set4/29.pl
[30]: https://github.com/EMerckx/operating-systems-3/blob/master/set4/30.pl
[31]: https://github.com/EMerckx/operating-systems-3/blob/master/set4/31.pl
[31b]: https://github.com/EMerckx/operating-systems-3/blob/master/set4/31b.pl
[37]: https://github.com/EMerckx/operating-systems-3/blob/master/set4/37.pl
[37b]: https://github.com/EMerckx/operating-systems-3/blob/master/set4/37b.pl
[39]: https://github.com/EMerckx/operating-systems-3/blob/master/set4/39.pl
