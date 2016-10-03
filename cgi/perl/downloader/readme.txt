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

It only takes 3 easy steps to setup this script

1, Open downloader.cgi and edit these 3 varibles

$defaulturl = It will redirect people to this url if they are trying to link to your downloads off there site
@okaysites = sites which can download files off your site
$url_1 = A location to a download folder with some downloads in it 

(to add more download locations just put on a new line in the script)
$url_4 = "http://site.com";
$url_5 = "http://site.com";
$url_6 = "http://site.com";
and keep going up a number for as many as you want

2, Upload the script to your cgi-bin and chmod it to 755

3, Now just link to the download you want by doing http://yoursite.com/cgi-bin/downloader.cgi?site=1&filename=thefile.zip
On that link it has ( site=1 ) that means it calls the download location ( $url_1 ) 
just change it to what you want so it calls the correct folder




Please link back to our site and help keep this script free
<A HREF="http://www.cgi-scripting.com">CGI-Scripting</A>