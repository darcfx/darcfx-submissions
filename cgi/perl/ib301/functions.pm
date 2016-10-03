package functions;
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
        $iB::EVAL = { DB_File => 'no',
                      CGI     => 'no',
                      DBI     => 'no',
                    };
        for my $mod (qw/DB_File CGI DBI/) {
            if (eval "require $mod") {
                $iB::EVAL->{$mod} = 'Yes';
            }
        }
 }

use AnyDBM_File;


sub new {
    my $pkg = shift;
    my $obj = { '_output' => undef, error => '' };
    bless $obj, $pkg;
    return $obj;
}



####################################################
# START: Step One
####################################################

sub start {
    my ($obj, $page_title) = @_;

    # Get the needed library
    require 'start.pl' or &iB::install_error ( 'Could not load install_modules/start.pl' );

    my $start = start->new();
    
    my $html = $iB::IN{'DO'} ? $start->process() : $start->form();

    $obj->output( TITLE => $page_title,
                  HTML  => $html,
                );

}

####################################################
# POPULATE: Install the basic files
####################################################

sub populate {
    my ($obj, $page_title) = @_;

    # Get the needed library
    require 'populate.pl' or iB::install_error ( 'Could not load install_modules/populate.pl' );

    my $start = populate->new();
    
    my $html = $iB::IN{'DO'} ? $start->process() : $start->form();

    $obj->output( TITLE => $page_title,
                  HTML  => $html,
                );

}

####################################################
# Sub ADMIN: Create an administration account
####################################################

sub admin {
    my ($obj, $page_title) = @_;

    # Get the needed library
    require 'admin.pl' or iB::install_error ( 'Could not load install_modules/admin.pl' );

    my $start = admin->new();
    
    my $html = $iB::IN{'DO'} ? $start->process() : $start->form();

    $obj->output( TITLE => $page_title,
                  HTML  => $html,
                );

}

####################################################
# DATABASE SET-UP
####################################################

sub database {
    my ($obj, $page_title) = @_;

    # Get the needed library
    require 'database.pl' or iB::install_error ( 'Could not load install_modules/database.pl' );

    my $start = database->new();
    
    my $html;

    if ( $iB::IN{'DO'} ) {
    
        if ($iB::IN{'end'}) {
            $html = $start->end_setup();
        }
        elsif ($iB::IN{'DB_DRIVER'} eq 'DBM') {
            $html = $start->setup_dbm();
        }
        elsif ($iB::IN{'DB_DRIVER'} eq 'mySQL') {  
            $html = $start->setup_mysql();
        }
        elsif ($iB::IN{'DB_DRIVER'} eq 'pgSQL') {  
            $html = $start->setup_pgsql();
        }

    } else {
        $html = $start->form();
    }

    $obj->output( TITLE => $page_title,
                  HTML  => $html,
                );

}

####################################################
# TAR : Installs the ikonboard files
####################################################

sub tar {
    my ($obj, $page_title) = @_;

    # Get the needed library
    require 'tar.pl' or iB::install_error ( 'Could not load install_modules/tar.pl' );

    # Set up a hash..

    my $tarballs = {  'Data.tar'      => [ 1, 'c', 'c', 0, 'Data'     ],
                      'Database.tar'  => [ 2, 'c', 'c', 0, 'Database' ],
                      'Languages.tar' => [ 3, 'c', 'c', 0, 'Languages'],
                      'non-cgi.tar'   => [ 4, 'c', 'h', 0, 'non-cgi'  ],
                      'Skin.tar'      => [ 5, 'c', 'c', 0, 'Skin'     ],
                      'Sources.tar'   => [ 6, 'c', 'c', 1, 'Sources'  ],
                   };

    my $start = tar->new();
    
    my $html;

    if ($iB::IN{'rTAR'} eq 'n') {
        $html = $start->end_tar();
    }
    else {

        if ($iB::IN{'DO'}) {
            if ($iB::IN{'end'}) {
                $html = $start->end_tar();
            }
            elsif ($iB::IN{'id'}) {
               $html = $start->do_tar( $iB::IN{'id'}, $tarballs );
            }
            else {
                $html = $start->start_tar( $tarballs );
            }
        } else {
            $html = $start->form();
        }

    }

    $obj->output( TITLE => $page_title,
                  HTML  => $html,
                );

}


####################################################
# SYSTEM TEST
####################################################

sub system_test {
    my ($obj, $page_title) = @_;

    my $recommend = "We recommend that you use the <b>DBM</b> database for your board. This will be sufficient for
                     small to meduim sized boards. In the future, you might want to consider installing the DBI modules
                     and mySQL.";


    my $has_dbm      = $iB::EVAL->{'DB_File'};
    my $has_cgi      = $iB::EVAL->{'CGI'};
    my $has_dbi      = $iB::EVAL->{'DBI'};
    my $cgi_version  = $CGI::VERSION;
    my $perl_version = $];
    my $dbm_library  = $AnyDBM_File::ISA[0];
    my $cw_install_data = ( -w $iB::OBJ->{tmp_path}.'INSTALL_DATA' )   ? 'Yes'  : 'No, please CHMOD to 0777';
    my $cw_config_file  = ( -w $iB::OBJ->{tmp_path}.'ikonboard.conf' ) ? 'Yes'  : 'No, please CHMOD to 0777';

    if ($dbm_library ne 'DB_File') {
        $recommend .= "<br><br>We strongly recommend that you build the DB_File on your server. DB_File is the best DBM
                       library currently available. You might run into problems with large posts without it.
                       <a href='http://search.cpan.org/search?dist=DB_File' target='_blank'>More information on CPAN</a>";
    }

    if ($has_dbi) {
        $recommend .= "<br><br>We also recommend that you ask your webhost about mySQL. Your perl installation supports mySQL. If you
                       have access to a mySQL database, then we suggest you use the <b>mySQL</b> option.";
    }

    my $p_perl_version  = $perl_version > 5.004 ? 'Yes' : 'No';

    my $next_action = "<a href='installer.$iB::EXT?act=start'>Proceed with the installation</a>";

    if ($cw_install_data ne 'Yes' or $cw_config_file ne 'Yes') {
        $next_action = 'Please correct the errors above before proceeding';
    }


    my $html = qq~<table cellspacing='0' cellpadding='4' width='100%' align='center' border='0'>
                  <tr>
                   <td class='ti' colspan='2'><span style='color:#CC0000'><u>iB System Profiler</u></span></td>
                  </tr>
                  <tr>
                   <td class='t'><b>Can the installer write into the directory 'INSTALL_DATA'?</b></td>
                   <td class='t'>$cw_install_data</td>
                  </tr>
                  <tr>
                   <td class='t'><b>Can the installer write into the file 'ikonboard.conf'?</b></td>
                   <td class='t'>$cw_config_file</td>
                  </tr>
                  <tr>
                   <td class='t'><b>Is my perl installation ok?</b></td>
                   <td class='t'>$p_perl_version</td>
                  </tr>
                  <tr>
                   <td class='t'><b>Is the CGI.pm module installed?</b></td>
                   <td class='t'>$has_cgi</td>
                  </tr>
                  <tr>
                   <td class='t'><b>Can I use the mySQL version of Ikonboard?</b></td>
                   <td class='t'>$has_dbi</td>
                  </tr>
                  <tr>
                   <td class='t'><b>Do I have the DB_File library installed (for DBM database)?</b></td>
                   <td class='t'>$has_dbm</td>
                  </tr>
                  <tr>
                   <td class='t'><b>What DBM library will my system use?</b></td>
                   <td class='t'>$dbm_library</td>
                  </tr>
                  <tr>
                   <td class='ti' colspan='2'><span style='color:#CC0000'><u>Recommended Installation</u></span></td>
                  </tr>
                  <tr>
                   <td class='t' colspan='2'>$recommend</td>
                  </tr>
                  <tr>
                   <td class='ti' colspan='2'><span style='color:#CC0000'><u>Next Action</u></span></td>
                  </tr>
                  <tr>
                   <td class='t' colspan='2'>$next_action</td>
                  </tr>
                  </table>
    ~;

    $obj->output( TITLE => $page_title,
                  HTML  => $html,
                );
}



####################################################
# LOAD CONFIG
####################################################


sub load_config {
    my ($obj, $path) = @_;

    unless (-e $path.'ikonboard.conf') {
        $obj->{error} = "Cannot locate ".$path.'ikonboard.conf';
        return;
    }
    open CONFIG, $path.'ikonboard.conf' or ( $obj->{error} = "Cannot load ".$path."ikonboard.conf ($!)" and return );
    my @data = <CONFIG>;
    close CONFIG;

    my %conf = ();
    for (@data) {
        next if /^#/;
        next if /^\$/;
        next if /^\s+$/;
        /^(\S+)\s*=\s*(.+?)\s*$/;
        my $k = $1;
        my $v = $2 || '';
        $v =~ s!^\s+!!;
        $conf{ $k } = $v;
    }
    return \%conf;
}


####################################################
# PRINT PAGE
####################################################


sub output {
    my $obj = shift;
    my %IN  = ( HTML  => "",
                TITLE => "",
                EXTRA => "",
                @_,
              );

    print $iB::CGI->header( -expires => 'Mon, 26 Jul 1997 05:00:00 GMT' );

    print qq~
<html>
  <head>
    <title>iB Installer -&gt $IN{'TITLE'}</title>
    <style type="text/css">
    .h        { font-family: Arial; font-size: 12px; color: #FF0000 }
    .t        { font-family: Arial; font-size: 11px; color: #000003 }
    .ti       { font-family: Arial; font-size: 12px; color: #000003; font-weight: bold }
    .l        { font-family: Arial; font-size: 14px; font-weight: bold; color: #FFFFFF }
    INPUT, SUBMIT 	{
                       font-family: Verdana, Arial;
	                   font-size: 10pt;
	                   font-family: verdana, helvetica, sans-serif;
                       vertical-align:middle;
                       background-color: #CCCCCC;
	                }
    .forminput      {
                       font-size: 8pt;
                       background-color: #CCCCCC;
                       font-family: verdana, helvetica, sans-serif;
                       vertical-align:middle;
                       width:90%
                     }
    a:active, a:link, a:visited { color:#000099 }
    a:hover { text-decoration:none; color:#0000FF }

    </style>
    <script language="JavaScript">
    <!--
    function OpenWin(theURL) {
      window.open('INSTALL_DATA/'+theURL,'InfoWindow','toolbar=no,location=no,status=no,menubar=no,scrollbars=yes,resizable=yes,width=500,height=200');
    }
    //-->
    </script>
  </head>
  <body marginheight='0' marginwidth='0' leftmargin='0' topmargin='10' bgcolor='#EEEEEE'>
  <table cellspacing='0' cellpadding='0' width='75%' align='center' border='0' height='100%'>
  <tr>
    <td valign='middle'>
      <table cellspacing='1' cellpadding='0' width='100%' align='center' border='0' bgcolor='#000000'>
       <tr>
        <td>
          <table cellspacing='0' cellpadding='4' width='100%' align='center' border='0'>
          <tr>
            <td bgcolor='#666699' class='l' align='left'>$IN{'TITLE'}</td>
          </tr>
          <tr>
            <td bgcolor='#8888AA' class='l' align='left'><span style='font-size:6pt;color:#8888AA'>.</span></td>
          </tr>
          <tr>
            <td valign='top' bgcolor='#FFFFFFF'>
              <!--|| BEGIN POOLED OUTPUT ||-->
                $IN{'HTML'}
              <!--|| END POOLED OUTPUT ||-->
            </td>
          </tr>
          </table>
         </td>
        </tr>
      </table>
    </td>
   </tr>
  </table>
 </body>
</html>
~;
}


####################################################
# PRINT MODULE
####################################################

sub _write_config {
    my ($obj, $data) = @_;

    my $file = $iB::OBJ->{tmp_path}.'ikonboard.conf';

    chmod( 0777, $file );

    # Create Module

    open (FH, ">" .$file) or die "Cannot write to $file ($!)";

    for my $key (sort { $a cmp $b } keys %{$data}) {

        print FH qq~$key\t\t=\t$data->{ $key }\n~;

    }


    close FH or die $!;

    chmod ( 0644, $file );

}

sub write_boardinfo {
    my ($obj, $data) = @_;

    my $file = $data->{'IKON_DIR'}.'/Data/Boardinfo.pm';

    # Lets sort out some of the data first..

    for my $i (qw/IKON_DIR HTML_DIR DB_DIR/) {
        $data->{ $i } = $data->{ $i }.'/';
    }
    

    $data->{'PUBLIC_UPLOADS'} = $data->{'HTML_DIR'}.'uploads';
    $data->{'HTML_DIR'}       = $data->{'HTML_DIR'}.'non-cgi/';
    $data->{'UPLOAD_URL'}     = $data->{'IMAGES_URL'}.'/uploads';
    $data->{'IMAGES_URL'}     = $data->{'IMAGES_URL'}.'/non-cgi';
    $data->{'BACKUP_DIR'}     = $data->{'IKON_DIR'}.'BACK_UP';

    $data->{'CGI_EXT'}        = $iB::EXT;

    # Create Module

    open (FH, ">" .$file) or die "Cannot write to $file ($!)";

print FH <<_END_PRINT_;
package Boardinfo;
  
  sub new {
    my \$pkg = shift;
    my \$obj = {
_END_PRINT_

    for my $key (sort { $a cmp $b } keys %{$data}) {
        my $space = " " x (20 - (length($key)));
        $data->{$key} =~ s|!|&#33;|g;
        print FH qq~'$key' $space => q!$data->{ $key }!,\n~;

    }

print FH <<_END_PRINT_;
    };
    bless \$obj, \$pkg;
    return \$obj;
 }

 1;
_END_PRINT_

    close FH or die $!;

    chmod ( 0644, $file );

}




1;