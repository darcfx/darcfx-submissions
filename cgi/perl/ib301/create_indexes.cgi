#!/usr/bin/perl
package iB;

#
# Convertor to create indexes.
#


#+------------------------------------------------------------------------------------------------------
#| Ikonboard by Matthew Mecham [ v3.0 ]
#|
#| No parts of this script can be used outside Ikonboard without prior consent.
#| You must keep this header intact and all copyright links visable.
#| (c)2001 Ikonboard.com <http://www.ikonboard.com>
#|
#| Please Read the licence for more information.
#+------------------------------------------------------------------------------------------------------

use strict;

BEGIN {
    use Cwd;
    my $cwd = cwd();
    $iB::PTH = $cwd;
    unshift (@INC, "$iB::PTH");
    unshift (@INC, "$iB::PTH/Data");
    unshift (@INC, "$iB::PTH/Sources");
    unshift (@INC, "$iB::PTH/Skin");
    unshift (@INC, "$iB::PTH/Languages");
    unshift (@INC, "$iB::PTH/Sources/Lib");
    
}
#+------------------------------------------------------------------------------------------------------
use CGI;
use CGI::Carp "fatalsToBrowser";
$iB::Q = new CGI;

use Boardinfo;
$iB::INFO = Boardinfo->new();




    if ($iB::Q->param('act') eq 'run') {

        iB::run();

    } else {

        iB::show();
    }




sub show {
    print $iB::Q->header();
    print $iB::Q->start_html();

    print qq~<b><font size=4>Index Creator</font></b>
             <br><br><font size='3'>This convertor will speed up Ikonboard on new registrations and log in. It creates 2 new indexes,
             MEMBER_EMAIL, contains the email addresses of all the members, MEMBER_NAMES contains all the member names.
             <br><br>
             <a href='create_indexes.cgi?act=run'>Convert members</a>
            ~;
    print $iB::Q->end_html();
}


sub run {

    require iDatabase::SQL;

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

    my $count = 0;

    print $iB::Q->header();
    print $iB::Q->start_html();

    print "<b><font size=4>Member Convertor Output</font></b><br>";

    print "Creating MEMBER_EMAIL index";

    $db->create_index( TABLE       => 'member_profiles',
                       INDEX_KEY   => 'MEMBER_EMAIL',
                       FOREIGN_KEY => 'MEMBER_ID',
                     );

    print "Creating MEMBER_NAME index";

    $db->create_index( TABLE       => 'member_profiles',
                       INDEX_KEY   => 'MEMBER_NAME',
                       FOREIGN_KEY => 'MEMBER_ID',
                     );

    my $members = $db->query( TABLE => 'member_profiles');

    my @delete;

    for my $m (@{$members}) {
        if ($m->{'MEMBER_ID'} =~ /^32-.+?$/) {
            push @delete, $m->{'MEMBER_ID'};
            print "DELETE: $m->{'MEMBER_NAME'} (ID: $m->{'MEMBER_ID'} )<br>";
            next;
        }
        $m->{'MEMBER_EMAIL'} = lc($m->{'MEMBER_EMAIL'});
        $db->update_index( TABLE      => 'member_profiles',
                           INDEX_KEY  => 'MEMBER_EMAIL',
                           R_KEY      => $m->{'MEMBER_EMAIL'},
                           R_VALUE    => $m->{'MEMBER_ID'},
                         );

        $db->update_index( TABLE      => 'member_profiles',
                           INDEX_KEY  => 'MEMBER_NAME',
                           R_KEY      => $m->{'MEMBER_NAME'},
                           R_VALUE    => $m->{'MEMBER_ID'},
                         );

        ++$count;
        print "$m->{'MEMBER_NAME'} has been added to the index...<br>";
    }

    if (scalar @delete > 0) {
        $db->delete( TABLE  => 'member_profiles',
                     KEY    => \@delete,
                   );
    }

    print "All done, $count members updated";
    print $iB::Q->end_html();
}
