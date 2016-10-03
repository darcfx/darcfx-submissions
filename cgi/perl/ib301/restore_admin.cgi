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
#| "restore_admin.cgi"
#|
#| This script updates the status of a named user to Super Administrator
#| Use this if you've deleted your own account, or otherwise made a cock-up :D
#|
#| > INSTRUCTIONS FOR USE
#|
#| Simply upload this script into the same directory that ikonboard.cgi is currently in
#| CHMOD to 0755 and call through your web browser (http://www.domain.tld/ikonboard/restore_admin.cgi)
#|
#| VERY IMPORTANT!!!
#| Make sure you remove this script after use, there is NO protection of ANY kind
#| Leaving it on your server is A) Stupid, B) Stupid and C) Stupid
#|
#+------------------------------------------------------------------------------------------------------

use strict;



    #Get script path

    $iB::PTH = '.';

    use lib ( ".", "./Sources" );

    #### Getting errors? Enter your path below!
    # Remeber to remove the comment first (# is a comment)
    
    
    #$iB::PTH = 'E:\inent\wwww\htdocs\ikonboard';

#+------------------------------------------------------------------------------------------------------
use CGI;
use CGI::Carp "fatalsToBrowser";
$iB::Q = new CGI;


require "$iB::PTH/Data/Boardinfo.pm";

$iB::INFO = Boardinfo->new();

    if ($iB::Q->param('act') eq 'run') {

        iB::run();

    } else {

        iB::show();
    }




sub show {
    print $iB::Q->header();
    print $iB::Q->start_html("iB Tools -> Restore Admin");

    print qq~<b><font size=4 face='verdana'>iB Tools: Restore an admin account</font></b><hr>
             <br><font size='3' face='verdana'><blockquote>This will restore a named user account to that of a super administrator.
             <br>This is handy if like me, in testing you've removed admin status from your account and can't get back
              into the Admin CP and you don't want to re-install the board.
             <br><br><font color='red'><b> >>>>> REMOVE THIS SCRIPT AFTER USE! <<<<<< </b><br><br>
             <br><br>
             <form action='restore_admin.cgi' method='POST'>
             <input type='hidden' name='act' value='run'>
             Name of the user account to re-store to admin <input type='text' name='NAME' value='iB account name here'>
             <br><input type='submit' value='Submit'></form></blockquote></font>
            ~;
    print $iB::Q->end_html();
}


sub run {

    die "No name specified!" unless $iB::Q->param('NAME');
    
    my $name = &_clean_value($iB::Q->param('NAME'));

    require "$iB::PTH/Sources/iDatabase/SQL.pm" or die $!;
    my $create = $iB::INFO->{DB_DRIVER} eq 'DBM' ? 1 : 0;
    my $drop   = $iB::INFO->{DB_DRIVER} eq 'DBM' ? 1 : 0;
    
    my $db    = iDatabase::SQL->new( DATABASE  => $iB::INFO->{'DB_NAME'},
                                     DB_DIR    => $iB::INFO->{'DB_DIR'},
                                     IP        => $iB::INFO->{'DB_IP'},
                                     PORT      => $iB::INFO->{'DB_PORT'},
                                     USERNAME  => $iB::INFO->{'DB_USER'},
                                     PASSWORD  => $iB::INFO->{'DB_PASS'},
                                     DB_PREFIX => $iB::INFO->{'DB_PREFIX'},
                                     DB_DRIVER => $iB::INFO->{'DB_DRIVER'},
                                     ATTR      => { allow_create => $create,
                                                    allow_drop   => $drop,
                                                  },
                                   ); 

    $db->update( TABLE  => 'member_profiles',
                 WHERE  => "MEMBER_NAME eq '$name'",
                 VALUES => { MEMBER_GROUP => $iB::INFO->{'SUPAD_GROUP'} }
               );

    print $iB::Q->header();
    print $iB::Q->start_html();

    print qq~<b><font size=4>Restore an admin account</font></b>
             <br><br><font size='3'>All done!<br><br><b>DELETE THIS SCRIPT FROM YOUR SERVER NOW!!</b>
            ~;
    print $iB::Q->end_html();

    exit;
}






sub _clean_value {
    my $Tmp = shift;
    return '' unless defined $Tmp;
    $Tmp =~ s|&|&amp;|g;
    $Tmp =~ s|<!--|&#60;&#33;--|g; $Tmp =~ s|-->|--&#62;|g;
    $Tmp =~ s|<script|&#60;script|ig;
    $Tmp =~ s|>|&gt;|g;
    $Tmp =~ s|<|&lt;|g;
    $Tmp =~ s|"|&quot;|g;
    $Tmp =~ s|  | &nbsp;|g;
    $Tmp =~ s!\|!&#124;!g;
    $Tmp =~ s|\n|<br>|g;
    $Tmp =~ s|\$|&#36;|g;
    $Tmp =~ s|\r||g;
    $Tmp =~ s|\_\_(.+?)\_\_||g;
    $Tmp =~ s|\\|&#92;|g;
    $Tmp =~ s|!|&#33;|g;
    $Tmp =~ s|\'|&#39;|g;
    return $Tmp;
}
