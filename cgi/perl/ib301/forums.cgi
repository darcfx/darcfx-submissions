#!/usr/bin/perl
###############################################
#
# Simple Little Redirect Script
# For use with Ikonboard 3
#
###############################################

use strict;
my $location = '';

###############################################
#
# SET UP
# ------
#
#
# Edit the variable"$location" to reflect the URL of your
# Ikonboard 3.


$location = "http://www.domain.com/cgi-bin/ib3/ikonboard.cgi";

# END OF SET UP, DO NOT EDIT ANYTHING UNDER THIS LINE
###############################################

print "Content-type: text/html\n\n";

print qq~<html>
          <head><title>We've upgraded!</title>
            <meta http-equiv="refresh" content="4; url=$location">
          </head>
          <body bgcolor='#FFFFFF'>
          <font face='verdana' size='3'><b>We've upgraded our forums!</b>
          <br><br>The bulletin board has been moved <a href='$location'>here</a>
          <br>Please update your bookmarks.
          <br><br><font size='2'>( <a href='$location'>Click here if you are not automatically redirected</a> )</font>
          </body>
         </html>
        ~;
        
exit();