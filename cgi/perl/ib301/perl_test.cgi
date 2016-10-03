#!/usr/bin/perl

#^^^^^^^^^^^^^^
#
# You may need to edit that line to reflect your path to perl.

##############################################################
#
# Ikonboard Systems Checker
#
#
# Copyright (c) 2001 Matthew Mecham for Ikonboard.com
#
# WE ACCEPT NO LIABILITY FOR USING THIS SCRIPT. THE ONLY THING
# WE GUARANTEE IS THAT IT TAKES UP HARD DRIVE SPACE!!
#
###############################################################

use strict;
my $has_sendmail = 'Cannot Locate it';

my @send_mail = qw(
	                /usr/sbin/sendmail
	                /sbin/sendmail
	                /usr/bin/sendmail
	                /bin/sendmail
	                /usr/lib/sendmail
	                /lib/sendmail
	                /usr/slib/sendmail
	                /slib/sendmail
	                /usr/sendmail
	                /sendmail
	                sendmail
                    /var/qmail/bin/qmail-inject
                   );

eval { require 5 };
my $has_perl = $@ ? 'No' : 'Yes';

eval { require DB_File };
my $has_dbm  = $@ ? 'No' : 'Yes';

eval { require CGI };
my $has_cgi     = $@ ? 'No' : 'Yes';
my $cgi_version = $CGI::VERSION;

eval { require DBI };
my $has_dbi  = $@ ? 'No' : 'Yes';

my $perl_version = $];

my $script = $0;
   $script =~ s/.*\/(.*?)/$1/;
my $path   = $ENV{'DOCUMENT_ROOT'};
if ( eval { require Cwd; } ) {
   use Cwd;
   $path = cwd();
}
   #$path   =~ s!$script!!;

for (@send_mail) {
    $has_sendmail = $_ if (-e $_ );
}


# Lets Print it Out

print "Content-Type: text/html\n\n";

print <<_END_OF_TIME;

<html>
<head>
<title>Ikonboard Perl Checker</title>
</head>
<body bgcolor='#FFFFFF'>
<font face='Verdana, Arial' size='3' color='#000000'>
<b>Ikonboard Perl Checker</b>
<hr>
The following results were returned
<br><br>
Is Perl Version 5 or above installed? <b>$has_perl</b>
<br>
Version of Perl running on this server: <b>$perl_version</b>
<br>
Is the CGI.pm module installed?: <b>$has_cgi</b>
<br>
Version of CGI running on this server: <b>$cgi_version</b>
<br>
Is the DB_File installed on this server to allow DBM's to be used? <b>$has_dbm</b>
<br>
Is the DBI package installed, allowing the use of mySQL? <b>$has_dbi</b>
<br>
Full path to this script: <b>$path</b>
<br>
Sendmail Path: <b>$has_sendmail</b>
<br><br>
That's it, you can run ikonboard if the Perl version is greater than 5!
</body>
</html>
_END_OF_TIME

exit;
