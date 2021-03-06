clear

#$list = Get-WmiObject -list | select methods -ExpandProperty methods
#$list | select Origin, Name, InParameters, OutParameters
#$list

#Get-WmiObject -List CIM_LogicalDevice | select methods -ExpandProperty methods

#Get-WmiObject -List CIM_LogicalDevice | foreach { $_.Methods }

# Get-WmiObject -List | select methods -ExpandProperty methods | where {$_.InParameters.Count -ge 2 }

#Get-WmiObject -List | select methods -ExpandProperty methods | 
#    select Origin, Name, InParameters, OutParameters, @{Name="inc";Ex -f 100


#Get-WmiObject -List __SystemSecurity | select methods -ExpandProperty methods | select -f 1 | select Outparameters

#(Get-WmiObject -List Win32_Process -Amended).Methods 

#$list = Get-WmiObject -List 
#$methods = $list | select methods -ExpandProperty methods
#$methods | select OutParameters, @{Name="out";Expression={$_.OutParameters.Properties_.count}}
#$methods | select Origin, Name, @
#$item = $methods | select -F 1
#$item | select OutParameters, @{Name="out";Expression={$_.OutParameters.Properties_.Count}}

#$Location=New-Object -comobject "WbemScripting.SWbemLocator"
#$service = $Location.ConnectServer(".","root\cimV2")
#$klasse = $service.Get("Win32_Directory")

#$klasse.Methods_ | select Name,@{Name="In";Expression={$_.InParameters.Properties_.count}},@{Name="Out";Expression={$_.OutParameters.Properties_.count}}

echo "---------------------"


#$list = Get-WmiObject -List 
#$methods = $list | select methods -ExpandProperty methods
#$methods | select Name,@{Name="In";Expression={$_.InParameters.Properties_.count}},@{Name="Out";Expression={$_.OutParameters.Properties_.count}}

$Location=New-Object -comobject "WbemScripting.SWbemLocator"
$service = $Location.ConnectServer(".","root\cimV2")

$list = Get-WmiObject -List | select name
$list | foreach {
    $klasse = $service.Get("Win32_Directory")
    $list2 = $klasse.Methods_ | select Origin,Name,@{Name="In";Expression={$_.InParameters.Properties_.count}},@{Name="Out";Expression={$_.OutParameters.Properties_.count}}
    $list3 = $list2 | where { $_.In -gt 2 -and $_.Out -gt 1 }
    $list3 # | group Origin, Name
}