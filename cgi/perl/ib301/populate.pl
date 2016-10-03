package populate;
use strict;
#+-----------------------------------------------------------------+
#| Ikonboard v3 by Jarvis Entertainment Group, Inc.
#|
#| No parts of this script can be used outside Ikonboard without prior consent.
#|
#| More information available from <ib-license@jarvisgroup.net>
#| (c)2001 Jarvis Entertainment Group, Inc.
#| 
#| http://www.ikonboard.com
#|
#| Please Read the license for more information
#+-----------------------------------------------------------------+
BEGIN { 
        @AnyDBM_File::ISA = qw(DB_File GDBM_File NDBM_File SDBM_File);
        require 'functions.pm' or iB::install_error ( 'Could not load install_modules/functions.pm' );
 }
use AnyDBM_File;

my $limit;


if ($AnyDBM_File::ISA[0] eq 'SDBM_File') {
    $limit = 1000;
} elsif ($AnyDBM_File::ISA[0] eq 'NDBM_File') {
    $limit = 4000;
}

my $functions = functions->new();



sub new {
    my $pkg = shift;
    my $obj = { '_output' => undef, error => '' };
    bless $obj, $pkg;
    return $obj;
}


####################################################
# PROCESS THE INFORMATION
####################################################

sub process {
    my $obj = shift;

    # Get the boardinfo file..

    require 'Data/Boardinfo.pm' or &iB::install_error( "Cannot locate /Data/Boardinfo.pm to require" );

    $iB::INFO = Boardinfo->new();

    # Get the iDatabase driver.
    require 'Sources/iDatabase/SQL.pm' or iB::install_error( "Cannot locate the needed iDatabase driver to require" );



    my $db    = iDatabase::SQL->new( DATABASE  => $iB::INFO->{'DB_NAME'},
                                     DB_DIR    => $iB::INFO->{'DB_DIR'},
                                     IP        => $iB::INFO->{'DB_IP'},
                                     PORT      => $iB::INFO->{'DB_PORT'},
                                     USERNAME  => $iB::INFO->{'DB_USER'},
                                     PASSWORD  => $iB::INFO->{'DB_PASS'},
                                     DB_PREFIX => $iB::INFO->{'DB_PREFIX'},
                                     DB_DRIVER => $iB::INFO->{'DB_DRIVER'},
                                     ATTR      => { allow_create => 0,
                                                    allow_drop   => 0,
                                                  },
                                   ); 

    my @errors;

    # Database: MemberGroups

    open (FILE, "$iB::INFO->{'IKON_DIR'}INSTALL_DATA/mem_groups.dat") or &iB::install_error( "Cannot open /INSTALL_DATA/mem_groups.dat" );
    my @groups = <FILE>;
    close FILE;

    for my $f (@groups) {
        chomp ($f);
        next unless $f;
        my @entry = split (/\|\^\|/, $f);
        next unless defined $entry[0];
        $db->insert( TABLE   => 'mem_groups',
                     VALUES  => {   VIEW_BOARD          =>  1,
                                    MEM_INFO            =>  $entry[1],
                                    OTHER_TOPICS        =>  $entry[2],
                                    USE_SEARCH          =>  $entry[3],
                                    EMAIL_FRIEND        =>  $entry[4],
                                    INVITE_FRIEND       =>  $entry[5],
                                    EDIT_PROFILE        =>  $entry[6],
                                    POST_NEW_TOPICS     =>  $entry[7],
                                    REPLY_OWN_TOPICS    =>  $entry[8],
                                    REPLY_OTHER_TOPICS  =>  $entry[9],
                                    EDIT_OWN_POSTS      =>  $entry[10],
                                    DELETE_OWN_POSTS    =>  $entry[11],
                                    OPEN_CLOSE_TOPICS   =>  $entry[12],
                                    DELETE_OWN_TOPICS   =>  $entry[13],
                                    POST_POLLS          =>  $entry[14],
                                    VOTE_POLLS          =>  $entry[15],
                                    USE_PM              =>  $entry[16],
                                    IS_SUPMOD           =>  $entry[17],
                                    ACCESS_CP           =>  $entry[18],
                                    TITLE               =>  $entry[19],
                                    CAN_REMOVE          =>  0,
                                    READ_AD_LOGS        =>  $entry[21],
                                    DELETE_AD_LOGS      =>  $entry[22],
                                    EDIT_GROUPS         =>  $entry[23],
                                    APPEND_EDIT         =>  $entry[24],
                                    ACCESS_OFFLINE      =>  $entry[25],
                                    AVOID_Q             =>  $entry[26],
                                    AVOID_FLOOD         =>  $entry[27],           
                              },
                    );
        
        push @errors, $db->error if $db->error;
        
    }



    # Database: Email Templates

    open (FILE, "$iB::INFO->{'IKON_DIR'}INSTALL_DATA/email_template.dat") or &iB::install_error( "Cannot open /INSTALL_DATA/email_template.dat" );
    my @templates = <FILE>;
    close FILE;

    for my $t (@templates) {
        chomp ($t);
        next unless $t;
        my @entry = split (/\|\^\|/, $t);
        next unless defined $entry[0];
        $db->insert( TABLE   => 'email_templates',
                     VALUES  => {   ID       =>  $entry[0],
                                    TYPE     =>  $entry[1],
                                    TEMPLATE =>  $entry[2],
                              },
                    );
        push @errors, $db->error if $db->error;
    }



    # Database: (ikon)Board Rules

    open (FILE, "$iB::INFO->{'IKON_DIR'}INSTALL_DATA/board_rules.dat") or &iB::install_error( "Cannot open /INSTALL_DATA/board_rules.dat" );
    my @templates = <FILE>;
    close FILE;

    for my $t (@templates) {
        next unless $t;
        chomp ($t);
        my @entry = split (/\|\^\|/, $t);
        next unless defined $entry[0];
        $db->insert( TABLE   => 'forum_rules',
                     VALUES  => {   ID           =>  $entry[0],
                                    RULES_TITLE  =>  $entry[1],
                                    RULES_TEXT   =>  $entry[2],
                                    LAST_UPDATE  =>  time,
                              },
                    );
        push @errors, $db->error if $db->error;
    }

    # Database: Board Rules

    open (FILE, "$iB::INFO->{'IKON_DIR'}INSTALL_DATA/news.html") or &iB::install_error( "Cannot open /INSTALL_DATA/news.html" );
    my @news = <FILE>;
    close FILE;

    my $text = join '', @news;

    if ($limit and $iB::INFO->{'DB_DRIVER'} eq 'DBM') {
        $text = substr($text, 0, $limit);
    }

    $db->insert( TABLE  => 'ssi_templates',
                 VALUES => { ID              => 'news',
                             EXPORT_FILENAME => "newsdata.txt",
                             TEMPLATE        => $text
                           }
               );


    push @errors, $db->error if $db->error;


    # Database: SSI Templates

    open (FILE, "$iB::INFO->{'IKON_DIR'}INSTALL_DATA/ssi_templates.dat") or &iB::install_error( "Cannot open /INSTALL_DATA/ssi_templates.dat" );
    my @templates = <FILE>;
    close FILE;


    for my $t (@templates) {
        chomp ($t);
        next unless $t;
        my @entry = split (/\|\^\|/, $t);
        next unless defined $entry[0];
        $db->insert( TABLE  => 'ssi_templates',
                     VALUES => { ID              =>  $entry[0],
                                 EXPORT_FILENAME =>  $entry[1],
                                 TEMPLATE        =>  $entry[2]
                               }
               );
        push @errors, $db->error if $db->error;
    }


    open (FILE, "$iB::INFO->{'IKON_DIR'}INSTALL_DATA/global_template.html") or &iB::install_error( "Cannot open /INSTALL_DATA/global_template.html" );
    my @news = <FILE>;
    close FILE;

    my $text = join '', @news;

    if ($limit) {
        $text = substr($text, 0, $limit);
    }

    $db->insert( TABLE  => 'templates',
                 VALUES => { ID              => 'global',
                             TEMPLATE        => $text
                           }
               );

    push @errors, $db->error if $db->error;
    

    open (FILE, "$iB::INFO->{'IKON_DIR'}INSTALL_DATA/register.html") or &iB::install_error( "Cannot open /INSTALL_DATA/register.html" );
    my @news = <FILE>;
    close FILE;

    my $text = join '', @news;

    if ($limit and $iB::INFO->{'DB_DRIVER'} eq 'DBM') {
        $text = substr($text, 0, $limit);
    }

    $db->insert( TABLE  => 'templates',
                 VALUES => { ID              => 'register',
                             TEMPLATE        => $text
                           }
               );

    push @errors, $db->error if $db->error;


    open (FILE, "$iB::INFO->{'IKON_DIR'}INSTALL_DATA/help.txt") or &iB::install_error( "Cannot open /INSTALL_DATA/help.txt" );
    my @help = <FILE>;
    close FILE;

    my $help = {};
    my $flag = 0;
    my $cur  = undef;

    for my $i (@help) {
        next unless $i;
        if ($i =~ /^\[(.+?)\]$/) {
            $help->{$1} = "";
            $flag = 1;
            $cur  = $1;
            next;
        } else {
            $help->{$cur} .= $i;
        }
    }


    for my $k (keys %{$help}) {
        $help->{$k} =~ s!\n!<br>!g;
        $db->insert( TABLE  => 'help',
                     VALUES => { TITLE  => $k,
                                 TEXT   => $help->{$k}
                               }
                   );
    }

    push @errors, $db->error if $db->error;


    # Do we have any errors?

    if (scalar @errors > 0) {
        my $htm = qq~
                  <table cellspacing='0' cellpadding='4' width='100%' align='center' border='0'>
                  <tr>
                   <td class='ti' colspan='2'><span style='color:#CC0000'><u>Database Population Errors</u></span></td>
                  </tr>
                  <tr>
                   <td class='t' colspan='2'>Error(s) were found trying to set populate the database, please use go back to correct these errors</td>
                  </tr>
                  <tr>
                    <td class='t' colspan='2'><ul>
                  ~;

        for my $e (@errors) {
            $htm .= qq~<li>$e\n~;
        }

        $htm .= qq~
                    </ul>
                    </td>
                  <tr>
                    <td align='left' bgcolor='#8888AA' colspan='2'><input type='button' class='forminput' style='width:100' value=' << BACK ' onClick='history.go(-1)'></td>
                  </tr>
                  </table>
         ~;
        return $htm;

    } else {

            return qq~
                  <form action='installer.$iB::EXT' method='post'>
                  <input type='hidden' name='act' value='admin'>
                  <input type='hidden' name='DO'  value='0'>
                  <table cellspacing='0' cellpadding='4' width='100%' align='center' border='0'>
                  <tr>
                   <td class='ti' colspan='2'><span style='color:#CC0000'><u>Database Population Complete</u></span></td>
                  </tr>
                  <tr>
                   <td class='t' colspan='2'>The default database has now been installed.<br><br>You may now proceed to the final step and set up an administration account.</td>
                  </tr>
                  <tr>
                    <td align='left' bgcolor='#8888AA'><input type='button' class='forminput' style='width:100' value=' << BACK ' onClick='window.location="installer.$iB::EXT?act=populate&DO=0"'></td>
                    <td align='right' bgcolor='#8888AA'><input type='submit' class='forminput' style='width:100' value=' PROCEED >> '></td>
                  </tr>
                  </table>
                  </form>
                ~;
    }

}

####################################################
# PRINT THE FORM
####################################################

sub form {
    my $obj = shift;



    return qq~
             <form action='installer.$iB::EXT' method='post'>
             <input type='hidden' name='act' value='populate'>
             <input type='hidden' name='DO'  value='1'>
             <table cellspacing='0' cellpadding='4' width='100%' align='center' border='0'>
             <tr>
              <td class='ti' colspan='2'><span style='color:#CC0000'><u>iB Database Population</u></span></td>
             </tr>
             <tr>
              <td class='t' colspan='2'>Ikonboard now needs to populate your database. This includes entering template, member group and other such information.<br>You may <b>proceed</b>.</td>
             </tr>
             <tr>
               <td align='left' bgcolor='#8888AA'><input type='button' class='forminput' style='width:100' value=' << BACK ' onClick='window.location="installer.$iB::EXT?act=database&DO=0"'></td>
               <td align='right' bgcolor='#8888AA'><input type='submit' class='forminput' style='width:100' value=' PROCEED >> '></td>
             </tr>
             </table>
             </form>
           ~;
}





1;