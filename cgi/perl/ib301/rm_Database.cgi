#!/usr/bin/perl
package iB;

#+------------------------------------------------------------------------------------------------------
#| Ikonboard UTILITIES by Matthew Mecham [ v3.0 ]
#|
#| No parts of this script can be used outside Ikonboard without prior consent.
#| You must keep this header intact and all copyright links visable.
#| (c)2001 Ikonboard.com <http://www.ikonboard.com>
#|
#| Please Read the licence for more information.
#|
#| "rm_all_backups.cgi"
#|
#| THIS SCRIPT REMOVES ANY BACK UPS CURRENTLY IN THE BACK_UP DIRECTORY
#| Use with EXTREME Caution. You only get asked once if you wish to proceed
#|
#| > INSTRUCTIONS FOR USE
#|
#| Simply upload this script into the same directory that ikonboard.cgi is currently in
#| CHMOD to 0755 and call through your web browser (http://www.domain.tld/ikonboard/rm_all_backups.cgi)
#|
#+------------------------------------------------------------------------------------------------------

use strict;

BEGIN {

    #Get script path

    use Cwd;
    my $cwd = cwd();
    $iB::PTH = $cwd;
}
#+------------------------------------------------------------------------------------------------------
use CGI;
use CGI::Carp "fatalsToBrowser";
$iB::Q = new CGI;

use File::Path;

require "$iB::PTH/Data/Boardinfo.pm";

$iB::INFO = Boardinfo->new();

    if ($iB::Q->param('act') eq 'run') {

        iB::run();

    } else {

        iB::show();
    }




sub show {
    print $iB::Q->header();
    print $iB::Q->start_html();

    print qq~<b><font size=4>Remove your current Database - **USE THIS WITH CAUTION**</font></b>
             <br><br><font size='3'>This script will remove your current, populated Database - only do this if you want to clobber all of your database data!
             <br><br><font color='red'><b>REMOVE THIS SCRIPT AFTER USE!</b></font><br><br>
             <a href='rm_Database.cgi?act=run'>Run the script now!</a>
            ~;
    print $iB::Q->end_html();
}


sub run {



    rmtree $iB::INFO->{'DB_DIR'};

    mkdir ($iB::INFO->{'DB_DIR'}, 0777);

    print $iB::Q->header();
    print $iB::Q->start_html();
    print "Database Directory Emptied";
    print $iB::Q->end_html();
}
