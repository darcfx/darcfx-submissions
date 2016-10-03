package start;
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

    my $check = {  IKON_DIR        => [ 'CGI Path'         ,   1 ],
                   HTML_DIR        => [ 'NON-CGI Path'     ,   1 ],
                   HOME_URL        => [ 'Website URL'      ,   0 ],
                   BOARD_URL       => [ 'Board URL'        ,   1 ],
                   IMAGES_URL      => [ 'HTML URL'         ,   1 ],
                   HOME_NAME       => [ 'Website Name'     ,   0 ],
                   BOARDNAME       => [ 'Board Name'       ,   0 ],
                   BOARD_DESC      => [ 'Board Description',   0 ],
                   ADMIN_EMAIL_IN  => [ 'Incoming email'   ,   1 ],
                   ADMIN_EMAIL_OUT => [ 'Outgoing email'   ,   1 ],
                   SMTP_SERVER     => [ 'SMTP Server'      ,   0 ],
                   SEND_MAIL       => [ 'Sendmail path'    ,   0 ],
                   EMAIL_TYPE      => [ 'Email method'     ,   0 ],
                };

    # Check for input

    my @blanks;

    for my $key (keys %{$check}) {
        if ($check->{ $key }[1] and $iB::CGI->param( $key ) eq '') {
            push @blanks, $check->{ $key }[0];
        }
        $iB::CONFIG->{ $key } = $iB::CGI->param( $key );
    }

    if (scalar @blanks > 0) {
        my $r_blanks = join ', ', @blanks;
        return qq~
                  <table cellspacing='0' cellpadding='4' width='100%' align='center' border='0'>
                  <tr>
                   <td class='ti' colspan='2'><span style='color:#CC0000'><u>The Following blank fields were detected</u></span></td>
                  </tr>
                  <tr>
                   <td class='t' colspan='2'>$r_blanks. Please go back and ensure that you complete the form fully before re-submitting.</td>
                  </tr>
                  <tr>
                    <td align='left' bgcolor='#8888AA' colspan='2'><input type='button' class='forminput' style='width:100' value=' << BACK ' onClick='history.go(-1)'></td>
                  </tr>
                  </table>
                  </form>
                ~;
    }

    # If not....


    my $data_error = 0;
    my ($ikon, $html);
    for my $key (qw/IKON_DIR HTML_DIR HOME_URL BOARD_URL IMAGES_URL/) {
        # Remove any trailing slashes...
        $iB::CONFIG->{ $key } =~ s![/\\]$!!;
        # Check to ensure the paths are correct
        if ($key eq 'IKON_DIR') {
            if (-e $iB::CONFIG->{'IKON_DIR'}) {
                $ikon = 'Found';
            } else {
                $ikon = "<span style='color:red'>Not Found</span>";
                $data_error = 1;
            }
        } elsif ($key eq 'HTML_DIR') {
            if (-e $iB::CONFIG->{'HTML_DIR'}) {
                $html = 'Found';
            } else {
                $html = "<span style='color:red'>Not Found</span>";
                $data_error = 1;
            }
        }
    }

    # Do we have any errors so far?

    if ($data_error) {
        return qq~
                  <table cellspacing='0' cellpadding='4' width='100%' align='center' border='0'>
                  <tr>
                   <td class='ti' colspan='2'><span style='color:#CC0000'><u>Possible Path Errors</u></span></td>
                  </tr>
                  <tr>
                   <td class='t' colspan='2'>We could not find the paths that you entered. A summary of what was entered follows, please go back to correct these errors</td>
                  </tr>
                  <tr>
                   <td class='t'><b><a href='#' onClick="OpenWin('cgi_path.html')">CGI Path</a></b></td>
                   <td class='t' width='60%'>$iB::CONFIG->{'IKON_DIR'}: $ikon</td>
                  </tr>
                  <tr>
                   <td class='t'><b><a href='#' onClick="OpenWin('non-cgi_path.html')">CGI Path</a></b></td>
                   <td class='t' width='60%'>$iB::CONFIG->{'HTML_DIR'}: $html</td>
                  </tr>
                  <tr>
                    <td align='left' bgcolor='#8888AA' colspan='2'><input type='button' class='forminput' style='width:100' value=' << BACK ' onClick='history.go(-1)'></td>
                  </tr>
                  </table>
                  </form>
                ~;
    }

    # Write the changes to the config file
    $iB::CONFIG->{tmp_step_one};
    $functions->_write_config( $iB::CONFIG );

    # Check for directories, and ensure that they are writable (if needed)

    my $directories = { BACK_UP    => [ 'c', 'w' ],
                        Data       => [ 'c', 'w' ],
                        Database   => [ 'c', 'w' ],
                        INCOMING   => [ 'c', 'w' ],
                        Languages  => [ 'c', 'w' ],
                        OUTGOING   => [ 'c', 'w' ],
                        Skin       => [ 'c', 'w' ],
                        Sources    => [ 'c', 'w' ],                  
                        uploads    => [ 'h', 'w' ],
                       };

    my $check = {};
    my $error = 0;

    for my $dir (keys %{$directories}) {
        my ($exist, $write, $path);
        if ($directories->{ $dir }[0] eq 'c') {
            $exist = (-e "$iB::CONFIG->{'IKON_DIR'}/$dir") ? 1 : 0;
            $write = (-w "$iB::CONFIG->{'IKON_DIR'}/$dir") ? 1 : 0;
            $path  = "$iB::CONFIG->{'IKON_DIR'}/<b>$dir</b>";
        } elsif ($directories->{ $dir }[0] eq 'h') {
            $exist = (-e "$iB::CONFIG->{'HTML_DIR'}/$dir") ? 1 : 0;
            $write = (-w "$iB::CONFIG->{'HTML_DIR'}/$dir") ? 1 : 0;
            $path  = "$iB::CONFIG->{'HTML_DIR'}/<b>$dir</b>";
        }
        $check->{ $dir } = { 
                             WRITE => $write,
                             EXIST => $exist,
                             PATH  => $path,
                           };

        unless ($exist and $write) {
            $error = 1;
        }
    }

    my $htm =  qq~
                  <form action='installer.$iB::EXT' method='post'>
                  <input type='hidden' name='act' value='tar'>
                  <input type='hidden' name='DO'  value='0'>
                  <table cellspacing='0' cellpadding='4' width='100%' align='center' border='0'>
                  <tr>
                   <td class='ti' colspan='2'><span style='color:#CC0000'><u>Checking entered information</u></span></td>
                  </tr>
                  <tr>
                   <td class='t' colspan='2'>Before we proceed, lets take a moment to check the information entered. Below is a table of the required directories and their writable state.</td>
                  </tr>
                   <td colspan='2' valign='top'>
                     <table cellspacing='0' cellpadding='4' width='75%' align='center' border='0'>
                        <tr>
                         <td class='t' width='70%' align='left' bgcolor='#8888AA'><span style='color:white;font-weight:bold'>Directory</span></td>
                         <td class='t' width='15%' align='center' bgcolor='#8888AA'><span style='color:white;font-weight:bold'>Exists?</span></td>
                         <td class='t' width='15%' align='center' bgcolor='#8888AA'><span style='color:white;font-weight:bold'>Writable?</span></td>
                        </tr>
             ~;
    for my $key (sort { $a cmp $b } keys %{$check}) {
        my $wr = $check->{ $key }->{'WRITE'} ? 'Yes' : "<span style='color:red;font-weight:bold'>No</span>";
        my $ex = $check->{ $key }->{'EXIST'} ? 'Yes' : "<span style='color:red;font-weight:bold'>No</span>";
        $htm .= qq~<tr>
                    <td class='t' align='left' bgcolor='#EEEEEE'>$check->{ $key }->{'PATH'}</td>
                    <td class='t' align='center' bgcolor='#EEEEEE'>$ex</td>
                    <td class='t' align='center' bgcolor='#EEEEEE'>$wr</td>
                   </tr>
                  ~;
    }

    $htm .= qq~   </table>
                 </td>
                </tr>
                <tr>
              ~;

    $htm .= $error
          ? qq~   <td class='t' colspan='2'>There appears to be some errors. Please use the table above as a guide and go back to adjust the paths and writable permissions accordingly</td>
                </tr>
                <tr>
                  <td align='left' bgcolor='#8888AA' colspan='2'><input type='button' class='forminput' style='width:100' value=' << BACK ' onClick='history.go(-1)'>
                </tr>
                </table>
                </form>~
          : qq~   <td class='t' colspan='2'>Everything appears to be correct. You may either go back to make any changes, or proceed to the next step.</td>
                </tr>
                <tr>
                  <td align='left' bgcolor='#8888AA'><input type='button' class='forminput' style='width:100' value=' << BACK ' onClick='window.location="installer.$iB::EXT?act=start&DO=0"'></td>
                  <td align='right' bgcolor='#8888AA'><input type='submit' class='forminput' style='width:100' value=' PROCEED >> '></td>
                </tr>
                </table>
                </form>~;

    return $htm;

}



####################################################
# PRINT THE FORM
####################################################

sub form {
    my $obj = shift;

    # Lets take a stab at the needed path information

    my $paths = {};

    if ($iB::CONFIG->{tmp_step_one}) {
        for (keys %{ $iB::CONFIG }) {
            $paths->{ $_ } = $iB::CONFIG->{ $_ };
        }
    } else {

        $paths->{'IKON_DIR'} = $ENV{'DOCUMENT_ROOT'}.$ENV{'SCRIPT_NAME'};
        $paths->{'IKON_DIR'} =~ s!installer.(cgi|pl)$!!i;
    
        # Remove trailing slashes.
        $paths->{'IKON_DIR'}        =~ s![/\\]+$!!;
        $paths->{'HTML_DIR'}        =  $paths->{'IKON_DIR'}.'/iB_html';
    
        $paths->{'HOME_URL'}        = "http://".$ENV{'HTTP_HOST'};
        $paths->{'BOARD_URL'}       = "http://".$ENV{'HTTP_HOST'}.$ENV{'SCRIPT_NAME'};
        $paths->{'BOARD_URL'}       =~ s/\/installer\.(cgi|pl)$//g;
        $paths->{'IMAGES_URL'}      = $paths->{'BOARD_URL'} . "/iB_html";
        $paths->{'HOME_NAME'}       = "Ikonboard.com";
        $paths->{'BOARDNAME'}       = "Ikonboard";
        $paths->{'BOARD_DESC'}      = "Website Forums";
        $paths->{'ADMIN_EMAIL_IN'}  = 'in-admin@domain.com';
        $paths->{'ADMIN_EMAIL_OUT'} = 'out-admin@domain.com';
        $paths->{'SMTP_SERVER'}     = 'localhost';
    
        for ("/usr/sbin/sendmail", "/usr/lib/sendmail", "/usr/bin/sendmail", "/var/qmail/bin/qmail-inject") {
            $paths->{'SEND_MAIL'} = $_ if -e $_;
        }
    }

    # Lets print out the html

    return qq~
                  <form action='installer.$iB::EXT' method='post'>
                  <input type='hidden' name='act' value='start'>
                  <input type='hidden' name='DO'  value='1'>
                  <table cellspacing='0' cellpadding='4' width='100%' align='center' border='0'>
                  <tr>
                   <td class='ti' colspan='2'><span style='color:#CC0000'><u>Board paths and other set-up information</u></span></td>
                  </tr>
                  <tr>
                   <td class='t' colspan='2'>We need to know some information before we can continue. This step asks for the paths and URL's to your board. Please double check the information before proceeding.</td>
                  </tr>
                  <tr>
                   <td class='t'><b><a href='#' onClick="OpenWin('cgi_path.html')">Your CGI Path?</a></b></td>
                   <td class='t' width='60%'><input type='text' class='forminput' name='IKON_DIR' value='$paths->{'IKON_DIR'}'></td>
                  </tr>
                  <tr>
                   <td class='t'><b><a href='#' onClick="OpenWin('non-cgi_path.html')">Your NON-CGI Path?</a></b></td>
                   <td class='t'><input type='text' class='forminput' name='HTML_DIR' value='$paths->{'HTML_DIR'}'></td>
                  </tr>
                  <tr>
                   <td class='t'><b><a href='#' onClick="OpenWin('cgi_url.html')">Your CGI URL?</a></b></td>
                   <td class='t'><input type='text' class='forminput' name='BOARD_URL' value='$paths->{'BOARD_URL'}'></td>
                  </tr>
                  <tr>
                   <td class='t'><b><a href='#' onClick="OpenWin('non-cgi_url.html')">Your NON-CGI URL?</a></b></td>
                   <td class='t'><input type='text' class='forminput' name='IMAGES_URL' value='$paths->{'IMAGES_URL'}'></td>
                  </tr>
                  <tr>
                   <td class='t'><b>Email address for incoming emails</b></td>
                   <td class='t'><input type='text' class='forminput' name='ADMIN_EMAIL_IN' value='$paths->{'ADMIN_EMAIL_IN'}'></td>
                  </tr>
                  <tr>
                   <td class='t'><b>Email address for outgoing emails</b></td>
                   <td class='t'><input type='text' class='forminput' name='ADMIN_EMAIL_OUT' value='$paths->{'ADMIN_EMAIL_OUT'}'></td>
                  </tr>
                  <tr>
                   <td class='t'><b>Which email program would you like to use?:</b></td>
                   <td class='t'><select name='EMAIL_TYPE' class='forminput'><option value='send_mail' selected>Send mail (Good for *NIX)</option><option value='smtp'>SMTP (Good for NT)</option></td>
                  </tr>
                  <tr>
                   <td class='t'><b>Path to Sendmail (if using sendmail!)</b></td>
                   <td class='t'><input type='text' class='forminput' name='SEND_MAIL' value='$paths->{'SEND_MAIL'}'></td>
                  </tr>
                  <tr>
                   <td class='t'><b>Address of the SMTP server (if using an SMTP server!)</b></td>
                   <td class='t'><input type='text' class='forminput' name='SMTP_SERVER' value='$paths->{'SMTP_SERVER'}'></td>
                  </tr>
                  <tr>
                   <td class='t'><b>Website Name</b></td>
                   <td class='t'><input type='text' class='forminput' name='HOME_NAME' value='$paths->{'HOME_NAME'}'></td>
                  </tr>
                  <tr>
                   <td class='t'><b>Board Name</b></td>
                   <td class='t'><input type='text' class='forminput' name='BOARDNAME' value='$paths->{'BOARDNAME'}'></td>
                  </tr>
                  <tr>
                   <td class='t'><b>Board Description</b></td>
                   <td class='t'><input type='text' class='forminput' name='BOARD_DESC' value='$paths->{'BOARD_DESC'}'></td>
                  </tr>
                  <tr>
                   <td class='t'><b>Website URL</b></td>
                   <td class='t'><input type='text' class='forminput' name='HOME_URL' value='$paths->{'HOME_URL'}'></td>
                  </tr>
                  <tr>
                    <td align='left' bgcolor='#8888AA'><input type='button' class='forminput' style='width:100' value=' << BACK ' onClick='window.location="installer.$iB::EXT"'></td>
                    <td align='right' bgcolor='#8888AA'><input type='submit' class='forminput' style='width:100' value=' PROCEED >> '></td>
                  </tr>
                  </table>
                  </form>
                ~;
}



1;