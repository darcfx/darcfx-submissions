#!/usr/bin/perl
##########################################################################
# To use this script copy this into the page
# <script src=tcounter.cgi language=javascript> </script>
##########################################################################
# stuff to configure
# The file that holds the current number, must have read write permission
$counterfile = "count.txt";

# The number of digits you want 
$totaldigts = 0;

##########################################################################
# no need to edit anything below this line
print "Content-type: text/html\n\n";

open(NUMBER,"$counterfile");
	$num = <NUMBER>;
close(NUMBER);

$amount = $totaldigits . "d";

if ($num != 0) {
	$number = sprintf("%0$amount", $num);
} else {
	$number = @info[0];
}

open(NUM,">$counterfile");
	print NUM ++$num;
close(NUM);

print "document.write('$number')\;";		