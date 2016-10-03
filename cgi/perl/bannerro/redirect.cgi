#!/usr/bin/perl
###############################################
##                                           ##
## Banner Rotation v.1                       ##
## ----------------------------------------- ##
## by Graeme (webmaster@cgi-scripting.com)   ##
## http://www.CGI-Scripting.com              ##
##                                           ############################
## This version of Banner Rotation is free, if anyone sold it to you   ##
## please contact me. Please DO NOT remove any of the copyrights or    ##
## links to our site, they keep this CGI free for everyone.            ##
##                                                                     ## 
## (c) Copyright 2000 CGI Scripting                                    ##
#########################################################################
#                      DO NOT EDIT BELOW THIS LINE                      #
#########################################################################

require "setup.cgi";

@querypairs = split(/&/, $ENV{'QUERY_STRING'});
foreach $querypair (@querypairs) {
	($queryname, $queryvalue) = split(/=/, $querypair);
	$queryvalue =~ tr/+/ /;
	$queryvalue =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
    $queryvalue =~ s/<([^>]|\n)*>//g;
	if ($QUERY{$queryname}) { $QUERY{$queryname} = $QUERY{$queryname}.",".$queryvalue; }
	else { $QUERY{$queryname} = $queryvalue; }
}


unless ($QUERY{'site'}) {
$thesitelocation = "http://cgi-scripting.com";
} else {
$tthesitelocation = "url_$QUERY{'site'}";
$thesitelocation = "$$tthesitelocation";
}

print "Location: $thesitelocation\n\n";
exit;