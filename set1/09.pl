# In de module Win32::OLE::Const beschik je over de interessante methode Load 
# waarmee alle constanten van een typelibrary in (een referentie naar) een hash 
# worden inladen. Toon alle constanten van een bibliotheek, waarvan je de naam 
# als argument meegeeft met je script.
# Nu kan je snel achterhalen welke constanten in die bibliotheek zitten.

#Geef als argument bijvoorbeeld "Microsoft CDO for Windows 2000 Library"
use Win32::OLE::Const;

#$bibnaam=$ARGV[0];
$bibnaam = "Scripting.FileSystemObject"
$wd = Win32::OLE::Const->Load($bibnaam);
while ( ( $key, $value ) = each %{$wd} ) {
    print "$key :$value\n";
}
