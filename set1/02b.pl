use Win32::OLE qw(in with);

while (($key, $value) = each %INC) {
	print "\$INC{$key} = $value\n\n";
}

# when running this script, you get a list of modules
# using perldoc, the documentation of a module is available
# command: perldoc <module>
# example: perldoc Win32/OLE.pm