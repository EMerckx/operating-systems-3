# Set 3: WMI concepten

Om hetzelfde resultaat van wbemtest te krijgen in Powershell ISE, 
voeren we onderstaand script uit.

```
$WQL = 'SELECT * FROM Win32_LogicalDisk'
$WMI = Get-WmiObject -Namespace root\CIMV2 -Query $WQL
$WMI
```

```
$WQL = 'ASSOCIATORS OF {Win32_Directory="c:\\"}'
$WMI = Get-WmiObject -Namespace root\CIMV2 -Query $WQL
$WMI.__RELPATH | nl
```

Hier hebben we het voordeel dat we lijnnummers krijgen. 
Via de tab toets kan je verder zoeken naar attributen.