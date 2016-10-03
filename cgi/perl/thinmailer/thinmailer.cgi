#!/usr/bin/perl

############
#
#  THINmailer v 1.41 (October 18th 2000)  by Richard Still  richard@oakbox.com
#  I'm trying to make a really really REALLY thin web email client.
#  I welcome suggestions for enhancements.  I also welcome you coding
#  those changes and enhancements.  The script is still ugly, it's in
#  development.  Visit the main site at http://www.oakbox.com/scripts/ for
#  updates and support information.
############
# (C) 2000 oakbox.com  This program is freeware and may 
# be used at no cost to you (just leave this notice intact). 
# Feel free to modify, hack, and play  with this script.
# No guarantees about the utility of this script for any particular
# purpose! 
############
# http://www.oakbox.com/scripts/thinmailer.shtml for complete revision history.

# This variable must be set to the domain of the computer
# that ThinMailer is installed on.  Otherwise, the receiving mailhost might
# reject the message because it thinks the header is forged.

$this_server="oakbox.com"; 

# Thanks to Sean Dowd <pop3client@dowds.net> for his POP interface

require "pop3client.cgi";

# You need to modify this line to point to your own sendmail or smtp server, just comment
# out the line you don't need

$SEND_MAIL="/usr/sbin/sendmail -t"; 
#$SMTP_SERVER="smtp.server.com"; 

# DECODING THE INPUT 

$REFID=$ENV{'QUERY_STRING'};
read(STDIN,$temp,$ENV{'CONTENT_LENGTH'});
&decodevar;
$temp=$ENV{'QUERY_STRING'};
&decodevar;

# Look at the cookie cache
&GetCookies;
if($Cookies{'userid'} eq "" && $fields{'action'} eq ""){&firstscreen; exit;} # first time user
# They are attempting to log in now
if ($fields{'action'} eq "setidpw"){
$pop = new pop3client( USER  => "$fields{'userid'} ", PASSWORD => "$fields{'password'} ", HOST=> "$fields{'popdomain'}", AUTH_MODE => "$fields{'auth_method'}", DEBUG => 0 );
&cookiethem; 

$specialhead=qq*<meta http-equiv="refresh" content="0;URL=thinmailer.cgi?action=listletters">*;

$message.=<<_EEE_;

<p>&nbsp;</p>
<center><p><font face="Arial, Helvetica, sans-serif">I have placed a temporary cookie 
  in your browser.<br> Be sure to EXIT your browser or hit the LOG OUT link before 
  leaving this terminal! </font></p>
<table border="2" cellspacing="2" cellpadding="2" bgcolor="#666666">
  <tr bgcolor="#999999"> 
    <td><b><font face="Verdana"><a href="thinmailer.cgi?action=listletters">Go 
      to the Inbox</a></font></b> </td>
  </tr>
</table>

_EEE_

&shellout; 
exit;}

&popme; # Establish connection with POP box

if ($fields{'action'} eq "listletters"){&listletters; &shellout; exit;} # Display all messages in box
if ($fields{'action'} eq "display"){&displayletters; &shellout; exit;} # Display selected message
if ($fields{'action'} eq "compose"){&compose; &shellout; exit;} # Write a new message
if ($fields{'action'} eq "send"){&sendmessage; &listletters; &shellout; exit;} # Send the new message out
if ($fields{'action'} eq "header"){&fullheader; &shellout; exit;} # Display full header of selected message
if ($fields{'action'} eq "fullbody"){&fullbody; &shellout; exit;} # Display full body of selected message
if ($fields{'action'} eq "delete"){&deletemess; &shellout; exit;} # Delete selected message
if ($fields{'action'} eq "reply"){&replymessage; &shellout; exit;} # Reply to selected message
if ($fields{'action'} eq "logout"){&logout; &firstscreen; exit;} # Just what the action says, man.
exit;

######

sub logout{
# to log out, I just cookie blank values to the browser
print "Content-type: text/html\n";
&SetCookies('userid','','password','','host','');

# THEN, I close the POP, because closing should complete any pending deletions
# (look in the pop3client file for more information)
$pop->Close();
}

#####

sub replymessage{

# read the message, line by line, put a greater-than symbol
# at the beginning of each line.

@bodymess=$pop->Body($fields{'messagenumber'});
    foreach (@bodymess)
     {$body.="> $_ \n";}
    @headermess=$pop->Head($fields{'messagenumber'});
    foreach ( @headermess ) {
	/^Subject\: (.+)$/i and $subject=$1; 
 }
$subject="RE: ".$subject;
&compose;
}


#####

sub deletemess{

foreach $i (@todelete){
$pop->Delete( $i );
}

$pop->State();
$pop->Close();
$specialhead=qq*<meta http-equiv="refresh" content="0;URL=thinmailer.cgi?action=listletters">*;

$message.=<<_EEE_;
<p>&nbsp;</p>
<center><p><font face="Arial, Helvetica, sans-serif">Your messages have been removed</font></p>

_EEE_

}

######
sub fullheader{
$i=$fields{'messagenumber'};
foreach ($pop->Head( $i )){
$message.= "$_ <br> \n"; }
$message.= "<P> end of header information";
}

#######
sub fullbody{
$i=$fields{'messagenumber'};
foreach ($pop->Body( $i )){
$message.= "$_ <br> \n"; }
$message.= "<P> end of full body info";
}


########
sub sendmessage{
$to=$fields{'address'};
$from=$fields{'fromaddress'};
$reply=$fields{'repaddress'};
$subject=$fields{'subject'};
$message=$fields{'messagecontent'};
&sendmail($from, $reply, $to, $smtp, $subject, $message );
$message="Your message was sent. <p> \n";
}


######
sub compose {

$message.=<<_END_;
<form method="post" action="thinmailer.cgi" name="rrform">
  <table width="100%" border="0">
    <tr> 
      <td width="12%" align="right"> <font face="Verdana" size="2">From :</font></td>
      <td width="88%" align="left"> <font face="Verdana" size="2"> 
       FROM <input type="text" name="fromaddress" value="$Cookies{'userid'}\@$this_server"></i></b> </font></td>
    </tr>
    <tr> 
      <td width="12%" align="right"> <font face="Verdana" size="2">ReplyTo :</font></td>
      <td width="88%" align="left"> <font face="Verdana" size="2"> 
        <input type="text" name="repaddress" value="$Cookies{'userid'}\@$this_server">
         </font></td>
    </tr>
    <tr> 
      <td width="12%" align="right"> <font face="Verdana" size="2">To :</font></td>
      <td width="88%" align="left"> <font face="Verdana" size="2"> 
        <input type="text" name="address" value="$fields{'address'}" size="45">
        </font></td>
    </tr>
    <tr> 
      <td width="12%" align="right"> <font face="Verdana" size="2">Subject : </font></td>
      <td width="88%" align="left"> <font face="Verdana" size="2"> 
        <input type="text" name="subject" value="$subject" size="45">
        </font></td>
    </tr>
  </table>
  <p> 
    <textarea name="messagecontent" rows="10" cols="70">$body</textarea>
  </p>
  <p> 
    <input type="reset" name="Reset" value="Reset">
 <input type="hidden" name="action" value="send">
   <input type="submit" name="submit" value="Mail Me" onClick="javascript:document.rrform.submit.value='Processing'">
  </p>
</form>
_END_
}

#######
sub displayletters
{
$i=$fields{'messagenumber'};

     foreach ( $pop->Head( $i ) ) {
     /^(Subject):\s+/i and $subject=$_;
     /^(Date):\s+/i and $date=$_;
     	if(/^From\: (.+)$/i) { 
	$rawaddress = $1;
	$rawaddress =~ s/^(.*)[\r\n]+$/$1/;
	$fromaddress .= $_; }
      if(/MIME/){$mime="yes";}
     }

# if($mime eq "yes"){@bodymess=&mimestrip;}else{}  
# I had to strip this out because I couldn't make it work correctly
# I can correctly identify MIME messages with the $mime flag, but parsing
# the message is a pain.  Any ideas?


@bodymess=$pop->Body($i);

# I'm going to flip through the message and try to do some basic formatting so that it
# will display in the browser correctly.  This also strips out most of the HTML that
# is included in the message.

foreach (@bodymess)
     {
$vartemp=$_;
$vartemp=~ s/</\&lt\;/;
$vartemp=~ s/>/\&gt\;/;
$body.="$vartemp <br> \n";}
$fromaddress =~ s/(<.*>)/ /g;
$fromaddress=$1;
$fromaddress=~ s/(<|>)//g;
$fromadd=$fromaddress;
if($fromaddress eq ""){
foreach ( $pop->Head( $i ) ) {
 /^(From):\s+/i and $from=$_;}
($trash,$fromadd)=split(/: /,$from);
$fromaddress=$fromadd; }

$nummessages=$pop->Count();
$next=$i+1;
$prev=$i-1;

if($prev > 0){
$previoustag=<<_TTT_;

<font size="1" face="Verdana"><b><font color="#FFFFFF"><a href="thinmailer.cgi?action=display&amp;messagenumber=$prev">Previous</a> 
      </font></b></font>

_TTT_
}else{$previoustag="<font size=\"1\" face=\"Verdana\"><b><font color=\"#999999\">Previous </font></b></font>";}

if($next <= $nummessages){
$nexttag=<<_TTT_;

<font size="1" face="Verdana"><b><font color="#FFFFFF"><a href="thinmailer.cgi?action=display&amp;messagenumber=$next">Next</a> 
      </font></b></font>

_TTT_
}else{$nexttag=qq*<font size="1" face="Verdana"><b><font color="#999999">Next </font></b></font>*;}


$message.=<<_END_;
<table border="1" cellspacing="0" cellpadding="5" $messageheaderbg width="100%">
  <tr bgcolor="#000099" align="center"> 
    <td> 
      <font color="#FFFFFF" face="Verdana" size="1"><b><a href="thinmailer.cgi?action=reply&address=$fromadd&messagenumber=$i">Reply</a></b></font>
    </td>
    <td> 
      <font color="#FFFFFF" face="Verdana" size="1"><b><a href="thinmailer.cgi?action=delete&xkill=$i">Delete 
        this message</a></b></font>
    </td>
    <td> 
      <font color="#FFFFFF" face="Verdana" size="1"><b><a href="thinmailer.cgi?action=header&messagenumber=$i">Display 
        full Header</a></b></font>
    </td>
    <td> 
      <font face="Verdana" size="1"><b><font color="#FFFFFF"><a href="thinmailer.cgi?action=fullbody&messagenumber=$i">Display 
        full Body</a></font></b></font>
    </td>
    <td>$nexttag</td>
    <td>$previoustag</td>
  </tr>
</table>
<table width="100%" border="0" cellpadding="2" cellspacing="2"  bgcolor="#FFFFFF">
  <tr> 

    <td><font face="Verdana, Arial, Helvetica, sans-serif"><b><font size="2" face="Verdana">$fromadd 
      $date</font></b></font></td>
  </tr>
  <tr> 
    <td><font face="Verdana, Arial, Helvetica, sans-serif"><b><font face="Verdana" size="2">$subject</b> <br><i>$i of $nummessages messages</i></font></font> 
    </td>
  </tr>
</table><p>
  $body <p>
<table border="1" cellspacing="0" cellpadding="5" $messageheaderbg width="100%">
  <tr bgcolor="#000099" align="center"> 
    <td> 
      <font color="#FFFFFF" face="Verdana" size="1"><b><a href="thinmailer.cgi?action=reply&address=$fromadd&messagenumber=$i">Reply</a></b></font>
    </td>
    <td> 
      <font color="#FFFFFF" face="Verdana" size="1"><b><a href="thinmailer.cgi?action=delete&xkill=$i">Delete 
        this message</a></b></font>
    </td>
    <td> 
      <font color="#FFFFFF" face="Verdana" size="1"><b><a href="thinmailer.cgi?action=header&messagenumber=$i">Display 
        full Header</a></b></font>
    </td>
    <td> 
      <font face="Verdana" size="1"><b><font color="#FFFFFF"><a href="thinmailer.cgi?action=fullbody&messagenumber=$i">Display 
        full Body</a></font></b></font>
    </td>
    <td><font size="1" face="Verdana"><b><font color="#FFFFFF"><a href="thinmailer.cgi?action=display&amp;messagenumber=$prev">Previous</a> 
      </font></b></font></td>    
    <td><font size="1" face="Verdana"><b><font color="#FFFFFF"><a href="thinmailer.cgi?action=display&amp;messagenumber=$next">Next</a> 
      </font></b></font></td>

  </tr>
</table>

_END_

}


####
sub listletters{
$nummessages=$pop->Count();
$message.=<<_END_;
<i>$nummessages messages</i>
<form method="post" action="thinmailer.cgi" name="">
  <table bgcolor="#FFFFFF" border="1" width="100%">
    <tr bgcolor="#CCCCCC" align="left"> 
      <td><font face="Verdana" size="2"><b><font color="#000000">From</font></b></font></td>
      <td><font face="Verdana" size="2"><b><font color="#000000">Subject</font></b></font></td>
      <td><font face="Verdana" size="2"><b><font color="#000000">Sent On</font></b></font></td>
    </tr>
_END_

for ($i = 1; $i <= $pop->Count(); $i++) {
	foreach ( $pop->Head( $i ) ) {
	if(/^From\: (.+)$/i) { 
	$rawaddress = $1;
	$rawaddress =~ s/^(.*)[\r\n]+$/$1/;
	$fromaddress .= $_; }
	/^Subject\: (.+)$/i and $subject=$1; 
	/^Date\: (.+)$/i and $date=$1; 
	/^To\: (.+)$/i and $to=$1; 
	}

$fromaddress =~ s/(<.*>)/ /g;
$fromaddress=$1;
$fromaddress=~ s/(<|>)//g;
if($fromaddress eq ""){
    foreach ( $pop->Head( $i ) ) {
     /^(From):\s+/i and $from=$_;
      }
 ($trash,$fromadd)=split(/: /,$from);
 $fromaddress=$fromadd; }


# You can list the $date, $fromaddress, $subject, and $to in your message
# list  The default is from, subject, date

if($subject eq ""){$subject="No Subject";}

$message.=<<_END_;
<tr bgcolor="#666666" align="left"> 
      <td> <font size="2" face="Verdana"><b> 
        <input type="checkbox" name="xkill" value="$i">
        <font color="#CCFFFF">$fromaddress</font></b></font></td>
      <td><font size="2" face="Verdana"><b><a href="thinmailer.cgi?action=display&messagenumber=$i">:$subject </a></b></font></td>
      <td><font size="2" face="Verdana"><b><font color="#CCFFFF">$date</font></b></font></td>
    </tr>
_END_

$date="";
$fromaddress="";
$to="";
$subject="";
$fromadd="";
$from="";

}

$message.=<<_END_;
  </table> 
<input type="reset" name="Reset" value="Reset"> <input type="hidden" name="action" value="delete"><input type="submit" name="Submit2" value="Delete Checked Messages">
</form>

_END_

}

#########
sub shellout {
&makeshell;
$matcher="CONVENTIONAL";
#foreach $line (@SHELL)
#{ $line=~ s/$matcher/$message/;
#  $output.=$line;}

$SHELLSTUFF=~ s/$matcher/$message/;
print "Content-type: text/html\n\n";
#print "$message";
print "$SHELLSTUFF $output";
}

##########
sub popme{
 $pop = new pop3client( USER  => "$Cookies{'userid'}", PASSWORD => "$Cookies{'password'}", HOST=> "$Cookies{'host'}", DEBUG => 0, AUTH_MODE => "$Cookies{'auth_method'}" );
	$count = $pop->Count;
	if ($count == -1) {
print "Content-type: text/html\n";
&SetCookies('userid','','password','','host','');
$message.="Could not connect to $Cookies{'host'} - ".$pop->Message."<br><a href=\"thinmailer.cgi\">Back to login</a>\n"; &shellout; exit;}
}
##########
sub cookiethem
{
print "Content-type: text/html\n";
&SetCookies('userid',$fields{'userid'},'password',$fields{'password'},'host',$fields{'popdomain'},'auth_mode',$fields{'auth_method'});
}

##########
sub decodevar
{
@pairs=split(/&/,$temp);
foreach $item(@pairs)
 {
  ($key,$content)=split(/=/,$item,2);
  $content=~tr/+/ /;
  $content =~ s/<!--(.|\n)*-->//g;
  $content=~s/%(..)/pack("c",hex($1))/ge;
  $fields{$key}=$content;
  if ($key eq "xkill"){
    push (@todelete,$content);}
 }     
}


#############
#Sendmail.pm routine below by Milivoj Ivkovic 

#############
sub sendmail  {

# error codes below for those who bother to check result codes <gr>

# 1 success
# -1 $smtphost unknown
# -2 socket() failed
# -3 connect() failed
# -4 service not available
# -5 unspecified communication error
# -6 local user $to unknown on host $smtp
# -7 transmission of message failed
# -8 argument $to empty
#
#  Sample call:
#
# &sendmail($from, $reply, $to, $smtp, $subject, $message );
#
#  Note that there are several commands for cleaning up possible bad inputs - if you
#  are hard coding things from a library file, so of those are unnecesssary
#

    my ($fromaddr, $replyaddr, $to, $smtp, $subject, $message) = @_;

    $to =~ s/[ \t]+/, /g; # pack spaces and add comma
    $fromaddr =~ s/.*<([^\s]*?)>/$1/; # get from email address
    $replyaddr =~ s/.*<([^\s]*?)>/$1/; # get reply email address
    $replyaddr =~ s/^([^\s]+).*/$1/; # use first address
    $message =~ s/^\./\.\./gm; # handle . as first character
    $message =~ s/\r\n/\n/g; # handle line ending
    $message =~ s/\n/\r\n/g;
    $smtp =~ s/^\s+//g; # remove spaces around $smtp
    $smtp =~ s/\s+$//g;

    if (!$to)
    {
	return(-8);
    }

 if ($SMTP_SERVER ne "")
  {
    my($proto) = (getprotobyname('tcp'))[2];
    my($port) = (getservbyname('smtp', 'tcp'))[2];

    my($smtpaddr) = ($smtp =~
		     /^(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})$/)
	? pack('C4',$1,$2,$3,$4)
	    : (gethostbyname($smtp))[4];

    if (!defined($smtpaddr))
    {
	return(-1);
    }

    if (!socket(MAIL, AF_INET, SOCK_STREAM, $proto))
    {
	return(-2);
    }

    if (!connect(MAIL, pack('Sna4x8', AF_INET, $port, $smtpaddr)))
    {
	return(-3);
    }

    my($oldfh) = select(MAIL);
    $| = 1;
    select($oldfh);

    $_ = <MAIL>;
    if (/^[45]/)
    {
	close(MAIL);
	return(-4);
    }

    print MAIL "helo $SMTP_SERVER\r\n";
    $_ = <MAIL>;
    if (/^[45]/)
    {
	close(MAIL);
	return(-5);
    }

    print MAIL "mail from: <$fromaddr>\r\n";
    $_ = <MAIL>;
    if (/^[45]/)
    {
	close(MAIL);
	return(-5);
    }

    foreach (split(/, /, $to))
    {
	print MAIL "rcpt to: <$_>\r\n";
	$_ = <MAIL>;
	if (/^[45]/)
	{
	    close(MAIL);
	    return(-6);
	}
    }

    print MAIL "data\r\n";
    $_ = <MAIL>;
    if (/^[45]/)
    {
	close MAIL;
	return(-5);
    }

   }

  if ($SEND_MAIL ne "")
   {
     open (MAIL,"| $SEND_MAIL");
   }

    print MAIL "To: $to\n";
    print MAIL "From: $fromaddr\n";
    print MAIL "Reply-to: $replyaddr\n" if $replyaddr;
    print MAIL "X-Mailer: Perl Powered Socket Mailer\n";
    print MAIL "Subject: $subject\n\n";
    print MAIL "$message";
    print MAIL "\n.\n";

 if ($SMTP_SERVER ne "")
  {
    $_ = <MAIL>;
    if (/^[45]/)
    {
	close(MAIL);
	return(-7);
    }

    print MAIL "quit\r\n";
    $_ = <MAIL>;
  }

    close(MAIL);
    return(1);
}

########################
# HTTP Cookie Library           Version 2.1                                  #
# Copyright 1996 Matt Wright    mattw@worldwidemart.com                      #
# Created 07/14/96              Last Modified 12/23/96                       #
# Script Archive at:            http://www.worldwidemart.com/scripts/        #
#                               Extensive Documentation found in README file.#
########################
# COPYRIGHT NOTICE                                                           #
# Copyright 1996 Matthew M. Wright.  All Rights Reserved.                    #
#                                                                            #
# HTTP Cookie Library may be used and modified free of charge by anyone so   #
# long as this copyright notice and the comments above remain intact.  By    #
# using this code you agree to indemnify Matthew M. Wright from any          #
# liability that might arise from it's use.                                  #
#                                                                            #
# Selling the code for this program without prior written consent is         #
# expressly forbidden.  In other words, please ask first before you try and  #
# make money off of my program.                                              #
#                                                                            #
# Obtain permission before redistributing this software over the Internet or #
# in any other medium.  In all cases copyright and header must remain intact.#
########################

########################
# Subroutine:    &GetCookies()                                               #
# Description:   This subroutine can be called with or without arguments. If #
#                arguments are specified, only cookies with names matching   #
#                those specified will be set in %Cookies.  Otherwise, all    #
#                cookies sent to this script will be set in %Cookies.        #
# Usage:         &GetCookies([cookie_names])                                 #
# Variables:     cookie_names - These are optional (depicted with []) and    #
#                               specify the names of cookies you wish to set.#
#                               Can also be called with an array of names.   #
#                               Ex. 'name1','name2'                          #
# Returns:       1 - If successful and at least one cookie is retrieved.     #
#                0 - If no cookies are retrieved.                            #
########################

sub GetCookies {

    # Localize the variables and read in the cookies they wish to have       #
    # returned.                                                              #

    local(@ReturnCookies) = @_;
    local($cookie_flag) = 0;
    local($cookie,$value);

    # If the HTTP_COOKIE environment variable has been set by the call to    #
    # this script, meaning the browser sent some cookies to us, continue.    #

    if ($ENV{'HTTP_COOKIE'}) {

        # If specific cookies have have been requested, meaning the          #
        # @ReturnCookies array is not empty, proceed.                        #

        if ($ReturnCookies[0] ne '') {

            # For each cookie sent to us:                                    #

            foreach (split(/; /,$ENV{'HTTP_COOKIE'})) {

                # Split the cookie name and value pairs, separated by '='.   #

                ($cookie,$value) = split(/=/);

                # Decode any URL encoding which was done when the compressed #
                # cookie was set.                                            #

                foreach $char (@Cookie_Decode_Chars) {
                    $cookie =~ s/$char/$Cookie_Decode_Chars{$char}/g;
                    $value =~ s/$char/$Cookie_Decode_Chars{$char}/g;
                }

                # For each cookie to be returned in the @ReturnCookies array:#

                foreach $ReturnCookie (@ReturnCookies) {

                    # If the $ReturnCookie is equal to the current cookie we #
                    # are analyzing, set the cookie name in the %Cookies     #
                    # associative array equal to the cookie value and set    #
                    # the cookie flag to a true value.                       #

                    if ($ReturnCookie eq $cookie) {
                        $Cookies{$cookie} = $value;
                        $cookie_flag = "1";
                    }
                }
            }

        }

        # Otherwise, if no specific cookies have been requested, obtain all  #
        # cookied and place them in the %Cookies associative array.          #

        else {

            # For each cookie that was sent to us by the browser, split the  #
            # cookie name and value pairs and set the cookie name key in the #
            # associative array %Cookies equal to the value of that cookie.  #
            # Also set the coxokie flag to 1, since we set some cookies.      #

            foreach (split(/; /,$ENV{'HTTP_COOKIE'})) {
                ($cookie,$value) = split(/=/);

                # Decode any URL encoding which was done when the compressed #
                # cookie was set.                                            #

                foreach $char (@Cookie_Decode_Chars) {
                    $cookie =~ s/$char/$Cookie_Decode_Chars{$char}/g;
                    $value =~ s/$char/$Cookie_Decode_Chars{$char}/g;
                }

                $Cookies{$cookie} = $value;
            }
            $cookie_flag = 1;
        }
    }

    # Return the value of the $cookie_flag, true or false, to indicate       #
    # whether we succeded in reading in a cookie value or not.               #

    return $cookie_flag;
}

########################
# Subroutine:    &SetCookies()                                               #
# Description:   Sets one or more cookies by printing out the Set-Cookie     #
#                HTTP header to the browser, based on cookie information     #
#                passed to subroutine.                                       #
# Usage:         &SetCookies(name1,value1,...namen,valuen)                   #
# Variables:     name  - Name of the cookie to be set.                       #
#                        Ex. 'count'                                         #
#                value - Value of the cookie to be set.                      #
#                        Ex. '3'                                             #
#                n     - This is tacked on to the last of the name and value #
#                        pairs in the usage instructions just to show you    #
#                        you can have as many name/value pairs as you wish.  #
#               ** You can specify as many name/value pairs as you wish, and #
#                  &SetCookies will set them all.  Just string them out, one #
#                  after the other.  You must also have already printed out  #
#                  the Content-type header, with only one new line following #
#                  it so that the header has not been ended.  Then after the #
#                  &SetCookies call, you can print the final new line.       #
# Returns:       Nothing.                                                    #
########################

sub SetCookies {

    # Localize variables and read in cookies to be set.                      #

    local(@cookies) = @_;
    local($cookie,$value,$char);

    # While there is a cookie and a value to be set in @cookies, that hasn't #
    # yet been set, proceed with the loop.                                   #

    while( ($cookie,$value) = @cookies ) {

        # We must translate characters which are not allowed in cookies.     #

        foreach $char (@Cookie_Encode_Chars) {
            $cookie =~ s/$char/$Cookie_Encode_Chars{$char}/g;
            $value =~ s/$char/$Cookie_Encode_Chars{$char}/g;
        }

        # Begin the printing of the Set-Cookie header with the cookie name   #
        # and value, followed by semi-colon.                                 #

        print 'Set-Cookie: ' . $cookie . '=' . $value . ';';

        # If there is an Expiration Date set, add it to the header.          #

        if ($Cookie_Exp_Date) {
            print ' expires=' . $Cookie_Exp_Date . ';';
        }

        # If there is a path set, add it to the header.                      #

        if ($Cookie_Path) {
            print ' path=' . $Cookie_Path . ';';
        }

        # If a domain has been set, add it to the header.                    #

        if ($Cookie_Domain) {
            print ' domain=' . $Cookie_Domain . ';';
        }

        # If this cookie should be sent only over secure channels, add that  #
        # to the header.                                                     #

        if ($Secure_Cookie) {
            print ' secure';
        }

        # End this line of the header, setting the cookie.                   #

        print "\n";

        # Remove the first two values of the @cookies array since we just    #
        # used them.                                                         #

        shift(@cookies); shift(@cookies);
    }
}
#######################
sub firstscreen{
print "Content-type: text/html\n\n";
print<<_END_;

<html>
<head>
<title>ThinMailer - oakbox.com</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<style type="text/css">
     <!--
     A { text-decoration:none }
     -->
     </style>
</head>

<body bgcolor="#CCCCCC" link="#FFFFFF" vlink="#FFFF33" text="#999999">
<form method="post" action="thinmailer.cgi?first" name="">
  <p align="center"><b><font face="Arial, Helvetica, sans-serif" size="+3" color="#000000">T</font></b><font face="Arial, Helvetica, sans-serif" size="+3" color="#000000">hin<b>M</b>ailer</font><font face="Arial, Helvetica, sans-serif"> 
    <a href="mailto:richard\@oakbox.com">a script by Richard Still</a> </font></p>
  <table width="475" border="0" height="100" align="center">
    <tr> 
      <td align="right" width="36%"><font color="#000000" face="Arial, Helvetica, sans-serif"><b><font size="-1">Your 
        ID</font></b></font></td>
      <td width="64%"> 
        <input type="text" name="userid">
        <input type="hidden" name="action" value="setidpw">
       </td>
    </tr>
    <tr> 
      <td align="right" width="36%"><font color="#000000" face="Arial, Helvetica, sans-serif" size="-1"><b>Your 
        Password</b></font></td>
      <td width="64%">  <input type="password" name="password">
        <input type="radio" name="auth_method" value="PASS" checked>
        <font size="-1"> PASS</font> 
        <input type="radio" name="auth_method" value="APOP">
        <font size="-1">APOP</font></td>
    </tr>
    <tr> 
      <td align="right" width="36%"><font color="#000000"><b><font size="-1" face="Arial, Helvetica, sans-serif">Your 
        POP Server</font></b></font></td>
      <td width="64%"><font size="2"><b><font face="Verdana, Arial, Helvetica, sans-serif"> 
        <input type="text" name="popdomain">
        </font><font size="2"><b><font size="2"><b><font size="2"><b><font face="Verdana, Arial, Helvetica, sans-serif"> 
        <input type="submit" name="Submit" value="Log In">
        </font></b></font></b></font></b></font></b></font></td>
    </tr>
  </table>
  <p>&nbsp;</p>
  <p align="center"><font face="Courier New, Courier, mono"><b><font color="#000000" face="Arial, Helvetica, sans-serif">This 
    script is FREE to use, download, and distribute.</font></b></font></p>
  <p align="center"><font face="Courier New, Courier, mono"><b><a href="http://www.oakbox.com">http://www.oakbox.com</a> 
    </b></font></p>
</form>
<p>&nbsp;</p>


</body>
</html>
_END_

}



#########

# to make everything pretty, I feed output to the $message variable, then
# stick that variable into this shell. 

sub shellout {

print "Content-type: text/html\n\n";
print<<_RRR_;

<html>
<head>
<title>ThinMailer - oakbox.com</title>
$specialhead
<STYLE type="text/css">
     <!--
     A { text-decoration:none }
     -->
     </STYLE>
</head>

<body  bgcolor="#999999" text="#000000" link="#FFFFFF"  vlink="#FFFF33">
<p align="left"><b><font face="Arial, Helvetica, sans-serif" size="+3" color="#000000">T</font></b><font face="Arial, Helvetica, sans-serif" size="+3" color="#000000">hin<b>M</b>ailer</font><font face="Arial, Helvetica, sans-serif" size="+3">&nbsp;</font>&nbsp;&nbsp;<b>&nbsp;<a href="http://www.oakbox.com"><font face="Arial, Helvetica, sans-serif" size="-1">by 
  Richard Still http://www.oakbox.com</font></a></b><font face="Arial, Helvetica, sans-serif" size="-1">&nbsp;&nbsp;</font><font size="-1"><b></b></font></p>
<p>
<table bgcolor="#FFFFFF" border="1" width="90%">
  <tr><td>
<table width="100%" border="0" bgcolor="#666666">
  <tr valign="middle" align="center"> 
    <td> <font size="1"><b><font face="Verdana"><a href="thinmailer.cgi?action=compose">Compose 
      a new message</a> </font></b></font></td>
    <td> <font size="1"><b><font face="Verdana"><a href="thinmailer.cgi?action=listletters">Go 
      to/Refresh the Inbox</a></font></b></font></td>
    <td> <font size="1"><b><font face="Verdana"><a href="thinmailer.cgi?action=logout">Logout</a></font></b></font></td>
  </tr>
</table>

$message

</td></tr></table>
</body>
</html>

_RRR_

}