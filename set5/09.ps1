# Oefening 9

# Bepaal de klasse met het grootste aantal "eigen" attributen.
# Met WMI-com-objecten haal je alle klassen op met een query. 
# Je moet veel meer code zelf schrijven.

# PS-WMI object

# get all the objects
Get-WmiObject -List 

# sort them by property count
Get-WmiObject -List | sort __Property_Count -Descending

# select the first one
Get-WmiObject -List | 
	sort __Property_Count -Descending | 
	select -f 1 Name, __Property_count