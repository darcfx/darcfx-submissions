package tar;
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
    require 'functions.pm' or iB::install_error ( 'Could not load install_modules/functions.pm' );
}

my $functions = functions->new();
use File::Path;

sub new {
    my $pkg = shift;
    my $obj = { '_output' => undef, error => '' };
    bless $obj, $pkg;
    return $obj;
}


####################################################
# Finish the tar process
####################################################

sub end_tar {
    my ($obj) = shift;

    my $htm =  qq~
                  <form action='installer.$iB::EXT' method='post'>
                  <input type='hidden' name='act' value='database'>
                  <input type='hidden' name='DO'  value='0'>
                  <table cellspacing='0' cellpadding='4' width='100%' align='center' border='0'>
                  <tr>
                   <td class='ti' colspan='2'><span style='color:#CC0000'><u>Checking Ikonboard file structures</u></span></td>
                  </tr>
                  <tr>
                   <td class='t' colspan='2'>Before we proceed, lets take a moment to check the information entered. Below is a table which provides information on populated ikonboard directories.</td>
                  </tr>
                   <td colspan='2' valign='top'>
                     <table cellspacing='0' cellpadding='4' width='75%' align='center' border='0'>
                        <tr>
                         <td class='t' width='70%' align='left' bgcolor='#8888AA'><span style='color:white;font-weight:bold'>Directory</span></td>
                         <td class='t' width='15%' align='center' bgcolor='#8888AA'><span style='color:white;font-weight:bold'>Exists?</span></td>
                         <td class='t' width='15%' align='center' bgcolor='#8888AA'><span style='color:white;font-weight:bold'>Populated?</span></td>
                        </tr>
                   ~;

    for my $key (qw/Data Database Languages Skin Sources/) {

        opendir DIR, "$iB::CONFIG->{'IKON_DIR'}/$key";
        my @files = grep { !/^\.*$/ } readdir DIR;
        closedir DIR;

        my $ex  = (-e "$iB::CONFIG->{'IKON_DIR'}/$key") ? 'Yes' : "<span style='color:red;font-weight:bold'>No</span>";
        my $pop = scalar @files > 0   ? 'Yes'  : "<span style='color:red;font-weight:bold'>No</span>";
        $htm .= qq~<tr>
                    <td class='t' align='left' bgcolor='#EEEEEE'>$iB::CONFIG->{'IKON_DIR'}/$key</td>
                    <td class='t' align='center' bgcolor='#EEEEEE'>$ex</td>
                    <td class='t' align='center' bgcolor='#EEEEEE'>$pop</td>
                   </tr>
                  ~;
    }

    opendir DIR, "$iB::CONFIG->{'HTML_DIR'}";
    my @files = grep { !/^\.*$/ } readdir DIR;
    closedir DIR;

    my $ex  = (-e "$iB::CONFIG->{'HTML_DIR'}") ? 'Yes' : "<span style='color:red;font-weight:bold'>No</span>";
    my $pop = scalar @files > 0   ? 'Yes'  : "<span style='color:red;font-weight:bold'>No</span>";
    $htm .= qq~<tr>
                <td class='t' align='left' bgcolor='#EEEEEE'>$iB::CONFIG->{'HTML_DIR'}</td>
                <td class='t' align='center' bgcolor='#EEEEEE'>$ex</td>
                <td class='t' align='center' bgcolor='#EEEEEE'>$pop</td>
               </tr>
              ~;

    $htm .= qq~   </table>
                 </td>
                </tr>
                <tr>
              ~;

    $htm .= qq~    <td class='t' colspan='2'>Everything appears to be installed successfully, you may proceed to the next step.</td>
                  </tr>
                  <tr>
                    <td align='left' bgcolor='#8888AA'><input type='button' class='forminput' style='width:100' value=' << BACK ' onClick='window.location="installer.$iB::EXT?act=tar&DO=0"'></td>
                    <td align='right' bgcolor='#8888AA'><input type='submit' class='forminput' style='width:100' value=' PROCEED >> '></td>
                  </tr>
                  </table>
                  </form>
                ~;

    return $htm;
}


####################################################
# UNTAR an archive
####################################################

sub do_tar {
    my ($obj, $id, $tarballs) = @_;

    # Import the Archive::Tar module
    require Archive::Tar or iB::install_error ( 'Could not load install_modules/Archive/Tar.pm' );

    # Check to make sure it's a valid id number

    my ($last, $real_id, $from, $to, $tar_name, $this_dir);
    for my $key (keys %{$tarballs}) {
        if ($id ==  $tarballs->{ $key }[0]) {
            $real_id = $tarballs->{ $key }[0];
            if ($tarballs->{ $key }[1] eq 'c') {
                $from = $iB::CONFIG->{'IKON_DIR'};
            } elsif ($tarballs->{ $key }[1] eq 'h') {
                $from = $iB::CONFIG->{'HTML_DIR'};
            }
            if ($tarballs->{ $key }[2] eq 'c') {
                $to = $iB::CONFIG->{'IKON_DIR'};
            } elsif ($tarballs->{ $key }[2] eq 'h') {
                $to = $iB::CONFIG->{'HTML_DIR'};
            }
            if ($tarballs->{ $key }[3]) {
                $last = 1;
            }
            $tar_name = $key;
            $this_dir = $tarballs->{ $key }[4];
            last;
        }
    }

    unless ($tar_name and $from and $to and $real_id) {
        &iB::install_error( "Error while processing a tar file. ID=$iB::IN{'ID'}, NAME=$tar_name. Try re-starting the tar process by clicking <a href='installer.$iB::EXT?act=tar&DO=1&id=1'>here</a>.<br>If this error persists, extract and upload the files manually." );
    }


    # If this is the first step, save out our form data

    if ($real_id == 1) {
        $iB::CONFIG->{tmp_REMOVE} = $iB::IN{'REMOVE'};
        $iB::CONFIG->{tmp_RM_DB}  = $iB::IN{'RM_DB'};
        $functions->_write_config( $iB::CONFIG );
    }


    # Are we removing the old installation?
    if ($tar_name eq 'Database.tar' and $iB::CONFIG->{tmp_RM_DB} eq 'y') {
        rmtree "$to/$this_dir";
        mkdir ("$to/$this_dir", 0777);
    }
    elsif ($iB::CONFIG->{tmp_REMOVE} eq 'y') {
        rmtree "$to/$this_dir";
        mkdir ("$to/$this_dir", 0777);
    }    


    # Extract the file..

   {
       
       my $tar =  Archive::Tar->new();
       my $dir = $tar_name;
       $dir    =~ s!^(.+?)\.tar!$1!;
       unless ($tar->read("$from/$tar_name", 0)) {
            &iB::install_error( "Error while processing a tar file. ID=$iB::IN{'ID'}, NAME=$tar_name. The tar file could not be read, try re-starting the tar process by clicking <a href='installer.$iB::EXT?act=tar&DO=1&id=1'>here</a>.<br>If this error persists, extract and upload the files manually." );
       }

       chdir $to;
       my @files = $tar->list_files();

       for (@files) {
           next if $_ eq 'Icon+';
           # Test for illegal characters
           if ($_ !~ /^(?:[\.\w\d\+\-\_\/\\]+)$/) {
                &iB::install_error( "Error while processing a tar file. ID=$iB::IN{'ID'}, NAME=$tar_name. The tar file did not contain legal file names, try re-starting the tar process by clicking <a href='installer.$iB::EXT?act=tar&DO=1&id=1'>here</a>.<br>If this error persists, extract and upload the files manually." );
           }
           # Test for embedded paths
           if ($_ =~ m!^$dir[/\\](\S+)[/\\]$dir!) {
                &iB::install_error( "Error while processing a tar file. ID=$iB::IN{'ID'}, NAME=$tar_name. The tar file contained embedded paths, try re-starting the tar process by clicking <a href='installer.$iB::EXT?act=tar&DO=1&id=1'>here</a>.<br>If this error persists, extract and upload the files manually." );
           }
       }
       $tar->extract(@files, $to);
       chdir $from;

    }

    # Update the real ID
    
    ++$real_id;

    if ($last) {
        return qq~
                  <form action='installer.$iB::EXT' method='post'>
                  <input type='hidden' name='act' value='tar'>
                  <input type='hidden' name='DO'  value='1'>
                  <input type='hidden' name='end'  value='1'>
                  <table cellspacing='0' cellpadding='4' width='100%' align='center' border='0'>
                  <tr>
                   <td class='ti' colspan='2'><span style='color:#CC0000'><u>Installing the ikonboard files</u></span></td>
                  </tr>
                  <tr>
                   <td class='t' colspan='2'>The tar archives have been extracted successfully.<br><br>You may <b>proceed</b> to the next step.</td>
                  </tr>
                  <tr>
                    <td align='left' bgcolor='#8888AA'><input type='button' class='forminput' style='width:100' value=' << BACK ' onClick='window.location="installer.$iB::EXT?act=tar&DO=0"'></td>
                    <td align='right' bgcolor='#8888AA'><input type='submit' class='forminput' style='width:100' value=' PROCEED >> '></td>
                  </tr>
                  </table>
                  </form>
                ~;
    } else {
        return qq~
                  <meta http-equiv="refresh" content="3; url=installer.$iB::EXT?act=tar&DO=1&id=$real_id">
                  <table cellspacing='0' cellpadding='4' width='100%' align='center' border='0'>
                  <tr>
                   <td class='ti' colspan='2'><span style='color:#CC0000'><u>Tar archive extraction in progress</u></span></td>
                  </tr>
                  <tr>
                   <td class='t' colspan='2'>Stand by as we continue to extract the tar archives...<br>Just extracted $tar_name</td>
                  </tr>
                  <tr>
                    <td bgcolor='#8888AA' colspan='2' align='center' class='t'><a href='installer.$iB::EXT?act=tar&DO=1&id=$real_id' style='font-size:12px;color:white'>Click here if your browser does not forward you</a></td>
                  </tr>
                  </table>
                ~;
    }
}



####################################################
# CHECK THE TAR BALLS FOR VALIDITY
####################################################

sub start_tar {
    my ($obj, $tarballs) = @_;

    # Check for input

    my (@missing_tars, @invalid);

    for my $key (keys %{$tarballs}) {
        unless (-e "$iB::CONFIG->{'IKON_DIR'}/$key") {
            push @missing_tars, $key;
        }
        unless (-B "$iB::CONFIG->{'IKON_DIR'}/$key") {
            push @invalid     , $key;
        }

    }

    if (scalar @missing_tars > 0) {
        my $r_blanks = join ', ', @missing_tars;
        return qq~
                  <table cellspacing='0' cellpadding='4' width='100%' align='center' border='0'>
                  <tr>
                   <td class='ti' colspan='2'><span style='color:#CC0000'><u>The following tar files are missing</u></span></td>
                  </tr>
                  <tr>
                   <td class='t' colspan='2'><b>$r_blanks.</b><br><br>Please go back and ensure that you have uploaded all the tar archive files before re-submitting.</td>
                  </tr>
                  <tr>
                    <td align='left' bgcolor='#8888AA' colspan='2'><input type='button' class='forminput' style='width:100' value=' << BACK ' onClick='history.go(-1)'></td>
                  </tr>
                  </table>
                ~;
    }
    if (scalar @invalid > 0) {
        my $r_blanks = join ', ', @invalid;
        return qq~
                  <table cellspacing='0' cellpadding='4' width='100%' align='center' border='0'>
                  <tr>
                   <td class='ti' colspan='2'><span style='color:#CC0000'><u>The following tar files are not vaild</u></span></td>
                  </tr>
                  <tr>
                   <td class='t' colspan='2'><b>$r_blanks.</b><br><br>Please go back and ensure that you have uploaded all the tar archive files in binary before re-submitting.</td>
                  </tr>
                  <tr>
                    <td align='left' bgcolor='#8888AA' colspan='2'><input type='button' class='forminput' style='width:100' value=' << BACK ' onClick='history.go(-1)'></td>
                  </tr>
                  </table>
                ~;
    }



    # Write the changes to the config file
    $iB::CONFIG->{tmp_TAR} = $iB::CGI->param('rTAR');
    $functions->_write_config( $iB::CONFIG );

    # All is good, lets print out the redirect screen
    return qq~
              <form action='installer.$iB::EXT' method='post'>
              <input type='hidden' name='act' value='tar'>
              <input type='hidden' name='DO'  value='1'>
              <input type='hidden' name='id'  value='1'>
              <table cellspacing='0' cellpadding='4' width='100%' align='center' border='0'>
              <tr>
               <td class='ti' colspan='2'><span style='color:#CC0000'><u>Tar archive set up.</u></span></td>
              </tr>
              <tr>
               <td class='t'><b>Remove old ikonboard files before installing new?</b><br>This will remove any custom skin installations you may have.</td>
               <td class='t'><select name='REMOVE' class='forminput'><option value='y' selected>Yes</option><option value='n'>No</option></select></td>
              </tr>
              <tr>
               <td class='t'><b>Remove any old databases (members and posts)?</b></td>
               <td class='t'><select name='RM_DB' class='forminput'><option value='y'>Yes</option><option value='n' selected>No</option></select></td>
              </tr>
              <tr>
                <td align='left' bgcolor='#8888AA'><input type='button' class='forminput' style='width:100' value=' << BACK ' onClick='window.location="installer.$iB::EXT?act=tar&DO=0"'></td>
                <td align='right' bgcolor='#8888AA'><input type='submit' class='forminput' style='width:100' value=' PROCEED >> '></td>
              </tr>
              </table>
              </form>
            ~;

}



####################################################
# PRINT THE FORM
####################################################

sub form {
    my $obj = shift;

    my $select = "<select name='rTAR' class='forminput'>";

    $iB::CONFIG->{tmp_TAR} ||= 'y';

    $select .= $iB::CONFIG->{tmp_TAR} eq 'y'
             ? "<option value='y' selected>Extract the tar archives for me</option><option value='n'>No extraction - I have uploaded the files manually</option>"
             : "<option value='y'>Extract the tar archives for me</option><option value='n' selected>No extraction - I have uploaded the files manually</option>";


    # Lets print out the html

    return qq~
                  <form action='installer.$iB::EXT' method='post'>
                  <input type='hidden' name='act' value='tar'>
                  <input type='hidden' name='DO'  value='1'>
                  <table cellspacing='0' cellpadding='4' width='100%' align='center' border='0'>
                  <tr>
                   <td class='ti' colspan='2'><span style='color:#CC0000'><u>Installing the ikonboard files</u></span></td>
                  </tr>
                  <tr>
                   <td class='t' colspan='2'>We now need to install the ikonboard files. The official ikonboard distribution contains these files in tar archives. This makes it easier to upload and set the permissions on. However, some webhosts have a file upload limit which the tar files exceed, or your system cannot untar these archives. If you've already extracted the files from the tar archives, then choose the approriate option. If you have uploaded the tar archives (in BINARY), the installer will then proceed to extract them for you. To save system resources, this is done in steps with a page refresh in between, please don't stop the page from loading or you may experience errors.</td>
                  </tr>
                  <tr>
                   <td class='t'><b>Which installation method?</b></td>
                   <td class='t' width='60%'>$select</select></td>
                  </tr>
                  <tr>
                    <td align='left' bgcolor='#8888AA'><input type='button' class='forminput' style='width:100' value=' << BACK ' onClick='window.location="installer.$iB::EXT?act=start&DO=0"'></td>
                    <td align='right' bgcolor='#8888AA'><input type='submit' class='forminput' style='width:100' value=' PROCEED >> '></td>
                  </tr>
                  </table>
                  </form>
                ~;
}



1;