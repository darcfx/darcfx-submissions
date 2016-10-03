#!/usr/bin/perl
package iB;
use strict;

####################################################
#| Ikonboard by Matthew Mecham [ v3.0 ]
#|
#| No parts of this script can be used outside Ikonboard
#| without prior consent.
#| You must keep this header intact and all copyright
#| links visable.
#|
#| (c)2001 Jarvis Entertainment Group, Inc.
#| Web: <http://www.ikonboard.com>
#| Email: ib@ikonboard.com
#| IRC Server   : irc.ikonboard.com
#|     Port     : #6667
#|     Channels : #ikonboard   #help   #support
#|
#| Please Read the licence for more information.
####################################################

####################################################
#
# P R O G R A M  S E T - U P
#
# If the installer has requested it, please following
# the instructions below.
#
#
# PART ONE:
# What is the path to this script?
# Please follow the example below by adding a trailing
# slash

my $full_path = '/home/ikonboard/cgi-bin/forums/';

# What extension do you use for CGI scripts?
# NT folks may want to use 'pl'

my $ext       = 'cgi';

# Change the use lib information below to reflect your
# full paths.
# Example:
# Change './'                   to '/home/board/www/stuff/'
# and    './install_modules'    to '/home/board/www/stuff/install_modules'

use lib ( 
            './',
            './Sources',
            './install_modules',
        );

#
# END OF SET UP
####################################################

# Check to make sure we have the needed version of perl
require 5.004;

# Load up the needed modules.
use File::Path;
use CGI::Carp "fatalsToBrowser";

# Set up our CGI environment
use CGI;
$iB::CGI = new CGI;
%iB::IN  = map { $_ => &iB::make_safe( $iB::CGI->param($_) ) } $iB::CGI->param();

# Mod perl clean up
$iB::OBJ    = { can_load => 0, tmp_path => '' };
$iB::CONFIG = {};
$iB::SAVED  = undef;

use constant IS_MODPERL => $ENV{MOD_PERL};
use subs qw(exit);
*iB::exit = IS_MODPERL ? \&Apache::exit : sub { CORE::exit };

####################################################
# Lets do a little test.
# Do we have to use a full qualified path name or can we get away with
# a relative name? Lets see..

if (-e 'installer.cgi') {
    $iB::OBJ->{can_load} = 1;
    $iB::OBJ->{tmp_path} = '';
    $iB::EXT = 'cgi';
} elsif (-e 'installer.pl') {
    $iB::OBJ->{can_load} = 1;
    $iB::OBJ->{tmp_path} = '';
    $iB::EXT = 'pl';
} elsif (-e $ENV{'DOCUMENT_ROOT'}.$ENV{'SCRIPT_NAME'}) {
    $iB::OBJ->{can_load} = 1;
    $iB::OBJ->{tmp_path} = $ENV{'DOCUMENT_ROOT'}.$ENV{'SCRIPT_NAME'};
    $iB::OBJ->{tmp_path} =~ s!installer.(cgi|pl)$!!i;
    $iB::EXT = $1;
} else {
    if ($full_path eq '/home/ikonboard/cgi-bin/forums/') {
        iB::install_error( 'FATAL_PATH_ERROR' );
    } else {
       $iB::OBJ->{tmp_path} = $full_path;
       $iB::EXT = $ext;
    } 
}
####################################################
# Load the Installer functions library

require 'functions.pm' or iB::install_error ( 'Could not load install_modules/functions.pm' );
my $functions = functions->new();

#
####################################################

####################################################
# Is the installer locked?
if (-e $iB::OBJ->{tmp_path}.'install.lock') {
    &iB::installer_locked();
}
#
####################################################

# Look for the config file
$iB::CONFIG = $functions->load_config( $iB::OBJ->{tmp_path} );

# Do we have any errors?
iB::install_error( $functions->{error} ) if $functions->{error};




####################################################
# MAIN SUB
####################################################

{

    my %Mode = (  
                    Splash   => [ 'system_test'   ,    'iB System Profiler'         ],
                    start    => [ 'start'         ,    'Installation: Step One'     ],
                    tar      => [ 'tar'           ,    'Installing Ikonboard Files' ],
                    database => [ 'database'      ,    'iB Database Set-up'         ],
                    populate => [ 'populate'      ,    'iB Database Population'     ],
                    admin    => [ 'admin'         ,    'iB Admin Creation'          ],
                 
               );

    $iB::IN{'act'} = 'Splash' if $iB::IN{'act'} eq '';
    $iB::IN{'act'} = 'Splash' unless exists $Mode{ $iB::IN{'act'} };

    # Fudge our autoloader together.
    my $code = '$functions->' .$Mode{ $iB::IN{'act'} }[0].'("'.$Mode{ $iB::IN{'act'} }[1].'");';
    # Trap and wrap any errors..
    unless (eval "$code") { &install_error($@); }


}

####################################################









####################################################
# UNIVERSAL SUBS
####################################################


sub make_safe {
    my $word = shift;
    $word    =~ s|!|&#33;|g;
    return $word;
}



sub install_error {
    my $message = shift;
       $message =~ s!\n!<br>!g;
    my $other = $! || 'none';
    my $help;

    if ($message eq 'FATAL_PATH_ERROR' or $message =~ /can't locate/i) {
        $message .= qq!<br><br>You will need to edit installer.cgi to enter in your full paths.
                      To do this, download a copy to your hard-drive, open it up in a
                      text editor, and look for the part that starts with:<br><br>
                      \#<br>
                      \# P R O G R A M  S E T - U P<br>
                      \#<br>
                      \# If the installer has requested it, please following<br>
                      \# the instructions below.<br><br>
                      Simply follow the instructions that follow, save, re-upload and run it again!;
    }

    print $iB::CGI->header();
    print $iB::CGI->start_html("Installer Error");
    print qq~
    <font face='verdana, arial'><h1>An error has occured</h1>
    <hr><font size='2'>
    The error returned was: <b>$message</b> $help
    <br>
    Error messages from perl:<font color='red'> $other</font>
    <br>
    Some information that may help:
    <br><br>
    ~;
    for (keys %ENV) {
        print "$_\t\t\t\t = \t$ENV{$_}<br>";
    }
    print qq~<br><b>Handy Error Message Meanings</b>
             <br>"Can't locate DBD..."  means that you do not have the needed files to run mySQL/pgSQL for perl
             <br>"Can't locate DBI..."  means that you do not have the needed files to run mySQL/pgSQL for perl
             <br>"Can't locate method TIE_HASH..  means that your servers DB_File installation is botched, contact your webhost
             <br>"Can't locate 'functions.pm'...  means you you will have to edit the installer script
             <br><br>~;
    print "<br>Please go back to correct this error";
    print $iB::CGI->end_html();
    iB::exit();
}

 sub catch_die {
    my $error = shift;
    
    &install_error($error);    
}

sub installer_locked {
    print "Content-type: text/html\n\n";
    print qq~
    <html>
    <head><title>Permission Denied!</title></head>
    <body bgcolor='#FFFFFF'>
    <font face='Arial' size='6' color='#333366'><b>Permission Denied, Installer locked</b></font>
    <hr size='1' color='#000000' noshade>
    <font face='arial, verdana' size='3' color='#00000'>
    As a safety precaution, the installer will lock itself after a successful install.<br><br>To unlock the installer, please remove the <b>'install.lock'</b> file from
    your ikonboard CGI directory. This installer will not run until you have done so.
    </font>
    </body>
    </html>
    ~;
    iB::exit(); 
}


1;