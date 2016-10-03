#!/usr/bin/perl

########################################################
#                                                      #
# DO NOT REMOVE THIS HEADER                            #
#                                                      #
########################################################
#                                                      #
# For Unix/Unix Compatible/Linux/FreeBSD servers with  #
# Sendmail.                                            #
#                                                      #
# DO NOT USE on MSWin32(Win9x/ME/NT/2k)/MacOS servers  #
# or servers without Sendmail.                         #
#                                                      #
########################################################
#                                                      #
# COPYRIGHT NOTICE                                     #
# Copyright 1998-2000 by Thomas J. Delorme             #
# All Rights Reserved.                                 #
#                                                      #
# DISCLAIMER                                           #
# This script may be used provided that all            #
# accompanying documentation is read completely before #
# use, it is not changed or altered in any way, and it #
# is used only on the supported operating systems.     #
# This script carries no warranties, express or        #
# implied, including, but not limited to, suitability  #
# for a particular purpose. By using this script you   #
# agree to release the author from any and all         #
# liability or damages that might arise from its use,  #
# including, but not limited to, lost data or time.    #
# Use of this script on any server, in any form,       #
# demonstrates your complete acceptance, and the       #
# complete acceptance of any entity for which you are  #
# acting as a representative, including, but not       #
# limited to, your employer or contractor, of these    #
# terms. Redistributing or selling the code for this   #
# script without prior written consent from the author #
# is expressly forbidden.                              #
#                                                      #
########################################################
#                                                      #
# EasyList v2.2 by Thomas J. Delorme                   #
# Website : http://www.getperl.com                     #
# E-mail : webmaster@getperl.com                       #
# Created : Thursday, July 8, 1999                     #
# Revised : Thursday, July 27, 2000                    #
#                                                      #
########################################################

############   ADJUST THESE VARIABLES   ################

# PATH of the header file

	$headfile = 'http://darcfx.com/newsletter/head.txt';

# PATH of the header file

	$footfile = 'http://darcfx.com/newsletter/foot.txt';

# PATH of the e-mail address database - include the filename

	$emailpath = 'http://darcfx.com/newsletter/easylist.log';

# URL of your homepage

	$homepage = 'http://darcfx.com';

# URL of this script - include the filename

	$scripturl = 'http://darcfx.com/cgi-bin/easylist.cgi';

# Name your mailing list - do not use quotes (" or ')

	$listname = 'My Newsletter';

# Describe how often will you send e-mail to your mailing list? - No CAPS

	$listcycle = 'once every month';

# Name of your website

	$mysite = 'Darc FX.com';

# Password to access admin screen - CHANGE THIS IMMEDIATELY

	$adminpass = 'j5689ay';

# Do you want to be notified if anyone tries to guess your password?

	$hacknotify = 'yes';

# Change this to your e-mail address 

	$myemail = 'darc@darcfx.com';

# If you want to use file-locking for a more secure database
# keep this line as is...if you don't want to use file-locking
# or can't use 'flock' change the 1 to 0
# If you have a high-traffic site, I strongly suggest you use
# file-locking. 

	$uselock = '1';

# Does your host require a sleep between blocks of e-mails sent?

	$usesleep = 'no';

# How many e-mails are sent in one block?

	$blocksize = '100';

# How long to sleep between blocks (in seconds)?

	$sleeptime = '3';

# If the script can't find sendmail when you run it, enter the 
# sendmail path here...otherwise, leave this as is.

	$mailprogram = 'script';

####################   STOP HERE!   ####################
#                                                      #
# You may now upload this file to your server, using   #
# the instructions you received in the readme.txt file #
#                                                      #
########################################################
#                                                      #
# CHANGING ANYTHING IN THIS BOX OR BELOW MAY DAMAGE    #
# THE SCRIPT AND COMPLETES YOUR FORFEIT OF ANY AND ALL #
# SUPPORT PRIVILEDGES.                                 #
#                                                      #
########################################################

# Get the form variables

	if ($ENV{'REQUEST_METHOD'} eq 'GET') {
        	$buffer = $ENV{'QUERY_STRING'};
	}	
	else {
        	read(STDIN, $buffer, $ENV{'CONTENT_LENGTH'});
	}

# Break em up into a format the script can read

	@pairs = split(/&/, $buffer);
	foreach $pair (@pairs) {
        	($name, $value) = split(/=/, $pair);
        	$value =~ tr/+/ /;
        	$value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
        	$FORM{$name} = $value;
	}

# Open the header/footer files

	open (FILE, "$headfile");

		if ($uselock eq '1') {
			flock FILE, 2;
			seek FILE, 0, 0;
		}

		@header = <FILE>;

		if ($uselock eq '1') {
			flock FILE, 8;
		}

	close (FILE);

	open (FILE, "$footfile");

		if ($uselock eq '1') {
			flock FILE, 2;
			seek FILE, 0, 0;
		}

		@footer = <FILE>;

		if ($uselock eq '1') {
			flock FILE, 8;
		}

	close (FILE);

	if ($mailprogram eq 'script') {

		@mailtest = ("/bin/sendmail","/sbin/sendmail","/usr/lib/sendmail","/usr/bin/sendmail","/usr/sbin/sendmail");

		foreach $mailtest (@mailtest) {
			if (-e $mailtest && -X $mailtest) {
					$mailprogram = $mailtest;
			}
		}
		if ($mailprogram eq 'script') {
			print "Content-type: text/html\n\n";
			print "@header\n";
			print "<CENTER><TABLE BORDER=1 WIDTH=400 BGCOLOR=FF0000><TR><TD ALIGN=CENTER><FONT FACE=arial,helvetica SIZE=2>\n";
			print "<H2>Sendmail Not Found!</H2>\n";
			print "Please ask your host admin what the valid path for sendmail is on your system.\n";
			print "</FONT></TD></TR></TABLE><P>\n";
			print "<FONT FACE=arial,helvetica SIZE=2><B>\n";
			print "Click here to <A HREF=$homepage><B>Return</B></A>.\n";
			print "<P></FONT>\n";
			print "<TABLE BGCOLOR=777777><TR><TD BGCOLOR=999999 ALIGN=CENTER>\n";
			print "<FONT FACE=arial,helvetica COLOR=FFFFFF SIZE=2>\n";
			print "Powered By :<BR>\n";
			print "<A HREF=http://www.getperl.com><B>EasyList</B></A><BR>\n";
			print "Copyright 2000<BR>\n";
			print "By : Thomas J. Delorme<BR>\n";
			print "All Rights Reserved.<BR>\n";
			print "</FONT></TD></TR></TABLE><P>\n";
			print "<P></CENTER>\n";
			print "@footer\n";
			exit;
		} 
	}

# Assign variables from FORM data

	$tempemail = $FORM{'submitemail'};
	$tempemail =~ s/\s//g;
	$thisemail = lc ($tempemail);

# Decide which part of the script we need

	if ($FORM{'action'} eq 'subscribe') { &subscribe; }
	if ($FORM{'action'} eq 'unsubscribe') { &unsubscribe; }
	if ($FORM{'action'} eq 'admin') { &admin; }

	print "Content-type: text/html\n\n";
	print "@header\n";
	print "<P><CENTER><FONT FACE=arial,helvetica SIZE=3><B>EasyList Administration</B></FONT><P><FORM ACTION=$scripturl METHOD=POST><TABLE BORDER=1 BGCOLOR=990000><TR>\n";
	print "<TD><FONT FACE=arial,helvetica SIZE=3 COLOR=FAC700><B>Admin Password :</B></FONT></TD>\n";
	print "<TD><FONT FACE=arial,helvetica SIZE=2><INPUT TYPE=password NAME=password SIZE=25><INPUT TYPE=hidden NAME=action VALUE=admin></FONT></TD>\n";
	print "</TR></TABLE><INPUT TYPE=submit VALUE=Submit></FORM><P>\n";
	print "<FONT FACE=arial,helvetica SIZE=2><B>\n";
	print "Click here to <A HREF=$homepage><B>Return</B></A>.\n";
	print "<P></FONT>\n";
	print "<TABLE BGCOLOR=999999><TR><TD BGCOLOR=777777 ALIGN=CENTER>\n";
	print "<FONT FACE=arial,helvetica COLOR=FFFFFF SIZE=2>\n";
	print "Powered By :<BR>\n";
	print "<A HREF=http://www.getperl.com><B>EasyList</B></A><BR>\n";
	print "Copyright 2000<BR>\n";
	print "By : Thomas J. Delorme<BR>\n";
	print "All Rights Reserved.<BR>\n";
	print "</FONT></TD></TR></TABLE><P>\n";
	print "<P></CENTER>\n";
	print "@footer\n";
	exit;

sub subscribe {

	if ($thisemail !~ /(^([\w\.\-]+)[@]([a-zA-z0-9\.\-]+)[\.]([a-zA-Z]{2,3})$)/ || $thisemail =~ /(\.\.)|(^\.)|(\.@)|(@\.)|(\.$)|(\\)/ || length($thisemail) > 128) {
	
		print "Content-type: text/html\n\n";
		print "@header\n";
		print "<CENTER><TABLE BORDER=1 WIDTH=400 BGCOLOR=FF0000><TR><TD ALIGN=CENTER><FONT FACE=arial,helvetica SIZE=2>\n";
		print "<H2>E-mail Not Valid!</H2>\n";
		print "$thisemail\n";
		print "</FONT></TD></TR></TABLE><P>\n";
		print "<FONT FACE=arial,helvetica SIZE=2><B>\n";
		print "Click here to <A HREF=$homepage><B>Return</B></A>.\n";
		print "<P></FONT>\n";
		print "<TABLE BGCOLOR=999999><TR><TD BGCOLOR=777777 ALIGN=CENTER>\n";
		print "<FONT FACE=arial,helvetica COLOR=FFFFFF SIZE=2>\n";
		print "Powered By :<BR>\n";
		print "<A HREF=http://www.getperl.com><B>EasyList</B></A><BR>\n";
		print "Copyright 2000<BR>\n";
		print "By : Thomas J. Delorme<BR>\n";
		print "All Rights Reserved.<BR>\n";
		print "</FONT></TD></TR></TABLE><P>\n";
		print "<P></CENTER>\n";
		print "@footer\n";
		exit;
		
	}

	open (FILE, "$emailpath");

		if ($uselock eq '1') {
			flock FILE, 2;
			seek FILE, 0, 0;
		}

		@emaillist = <FILE>;

		if ($uselock eq '1') {
			flock FILE, 8;
		}

	close (FILE);

	foreach $emailaddress (@emaillist) {
		chomp ($emailaddress);
		if ($emailaddress eq $thisemail) {
			$already = 1;
		} 
	}

	if (!$already) {
		open (FILE, ">>$emailpath");

			if ($uselock eq '1') {
			flock FILE, 2;
			seek FILE, 0, 2;
			}

			print FILE "$thisemail\n";

			if ($uselock eq '1') {
			flock FILE, 8;
			}

		close (FILE);

		open (MAIL,"|$mailprogram -t -oi");
             		print MAIL "To: $thisemail\n";
                	print MAIL "From: $myemail\n";
                	print MAIL "Subject: Success! $listname joined!\n";
			print MAIL "Thank-you for joining $listname!\n\n";
			print MAIL "You will receive news and information about $mysite\n";
			print MAIL "$listcycle.\n\n";
			print MAIL "--------------------------------------------\n";
			print MAIL "If you have joined $listname by accident or someone else has\n";
			print MAIL "joined you without your permission, or\n";
			print MAIL "if you ever want to remove yourself from $listname\n";
			print MAIL "simply visit $scripturl?action=unsubscribe&submitemail=$thisemail\n";
			print MAIL "and you will be automatically removed.\n\n";
			print MAIL "Thanks,\n\n";
			print MAIL "$mysite staff\n\n";
			print MAIL "Powered By :\n";
			print MAIL "EasyList\n";
			print MAIL "http://www.getperl.com\n";
			print MAIL "Copyright 2000\n";
			print MAIL "By : Thomas J. Delorme\n";
			print MAIL "All Rights Reserved.\n";
		close (MAIL);

		print "Content-type: text/html\n\n";
		print "@header\n";
		print "<CENTER><TABLE BORDER=1 WIDTH=400 BGCOLOR=000077><TR><TD><FONT FACE=arial,helvetica SIZE=2>\n";
		print "<H2>$listname joined!</H2>\n";
		print "Thank-you for joining $listname!<P>\n";
		print "You will receive news and information about $mysite \n";
		print "$listcycle.<P>\n";
		print "If you have joined $listname by accident or someone else has\n";
		print "joined you without your permission, or\n";
		print "if you ever want to remove yourself from $listname<BR>\n";
		print "simply visit <A HREF=\"$scripturl?action=unsubscribe&submitemail=$thisemail\">$scripturl?action=unsubscribe&submitemail=$thisemail</A><BR>\n";
		print "and you will be automatically removed.<P>\n";
		print "Thanks,<P>\n";
		print "$mysite staff<P>\n";
		print "</FONT></TD></TR></TABLE><P>\n";
		print "<FONT FACE=arial,helvetica SIZE=2><B>\n";
		print "Click here to <A HREF=$homepage><B>Return</B></A>.\n";
		print "<P></FONT>\n";
		print "<TABLE BGCOLOR=999999><TR><TD BGCOLOR=777777 ALIGN=CENTER>\n";
		print "<FONT FACE=arial,helvetica COLOR=FFFFFF SIZE=2>\n";
		print "Powered By :<BR>\n";
		print "<A HREF=http://www.getperl.com><B>EasyList</B></A><BR>\n";
		print "Copyright 2000<BR>\n";
		print "By : Thomas J. Delorme<BR>\n";
		print "All Rights Reserved.<BR>\n";
		print "</FONT></TD></TR></TABLE><P>\n";
		print "<P></CENTER>\n";
		print "@footer\n";
	}

	if ($already) {
		print "Content-type: text/html\n\n";
		print "@header\n";
		print "<CENTER><TABLE BORDER=1 WIDTH=400 BGCOLOR=000077><TR><TD><FONT FACE=arial,helvetica SIZE=2>\n";
		print "<H2>$thisemail Already Joined!</H2>\n";
		print "</FONT></TD></TR></TABLE><P>\n";
		print "<FONT FACE=arial,helvetica SIZE=2><B>\n";
		print "Click here to <A HREF=$homepage><B>Return</B></A>.\n";
		print "<P></FONT>\n";
		print "<TABLE BGCOLOR=999999><TR><TD BGCOLOR=777777 ALIGN=CENTER>\n";
		print "<FONT FACE=arial,helvetica COLOR=FFFFFF SIZE=2>\n";
		print "Powered By :<BR>\n";
		print "<A HREF=http://www.getperl.com><B>EasyList</B></A><BR>\n";
		print "Copyright 2000<BR>\n";
		print "By : Thomas J. Delorme<BR>\n";
		print "All Rights Reserved.<BR>\n";
		print "</FONT></TD></TR></TABLE><P>\n";
		print "<P></CENTER>\n";
		print "@footer\n";
	}
	exit;

}

sub unsubscribe {

	if ($thisemail !~ /(^([\w\.\-]+)[@]([a-zA-z0-9\.\-]+)[\.]([a-zA-Z]{2,3})$)/ || $thisemail =~ /(\.\.)|(^\.)|(\.@)|(@\.)|(\.$)|(\\)/ || length($thisemail) > 128) {
		print "Content-type: text/html\n\n";
		print "@header\n";
		print "<CENTER><TABLE BORDER=1 WIDTH=400 BGCOLOR=FF0000><TR><TD ALIGN=CENTER><FONT FACE=arial,helvetica SIZE=2>\n";
		print "<H2>E-mail Not Valid!</H2>\n";
		print "$thisemail\n";
		print "</FONT></TD></TR></TABLE><P>\n";
		print "<FONT FACE=arial,helvetica SIZE=2><B>\n";
		print "Click here to <A HREF=$homepage><B>Return</B></A>.\n";
		print "<P></FONT>\n";
		print "<TABLE BGCOLOR=999999><TR><TD BGCOLOR=777777 ALIGN=CENTER>\n";
		print "<FONT FACE=arial,helvetica COLOR=FFFFFF SIZE=2>\n";
		print "Powered By :<BR>\n";
		print "<A HREF=http://www.getperl.com><B>EasyList</B></A><BR>\n";
		print "Copyright 2000<BR>\n";
		print "By : Thomas J. Delorme<BR>\n";
		print "All Rights Reserved.<BR>\n";
		print "</FONT></TD></TR></TABLE><P>\n";
		print "<P></CENTER>\n";
		print "@footer\n";
		exit;
	}

	open (FILE, "$emailpath");

		if ($uselock eq '1') {
			flock FILE, 2;
			seek FILE, 0, 0;
		}

		@emaillist = <FILE>;

		if ($uselock eq '1') {
			flock FILE, 8;
		}

	close (FILE);

	open (FILE, ">$emailpath");

		if ($uselock eq '1') {
			flock FILE, 2;
			seek FILE, 0, 0;
		}

	foreach $emailaddress (@emaillist) {
		chomp ($emailaddress);
		if ($emailaddress ne $thisemail) {
			print FILE "$emailaddress\n";
		} else {
			$myfound = 1;
		}
	}
	if ($uselock eq '1') {
		flock FILE, 8;
	}
	close (FILE);
	if ($myfound) {
		open (MAIL,"|$mailprogram -t -oi");
             		print MAIL "To: $thisemail\n";
                	print MAIL "From: $myemail\n";
                	print MAIL "Subject: $thisemail Removed\n";
			print MAIL "We are sorry to see you leaving $listname!\n\n";
			print MAIL "You will not receive news and information about $mysite\n";
			print MAIL "$listcycle anymore.\n\n";
			print MAIL "--------------------------------------------\n";
			print MAIL "If you ever want to join $listname again\n";
			print MAIL "simply visit $scripturl?action=subscribe&submitemail=$thisemail\n";
			print MAIL "and you will be automatically subscribed again.\n\n";
			print MAIL "Thanks,\n\n";
			print MAIL "$mysite staff\n\n";
			print MAIL "Powered By :\n";
			print MAIL "EasyList\n";
			print MAIL "http://www.getperl.com\n";
			print MAIL "Copyright 2000\n";
			print MAIL "By : Thomas J. Delorme\n";
			print MAIL "All Rights Reserved.\n";
		close (MAIL);
		print "Content-type: text/html\n\n";
		print "@header\n";
		print "<CENTER><TABLE BORDER=1 WIDTH=400 BGCOLOR=000077><TR><TD><FONT FACE=arial,helvetica SIZE=2>\n";
		print "<H2>$thisemail removed!</H2>\n";
		print "We're sorry to see you leaving $listname!<P>\n";
		print "You will not receive news and information about $mysite\n";
		print "$listcycle anymore.<P>\n";
		print "If you ever want to join $listname again<BR>\n";
		print "simply visit <A HREF=\"$scripturl?action=subscribe&submitemail=$thisemail\">$scripturl?action=subscribe&submitemail=$thisemail</A><BR>\n";
		print "and you will be automatically subscribed again.<P>\n";
		print "Thanks,<P>\n";
		print "$mysite staff<P>\n";
		print "</FONT></TD></TR></TABLE><P>\n";
		print "<FONT FACE=arial,helvetica SIZE=2><B>\n";
		print "Click here to <A HREF=$homepage><B>Return</B></A>.\n";
		print "<P></FONT>\n";
		print "<TABLE BGCOLOR=999999><TR><TD BGCOLOR=777777 ALIGN=CENTER>\n";
		print "<FONT FACE=arial,helvetica COLOR=FFFFFF SIZE=2>\n";
		print "Powered By :<BR>\n";
		print "<A HREF=http://www.getperl.com><B>EasyList</B></A><BR>\n";
		print "Copyright 2000<BR>\n";
		print "By : Thomas J. Delorme<BR>\n";
		print "All Rights Reserved.<BR>\n";
		print "</FONT></TD></TR></TABLE><P>\n";
		print "<P></CENTER>\n";
		print "@footer\n";
		exit;
	} else {
		print "Content-type: text/html\n\n";
		print "@header\n";
		print "<CENTER><TABLE BORDER=1 WIDTH=400 BGCOLOR=000077><TR><TD><FONT FACE=arial,helvetica SIZE=2>\n";
		print "<H2>$thisemail not listed!</H2>\n";
		print "There seems to have been a mistake...\n";
		print "This e-mail address is not currently listed as a member of $listname!<P>\n";
		print "You've been missing out on news and information about $mysite\n";
		print "$listcycle!<P>\n";
		print "If you decide you want to join $listname<BR>\n";
		print "simply visit <A HREF=\"$scripturl?action=subscribe&submitemail=$thisemail\">$scripturl?action=subscribe&submitemail=$thisemail</A><BR>\n";
		print "and you will be automatically subscribed.<P>\n";
		print "Thanks,<P>\n";
		print "$mysite staff<P>\n";
		print "</FONT></TD></TR></TABLE><P>\n";
		print "<FONT FACE=arial,helvetica SIZE=2><B>\n";
		print "Click here to <A HREF=$homepage><B>Return</B></A>.\n";
		print "<P></FONT>\n";
		print "<TABLE BGCOLOR=999999><TR><TD BGCOLOR=777777 ALIGN=CENTER>\n";
		print "<FONT FACE=arial,helvetica COLOR=FFFFFF SIZE=2>\n";
		print "Powered By :<BR>\n";
		print "<A HREF=http://www.getperl.com><B>EasyList</B></A><BR>\n";
		print "Copyright 2000<BR>\n";
		print "By : Thomas J. Delorme<BR>\n";
		print "All Rights Reserved.<BR>\n";
		print "</FONT></TD></TR></TABLE><P>\n";
		print "<P></CENTER>\n";
		print "@footer\n";
		exit;
	}
}

sub admin {

	if ($FORM{'password'}) {
		if ($FORM{'password'} eq $adminpass) {

			if ($FORM{'sendmessage'}) {

				open (FILE, "$emailpath");

					if ($uselock eq '1') {
					flock FILE, 2;
					seek FILE, 0, 0;
					}

					@emaillist = <FILE>;

					if ($uselock eq '1') {
					flock FILE, 8;
					}

				close (FILE);

				$subscribers = @emaillist;

				unless (defined($child_pid = fork())) {die "Process Error : $!\n"};

				if ($child_pid) {

					print "Content-type: text/html\n\n";
					print "@header\n";
					print "<P><CENTER><TABLE BGCOLOR=990000><TR><TD BGCOLOR=770000><FONT FACE=arial,helvetica SIZE=3 COLOR=FAC700><B>EasyList Administration</B></FONT></TD></TR></TABLE><P>\n";
					print "<FONT FACE=arial,helvetica SIZE=2><B>Messages Sent Successfully!</B></FONT><P>\n";
					print "<FORM ACTION=$scripturl METHOD=POST><TABLE BORDER=0 BGCOLOR=990000 WIDTH=400><TR><TD BGCOLOR=770000>\n";
					print "<FONT FACE=arial,helvetica SIZE=3 COLOR=FAC700><B>Send Mail To List</B></FONT><BR></TD></TR><TR><TD><FONT FACE=arial,helvetica SIZE=2 COLOR=FFFFFF><B>Click 'Send!' only once...it may take a few minutes depending on the size of your mailing list and the speed of your server.</B><P>\n";
					print "<FONT FACE=arial,helvetica SIZE=2 COLOR=FFFFFF><B>Subject :</B></FONT><BR><INPUT TYPE=text NAME=subject VALUE='$listname' SIZE=50><P>\n";
					print "<FONT FACE=arial,helvetica SIZE=2 COLOR=FFFFFF><B>Message :</B></FONT><BR><TEXTAREA NAME=listmessage COLS=70 ROWS=10 WRAP=PHYSICAL></TEXTAREA><P></TD></TR>\n";
					print "<TR><TD ALIGN=RIGHT><INPUT TYPE=hidden NAME=action VALUE=admin><INPUT TYPE=hidden NAME=sendmessage VALUE=yes><INPUT TYPE=hidden NAME=password VALUE=$FORM{'password'}><INPUT TYPE=submit VALUE=Send!></FONT></TD></TR></TABLE></FORM>\n";
					print "<TABLE BORDER=0 BGCOLOR=990000 WIDTH=400>\n";
					print "<TR><TD BGCOLOR=770000><FONT FACE=arial,helvetica SIZE=3 COLOR=FAC700><B>Your Mailing List - <I>$subscribers</I> subscribers</B></FONT></TD></TR>\n";
					print "<TR><TD><FONT FACE=arial,helvetica SIZE=2 COLOR=FFFFFF><B>You can add to or remove from your mailing list below.<BR>Use only one e-mail address per line.<BR>Click 'Change' only once...it may take a few minutes depending on the size of your mailing list and the speed of your server.</B><P>\n";
					print "<FORM ACTION=$scripturl METHOD=POST><TEXTAREA NAME=oldlist COLS=70 ROWS=10 WRAP=PHYSICAL>\n";
				
					foreach $emailaddress (@emaillist) {
						chomp ($emailaddress);
						print "$emailaddress\n";
					}
				
					print "</TEXTAREA><INPUT TYPE=hidden NAME=action VALUE=admin><INPUT TYPE=hidden NAME=password VALUE=$FORM{'password'}><INPUT TYPE=hidden NAME=maintain VALUE=yes></FONT><P></TD></TR>\n";
					print "<TR><TD ALIGN=RIGHT><INPUT TYPE=submit Value='Change'></FORM><P>\n";
					print "</TD></TR></TABLE><P>\n";
					print "<TABLE BORDER=0 BGCOLOR=990000 WIDTH=400><TR>\n";
					print "<TD BGCOLOR=770000><FONT FACE=arial,helvetica SIZE=3 COLOR=FAC700><B>Duplicate Removal</B></FONT></TD></TR>\n";
					print "<TR><TD><FONT FACE=arial,helvetica SIZE=2 COLOR=FFFFFF><B>To weed out duplicate e-mail addresses, click the button below.</B></FONT><P></TD></TR>\n";
					print "<TR><TD ALIGN=CENTER><FORM ACTION=$scripturl METHOD=POST><INPUT TYPE=hidden NAME=action VALUE=admin><INPUT TYPE=hidden NAME=dupecheck VALUE=yes><INPUT TYPE=hidden NAME=password VALUE=$FORM{'password'}><INPUT TYPE=submit VALUE=Remove!></FORM></TD>\n";
					print "</TR></TABLE><P>\n";
					print "<FONT FACE=arial,helvetica SIZE=2><B>\n";
					print "Click here to <A HREF=$homepage><B>Return</B></A>.\n";
					print "<P></FONT>\n";
					print "<TABLE BGCOLOR=999999><TR><TD BGCOLOR=777777 ALIGN=CENTER>\n";
					print "<FONT FACE=arial,helvetica COLOR=FFFFFF SIZE=2>\n";
					print "Powered By :<BR>\n";
					print "<A HREF=http://www.getperl.com><B>EasyList</B></A><BR>\n";
					print "Copyright 2000<BR>\n";
					print "By : Thomas J. Delorme<BR>\n";
					print "All Rights Reserved.<BR>\n";
					print "</FONT></TD></TR></TABLE><P>\n";
					print "<P></CENTER>\n";
					print "@footer\n";
					exit(0);

				} else {

					close (STDOUT);

					$subject = $FORM{'subject'};
					$subject =~ s/^\s+//;
					$subject =~ s/\s+$//;
					foreach $emailaddress (@emaillist) {
						chomp ($emailaddress);
						$sendcnt++;
						unless ($emailaddress eq '' || $emailaddress !~ /(^([\w\.\-]+)[@]([a-zA-z0-9\.\-]+)[\.]([a-zA-Z]{2,3})$)/ || $emailaddress =~ /(\.\.)|(^\.)|(\.@)|(@\.)|(\.$)|(\\)/ || length($emailaddress) > 128) {
							open (MAIL,"|$mailprogram -t -oi");
             							print MAIL "To: $emailaddress\n";
                						print MAIL "From: $myemail\n";
								print MAIL "Subject: $subject\n";
								print MAIL "$FORM{'listmessage'}\n\n";
								print MAIL "--------------------------------------------\n";					
								print MAIL "If you have joined $listname by accident or someone else has\n";
								print MAIL "joined you without your permission, or\n";
								print MAIL "if you ever want to remove yourself from $listname\n";
								print MAIL "simply visit $scripturl?action=unsubscribe&submitemail=$emailaddress\n";
								print MAIL "and you will be automatically removed.\n\n";
								print MAIL "Powered By :\n";
								print MAIL "EasyList\n";
								print MAIL "http://www.getperl.com\n";
								print MAIL "Copyright 2000\n";
								print MAIL "By : Thomas J. Delorme\n";
								print MAIL "All Rights Reserved.\n";
							close (MAIL);
						}
						if ($usesleep !~ 'n' && $sendcnt eq $blocksize) {
							sleep $sleeptime;
							$sendcnt = 0;
						}
					}
				}
			}

			if (!$FORM{'sendmessage'}) {
				
				open (FILE, "$emailpath");

					if ($uselock eq '1') {
					flock FILE, 2;
					seek FILE, 0, 0;
					}

					@emaillist = <FILE>;

					if ($uselock eq '1') {
					flock FILE, 8;
					}

				close (FILE);

				if ($FORM{'dupecheck'}) {

					foreach $templist (@emaillist) {
						chomp($templist);
						$testlist = lc($templist);
						if ($dupecheck !~ $testlist) {
							push (@nodupes, $testlist);
							$dupecheck .= $testlist;
						}
					}
					@newlist = @nodupes;

					open (FILE, ">$emailpath");

						if ($uselock eq '1') {
							flock FILE, 2;
							seek FILE, 0, 0;
						}

						foreach $addnew (@newlist) {
							print FILE "$addnew\n";
						}
						if ($uselock eq '1') {
							flock FILE, 8;
						}

					close (FILE);

					@emaillist = @newlist;
				}

				if ($FORM{'maintain'}) {
					@oldlist = split (/\n/, $FORM{'oldlist'});
					foreach $oldtemp (@oldlist) {
						$oldtemp =~ s/^\s+//;
						$oldtemp =~ s/\s+$//;
						$oldlist = lc ($oldtemp);
						push (@newlist, $oldlist);
					}
					open (FILE, ">$emailpath");

						if ($uselock eq '1') {
							flock FILE, 2;
							seek FILE, 0, 0;
						}

						foreach $addnew (@newlist) {
							print FILE "$addnew\n";
						}
						if ($uselock eq '1') {
							flock FILE, 8;
						}

					close (FILE);

					@emaillist = @newlist;
				}

				$subscribers = @emaillist;
				print "Content-type: text/html\n\n";
				print "@header\n";
				print "<P><CENTER><TABLE BGCOLOR=990000><TR><TD BGCOLOR=770000><FONT FACE=arial,helvetica SIZE=3 COLOR=FAC700><B>EasyList Administration</B></FONT></TD></TR></TABLE><P>\n";
				print "<FORM ACTION=$scripturl METHOD=POST><TABLE BORDER=0 BGCOLOR=990000 WIDTH=400><TR><TD BGCOLOR=770000>\n";
				print "<FONT FACE=arial,helvetica SIZE=3 COLOR=FAC700><B>Send Mail To List</B></FONT><BR></TD></TR><TR><TD><FONT FACE=arial,helvetica SIZE=2 COLOR=FFFFFF><B>Click 'Send!' only once...it may take a few minutes depending on the size of your mailing list and the speed of your server.</B><P>\n";
				print "<FONT FACE=arial,helvetica SIZE=2 COLOR=FFFFFF><B>Subject :</B></FONT><BR><INPUT TYPE=text NAME=subject VALUE='$listname' SIZE=50><P>\n";
				print "<FONT FACE=arial,helvetica SIZE=2 COLOR=FFFFFF><B>Message :</B></FONT><BR><TEXTAREA NAME=listmessage COLS=70 ROWS=10 WRAP=PHYSICAL></TEXTAREA><P></TD></TR>\n";
				print "<TR><TD ALIGN=RIGHT><INPUT TYPE=hidden NAME=action VALUE=admin><INPUT TYPE=hidden NAME=sendmessage VALUE=yes><INPUT TYPE=hidden NAME=password VALUE=$FORM{'password'}><INPUT TYPE=submit VALUE=Send!></FONT></TD></TR></TABLE></FORM>\n";
				print "<TABLE BORDER=0 BGCOLOR=990000 WIDTH=400>\n";
				print "<TR><TD BGCOLOR=770000><FONT FACE=arial,helvetica SIZE=3 COLOR=FAC700><B>Your Mailing List - <I>$subscribers</I> subscribers</B></FONT></TD></TR>\n";
				print "<TR><TD><FONT FACE=arial,helvetica SIZE=2 COLOR=FFFFFF><B>You can add to or remove from your mailing list below.<BR>Use only one e-mail address per line.<BR>Click 'Change' only once...it may take a few minutes depending on the size of your mailing list and the speed of your server.</B><P>\n";
				print "<FORM ACTION=$scripturl METHOD=POST><TEXTAREA NAME=oldlist COLS=70 ROWS=10 WRAP=PHYSICAL>\n";
				
				foreach $emailaddress (@emaillist) {
					chomp ($emailaddress);
					print "$emailaddress\n";
				}
				
				print "</TEXTAREA><INPUT TYPE=hidden NAME=action VALUE=admin><INPUT TYPE=hidden NAME=password VALUE=$FORM{'password'}><INPUT TYPE=hidden NAME=maintain VALUE=yes></FONT><P></TD></TR>\n";
				print "<TR><TD ALIGN=RIGHT><INPUT TYPE=submit Value='Change'></FORM><P>\n";
				print "</TD></TR></TABLE><P>\n";
				print "<TABLE BORDER=0 BGCOLOR=990000 WIDTH=400><TR>\n";
				print "<TD BGCOLOR=770000><FONT FACE=arial,helvetica SIZE=3 COLOR=FAC700><B>Duplicate Removal</B></FONT></TD></TR>\n";
				print "<TR><TD><FONT FACE=arial,helvetica SIZE=2 COLOR=FFFFFF><B>To weed out duplicate e-mail addresses, click the button below.</B></FONT><P></TD></TR>\n";
				print "<TR><TD ALIGN=CENTER><FORM ACTION=$scripturl METHOD=POST><INPUT TYPE=hidden NAME=action VALUE=admin><INPUT TYPE=hidden NAME=dupecheck VALUE=yes><INPUT TYPE=hidden NAME=password VALUE=$FORM{'password'}><INPUT TYPE=submit VALUE=Remove!></FORM></TD>\n";
				print "</TR></TABLE><P>\n";
				print "<FONT FACE=arial,helvetica SIZE=2><B>\n";
				print "Click here to <A HREF=$homepage><B>Return</B></A>.\n";
				print "<P></FONT>\n";
				print "<TABLE BGCOLOR=999999><TR><TD BGCOLOR=777777 ALIGN=CENTER>\n";
				print "<FONT FACE=arial,helvetica COLOR=FFFFFF SIZE=2>\n";
				print "Powered By :<BR>\n";
				print "<A HREF=http://www.getperl.com><B>EasyList</B></A><BR>\n";
				print "Copyright 2000<BR>\n";
				print "By : Thomas J. Delorme<BR>\n";
				print "All Rights Reserved.<BR>\n";
				print "</FONT></TD></TR></TABLE><P>\n";
				print "<P></CENTER>\n";
				print "@footer\n";
				
			}
	
			

		}

		if ($FORM{'password'} ne $adminpass) {

			print "Content-type: text/html\n\n";
			print "@header\n";
			print "<P><CENTER><FONT FACE=arial,helvetica SIZE=3 COLOR=FAC700><B>PASSWORD BREACH - WEBMASTER HAS BEEN NOTIFIED</B><P>\n";
			print "You have been identified as : $ENV{'REMOTE_ADDR'}</FONT>\n";
			print "@footer\n";
			
			if ($hacknotify eq 'yes') {

				open (MAIL,"|$mailprogram -t -oi");
        	     			print MAIL "To: $myemail\n";
                			print MAIL "From: $myemail\n";
                			print MAIL "Subject: Attempted Hack!\n";
					print MAIL "Someone has attempted to hack into your\n";
					print MAIL "EasyList Admin area.\n\n";
					print MAIL "The time was : ".gmtime()." GMT\n";
					print MAIL "Their IP was : $ENV{'REMOTE_ADDR'}\n";
					print MAIL "Their guess was : $FORM{'password'}\n\n";
					print MAIL "If they were close you should change your password now!\n\n";
					print MAIL "This message is a security feature of your EasyList script.\n\n";
					print MAIL "Powered By :\n";
					print MAIL "EasyList\n";
					print MAIL "http://www.getperl.com\n";
					print MAIL "Copyright 2000\n";
					print MAIL "By : Thomas J. Delorme\n";
					print MAIL "All Rights Reserved.\n";
				close (MAIL);
			}

		}
	}

	if (!$FORM{'password'}) {

		print "Content-type: text/html\n\n";
		print "@header\n";
		print "<P><CENTER><FONT FACE=arial,helvetica SIZE=3><B>EasyList Administration</B></FONT><P><FORM ACTION=$scripturl METHOD=POST><TABLE BORDER=1 BGCOLOR=990000><TR>\n";
		print "<TD><FONT FACE=arial,helvetica SIZE=3 COLOR=FAC700><B>Admin Password :</B></FONT></TD>\n";
		print "<TD><FONT FACE=arial,helvetica SIZE=2><INPUT TYPE=password NAME=password SIZE=25><INPUT TYPE=hidden NAME=action VALUE=admin></FONT></TD>\n";
		print "</TR></TABLE><INPUT TYPE=submit VALUE=Submit></FORM><P>\n";
		print "<FONT FACE=arial,helvetica SIZE=2><B>\n";
		print "Click here to <A HREF=$homepage><B>Return</B></A>.\n";
		print "<P></FONT>\n";
		print "<TABLE BGCOLOR=999999><TR><TD BGCOLOR=777777 ALIGN=CENTER>\n";
		print "<FONT FACE=arial,helvetica COLOR=FFFFFF SIZE=2>\n";
		print "Powered By :<BR>\n";
		print "<A HREF=http://www.getperl.com><B>EasyList</B></A><BR>\n";
		print "Copyright 2000<BR>\n";
		print "By : Thomas J. Delorme<BR>\n";
		print "All Rights Reserved.<BR>\n";
		print "</FONT></TD></TR></TABLE><P>\n";
		print "<P></CENTER>\n";
		print "@footer\n";

	}

	exit;
}