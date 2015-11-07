# REEKS 4: WMI scripting

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