# De Load methode kan ook een OLE object als argument hebben. In Perl(Script) beschik je 
# dus heel eenvoudig over alle constanten van een typelibrary die hoort bij een specifiek 
# COM-object, ook al ken je de juiste naam niet.
# Gebruik deze methode om een overzicht te tonen van alle constanten van de drie COM-object 
# die we tot nu toe gezien hebben. Orden nu ook dit overzicht op de constantennaam.
use Win32::OLE::Const;

@ARGV=("Excel.Sheet","Scripting.FileSystemObject","CDO.Message"); #lukt altijd.

for $comObjectNaam (@ARGV) {
  print  "\n**********",$comObjectNaam,"***********\n";
  $object = Win32::OLE->new($comObjectNaam);
  %wd = %{Win32::OLE::Const->Load($object)}; #direct in een hash stoppen

  foreach (sort {$a cmp $b} keys %wd) {
    printf ("%30s : %s\n",$_,$wd{$_});
  }  
}