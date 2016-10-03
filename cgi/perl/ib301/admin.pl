package admin;
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

BEGIN {  require 'functions.pm' or iB::install_error ( 'Could not load install_modules/functions.pm' ); };

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
    for my $i (qw/MEMBER_NAME MEMBER_PASSWORD MEMBER_PASSWORD_2 MEMBER_EMAIL MEMBER_EMAIL_2/) {
        if ($iB::CGI->param( $i ) eq '') {
            push @errors, "Blank field detected, field name: $i";
        }
    }

    if ($iB::CGI->param('MEMBER_PASSWORD') ne $iB::CGI->param('MEMBER_PASSWORD_2')) {
        push @errors, "The entered passwords did not match";
    }
    if ($iB::CGI->param('MEMBER_EMAIL') ne $iB::CGI->param('MEMBER_EMAIL_2')) {
        push @errors, "The entered email addresses did not match";
    }

    if ( scalar @errors > 0 ) {
         my $htm = qq~
                  <table cellspacing='0' cellpadding='4' width='100%' align='center' border='0'>
                  <tr>
                   <td class='ti' colspan='2'><span style='color:#CC0000'><u>Administration Account Errors</u></span></td>
                  </tr>
                  <tr>
                   <td class='t' colspan='2'>The following errors were found whilst trying to create an administration account</td>
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
    }

    my $Time = time;
    my $IdPart = substr($iB::IN{'MEMBER_NAME'}, 0, 1);
       $IdPart = ord $IdPart;
    my $member_id = "$IdPart".'-'."$Time";
    my $member_pass = crypt ($iB::IN{'MEMBER_PASSWORD'}, lc (substr($iB::IN{'MEMBER_NAME'}, 0, 2 )));


    $db->create_index( TABLE       => 'member_profiles',
                       INDEX_KEY   => 'MEMBER_NAME',
                       FOREIGN_KEY => 'MEMBER_ID'
                     );

    $db->create_index( TABLE       => 'member_profiles',
                       INDEX_KEY   => 'MEMBER_EMAIL',
                       FOREIGN_KEY => 'MEMBER_ID'
                     );

    $iB::IN{'MEMBER_EMAIL'} = lc($iB::IN{'MEMBER_EMAIL'});

    $db->update_index( TABLE      => 'member_profiles',
                       INDEX_KEY  => 'MEMBER_EMAIL',
                       R_KEY      => $iB::IN{'MEMBER_EMAIL'},
                       R_VALUE    => $member_id
                     );

    $db->update_index( TABLE      => 'member_profiles',
                       INDEX_KEY  => 'MEMBER_NAME',
                       R_KEY      => $iB::IN{'MEMBER_NAME'},
                       R_VALUE    => $member_id
                     );

    $db->insert( TABLE  => 'member_profiles',
                 ID     => $member_id,
                 VALUES => { 
                              MEMBER_NAME      => $iB::IN{'MEMBER_NAME'},
                              MEMBER_ID        => $member_id,
                              MEMBER_PASSWORD  => $member_pass,
                              MEMBER_EMAIL     => $iB::IN{'MEMBER_EMAIL'},
                              MEMBER_GROUP     => 4,
                              ALLOW_POST       => 1,
                              MEMBER_POSTS     => 0,
                              MEMBER_LEVEL     => 1,
                              MEMBER_AVATAR    => 'noavatar',
                              MEMBER_IP        => $ENV{'REMOTE_ADDR'},
                              TIME_ADJUST      => 0,
                              LANGUAGE         => 'en',
                              MEMBER_SKIN      => 'Default',
                              MEMBER_JOINED    => time,
                              VIEW_SIGS        => 1,
                              VIEW_IMG         => 1,
                              VIEW_AVS         => 1,
                           }
               );

    iB::install_error( $db->{error} ) if $db->{error};

    # Lock down the board:

    open FILE, ">$iB::INFO->{'IKON_DIR'}install.lock";
    print FILE "Go away and annoy someone else";
    close FILE;

    return qq~
             <table cellspacing='0' cellpadding='4' width='100%' align='center' border='0'>
             <tr>
              <td class='ti' colspan='2'><span style='color:#CC0000'><u>iB Administration Account Creation</u></span></td>
             </tr>
             <tr>
              <td class='t' colspan='2'>Your administration account has been set up successfully.<br><br>You may now proceed to log into your board.</td>
             </tr>
             <tr>
              <td class='t' colspan='2'><b>Suggested steps after logging in.</b>
              <ul>
               <li>Click on the link "AdminCP" found above the navigation bar
               <li>Log into the AdminCP
               <li>Create a new category
               <li>Create a new forum
               <li>Try a test post
              </td>
             </tr>
             <tr>
               <td align='left' bgcolor='#8888AA'><input type='button' class='forminput' style='width:100' value=' << BACK ' onClick='window.location="installer.$iB::EXT?act=admin&DO=0"'></td>
               <td align='right' bgcolor='#8888AA'><input type='button' class='forminput' style='width:100' value=' PROCEED >> ' onClick='window.location="ikonboard.$iB::EXT?act=Login&CODE=00"'></td>
             </tr>
             </table>
            ~;


}



####################################################
# PRINT THE FORM
####################################################

sub form {
    my $obj = shift;



    return qq~
             <form action='installer.$iB::EXT' method='post'>
             <input type='hidden' name='act' value='admin'>
             <input type='hidden' name='DO'  value='1'>
             <table cellspacing='0' cellpadding='4' width='100%' align='center' border='0'>
             <tr>
              <td class='ti' colspan='2'><span style='color:#CC0000'><u>iB Administration Account Creation</u></span></td>
             </tr>
             <tr>
              <td class='t' colspan='2'>The last step is to create an administration account to allow you access to the extensive adminstrative control panel. Please double check all the information you enter before continuing.</td>
             </tr>
             <tr>
              <td class='t'><b>Your desired member name</b></td>
              <td class='t'><input type='text' class='forminput' name='MEMBER_NAME' value=''></td>
             </tr>
             <tr>
              <td class='t'><b>Your password</b></td>
              <td class='t'><input type='password' class='forminput' name='MEMBER_PASSWORD' value=''></td>
             </tr>
             <tr>
              <td class='t'><b>Please re-enter your password</b></td>
              <td class='t'><input type='password' class='forminput' name='MEMBER_PASSWORD_2' value=''></td>
             </tr>
             <tr>
              <td class='t'><b>Your email address</b></td>
              <td class='t'><input type='text' class='forminput' name='MEMBER_EMAIL' value=''></td>
             </tr>
             <tr>
              <td class='t'><b>Please re-enter your email address</b></td>
              <td class='t'><input type='text' class='forminput' name='MEMBER_EMAIL_2' value=''></td>
             </tr>
             <tr>
               <td align='left' bgcolor='#8888AA'><input type='button' class='forminput' style='width:100' value=' << BACK ' onClick='window.location="installer.$iB::EXT?act=populate&DO=0"'></td>
               <td align='right' bgcolor='#8888AA'><input type='submit' class='forminput' style='width:100' value=' PROCEED >> '></td>
             </tr>
             </table>
             </form>
           ~;
}



1;