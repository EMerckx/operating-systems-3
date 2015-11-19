# Reeks 6: raadplegen en wijzigen van Active Directory objecten

## Active Directory

Het domein iii.hogent.be, waar de logins van de computerlokalen beheerd worden, beschikt momenteel over twee Domain Controllers, Belial en Satan, waarvan er één wordt toegekend bij elke aanvraag om Active Directory informatie. Tijdens het labo ben je ingelogd in dit domein, tenzij je als administrator inlogt, zoals in test-situaties.
Het domein ugent.be, waar alle UGent-users beheerd worden, kan ook worden geraadpleegd. Het beschikt over vier Domain Controllers, ugentdc1, ugentdc2, ugentdc3 en ugentdc4. Als je via Athena inlogt, ben je in dit domein ingelogd.

In een DOS-shell kan je de Environment Variables raadplegen met het commando set. In USERDOMAIN en USERDNSDOMAIN zit informatie over het domein waarop je ben ingelogd. Bekijk de waarde van die variabelen thuis, op Athena en in het labo.

Indien je ingelogd bent op het domein dan is het vrij eenvoudig om dat domein te connecteren(zie verder). Anders moet je bij de connectie extra informatie doorgeven:

1. de naam van de server (of van het domein): dit kan met de DNS-naam of het ip-adres
2. loginnaam/paswoord om toegang te krijgen tot het domein
3. eventueel de poort waarop geconnecteerd moet worden

De connectie-waarden voor:

* Het domein iii.hogent.be:
	1. de interne DNS-naam en ip-adres van de domeincontroller Satan zijn respectievelijk satan.iii.hogent.be en 192.168.16.16. Dit heb je nodig als je ingelogd bent als administrator in de labo-lokalen (test-situatie). Met ping satan(.hogent.be) kan je het ip-adres achterhalen. Aangezien de configuratie van het iii.hogent.be domein en zijn toestellen van het publieke Internet wordt afgeschermd, moet je - buiten de labolokalen - als serveridentificatie steeds expliciet de externe DNS-naam of ip-adres van een domeincontroller opgeven. Bovendien is enkel Satan publiek bereikbaar: hetzij via satan.hogent.be, hetzij via 193.190.126.71. Er kunnen wel problemen zijn als de VPN-connectie van UGent is gemaakt (niet altijd).
	2. de loginnaam/paswoord waarmee je aanmeldt in het labo,
	3. de poort moet niet opgegeven worden.
* Het domein ugent.be:
	1. Gebruik de DNS-naam ugentdc1.ugent.be, ugentdc2.ugent.be,... van een domeincontroller. Het lukt niet met het ip-adres. Thuis met je vooraf de VPN-connectie met UGent initialiseren, in het labo is dat niet nodig.
	2. de loginnaam van je UGent-account, aangevuld met "@UGENT.BE" en bijhorend paswoord.
	3. de poort is 636.

De connectie over VPN is wel heeeeel traag.

## LDAP vs. ADSI

Er zijn twee manieren om Active Directory programmatorisch te manipuleren: de Lightweight Directory Access Protocol Application Program Interface (LDAP API), en de Active Directory Service Interfaces (ADSI). Het LDAP protocol definieert een aantal basis operaties bovenop TCP, die het cliënts mogelijk maken om data in een willekeurige Active Directory te raadplegen en aan te passen. De meeste operaties bestaan uit eenvoudige vraag/antwoord wisselwerkingen, analoog aan deze in het HTTP protocol, tussen Web cliënt en server. De LDAP API programmeerinterface wordt geïmplementeerd door de wldap32.dll module van elk Windows platform met een Active Directory cliënt, en bevat een aantal functies die het de programmeertaal C toelaten om te communiceren met LDAP servers. De LDAP API veroorzaken weinig overhead en zijn hierdoor zeer snel. Bovendien zijn programma's die gebruik maken van de LDAP API met geringe moeite overdraagbaar op andere besturingssystemen. De LDAP API voorzien niet in een object georiënteerde interface. Het programmeren van eenvoudige cliënts is ondermeer daardoor vrij primitief. Ook is het moeilijk om de LDAP API aan te wenden in andere programmeeromgevingen dan C.
ADSI daarentegen voorziet in COM objecten die de low-level LDAP API verbergen in hun implementatie, en een object georiënteerde functionaliteit aanbieden. Elk Active Directory object wordt door ADSI gerepresenteerd als een ADSI object in de geheugenruimte van de cliënt. De provider architectuur maakt het mogelijk om niet alleen de Windows Server Active Directory te manipuleren, maar ook andere directories zoals de global catalog, de Novell Directory Services (NDL), de metabase van de Internet Information Server (IIS), en zelfs de SAM van NT 4.0: specifieke providers communiceren met specifieke directories. Hoe ze dit doen is volledig afgeschermd van de cliënt toepassingen. ADSI is geïmplementeerd als een in-process COM component. De overhead op de performantie blijft hierdoor beperkt. ADSI kan gebruikt worden vanuit om het even welke programmeertaal. Bovendien zijn de meeste van de 58 ADSI interfaces duaal, en kunnen ze bijgevolg ook via late binding vanuit scriptomgevingen aangesproken worden, (zoals WSH met PerlScript of VBScript, in deze labo's). Enkel Windows cliënts daarentegen ondersteunen ADSI. De meeste ADSI interfaces zijn gemeenschappelijk voor alle providers, een aantal andere zijn specifiek.

Deze reeks beperkt zich tot een omschrijving van de belangrijkste technieken om een AD object te onderzoeken door de attributen en methods aan te sprekende van het bijhorende ADSI object. In de volgende reeks gaan we leren hoe je snel AD objecten kan opzoeken aan de hand van hun eigenschappen. In de laatste reeks leren we ook hoe je de eigenschappen van deze objecten kan wijzigen.

In de MSDN Library vind je heel wat documentatie in de sectie WIN32 and COM Development  /   Administration and Management  /  Directory Services   /   SDK Documentation  /   Directory Services
(In de nieuwe versie MSDN Library 2008 SP1 staat deze sectie op een andere plaats, nl WIN32 and COM Development / Administration and Management / Directory, Identity, and Access Services / Directory Services Overview )
We gebruiken twee subtakken:

* De ADSI-interface wordt beschreven in de tak Directory Access Technologies / Active Directory Service Interfaces / Active Directory Service Interfaces Reference. We noemen deze tak kortweg de ADSI Library.
* Informatie over Active Directory zoek je op in de tak Directories. Deze tak noemen we de AD Library

We zullen in de volgende oefeningen een aantal interessante subtakken vermelden (zie ook overzicht).

## Binding van de Active Directory objecten

Net als bij WMI start elke communicatie met de Active Directory services met het binden van een AD object (op de server) aan een ADSI object (in de geheugenruimte van de cliënt). Het AD object wordt beschreven met behulp van de ADsPath moniker.

### De ADsPath moniker

De ADsPath moniker bestaat uit drie delen en beschrijft zowel de ADSI provider die aangesproken moet worden, als het AD object dat men wil binden, de facultatieve elementen staan tussen vierkante haakjes:

```
provider:// [server | domein [ : poort ] / ] distinguishedName
```

* <b>provider</b>: hier moet hetzij LDAP, hetzij GC gespecifieerd worden, afhankelijk of we de domeingegevens, het schema, de configuratiegevens, dan wel de global catalog willen aanspreken. Andere ADSI compatibele providers, zoals NDS, NWCOMPAT, IIS of WinNT, komen in deze labo's niet aan bod. Je vindt meer informatie in de subtak Adsi Service Providers van de ADSI Library. Ga verder naar de sectie ADSI LDAP Provider / LDAP ADsPath voor alle informatie over de "ADsPath moniker" in LDAP.
* <b>[server | domein [:poort] /]</b> : het poortnummer is optioneel, LDAP en GC als providers impliceren respectievelijk TCP poorten 389 en 3268 als default. Het |-teken maakt hierbij geen deel uit van ADsPath, maar duidt aan dat hetzij een server, hetzij een domein kan gespecifieerd worden. Indien enkel een domeinidentificatie (hetzij DNS domeinnaam, hetzij SAM accountnaam) vermeld wordt, poogt de lokale LDAP cliënt via DNS te achterhalen welke server de provider ondersteunt. Indien een serveridentificatie (DNS domeinnaam, SAM accountnaam) vermeld wordt, richt de cliënt zich rechtstreeks tot deze server. Je kan hier echter ook het ip-adres van de server opgeven, waardoor de DNS interactie vermeden wordt (ga na dat het interne ip-adres van Satan 192.168.16.16 is). Thuis gebruik je uiteraard het externe ip-adres. Indien zowel de server als het domein ontbreekt, wordt het domein gebruikt van de ingelogde gebruiker. Enkel indien je als gebruiker bent ingelogd in het Active Directory domein waarvan je informatie opvraagt, is het toegelaten om hier helemaal niets te vermelden.
* <b>distinguishedName</b> : verwijst naar het AD object in het domein en kan je opzoeken in AdsiEdit

* Oefening 2

### Connecteren met PowerShell

De methode een PS Object te initialiseren is verschillend indien je wel/niet ingelogd bent op het domein. Indien je ingelogd bent dan kan di heel eenvoudig met:

```
$adObject = [adsi] $moniker 
```

Indien je niet ingelogd bent op het domein, dan is het wat complexer:

```
$adObject = New-Object System.DirectoryServices.DirectoryEntry ($moniker,"Interim F","Interim F")
```

De twee laatste parameters zijn de "username" en "password" waarmee je toegang hebt tot het domein.
De waarde van $moniker is net als hiervoor ingevuld. We gaan in deze labo's niet verder in op de mogelijkheden die je nu hebt in PowerShell, maar Get-Member kan je alvast op weg helpen. In een aantal oplossingen wordt ook een opmerking toegevoegd ivm PowerShell.

### Initialiseren van een ADSI object in PerlScript

De methode om een ADSI object te initaliseren is ook nu afhankelijk van de situatie. Indien je bent ingelogd op het domein kan je dezelfde methode gebruiken als bij WMI-objecten:

```
my $object=Win32::OLE->GetObject(moniker);
```