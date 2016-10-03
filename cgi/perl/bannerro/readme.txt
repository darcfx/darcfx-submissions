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

Step 1,
Open up setup.cgi and alter the varibles

$numbertoshow = "3"; # TELLS THE SCRIPT HOW MANY BANNERS TO ROTATE IN THE SCRIPT

$url_* = "url"; # LOCATION TO THE URL
$banner_* = "banner"; # LOCATION TO THE BANNER

_* = change the * to a number for each banner ie ($url_1 $banner_1 | $url_2 $banner_2) and so on for each banner

Step 2,
Upload all 4 of the cgi scripts and chmod them to 755

step 3,
Add this html code to your site ( SCRIPT URL ) means put the location to the cgi scripts there

<!-- Start Banner Rotation Ad. Code -->
<SCRIPT SRC=" SCRIPT URL /cgi-bin/show.cgi"></SCRIPT>
<NOSCRIPT>
<A HREF=" SCRIPT URL /cgi-bin/redirect.cgi" TARGET="_blank"><IMG SRC=" SCRIPT URL /cgi-bin/banner.cgi" border=0></A>
</NOSCRIPT>
<!-- End of Banner Rotation Ad. Code -->