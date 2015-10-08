# In de vorige reeks heb je, in Oleview, de type libraries gevonden die horen bij de COM-klassen Excel.Sheet en CDO.Message. 
# Laad nu beide libraries in, en schrijf een willekeurig gekozen constante uit (zoek de naam van een constante op met Oleview). 
# Experimenteer met de reguliere expressie en kijk wat er gebeurt indien de bibliotheeknaam niet uniek is, of indien je een foute naam opgeeft.
# De typelibrary die hoort bij "Scripting.FileSystemObject" kunnen we niet inladen met deze methode.

use Win32::OLE::Const "^Microsoft CDO for Windows 2000 Library";
#use Win32::OLE::Const ".*CDO"; #volstaat om de bibliotheek te vinden
print "\ncdoSendUsingPort : ",cdoSendUsingPort; #toont de waarde

use Win32::OLE::Const "^Microsoft Excel";      
#use Win32::OLE::Const ".*Excel"; #volstaat om de bibliotheek te vinden
print "\nxlHorizontaal    : ",xlHorizontal;
print "\nniet bestaand    : ",xlHorizontaal;   #geeft de naam zelf terug
