##############################
# Start up script for mod_perl
#############################
use strict;

# Compile CGI.pm

use CGI ();
CGI->compile (':all');

# Use the Ikonboard 3 pre-loader script

use lib ("/home/ikonboar/public_html/z_test/Sources");

# Test to make sure we can load it...

{
    local ($@);
    # Supress warnings
    $^W = undef;
    eval "require iPerl::mod_perl";
    unless ($@) {
       use iPerl::mod_perl;
    } else {
       print STDERR "Could not Preload Ikonboard: $@";
   }
}

# That's it...

1;
