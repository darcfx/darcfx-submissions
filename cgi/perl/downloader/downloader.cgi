#!/usr/bin/perl
###############################################
##                                           ##
## Downloader v.1                            ##
## ----------------------------------------- ##
## by Graeme (webmaster@cgi-scripting.com)   ##
## http://www.CGI-Scripting.com              ##
##                                           ############################
## This version of Downloader is free, if anyone sold it to you        ##
## please contact me. Please DO NOT remove any of the copyrights or    ##
## links to our site, they keep this CGI free for everyone.            ##
##                                                                     ## 
## (c) Copyright 2000 CGI Scripting                                    ##
#########################################################################

# Look in the readme.txt file for help setting up this script

$defaulturl = "http://cgi-scripting.com";

@okaysites = ("http://cgi-scripting.com", "http://www.cgi-scripting.com");    

$url_1 = "http://yahoo.com";
$url_2 = "http://downloads.com";
$url_3 = "http://downloads.com/new";


####################### DO NOT EDIT BELOW THIS LINE ######################

@querypairs = split(/&/, $ENV{'QUERY_STRING'});
foreach $querypair (@querypairs) {
	($queryname, $queryvalue) = split(/=/, $querypair);
	$queryvalue =~ tr/+/ /;
	$queryvalue =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
    $queryvalue =~ s/<([^>]|\n)*>//g;
	if ($QUERY{$queryname}) { $QUERY{$queryname} = $QUERY{$queryname}.",".$queryvalue; }
	else { $QUERY{$queryname} = $queryvalue; }
}

$reffer = $ENV{'HTTP_REFERER'};
$yes = 0;
foreach $domain (@okaysites) {
if ($reffer =~ /$domain/) {
$yes = 1;
}
}

$theu = "url"."_"."$QUERY{'site'}";

if ($$theu && $yes == 1) {
print "Location: $$theu/$QUERY{'filename'}\n\n";
} else {
print "Location: $defaulturl\n\n";
}
exit;