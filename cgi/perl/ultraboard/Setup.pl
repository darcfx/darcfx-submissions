#!/usr/bin/perl
###############################################################################
# Setup.pl                                                                    #
###############################################################################
# UltraBoard Ver. 1.62 by UltraScripts.com                                    #
# Scripts written by Jacky W.W. Yung, WebMaster@UltraScripts.com              #
# Available from http://www.UltraScripts.com/UltraBoard/                      #
# --------------------------------------------------------------------------- #
# PROGRAM NAME : UltraBoard                                                   #
# VERSION : 1.62                                                              #
# LAST MODIFIED : 29/07/1999                                                  #
# =========================================================================== #
# COPYRIGHT NOTICE :                                                          #
#                                                                             #
# Copyright (c) 1999 Jacky Yung. All Rights Reserved.                         #
#                                                                             #
# This program is free software; you can change or modify it as you see fit.  #
# However, modified versions cannot be sold or distributed.  You cannot alter #
# the copyright and "powered by" notices throughout the scripts. These        #
# notices must be clearly visible to the end users.                           #
#                                                                             #
# WARRANTY DISCLAIMER:                                                        #
#                                                                             #
# THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT WITHOUT #
# ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF MERCHANTABILITY OR       #
# FITNESS FOR A PARTICULAR PURPOSE.                                           #
###############################################################################

$Ext="pl";

# sometime server don't understand the path with . in front, 
# so change it to full path when you have error on creating admin
# profile data.

# the path of variables for ultraboard
$VarsPath   ="./Variables";

# the path of libraries sources codes for ultraboard
$LibPath    ="./Sources/Libraries";

# the path of admin sources codes for ultraboard
$UBAdminPath="./Sources/UBAdmin";

# the path of ultraboard sources codes for ultraboard
$UBPath     ="./Sources/UltraBoard";

###############################################################################
# code part
&ParseForm;

if      ($in{'Action'} eq "") {
    &AbsolutePaths();
}elsif  ($in{'Action'} eq "AbsolutePaths") {
    &AbsolutePaths();
}elsif  ($in{'Action'} eq "DoAbsolutePaths") {
    &DoAbsolutePaths();
}elsif  ($in{'Action'} eq "DoURLAddresses") {
    &DoURLAddresses();
}elsif  ($in{'Action'} eq "DoEmailOptions") {
    &DoEmailOptions();
}elsif  ($in{'Action'} eq "DoDateTimeOptions") {
    &DoDateTimeOptions();
}elsif  ($in{'Action'} eq "DoMiscellaneousOptions") {
    &DoMiscellaneousOptions();
}elsif  ($in{'Action'} eq "DoSaveSystemConfigurations") {
    &DoSaveSystemConfigurations();
}elsif  ($in{'Action'} eq "CreateAdminProfile") {
    &CreateAdminProfile();
}elsif  ($in{'Action'} eq "DoCreateAdminProfile") {
    &DoCreateAdminProfile();
}elsif  ($in{'Action'} eq "Conclusion") {
    &Conclusion();
}elsif  ($in{'Action'} eq "SelfDelete") {
    &SelfDelete();
}

###############################################################################
# Introduction                                                                #
###############################################################################
sub Introduction {
    print "Content-type: text/html\n\n";
    print<<HTML;
<html>
<body bgcolor="White" text="Black" leftmargin=0 topmargin=0>

</body>
</html>
HTML
}

###############################################################################
# AbsolutePaths                                                               #
###############################################################################
sub AbsolutePaths {

    # Finding UltraBoard Directory...
    $CGIPath=$ENV{'SCRIPT_FILENAME'};
    $CGIPath=~s/\/Setup.\S+$//isg;
    if ($Errors==0) {
        # Finding UltraBoard Directory...
        $in{'CGIPath'}=$CGIPath;
        
        # Finding Database, Stats, and Members Directory under UltraBoard Directory...
        opendir(CGIPath, $in{'CGIPath'});
            while($File=readdir(CGIPath)) {
                if (-d "$in{'CGIPath'}/$File") {
                    if      (-e "$in{'CGIPath'}/$File/Database.path") {
                        $in{'DBPath'}="$in{'CGIPath'}/$File";
                    }elsif  (-e "$in{'CGIPath'}/$File/Stats.path") {
                        $in{'StatsPath'}="$in{'CGIPath'}/$File";
                    }elsif  (-e "$in{'CGIPath'}/$File/Members.path") {
                        $in{'MembersPath'}="$in{'CGIPath'}/$File";
                    }elsif  (-e "$in{'CGIPath'}/$File/Sessions.path") {
                            $in{'SessionPath'}="$in{'CGIPath'}/$File";
                        }
                }
            }
        closedir(CGIPath);

        # Finding Stats, and Members Directory under Database Directory...
        if ($in{'DBPath'}) {
            opendir(DBPath, $in{'DBPath'});
                while($File=readdir(DBPath)) {
                    if (-d "$in{'DBPath'}/$File") {
                        if      (-e "$in{'DBPath'}/$File/Stats.path") {
                            $in{'StatsPath'}="$in{'DBPath'}/$File";
                        }elsif  (-e "$in{'DBPath'}/$File/Members.path") {
                            $in{'MembersPath'}="$in{'DBPath'}/$File";
                        }elsif  (-e "$in{'DBPath'}/$File/Sessions.path") {
                            $in{'SessionPath'}="$in{'DBPath'}/$File";
                        }
                    }
                }
            closedir(DBPath);
        }
        # Finding Variables, and Sources Directory under UltraBoard Directory...
        $in{'VarsPath'}       ="$in{'CGIPath'}/Variables"           if (-e "$in{'CGIPath'}/Variables");
        $in{'LibPath'}        ="$in{'CGIPath'}/Sources/Libraries"   if (-e "$in{'CGIPath'}/Sources/Libraries");
        $in{'UBAdminPath'}    ="$in{'CGIPath'}/Sources/UBAdmin"     if (-e "$in{'CGIPath'}/Sources/UBAdmin");
        $in{'UBPath'}         ="$in{'CGIPath'}/Sources/UltraBoard"  if (-e "$in{'CGIPath'}/Sources/UltraBoard");        
    }
    # Printing Absolute Paths Setup page...
    &Header();
    print "<form action=\"Setup.$Ext\" method=\"POST\">\n";
    print "<input type=\"Hidden\" name=\"Action\" value=\"DoAbsolutePaths\">\n";
    &ToolBar();
    print<<HTML;
<table width="100%" border="0" cellspacing="0" cellpadding="5">
	<tr>
		<td width="100%" valign="top">
			<font face="Verdana" size="4" color="#0033CC"><b>Absolute Paths</b></font>
		</td>
	</tr>
</table>
<center><img src="http://www.ultrascripts.com/UltraBoard/Remote/Black.gif" width=100% height=1 border=0 alt=""></center>
<table width="100%" border="0" cellspacing="0" cellpadding="5">
	<tr>
		<td width="100%" bgcolor="white" valign="top">
            <font face="Verdana" size="2" color="#0033CC"><b>CGI Path (required)</b></font><br>
			<font face="Verdana" size="1" color="Black">the absolute path of directory where the UltraBoard.$Ext and UBAdmin.$Ext are located. (e.g. "$CGIPath")</font><br>
            $Error{'CGIPath'}
			<input type="Text" name="CGIPath" value="$in{'CGIPath'}" size="60" style="width=100%" class="TextBox">
            <p>

			<font face="Verdana" size="2" color="#0033CC"><b>Database Path (required)</b></font><br>
			<font face="Verdana" size="1" color="Black">the absolute path of the directory where all the ultraboard data files will be located. (e.g. "$CGIPath/UBData")</font><br>
			$Error{'DBPath'}
			<input type="Text" name="DBPath" value="$in{'DBPath'}" size="60" style="width=100%" class="TextBox">
            <p>
			
			<font face="Verdana" size="2" color="#0033CC"><b>Members Path (required)</b></font><br>
			<font face="Verdana" size="1" color="Black">the absolute path of the directory where all the ultraboard members data files will be located. (e.g. "$CGIPath/UBData/Members")</font><br>
			$Error{'MembersPath'}
            <input type="Text" name="MembersPath" value="$in{'MembersPath'}" size="60" style="width=100%" class="TextBox">
			<p>

			<font face="Verdana" size="2" color="#0033CC"><b>Members Session Path (required)</b></font><br>
			<font face="Verdana" size="1" color="Black">the absolute path of the directory where all the ultraboard members session files will be located. (e.g. "$CGIPath/UBData/Sessions")</font><br>
			$Error{'SessionPath'}
            <input type="Text" name="SessionPath" value="$in{'SessionPath'}" size="60" style="width=100%" class="TextBox">
			<p>
			
			<font face="Verdana" size="2" color="#0033CC"><b>Stats Path (required)</b></font><br>
			<font face="Verdana" size="1" color="Black">the absolute path of directory that where all the ultraboard log and stats files will be located. (e.g. "$CGIPath/UBData/Stats")</font><br>
			$Error{'StatsPath'}
            <input type="Text" name="StatsPath" value="$in{'StatsPath'}" size="60" style="width=100%" class="TextBox">
		</td>
	</tr>
</table>
<center><img src="http://www.ultrascripts.com/UltraBoard/Remote/Black.gif" width=100% height=1 border=0 alt=""></center>
<table width="100%" border="0" cellspacing="0" cellpadding="5">
	<tr>
		<td width="100%" valign="top" align="right">
			<input type="Reset" value="Starting Over" style="background-color : 0033CC; color : FFFFFF; font-weight : bold; font-family : Verdana; font-size : 9pt;">
			<input type="Submit" value="Next Step >" style="background-color : 0033CC; color : FFFFFF; font-weight : bold; font-family : Verdana; font-size : 9pt;">
		</td>
	</tr>
</table>
HTML
    &Footer();
    exit;
}

###############################################################################
# DoAbsolutePaths                                                             #
###############################################################################
sub DoAbsolutePaths {

    # Verify Path
    chop ($in{'CGIPath'})       if ($in{'CGIPath'}=~/\/$/);
    chop ($in{'DBPath'})        if ($in{'DBPath'}=~/\/$/);
    chop ($in{'MembersPath'})   if ($in{'MembersPath'}=~/\/$/);
    chop ($in{'StatsPath'})     if ($in{'StatsPath'}=~/\/$/);
    
    %Error=();
    $Errors=0;
    $Errors++ , $Error{'CGIPath'}       ="<font face=\"Verdana\" size=\"1\" color=\"#FF3300\">error: couldn't find the cgi path</font><br>"                               unless (-e $in{'CGIPath'});
    $Errors++ , $Error{'DBPath'}        ="<font face=\"Verdana\" size=\"1\" color=\"#FF3300\">error: couldn't find the database path</font><br>"                          unless (-e $in{'DBPath'});
    $Errors++ , $Error{'MembersPath'}   ="<font face=\"Verdana\" size=\"1\" color=\"#FF3300\">error: couldn't find the members path</font><br>"                           unless (-e $in{'MembersPath'});
    $Errors++ , $Error{'SessionPath'}   ="<font face=\"Verdana\" size=\"1\" color=\"#FF3300\">error: couldn't find the session path</font><br>"                           unless (-e $in{'SessionPath'});
    $Errors++ , $Error{'StatsPath'}     ="<font face=\"Verdana\" size=\"1\" color=\"#FF3300\">error: couldn't find the stats path</font><br>"                             unless (-e $in{'StatsPath'});
    &AbsolutePaths() if ($Errors>0);
    &URLAddresses();   
}

###############################################################################
# URLAddresses                                                                #
###############################################################################
sub URLAddresses {
    if ($Errors==0) {
        # Finding URL of the site...
        $URLSite=$ENV{'HTTP_HOST'};
        $URLCGI =$ENV{'SCRIPT_NAME'};
        $URLCGI =~s/\/Setup.\S+$//isg;

        # Finding URL of the site...
        $in{'URLSite'}="http://".$URLSite;

        # Finding URL of the UltraBoard...   
        $in{'URLCGI'}="http://".$URLSite.$URLCGI;

        # Finding URL of the images...
        $in{'URLImages'}="$in{'URLSite'}$URLCGI/Images";
    }

    # Printing URL Addresses Setup page...
    &Header();
    print "<form action=\"Setup.$Ext\" method=\"POST\">\n";
    print "<input type=\"Hidden\" name=\"Action\" value=\"DoURLAddresses\">\n";

    # Absolute Paths Data
    print "<input type=\"Hidden\" name=\"CGIPath\" value=\"$in{'CGIPath'}\">\n";
    print "<input type=\"Hidden\" name=\"DBPath\" value=\"$in{'DBPath'}\">\n";
    print "<input type=\"Hidden\" name=\"MembersPath\" value=\"$in{'MembersPath'}\">\n";
    print "<input type=\"Hidden\" name=\"SessionPath\" value=\"$in{'SessionPath'}\">\n";
    print "<input type=\"Hidden\" name=\"StatsPath\" value=\"$in{'StatsPath'}\">\n";

    &ToolBar();
    print<<HTML;
<table width="100%" border="0" cellspacing="0" cellpadding="5">
	<tr>
		<td width="100%" valign="top">
			<font face="Verdana" size="4" color="#0033CC"><b>URL Addresses</b></font>
		</td>
	</tr>
</table>
<center><img src="http://www.ultrascripts.com/UltraBoard/Remote/Black.gif" width=100% height=1 border=0 alt=""></center>
<table width="100%" border="0" cellspacing="0" cellpadding="5">
	<tr>
		<td width="100%" bgcolor="white" valign="top">
            <font face="Verdana" size="2" color="#0033CC"><b>Site URL (required)</b></font><br>
			<font face="Verdana" size="1" color="Black">the url of your site. (e.g. "http://$URLSite")</font><br>
			<input type="Text" name="URLSite" value="$in{'URLSite'}" size="60" style="width=100%" class="TextBox">
            $Error{'URLSite'}
            <p>

			<font face="Verdana" size="2" color="#0033CC"><b>CGI URL (required)</b></font><br>
			<font face="Verdana" size="1" color="Black">the location where the UltraBoard.pl and UBAdmin.pl are located. (e.g. "http://$URLSite$URLCGI")</font><br>
			<input type="Text" name="URLCGI" value="$in{'URLCGI'}" size="60" style="width=100%" class="TextBox">
			$Error{'URLCGI'}    
            <p>
			
			<font face="Verdana" size="2" color="#0033CC"><b>Images URL (required)</b></font><br>
			<font face="Verdana" size="1" color="Black">the location where the UltraBoard images (*.gif) are located. (e.g. "http://$URLSite$URLCGI/Images")</font><br>
			<input type="Text" name="URLImages" value="$in{'URLImages'}" size="60" style="width=100%" class="TextBox">
            $Error{'URLImages'}
		</td>
	</tr>
</table>
<center><img src="http://www.ultrascripts.com/UltraBoard/Remote/Black.gif" width=100% height=1 border=0 alt=""></center>
<table width="100%" border="0" cellspacing="0" cellpadding="5">
	<tr>
		<td width="100%" valign="top" align="right">
			<input type="Reset" value="Starting Over" style="background-color : 0033CC; color : FFFFFF; font-weight : bold; font-family : Verdana; font-size : 9pt;">
			<input type="Submit" value="Next Step >" style="background-color : 0033CC; color : FFFFFF; font-weight : bold; font-family : Verdana; font-size : 9pt;">
		</td>
	</tr>
</table>
HTML
    &Footer();
    exit;
}

###############################################################################
# DoURLAddresses                                                              #
###############################################################################
sub DoURLAddresses {

    # Verify Path
    chop ($in{'URLSite'})   if ($in{'URLSite'}=~/\/$/);
    chop ($in{'URLCGI'})    if ($in{'URLCGI'}=~/\/$/);
    chop ($in{'URLImages'}) if ($in{'MembersPath'}=~/\/$/);

    %Error=();
    $Errors=0;
    $Errors++ , $Error{'URLSite'}   ="<font face=\"Verdana\" size=\"1\" color=\"#FF3300\">error: you forgot to fill out your site url</font><br>"           if (($in{'URLSite'} =~/^http:\/\/\s+$/)||(!$in{'URLSite'}));
    $Errors++ , $Error{'URLCGI'}    ="<font face=\"Verdana\" size=\"1\" color=\"#FF3300\">error: you forgot to fill out the ultraboard url </font><br>"     if (($in{'URLCGI'} =~/^http:\/\/\s+$/)||(!$in{'URLCGI'}));
    $Errors++ , $Error{'URLImages'} ="<font face=\"Verdana\" size=\"1\" color=\"#FF3300\">error: you forgot to fill out the ultraboard images url</font><br>" if (($in{'URLImages'} =~/^http:\/\/\s+$/)||(!$in{'URLImages'}));
    &URLAddresses() if ($Errors>0);

    $in{'URLSite'}  ="http://".$in{'URLSite'}   unless ($in{'URLSite'}=~/^http:\/\//);
    $in{'URLCGI'}   ="http://".$in{'URLCGI'}    unless ($in{'URLCGI'}=~/^http:\/\//);
    $in{'URLImages'}="http://".$in{'URLImages'} unless ($in{'URLImages'}=~/^http:\/\//);

    &EmailOptions();   
}

###############################################################################
# EmailOptions                                                                #
###############################################################################
sub EmailOptions {

    # Finding Email Address...
    $EmailAddress=$ENV{'SERVER_ADMIN'};
    
    # Finding SendMail Location...
    if (-e "/usr/lib/sendmail") {
        $SendMailLocation="/usr/lib/sendmail";
    }elsif (-e "/usr/bin/sendmail") {
        $SendMailLocation="/usr/bin/sendmail";
    }elsif (-e "/var/qmail/bin/qmail-inject") {
        $SendMailLocation="/var/qmail/bin/qmail-inject";
    }elsif (-e "/usr/sbin/sendmail") {
        $SendMailLocation="/usr/sbin/sendmail";
    }

    # Finding SendMail Method...
    if ($in{'EmailFunction'} eq "") {
        $EmailFunction="checked";
    }elsif ($in{'EmailFunction'} eq "SendMail") {
        $EmailFunction_SendMail="checked";
    }elsif ($in{'EmailFunction'} eq "SMTP") {
        $EmailFunction_SMTP="checked";
    }

    # Finding SMTP Server Address...
    if ($EmailAddress) {
        $SMTPAddress=$EmailAddress;
        $SMTPAddress=s/^\S+\@//isg;
    }

    if ($Errors==0) {

        # Finding Email Address...
        $in{'EmailAddress'}=$EmailAddress;

        # Finding SendMail Location...
        $in{'SendMailLocation'}=$SendMailLocation;
        if ($in{'SendMailLocation'}) {
            $EmailFunction="";
            $EmailFunction_SendMail="checked";
            $EmailFunction_SMTP="";
        }
        
    }

    # Replace to default value of $EmailAddress
    $EmailAddress="webmaster\@yourdomain.com" unless ($EmailAddress);

    # Replace to default value of $SMTPAddress
    $SMTPAddress="yourdomain.com" unless ($SMTPAddress);

    # Replace to default value of $SendMailLocation
    $SendMailLocation="/usr/bin/sendmail" unless ($SendMailLocation);

    # Printing Email Options Setup page...
    &Header();
    print "<form action=\"Setup.$Ext\" method=\"POST\">\n";
    print "<input type=\"Hidden\" name=\"Action\" value=\"DoEmailOptions\">\n";

    # Absolute Paths Data
    print "<input type=\"Hidden\" name=\"CGIPath\" value=\"$in{'CGIPath'}\">\n";
    print "<input type=\"Hidden\" name=\"DBPath\" value=\"$in{'DBPath'}\">\n";
    print "<input type=\"Hidden\" name=\"MembersPath\" value=\"$in{'MembersPath'}\">\n";
    print "<input type=\"Hidden\" name=\"SessionPath\" value=\"$in{'SessionPath'}\">\n";
    print "<input type=\"Hidden\" name=\"StatsPath\" value=\"$in{'StatsPath'}\">\n";

    # URL Addresses Data
    print "<input type=\"Hidden\" name=\"URLSite\" value=\"$in{'URLSite'}\">\n";
    print "<input type=\"Hidden\" name=\"URLCGI\" value=\"$in{'URLCGI'}\">\n";
    print "<input type=\"Hidden\" name=\"URLImages\" value=\"$in{'URLImages'}\">\n";

    &ToolBar();
    print<<HTML;
<table width="100%" border="0" cellspacing="0" cellpadding="5">
	<tr>
		<td width="100%" valign="top">
			<font face="Verdana" size="4" color="#0033CC"><b>Email Options</b></font>
		</td>
	</tr>
</table>
<center><img src="http://www.ultrascripts.com/UltraBoard/Remote/Black.gif" width=100% height=1 border=0 alt=""></center>
<table width="100%" border="0" cellspacing="0" cellpadding="5">
	<tr>
		<td width="100%" bgcolor="white" valign="top">
			<font face="Verdana" size="2" color="#0033CC"><b>Email Address (required)</b></font><br>
			<font face="Verdana" size="1" color="Black">your e-mail address. (e.g. "$EmailAddress")</font><br>
            $Error{'EmailAddress'}
			<input type="Text" name="EmailAddress" value="$in{'EmailAddress'}" size="60" style="width=100%" class="TextBox">
			<p>
			
			<font face="Verdana" size="2" color="#0033CC"><b>Mail Function</b></font><br>
			<font face="Verdana" size="1" color="Black">choose the type of method UltraBoard should send mail by. if you don't want to allow UltraBoard to send mail function just choose "don't use.".</font><br>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="20"><input type="Radio" name="EmailFunction" value="" $EmailFunction></td>
					<td width="100%"><font face="Verdana" size="2" color="#0033CC"><b>Don't use.</b></font></td>
				</tr>
				<tr>
					<td width="20"><input type="Radio" name="EmailFunction" value="SendMail" $EmailFunction_SendMail></td>
					<td width="100%"><font face="Verdana" size="2" color="#0033CC"><b>Use SendMail.</b></font></td>
				</tr>
				<tr>
					<td width="20">&nbsp;</td>
					<td width="100%">
						&nbsp;<br>
						<font face="Verdana" size="2" color="#0033CC"><b>SendMail Location</b></font><br>
						<font face="Verdana" size="1" color="Black">if you choose to use the sendmail program, please fill in the location of the sendmail program on your server. (e.g. "$SendMailLocation")</font><br>
						$Error{'SendMailLocation'}
                        <input type="Text" name="SendMailLocation" value="$in{'SendMailLocation'}" size="60" style="width=100%" class="TextBox"><p>
					</td>
				</tr>
				<tr>
					<td width="20"><input type="Radio" name="EmailFunction" value="SMTP" $EmailFunction_SMTP></td>
					<td width="100%"><font face="Verdana" size="2" color="#0033CC"><b>Use SMTP.</b></font></td>
				</tr>
				<tr>
					<td width="20">&nbsp;</td>
					<td width="100%">
						&nbsp;<br>
						<font face="Verdana" size="2" color="#0033CC"><b>SMTP Server Address</b></font><br>
						<font face="Verdana" size="1" color="Black">if you choose to use your smtp server, please fill in the address of your smtp server. (e.g. "smtp.$SMTPAddress")</font><br>
						$Error{'SMTPAddress'}
                        <input type="Text" name="SMTPAddress" value="" size="60" style="width=100%" class="TextBox">
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<center><img src="http://www.ultrascripts.com/UltraBoard/Remote/Black.gif" width=100% height=1 border=0 alt=""></center>
<table width="100%" border="0" cellspacing="0" cellpadding="5">
	<tr>
		<td width="100%" valign="top" align="right">
			<input type="Reset" value="Starting Over" style="background-color : 0033CC; color : FFFFFF; font-weight : bold; font-family : Verdana; font-size : 9pt;">
			<input type="Submit" value="Next Step >" style="background-color : 0033CC; color : FFFFFF; font-weight : bold; font-family : Verdana; font-size : 9pt;">
		</td>
	</tr>
</table>
HTML
    &Footer();
    exit;
}

###############################################################################
# DoEmailOptions                                                              #
###############################################################################
sub DoEmailOptions {
    # Verify Path
    chop ($in{'SendMailLocation'})       if ($in{'SendMailLocation'}=~/\/$/);

    %Error=();
    $Errors=0;
    $Errors++ , $Error{'EmailAddress'}      ="<font face=\"Verdana\" size=\"1\" color=\"#FF3300\">error: you forgot to fill out your email address</font><br>"      if (!$in{'EmailAddress'});
    $Errors++ , $Error{'EmailAddress'}      ="<font face=\"Verdana\" size=\"1\" color=\"#FF3300\">error: invaild format of the email address</font><br>"            if ((($in{'EmailAddress'}!~/.*\@.*\..*/)||($in{'EmailAddress'}=~/[\!\#\$\%\^\&\*\(\)\{\}\;\:\'\`]/))&&($in{'EmailAddress'}));
    $Errors++ , $Error{'SendMailLocation'}  ="<font face=\"Verdana\" size=\"1\" color=\"#FF3300\">error: you forgot to fill out the sendmail location</font><br>"   if ((!$in{'SendMailLocation'})&&($in{'EmailFunction'} eq "SendMail"));
    $Errors++ , $Error{'SendMailLocation'}  ="<font face=\"Verdana\" size=\"1\" color=\"#FF3300\">error: couldn't find the sendmail location</font><br>"            if (!((-e $in{'SendMailLocation'}))&&($in{'EmailFunction'} eq "SendMail")&&($in{'SendMailLocation'}));
    $Errors++ , $Error{'SMTPAddress'}       ="<font face=\"Verdana\" size=\"1\" color=\"#FF3300\">error: you forgot to fill out the smtp address</font><br>"        if ((!$in{'SMTPAddress'})&&($in{'EmailFunction'} eq "SMTP"));
    &EmailOptions() if ($Errors>0);

    $in{'EmailAddress'} =&ChangesChars($in{'EmailAddress'});

    &DateTimeOptions();   
}

###############################################################################
# DateTimeOptions                                                             #
###############################################################################
sub DateTimeOptions {
    # Finding Time Zone of the server...
    $TimeZoneName=$ENV{'TZ'};

    if (!$Errors) {
        # Finding Time Zone of the server...
        $in{'TimeZoneName'}=$TimeZoneName;

        # Replace to default value of $GMTOffset
        $in{'GMTOffset'}=0;
        
        $DateFormat{'US'}=" checked";
        $TimeFormat{'24'}=" checked";
    }else{
        $DateFormat{$in{'DateFormat'}}=" checked";
        $TimeFormat{$in{'TimeFormat'}}=" checked";
    }

    # Replace to default value of $TimeZoneName
    $TimeZoneName="GMT" unless ($TimeZoneName);

    # Printing Email Options Setup page...
    &Header();
    print "<form action=\"Setup.$Ext\" method=\"POST\">\n";
    print "<input type=\"Hidden\" name=\"Action\" value=\"DoDateTimeOptions\">\n";

    # Absolute Paths Data
    print "<input type=\"Hidden\" name=\"CGIPath\" value=\"$in{'CGIPath'}\">\n";
    print "<input type=\"Hidden\" name=\"DBPath\" value=\"$in{'DBPath'}\">\n";
    print "<input type=\"Hidden\" name=\"MembersPath\" value=\"$in{'MembersPath'}\">\n";
    print "<input type=\"Hidden\" name=\"SessionPath\" value=\"$in{'SessionPath'}\">\n";
    print "<input type=\"Hidden\" name=\"StatsPath\" value=\"$in{'StatsPath'}\">\n";

    # URL Addresses Data
    print "<input type=\"Hidden\" name=\"URLSite\" value=\"$in{'URLSite'}\">\n";
    print "<input type=\"Hidden\" name=\"URLCGI\" value=\"$in{'URLCGI'}\">\n";
    print "<input type=\"Hidden\" name=\"URLImages\" value=\"$in{'URLImages'}\">\n";

    # Email Options Data
    print "<input type=\"Hidden\" name=\"EmailAddress\" value=\"$in{'EmailAddress'}\">\n";
    print "<input type=\"Hidden\" name=\"EmailFunction\" value=\"$in{'EmailFunction'}\">\n";
    print "<input type=\"Hidden\" name=\"SendMailLocation\" value=\"$in{'SendMailLocation'}\">\n";
    print "<input type=\"Hidden\" name=\"SMTPAddress\" value=\"$in{'SMTPAddress'}\">\n";

    &ToolBar();
    print<<HTML;
<table width="100%" border="0" cellspacing="0" cellpadding="5">
	<tr>
		<td width="100%" valign="top">
			<font face="Verdana" size="4" color="#0033CC"><b>Date/Time Options</b></font>
		</td>
	</tr>
</table>
<center><img src="http://www.ultrascripts.com/UltraBoard/Remote/Black.gif" width=100% height=1 border=0 alt=""></center>
<table width="100%" border="0" cellspacing="0" cellpadding="5">
	<tr>
		<td width="100%" bgcolor="white" valign="top">
			<font face="Verdana" size="2" color="#0033CC"><b>Time Zone Name</b></font><br>
			<font face="Verdana" size="1" color="Black">the time zone of your area. (e.g. "$TimeZoneName")</font><br>
			<input type="Text" name="TimeZoneName" value="$in{'TimeZoneName'}" size="60" style="width=100%" class="TextBox">
			<p>
			
			<font face="Verdana" size="2" color="#0033CC"><b>GMT Time Zone Offset</b></font><br>
			<font face="Verdana" size="1" color="Black">the time different between your area and greenwhich mean time. (e.g. "-5" if you live in new york.)</font><br>
			<input type="Text" name="GMTOffset" value="$in{'GMTOffset'}" size="60" style="width=100%" class="TextBox">
			<p>
			
			<font face="Verdana" size="2" color="#0033CC"><b>Date Format</b></font><br>
			<font face="Verdana" size="1" color="Black">select the date format you prefer.</font><br>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="20"><input type="Radio" name="DateFormat" value="US"$DateFormat{'US'}></td>
					<td width="100%"><font face="Verdana" size="2" color="Black">US Format (MM-DD-YYYY)</font></td>
				</tr>
				<tr>
					<td width="20"><input type="Radio" name="DateFormat" value="USE"$DateFormat{'USE'}></td>
					<td width="100%"><font face="Verdana" size="2" color="Black">Expanded US Format (Month DD, YYYY)</font></td>
				</tr>
				<tr>
					<td width="20"><input type="Radio" name="DateFormat" value="EU"$DateFormat{'EU'}></td>
					<td width="100%"><font face="Verdana" size="2" color="Black">European Format (DD-MM-YYYY)</font></td>
				</tr>
				<tr>
					<td width="20"><input type="Radio" name="DateFormat" value="EUE"$DateFormat{'EUE'}></td>
					<td width="100%"><font face="Verdana" size="2" color="Black">Expanded European Format (DD Month, YYYY)</font></td>
				</tr>
			</table>
			<p>
			
			<font face="Verdana" size="2" color="#0033CC"><b>Time Format</b></font><br>
			<font face="Verdana" size="1" color="Black">select the time format you prefer.</font><br>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="20"><input type="Radio" name="TimeFormat" value="12"$TimeFormat{'12'}></td>
					<td width="100%"><font face="Verdana" size="2" color="Black">AM/PM Time Format</font></td>
				</tr>
				<tr>
					<td width="20"><input type="Radio" name="TimeFormat" value="24"$TimeFormat{'24'}></td>
					<td width="100%"><font face="Verdana" size="2" color="Black">24 Hour Time Format</font></td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<center><img src="http://www.ultrascripts.com/UltraBoard/Remote/Black.gif" width=100% height=1 border=0 alt=""></center>
<table width="100%" border="0" cellspacing="0" cellpadding="5">
	<tr>
		<td width="100%" valign="top" align="right">
			<input type="Reset" value="Starting Over" style="background-color : 0033CC; color : FFFFFF; font-weight : bold; font-family : Verdana; font-size : 9pt;">
			<input type="Submit" value="Next Step >" style="background-color : 0033CC; color : FFFFFF; font-weight : bold; font-family : Verdana; font-size : 9pt;">
		</td>
	</tr>
</table>
HTML
    &Footer();
    exit;
}

###############################################################################
# DoDateTimeOptions                                                           #
###############################################################################
sub DoDateTimeOptions {
    # Verify Variables
    $in{'TimeZoneName'} =&ChangesChars($in{'TimeZoneName'});
    $in{'GMTOffset'}    ="0" unless ($in{'GMTOffset'}); 

    &MiscellaneousOptions();   
}

###############################################################################
# MiscellaneousOptions                                                        #
###############################################################################
sub MiscellaneousOptions {
    
    if (!$Errors) {
        $CloseUB                =" checked";
        $in{'ClosedMessage'}    ="Sorry, I am installing the UltraBoard 1.62, please check it out later. Thank you !!";
        $FLock                  =" checked";
        $UseStats               =" checked";
        $UseLog                 =" checked";
        $in{'MaxActionLog'}     ="200";
        $in{'MaxVisitorLog'}    ="200";
        $in{'CleanUpTime'}      = "14400";
    }else{
        $CloseUB                =" checked" if ($in{'CloseUB'});
        $FLock                  =" checked" if ($in{'FLock'});
        $UseStats               =" checked" if ($in{'UseStats'});
        $UseLog                 =" checked" if ($in{'UseLog'});
    }

    # Printing Miscellaneous Options Setup page...
    &Header();
    print "<form action=\"Setup.$Ext\" method=\"POST\">\n";
    print "<input type=\"Hidden\" name=\"Action\" value=\"DoMiscellaneousOptions\">\n";

    # Absolute Paths Data
    print "<input type=\"Hidden\" name=\"CGIPath\" value=\"$in{'CGIPath'}\">\n";
    print "<input type=\"Hidden\" name=\"DBPath\" value=\"$in{'DBPath'}\">\n";
    print "<input type=\"Hidden\" name=\"MembersPath\" value=\"$in{'MembersPath'}\">\n";
    print "<input type=\"Hidden\" name=\"SessionPath\" value=\"$in{'SessionPath'}\">\n";
    print "<input type=\"Hidden\" name=\"StatsPath\" value=\"$in{'StatsPath'}\">\n";

    # URL Addresses Data
    print "<input type=\"Hidden\" name=\"URLSite\" value=\"$in{'URLSite'}\">\n";
    print "<input type=\"Hidden\" name=\"URLCGI\" value=\"$in{'URLCGI'}\">\n";
    print "<input type=\"Hidden\" name=\"URLImages\" value=\"$in{'URLImages'}\">\n";

    # Email Options Data
    print "<input type=\"Hidden\" name=\"EmailAddress\" value=\"$in{'EmailAddress'}\">\n";
    print "<input type=\"Hidden\" name=\"EmailFunction\" value=\"$in{'EmailFunction'}\">\n";
    print "<input type=\"Hidden\" name=\"SendMailLocation\" value=\"$in{'SendMailLocation'}\">\n";
    print "<input type=\"Hidden\" name=\"SMTPAddress\" value=\"$in{'SMTPAddress'}\">\n";

    # Date/Time Options Data
    print "<input type=\"Hidden\" name=\"TimeZoneName\" value=\"$in{'TimeZoneName'}\">\n";
    print "<input type=\"Hidden\" name=\"GMTOffset\" value=\"$in{'GMTOffset'}\">\n";
    print "<input type=\"Hidden\" name=\"DateFormat\" value=\"$in{'DateFormat'}\">\n";
    print "<input type=\"Hidden\" name=\"TimeFormat\" value=\"$in{'TimeFormat'}\">\n";

    &ToolBar();
    print<<HTML;
<table width="100%" border="0" cellspacing="0" cellpadding="5">
	<tr>
		<td width="100%" valign="top">
			<font face="Verdana" size="4" color="#0033CC"><b>Miscellaneous Options</b></font>
		</td>
	</tr>
</table>
<center><img src="http://www.ultrascripts.com/UltraBoard/Remote/Black.gif" width=100% height=1 border=0 alt=""></center>
<table width="100%" border="0" cellspacing="0" cellpadding="5">
	<tr>
		<td width="100%" bgcolor="white" valign="top">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="20"><input type="Checkbox" name="CloseUB" value="on"$CloseUB></td>
					<td width="100%">
						<font face="Verdana" size="2" color="#0033CC"><b>Close the UltraBoard a While</b></font><br>
						<font face="Verdana" size="1" color="Black">if you want to close your board a while for upgrade or...</font><br>
                        $Error{'CloseUB'}
					</td>
				</tr>
				<tr>
					<td width="20">&nbsp;</td>
					<td width="100%">
						&nbsp;<br>
						<font face="Verdana" size="2" color="#0033CC"><b>Close UltraBoard Message</b></font><br>
						<font face="Verdana" size="1" color="Black">this message will appear while the board is closed.</font><br>
						<textarea name="ClosedMessage" cols="60" rows="3" wrap="VIRTUAL" style="width=100%" class="TextArea">$in{'ClosedMessage'}</textarea>
					</td>
				</tr>
			</table>
			<p>
			
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="20"><input type="Checkbox" name="FLock" value="on"$FLock></td>
					<td width="100%">
						<font face="Verdana" size="2" color="#0033CC"><b>Use File Lock Function</b></font><br>
						<font face="Verdana" size="1" color="Black">if your server supports the flock() function, I suggest you to use this. otherwise the board can become corrupted when some people post an the same time.</font><br>
					</td>
				</tr>
			</table>
			<p>

			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="20"><input type="Checkbox" name="UseStats" value="on"$UseStats></td>
					<td width="100%">
						<font face="Verdana" size="2" color="#0033CC"><b>Use Stats Feature</b></font><br>
						<font face="Verdana" size="1" color="Black">if you want to know how many people access your board hourly, daily and monthly, use this option.</font><br>
					</td>
				</tr>
			</table>
			<p>
			
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="20"><input type="Checkbox" name="UseLog" value="on"$UseLog></td>
					<td width="100%">
						<font face="Verdana" size="2" color="#0033CC"><b>Track all the Log Information</b></font><br>
						<font face="Verdana" size="1" color="Black">if you want to log all users who access your board, use this option.</font><br>
                        $Error{'UseLog'}
					</td>
				</tr>
				<tr>
					<td width="20">&nbsp;</td>
					<td width="100%">
						&nbsp;<br>
						<font face="Verdana" size="2" color="#0033CC"><b>Maximum Number of Action Log Informations</b></font><br>
						<font face="Verdana" size="1" color="Black">how many lines of action information do you want to keep track of?</font><br>
						<input type="Text" name="MaxActionLog" value="$in{'MaxActionLog'}" size="60" maxlength="4" style="width=100%" class="TextBox"><p>
					</td>
				</tr>
				<tr>
					<td width="20">&nbsp;</td>
					<td width="100%">
						<font face="Verdana" size="2" color="#0033CC"><b>Maximum Number of Visitor Log Informations</b></font><br>
						<font face="Verdana" size="1" color="Black">how many visitors (if the number of visitors exceeds this number, older ones will be deleted) do you want to keep track of?</font><br>
						<input type="Text" name="MaxVisitorLog" value="$in{'MaxVisitorLog'}" size="60" maxlength="4" style="width=100%" class="TextBox">
					</td>
				</tr>
			</table>
			<p>

			<font face="Verdana" size="2" color="#0033CC"><b>Clean Up Time</b></font><br>
			<font face="Verdana" size="1" color="Black">every how many second of time clean the members session files once?</font><br>
			<input type="Text" name="CleanUpTime" value="$in{'CleanUpTime'}" size="60" maxlength="9" style="width=100%" class="TextBox">
			<p>

			<font face="Verdana" size="2" color="#0033CC"><b>IP Addresses Ban List</b></font><br>
			<font face="Verdana" size="1" color="Black">list all of the ip addresses that you want to ban from your board. use a space to seperate each ip address. (also, to ban a specfic range, say 128.64, just type "128.64")</font><br>
			<textarea name="IPBanList" cols="60" rows="3" wrap="VIRTUAL" style="width=100%" class="TextArea">$in{'IPBanList'}</textarea>
			<p>
			
			<font face="Verdana" size="2" color="#0033CC"><b>Host Addresses Ban List</b></font><br>
			<font face="Verdana" size="1" color="Black">list all of the host addresses that you want to ban from your board. use a space to seperate every host address (e.g. if you want to ban ban.net, just type "ban.net")</font><br>
			<textarea name="HostBanList" cols="60" rows="3" wrap="VIRTUAL" style="width=100%" class="TextArea">$in{'HostBanList'}</textarea>
		</td>
	</tr>
</table>
<center><img src="http://www.ultrascripts.com/UltraBoard/Remote/Black.gif" width=100% height=1 border=0 alt=""></center>
<table width="100%" border="0" cellspacing="0" cellpadding="5">
	<tr>
		<td width="100%" valign="top" align="right">
			<input type="Reset" value="Starting Over" style="background-color : 0033CC; color : FFFFFF; font-weight : bold; font-family : Verdana; font-size : 9pt;">
			<input type="Submit" value="Next Step >" style="background-color : 0033CC; color : FFFFFF; font-weight : bold; font-family : Verdana; font-size : 9pt;">
		</td>
	</tr>
</table>
HTML
    &Footer();
    exit;
}
    
###############################################################################
# DoMiscellaneousOptions                                                      #
###############################################################################
sub DoMiscellaneousOptions {
    %Error=();
    $Errors=0;
    $Errors++ , $Error{'CloseUB'}   ="<font face=\"Verdana\" size=\"1\" color=\"#FF3300\">error: you forgot to fill out the close message</font><br>"   if (!$in{'ClosedMessage'});
    $Errors++ , $Error{'UseLog'}    ="<font face=\"Verdana\" size=\"1\" color=\"#FF3300\">error: you forgot to fill out the maximun number of action/visitor log information</font><br>"    if ((!$in{'MaxActionLog'})||(!$in{'MaxVisitorLog'}));
    $Errors++ , $Error{'CleanUpTime'}   ="<font face=\"Verdana\" size=\"1\" color=\"#FF3300\">error: you forgot to fill out the clean up time</font><br>"    if (!$in{'CleanUpTime'});
    &MiscellaneousOptions() if ($Errors>0);

    # Verify Variables
    $in{'ClosedMessage'}    =&ChangesChars($in{'ClosedMessage'});
    $in{'IPBanList'}        =&ChangesChars($in{'IPBanList'});
    $in{'HostBanList'}      =&ChangesChars($in{'HostBanList'});
    $in{'CleanUpTime'}=3600 if ($in{'CleanUpTime'}<3600);
    &CheckList();
}

###############################################################################
# CheckList                                                                   #
###############################################################################
sub CheckList {
    $tmpCGIPath     =$in{'CGIPath'};
    $tmpDBPath      =$in{'DBPath'};
    $tmpMembersPath =$in{'MembersPath'};
    $tmpStatsPath   =$in{'StatsPath'};
    $tmpVarsPath    =$VarsPath;
    $tmpLibPath     =$LibPath;
    $tmpUBAdminPath =$UBAdminPath;
    $tmpUBPath      =$UBPath;

    $tmpVarsPath    =~s/^\./$in{'CGIPath'}/isg;
    $tmpLibPath     =~s/^\./$in{'CGIPath'}/isg;
    $tmpUBAdminPath =~s/^\./$in{'CGIPath'}/isg;
    $tmpUBPath      =~s/^\./$in{'CGIPath'}/isg;

    @Directories = (
        [$tmpCGIPath,       "755"],
        [$tmpDBPath,        "777"],
        [$tmpMembersPath,   "777"],
        [$in{'SessionPath'},"777"],
        [$tmpStatsPath,     "777"],
        [$tmpVarsPath,      "666"],
        [$tmpLibPath,       "755"],
        [$tmpUBAdminPath,   "755"],
        [$tmpUBPath,        "755"]
    );
    @Files = (
        ["UltraBoard.$Ext",             $in{'CGIPath'}, "755", "ascii"],
        ["UBAdmin.$Ext",                $in{'CGIPath'}, "755", "ascii"],

        ["Common.lib",                  $LibPath, "755", "ascii"],
        ["Crypt.pm",                    $LibPath, "755", "ascii"],
        ["HTML.lib",                    $LibPath, "755", "ascii"],
        ["SearchAccounts.lib",          $LibPath, "755", "ascii"],
        ["SearchMessages.lib",          $LibPath, "755", "ascii"],
        ["SearchPostID.lib",            $LibPath, "755", "ascii"],
        ["Sender.pm",                   $LibPath, "755", "ascii"],
        ["Stats.lib",                   $LibPath, "755", "ascii"],
        ["UBAdmin.lib",                 $LibPath, "755", "ascii"],
        ["UltraBoard.lib",              $LibPath, "755", "ascii"],

        ["AdminActivateAccounts.pl",    $UBAdminPath, "755", "ascii"],
        ["AdminCfgGeneral.pl",          $UBAdminPath, "755", "ascii"],
        ["AdminCfgStyle.pl",            $UBAdminPath, "755", "ascii"],
        ["AdminCfgSystem.pl",           $UBAdminPath, "755", "ascii"],
        ["AdminCloseThreads.pl",        $UBAdminPath, "755", "ascii"],
        ["AdminCreateAccount.pl",       $UBAdminPath, "755", "ascii"],
        ["AdminCreateBoard.pl",         $UBAdminPath, "755", "ascii"],
        ["AdminCreateCategory.pl",      $UBAdminPath, "755", "ascii"],
        ["AdminCreateGroup.pl",         $UBAdminPath, "755", "ascii"],
        ["AdminDoActivateAccounts.pl",  $UBAdminPath, "755", "ascii"],
        ["AdminDoApproveAccounts.pl",   $UBAdminPath, "755", "ascii"],
        ["AdminDoCfgGeneral.pl",        $UBAdminPath, "755", "ascii"],
        ["AdminDoCfgStyle.pl",          $UBAdminPath, "755", "ascii"],
        ["AdminDoCfgSystem.pl",         $UBAdminPath, "755", "ascii"],
        ["AdminDoCloseThreads.pl",      $UBAdminPath, "755", "ascii"],
        ["AdminDoCreateAccount.pl",     $UBAdminPath, "755", "ascii"],
        ["AdminDoCreateBoard.pl",       $UBAdminPath, "755", "ascii"],
        ["AdminDoCreateCategory.pl",    $UBAdminPath, "755", "ascii"],
        ["AdminDoCreateGroup.pl",       $UBAdminPath, "755", "ascii"],
        ["AdminDoEmailMembers.pl",      $UBAdminPath, "755", "ascii"],
        ["AdminDoModifyAccount.pl",     $UBAdminPath, "755", "ascii"],
        ["AdminDoModifyAccount2.pl",    $UBAdminPath, "755", "ascii"],
        ["AdminDoModifyBoard.pl",       $UBAdminPath, "755", "ascii"],
        ["AdminDoModifyBoard2.pl",      $UBAdminPath, "755", "ascii"],
        ["AdminDoModifyCategory.pl",    $UBAdminPath, "755", "ascii"],
        ["AdminDoModifyCategory2.pl",   $UBAdminPath, "755", "ascii"],
        ["AdminDoModifyGroup.pl",       $UBAdminPath, "755", "ascii"],
        ["AdminDoModifyGroup2.pl",      $UBAdminPath, "755", "ascii"],
        ["AdminDoModifyProfile.pl",     $UBAdminPath, "755", "ascii"],
        ["AdminDoModifyThread.pl",      $UBAdminPath, "755", "ascii"],
        ["AdminDoModifyThread2.pl",     $UBAdminPath, "755", "ascii"],
        ["AdminDoMoveAccounts.pl",      $UBAdminPath, "755", "ascii"],
        ["AdminDoMoveThreads.pl",       $UBAdminPath, "755", "ascii"],
        ["AdminDoNewPost.pl",           $UBAdminPath, "755", "ascii"],
        ["AdminDoReOrderBoards.pl",     $UBAdminPath, "755", "ascii"],
        ["AdminDoReOrderCategories.pl", $UBAdminPath, "755", "ascii"],
        ["AdminDoRemoveAccounts.pl",    $UBAdminPath, "755", "ascii"],
        ["AdminDoRemoveBoards.pl",      $UBAdminPath, "755", "ascii"],
        ["AdminDoRemoveCategories.pl",  $UBAdminPath, "755", "ascii"],
        ["AdminDoRemoveGroups.pl",      $UBAdminPath, "755", "ascii"],
        ["AdminDoRemoveThreads.pl",     $UBAdminPath, "755", "ascii"],
        ["AdminEmailMembers.pl",        $UBAdminPath, "755", "ascii"],
        ["AdminMain.pl",                $UBAdminPath, "755", "ascii"],
        ["AdminManageAccounts.pl",      $UBAdminPath, "755", "ascii"],
        ["AdminManageMessages.pl",      $UBAdminPath, "755", "ascii"],
        ["AdminModifyAccount.pl",       $UBAdminPath, "755", "ascii"],
        ["AdminModifyBoard.pl",         $UBAdminPath, "755", "ascii"],
        ["AdminModifyCategory.pl",      $UBAdminPath, "755", "ascii"],
        ["AdminModifyGroup.pl",         $UBAdminPath, "755", "ascii"],
        ["AdminModifyProfile.pl",       $UBAdminPath, "755", "ascii"],
        ["AdminModifyThread.pl",        $UBAdminPath, "755", "ascii"],
        ["AdminMoveAccounts.pl",        $UBAdminPath, "755", "ascii"],
        ["AdminMoveThreads.pl",         $UBAdminPath, "755", "ascii"],
        ["AdminNewPost.pl",             $UBAdminPath, "755", "ascii"],
        ["AdminReOrderBoards.pl",       $UBAdminPath, "755", "ascii"],
        ["AdminReOrderCategories.pl",   $UBAdminPath, "755", "ascii"],
        ["AdminRemoveAccounts.pl",      $UBAdminPath, "755", "ascii"],
        ["AdminRemoveBoards.pl",        $UBAdminPath, "755", "ascii"],
        ["AdminRemoveCategories.pl",    $UBAdminPath, "755", "ascii"],
        ["AdminRemoveGroups.pl",        $UBAdminPath, "755", "ascii"],
        ["AdminRemoveThreads.pl",       $UBAdminPath, "755", "ascii"],
        ["AdminShowStats.pl",           $UBAdminPath, "755", "ascii"],

        ["DoCloseThread.pl",            $UBPath, "755", "ascii"],
        ["DoForwardTopic.pl",           $UBPath, "755", "ascii"],
        ["DoLostPassword.pl",           $UBPath, "755", "ascii"],
        ["DoModifyAccount.pl",          $UBPath, "755", "ascii"],
        ["DoModifyPost.pl",             $UBPath, "755", "ascii"],
        ["DoModifyReply.pl",            $UBPath, "755", "ascii"],
        ["DoNewPost.pl",                $UBPath, "755", "ascii"],
        ["DoNewReply.pl",               $UBPath, "755", "ascii"],
        ["DoRemoveMessages.pl",         $UBPath, "755", "ascii"],
        ["DoSearchThreads.pl",          $UBPath, "755", "ascii"],
        ["DoSignUp.pl",                 $UBPath, "755", "ascii"],
        ["ForwardTopic.pl",             $UBPath, "755", "ascii"],
        ["Help.pl",                     $UBPath, "755", "ascii"],
        ["LostPassword.pl",             $UBPath, "755", "ascii"],
        ["Main.pl",                     $UBPath, "755", "ascii"],
        ["ModifyAccount.pl",            $UBPath, "755", "ascii"],
        ["ModifyPost.pl",               $UBPath, "755", "ascii"],
        ["ModifyReply.pl",              $UBPath, "755", "ascii"],
        ["NewPost.pl",                  $UBPath, "755", "ascii"],
        ["NewReply.pl",                 $UBPath, "755", "ascii"],
        ["PreviewMessage.pl",           $UBPath, "755", "ascii"],
        ["PrintableTopic.pl",           $UBPath, "755", "ascii"],
        ["SearchThreads.pl",            $UBPath, "755", "ascii"],
        ["ShowBoard.pl",                $UBPath, "755", "ascii"],
        ["ShowCategory.pl",             $UBPath, "755", "ascii"],
        ["ShowPost.pl",                 $UBPath, "755", "ascii"],
        ["ShowProfile.pl",              $UBPath, "755", "ascii"],
        ["SignUp.pl",                   $UBPath, "755", "ascii"],

        ["General.cfg",                 $VarsPath, "666", "ascii"],
        ["Hosts.ban",                   $VarsPath, "666", "ascii"],
        ["IPs.ban",                     $VarsPath, "666", "ascii"],
        ["Rule.txt",                    $VarsPath, "666", "ascii"],
        ["Style.cfg",                   $VarsPath, "666", "ascii"],
        ["System.cfg",                  $VarsPath, "666", "ascii"],
        ["UltraBoard.them",             $VarsPath, "666", "ascii"],

        ["administrator.grp",           $in{'MembersPath'}, "666", "ascii"],
        ["Groups.db",                    $in{'MembersPath'}, "666", "ascii"],
        ["Members.email",               $in{'MembersPath'}, "666", "ascii"],
        ["members.grp",                 $in{'MembersPath'}, "666", "ascii"],
        ["Members.rev",                 $in{'MembersPath'}, "666", "ascii"],
        ["Members.total",               $in{'MembersPath'}, "666", "ascii"],
        ["moderator.grp",               $in{'MembersPath'}, "666", "ascii"]
    );

    # Printing Miscellaneous Options Setup page...
    &Header();
    print "<form action=\"Setup.$Ext\" method=\"POST\">\n";
    print "<input type=\"Hidden\" name=\"Action\" value=\"DoSaveSystemConfigurations\">\n";

    # Absolute Paths Data
    print "<input type=\"Hidden\" name=\"CGIPath\" value=\"$in{'CGIPath'}\">\n";
    print "<input type=\"Hidden\" name=\"DBPath\" value=\"$in{'DBPath'}\">\n";
    print "<input type=\"Hidden\" name=\"MembersPath\" value=\"$in{'MembersPath'}\">\n";
    print "<input type=\"Hidden\" name=\"SessionPath\" value=\"$in{'SessionPath'}\">\n";
    print "<input type=\"Hidden\" name=\"StatsPath\" value=\"$in{'StatsPath'}\">\n";

    # URL Addresses Data
    print "<input type=\"Hidden\" name=\"URLSite\" value=\"$in{'URLSite'}\">\n";
    print "<input type=\"Hidden\" name=\"URLCGI\" value=\"$in{'URLCGI'}\">\n";
    print "<input type=\"Hidden\" name=\"URLImages\" value=\"$in{'URLImages'}\">\n";

    # Email Options Data
    print "<input type=\"Hidden\" name=\"EmailAddress\" value=\"$in{'EmailAddress'}\">\n";
    print "<input type=\"Hidden\" name=\"EmailFunction\" value=\"$in{'EmailFunction'}\">\n";
    print "<input type=\"Hidden\" name=\"SendMailLocation\" value=\"$in{'SendMailLocation'}\">\n";
    print "<input type=\"Hidden\" name=\"SMTPAddress\" value=\"$in{'SMTPAddress'}\">\n";

    # Date/Time Options Data
    print "<input type=\"Hidden\" name=\"TimeZoneName\" value=\"$in{'TimeZoneName'}\">\n";
    print "<input type=\"Hidden\" name=\"GMTOffset\" value=\"$in{'GMTOffset'}\">\n";
    print "<input type=\"Hidden\" name=\"DateFormat\" value=\"$in{'DateFormat'}\">\n";
    print "<input type=\"Hidden\" name=\"TimeFormat\" value=\"$in{'TimeFormat'}\">\n";

    # Miscellaneous Options Data
    print "<input type=\"Hidden\" name=\"CloseUB\" value=\"$in{'CloseUB'}\">\n";
    print "<input type=\"Hidden\" name=\"ClosedMessage\" value=\"$in{'ClosedMessage'}\">\n";
    print "<input type=\"Hidden\" name=\"FLock\" value=\"$in{'FLock'}\">\n";
    print "<input type=\"Hidden\" name=\"UseStats\" value=\"$in{'UseStats'}\">\n";
    print "<input type=\"Hidden\" name=\"UseLog\" value=\"$in{'UseLog'}\">\n";
    print "<input type=\"Hidden\" name=\"MaxActionLog\" value=\"$in{'MaxActionLog'}\">\n";
    print "<input type=\"Hidden\" name=\"MaxVisitorLog\" value=\"$in{'MaxVisitorLog'}\">\n";
    print "<input type=\"Hidden\" name=\"CleanUpTime\" value=\"$in{'CleanUpTime'}\">\n";
    print "<input type=\"Hidden\" name=\"IPBanList\" value=\"$in{'IPBanList'}\">\n";
    print "<input type=\"Hidden\" name=\"HostBanList\" value=\"$in{'HostBanList'}\">\n";

    &ToolBar();
    print<<HTML;
<table width="100%" border="0" cellspacing="0" cellpadding="5">
	<tr>
		<td width="100%" valign="top">
			<font face="Verdana" size="4" color="#0033CC"><b>Check List</b></font>
		</td>
	</tr>
</table>
<center><img src="http://www.ultrascripts.com/UltraBoard/Remote/Black.gif" width=100% height=1 border=0 alt=""></center>
<table width="100%" border="0" cellspacing="0" cellpadding="1" algin="right">
	<tr>
		<td width="100%" align="right">
            <font face="Verdana" size="1">
                <font color="#FF3300">red:</font> incorrect, 
                <font color="#009900">green:</font> correct
            </font>
        </td>
	</tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="5">
	<tr>
		<td colspan="4" valign="middle">
            &nbsp;<br><font face="Verdana" size="2" color="#0033CC"><b>Directories</b></font>    
        </td>
	</tr>
</table>
<center><img src="http://www.ultrascripts.com/UltraBoard/Remote/Black.gif" width=100% height=1 border=0 alt=""></center>
<table width="100%" border="0" cellspacing="0" cellpadding="5">
	<tr>
		<td width="70%" valign="middle"><font face="Verdana" size="1" color="Black"><b>name</b></font></td>
		<td width="15%" align="center"><font face="Verdana" size="1" color="Black"><b>permission</b></font></td>
        <td width="15%" align="center"><font face="Verdana" size="1" color="Black"><b>status</b></font></td>
	</tr>
</table>
<center><img src="http://www.ultrascripts.com/UltraBoard/Remote/Black.gif" width=100% height=1 border=0 alt=""></center>
<table width="100%" border="0" cellspacing="0" cellpadding="5">
HTML
    $BackGroundColor="#EEEEEE";
    for $index (0..$#Directories) {
        if (-e "$Directories[$index][0]") {
            $DirectoryStatus     = "<font face=\"Verdana\" size=\"1\" color=\"#009900\">found</font>";

            $DirectoryPermission = &GetPermission((stat($Directories[$index][0]))[2]);
            if ($DirectoryPermission < $Directories[$index][1]) {
                $DirectoryPermission = "<font face=\"Verdana\" size=\"1\" color=\"#FF3300\"><strike>$DirectoryPermission</strike> <font color=\"#009900\">(".$Directories[$index][1].")</font></font>"
            }else{
                $DirectoryPermission = "<font face=\"Verdana\" size=\"1\" color=\"#009900\">$DirectoryPermission</font>"
            }
        }else{
            $DirectoryStatus     = "<font face=\"Verdana\" size=\"1\" color=\"#FF3300\">not found</font>";
            $DirectoryPermission = "<font face=\"Verdana\" size=\"1\" color=\"#FF3300\">unknown</font>";
        }

        $LengthPath=length($Directories[$index][0]);
        $tmpPath=$Directories[$index][0];
        if ($LengthPath >= 50) {
            $tmpPath=substr ($Directories[$index][0],0,10)."...".substr ($Directories[$index][0],$LengthPath-37,37);
        }
        print<<HTML;
    <tr bgcolor="$BackGroundColor">
		<td width="70%" valign="middle"><font face="Verdana" size="1" color="Black">$tmpPath</font></td>
		<td width="15%" align="center">$DirectoryPermission</td>
        <td width="15%" align="center">$DirectoryStatus</td>
    </tr>
HTML
        if ($BackGroundColor ne "") {
            $BackGroundColor="";
        }else{
            $BackGroundColor="#EEEEEE";
        }
    }
    print<<HTML;
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="5">
HTML
    $CurrentDirectory="";
    $BackGroundColor="#EEEEEE";
    for $index (0..$#Files) {
        $Files[$index][1]=~s/^\./$in{'CGIPath'}/isg;
        if ($CurrentDirectory ne $Files[$index][1]) {
            $CurrentDirectory=$Files[$index][1];
            print<<HTML;
	<tr>
		<td colspan="4" valign="middle">
            &nbsp;<br><font face="Verdana" size="2" color="#0033CC"><b>$CurrentDirectory</b></font>    
HTML
            unless (-e $CurrentDirectory) {
                print "<br><font face=\"Verdana\" size=\"1\" color=\"#FF3300\">error: the directory was not found.</font>"
            }
            print<<HTML;
        </td>
	</tr>
</table>
<center><img src="http://www.ultrascripts.com/UltraBoard/Remote/Black.gif" width=100% height=1 border=0 alt=""></center>
<table width="100%" border="0" cellspacing="0" cellpadding="5">
	<tr>
		<td width="55%" valign="middle"><font face="Verdana" size="1" color="Black"><b>name</b></font></td>
		<td width="15%" align="center"><font face="Verdana" size="1" color="Black"><b>permission</b></font></td>
		<td width="15%" align="center"><font face="Verdana" size="1" color="Black"><b>mode</b></font></td>
        <td width="15%" align="center"><font face="Verdana" size="1" color="Black"><b>status</b></font></td>
	</tr>
</table>
<center><img src="http://www.ultrascripts.com/UltraBoard/Remote/Black.gif" width=100% height=1 border=0 alt=""></center>
<table width="100%" border="0" cellspacing="0" cellpadding="5">
HTML
        }
        if (-e $CurrentDirectory) {
            if (-e "$CurrentDirectory/$Files[$index][0]") {
                $FileStatus     = "<font face=\"Verdana\" size=\"1\" color=\"#009900\">found</font>";

                $FilePermission = &GetPermission((stat("$CurrentDirectory/".$Files[$index][0]))[2]);
                if ($FilePermission < $Files[$index][2]) {
                    $FilePermission = "<font face=\"Verdana\" size=\"1\" color=\"#FF3300\"><strike>$FilePermission</strike> <font color=\"#009900\">(".$Files[$index][2].")</font></font>"
                }else{
                    $FilePermission = "<font face=\"Verdana\" size=\"1\" color=\"#009900\">$FilePermission</font>"
                }

                if (-T "$CurrentDirectory/$Files[$index][0]") {
                    $FileMode   = "ascii";
                }elsif (-B "$CurrentDirectory/$Files[$index][0]") {
                    $FileMode   = "binary";
                }else{
                    $FileMode   = "unknown";
                }
                if ($FileMode ne $Files[$index][3]) {
                    $FileMode="<font face=\"Verdana\" size=\"1\" color=\"#FF3300\"><strike>$FileMode</strike> <font color=\"#009900\">(".$Files[$index][3].")</font></font>"
                }else{
                    $FileMode="<font face=\"Verdana\" size=\"1\" color=\"#009900\">$FileMode</font>"
                }
            }else{
                $FileStatus     = "<font face=\"Verdana\" size=\"1\" color=\"#FF3300\">not found</font>";
                $FilePermission = "<font face=\"Verdana\" size=\"1\" color=\"#FF3300\">unknown</font>";
                $FileMode       = "<font face=\"Verdana\" size=\"1\" color=\"#FF3300\">unknown</font>";
            }
            print<<HTML;
    <tr bgcolor="$BackGroundColor">
		<td width="55%" valign="middle"><font face="Verdana" size="1" color="Black">$Files[$index][0]</font></td>
		<td width="15%" align="center">$FilePermission</td>
        <td width="15%" align="center">$FileMode</td>
        <td width="15%" align="center">$FileStatus</td>
    </tr>
HTML
            if ($BackGroundColor ne "") {
                $BackGroundColor="";
            }else{
                $BackGroundColor="#EEEEEE";
            }
        }
    }
    print<<HTML;
</table>
<center><img src="http://www.ultrascripts.com/UltraBoard/Remote/Black.gif" width=100% height=1 border=0 alt=""></center>
<table width="100%" border="0" cellspacing="0" cellpadding="5">
	<tr>
		<td width="100%" valign="top" align="right">
			<input type="Submit" value="Save Configurations" style="background-color : 0033CC; color : FFFFFF; font-weight : bold; font-family : Verdana; font-size : 9pt;">
		</td>
	</tr>
</table>
HTML
    &Footer();
    exit;
}

###############################################################################
# DoSaveSystemConfigurations                                                  #
###############################################################################
sub DoSaveSystemConfigurations {
    # Verify Variables
    if ($in{'EmailFunction'} eq "SendMail") {
        $in{'SendMailLocation'}=$in{'SendMailLocation'};
    }elsif ($in{'EmailFunction'} eq "SMTP") {
        $in{'SendMailLocation'}=$in{'SMTPAddress'};
    }else{
        $in{'SendMailLocation'}="";
    }
    $in{'CleanUpTime'}=3600 if ($in{'CleanUpTime'}<3600);
    @IPBanList              =split(/\s/,$in{'IPBanList'});
    @HostBanList            =split(/\s/,$in{'HostBanList'});
    $in{'Ban'}="on"         if (@IPBanList or @HostBanList);

    # Saving System Variables
    open(SYSTEM,">$VarsPath/System.cfg")||&CGIError("Couldn't create/write the System.cfg file<br>\nPath: $VarsPath<br>\nReason : $!");
		flock(SYSTEM,2) if ($FLock);
		print SYSTEM<<FILE;
\$DBPath            =\"$in{'DBPath'}\";
\$MembersPath       =\"$in{'MembersPath'}\";
\$SessionPath       =\"$in{'SessionPath'}\";
\$StatsPath         =\"$in{'StatsPath'}\";
\$CGIPath           =\"$in{'CGIPath'}\";
\$URLCGI            =\"$in{'URLCGI'}\";
\$URLImages         =\"$in{'URLImages'}\";
\$URLSite           =\"$in{'URLSite'}\";
\$EmailAddress      =\"$in{'EmailAddress'}\";
\$EmailFunction     =\"$in{'EmailFunction'}\";
\$SendMailLocation  =\"$in{'SendMailLocation'}\";
\$TimeZoneName      =\"$in{'TimeZoneName'}\";
\$GMTOffset         =\"$in{'GMTOffset'}\";
\$DateFormat        =\"$in{'DateFormat'}\";
\$TimeFormat        =\"$in{'TimeFormat'}\";

\$CloseUB           =\"$in{'CloseUB'}\";
\$ClosedMessage     =\"$in{'ClosedMessage'}\";

\$FLock             =\"$in{'FLock'}\";
\$Ban               =\"$in{'Ban'}\";

\$UseStats          =\"$in{'UseStats'}\";
\$UseLog            =\"$in{'UseLog'}\";

\$CleanUpTime       =\"$in{'CleanUpTime'}\";

\$MaxActionLog      =\"$in{'MaxActionLog'}\";
\$MaxVisitorLog     =\"$in{'MaxVisitorLog'}\";

\$Ext               =\"$Ext\";
1;
FILE
		flock(SYSTEM,8) if ($FLock);
	close(SYSTEM);

    open(BAN,">$VarsPath/IPs.ban")||&CGIError("Couldn't create/write the IPs.ban file<br>\nPath: $VarsPath<br>\nReason : $!");
		flock(BAN,2) if ($FLock);
			print BAN join("\n",@IPBanList);
		flock(BAN,8) if ($FLock);
	close(BAN);
    open(BAN,">$VarsPath/Hosts.ban")||&CGIError("Couldn't create/write the Hosts.ban file<br>\nPath: $VarsPath<br>\nReason : $!");
		flock(BAN,2) if ($FLock);
			print BAN join("\n",@HostBanList);
		flock(BAN,8) if ($FLock);
	close(BAN);
    print "Location: $in{'URLCGI'}/Setup.$Ext?Action=CreateAdminProfile\n\n";
}

###############################################################################
# CreateAdminProfile                                                          #
###############################################################################
sub CreateAdminProfile {
    if ($Errors) {
        $REG_Remember   =" checked" if ($in{'REG_Remember'});
    }
    # Printing Creating Administrator Profile Setup page...
    &Header();
    print "<form action=\"Setup.$Ext\" method=\"POST\">\n";
    print "<input type=\"Hidden\" name=\"Action\" value=\"DoCreateAdminProfile\">\n";
    &ToolBar();
    print<<HTML;
<table width="100%" border="0" cellspacing="0" cellpadding="5">
	<tr>
		<td width="100%" valign="top">
			<font face="Verdana" size="4" color="#0033CC"><b>Creating Administrator Profile</b></font>
		</td>
	</tr>
</table>
<center><img src="http://www.ultrascripts.com/UltraBoard/Remote/Black.gif" width=100% height=1 border=0 alt=""></center>
<table width="100%" border="0" cellspacing="0" cellpadding="5">
	<tr>
		<td width="100%" bgcolor="white" valign="top">
			<font face="Verdana" size="2" color="#0033CC"><b>Username (required)</b></font><br>
			<font face="Verdana" size="1" color="Black">your username can be up to 26 characters with letters or numbers with no spaces, and it is not case-sensitive.</font><br>
			$Error{'REG_UserName'}
            <input type="Text" name="REG_UserName" value="$in{'REG_UserName'}" size="60" style="width=100%" class="TextBox">
			<p>
			
			<font face="Verdana" size="2" color="#0033CC"><b>Password (required)</b></font><br>
			<font face="Verdana" size="1" color="Black">your password can be up to 26 characters with letters or numbers with no spaces, and it is case-sensitive. (at least 6 characters)</font><br>
			$Error{'REG_Password'}
            <input type="Password" name="REG_Password" value="$in{'REG_Password'}" size="60" style="width=100%" class="TextBox">
			<p>
			
			<font face="Verdana" size="2" color="#0033CC"><b>Verfiy Password (required)</b></font><br>
			<font face="Verdana" size="1" color="Black">please enter your password again..</font><br>
			$Error{'REG_VerfiyPassword'}
            <input type="Password" name="REG_VerfiyPassword" value="$in{'REG_VerfiyPassword'}" size="60" style="width=100%" class="TextBox">
			<p>
			
			<font face="Verdana" size="2" color="#0033CC"><b>Nick Name (required)</b></font><br>
			<font face="Verdana" size="1" color="Black">your nickname can be up to 20 characters with no spaces, it will used in every message you post.</font><br>
			$Error{'REG_NickName'}
            <input type="Text" name="REG_NickName" value="$in{'REG_NickName'}" size="60" style="width=100%" class="TextBox">
			<p>
			
			<font face="Verdana" size="2" color="#0033CC"><b>Email (required)</b></font><br>
			<font face="Verdana" size="1" color="Black">please use your real e-mail address.</font><br>
			$Error{'REG_Email'}
            <input type="Text" name="REG_Email" value="$in{'REG_Email'}" size="60" style="width=100%" class="TextBox">
			<p>
			
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="20"><input type="Checkbox" name="REG_Remember" value="on"$REG_Remember></td>
					<td width="100%"><font face="Verdana" size="2" color="#0033CC"><b>Remember Your Password?</b></font></td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<center><img src="http://www.ultrascripts.com/UltraBoard/Remote/Black.gif" width=100% height=1 border=0 alt=""></center>
<table width="100%" border="0" cellspacing="0" cellpadding="5">
	<tr>
		<td width="100%" valign="top" align="right">
			<input type="Reset" value="Starting Over" style="background-color : 0033CC; color : FFFFFF; font-weight : bold; font-family : Verdana; font-size : 9pt;">
			<input type="Submit" value="Create the Administrator Profile" style="background-color : 0033CC; color : FFFFFF; font-weight : bold; font-family : Verdana; font-size : 9pt;">
		</td>
	</tr>
</table>
HTML
    &Footer();
    exit;
}

###############################################################################
# DoCreateAdminProfile                                                        #
###############################################################################
sub DoCreateAdminProfile {
	
    # Verify Path
    $in{'REG_UserName'}=lc($in{'REG_UserName'});
    %Error=();
    $Errors=0;

    $Errors++ , $Error{'REG_UserName'}          ="<font face=\"Verdana\" size=\"1\" color=\"#FF3300\">error: you forgot to fill out your username</font><br>"                                       if (!$in{'REG_UserName'});
    $Errors++ , $Error{'REG_UserName'}          ="<font face=\"Verdana\" size=\"1\" color=\"#FF3300\">error: your username must not less than 2 characters</font><br>"                              if ((length($in{'REG_UserName'})<2)&&($in{'REG_UserName'}));
    $Errors++ , $Error{'REG_UserName'}          ="<font face=\"Verdana\" size=\"1\" color=\"#FF3300\">error: your username must not more than 26 characters</font><br>"                             if (length($in{'REG_UserName'})>26);
    $Errors++ , $Error{'REG_UserName'}          ="<font face=\"Verdana\" size=\"1\" color=\"#FF3300\">error: your username must not contain any blank spaces, or special characters.</font><br>"    if ($in{'REG_UserName'}=~/\W/);
    
    $Errors++ , $Error{'REG_Password'}          ="<font face=\"Verdana\" size=\"1\" color=\"#FF3300\">error: you forgot to fill out your password</font><br>"           if (!$in{'REG_Password'});
    $Errors++ , $Error{'REG_Password'}          ="<font face=\"Verdana\" size=\"1\" color=\"#FF3300\">error: your password must not less than 6 characters</font><br>"  if ((length($in{'REG_Password'})<6)&&($in{'REG_Password'}));
    $Errors++ , $Error{'REG_Password'}          ="<font face=\"Verdana\" size=\"1\" color=\"#FF3300\">error: your password must not more than 26 characters</font><br>" if (length($in{'REG_Password'})>26);
    
    $Errors++ , $Error{'REG_VerfiyPassword'}    ="<font face=\"Verdana\" size=\"1\" color=\"#FF3300\">error: you forgot to fill out your verify password</font><br>"            if (!$in{'REG_VerfiyPassword'});
    $Errors++ , $Error{'REG_VerfiyPassword'}    ="<font face=\"Verdana\" size=\"1\" color=\"#FF3300\">error: your verify password is not match with your password</font><br>"   if (($in{'REG_Password'} ne $in{'REG_VerfiyPassword'})&&($in{'REG_VerfiyPassword'}));
    
    $Errors++ , $Error{'REG_NickName'}          ="<font face=\"Verdana\" size=\"1\" color=\"#FF3300\">error: you forgot to fill out your nick name</font><br>"              if (!$in{'REG_NickName'});
    $Errors++ , $Error{'REG_NickName'}          ="<font face=\"Verdana\" size=\"1\" color=\"#FF3300\">error: your nick name must not less than 4 characters</font><br>"     if ((length($in{'REG_NickName'})<4)&&($in{'REG_NickName'}));
    $Errors++ , $Error{'REG_NickName'}          ="<font face=\"Verdana\" size=\"1\" color=\"#FF3300\">error: your nick name must not more than 20 characters</font><br>"    if (length($in{'REG_NickName'})>20);
    
    $Errors++ , $Error{'REG_Email'}             ="<font face=\"Verdana\" size=\"1\" color=\"#FF3300\">error: you forgot to fill out your email address</font><br>"                                      if (!$in{'REG_NickName'});
    $Errors++ , $Error{'REG_Email'}             ="<font face=\"Verdana\" size=\"1\" color=\"#FF3300\">error: your email address must not contain any blank spaces, and special characters.</font><br>"  if ($in{'REG_Email'}=~/[\!\#\$\%\^\&\*\(\)\{\}\;\:\'\`]/);
    $Errors++ , $Error{'REG_Email'}             ="<font face=\"Verdana\" size=\"1\" color=\"#FF3300\">error: the format of your email address is wrong</font><br>"                                      if (($in{'REG_Email'}!~/.*\@.*\..*/)&&($in{'REG_NickName'}));
    
    &CreateAdminProfile() if ($Errors>0);
    eval {
        # Get System Variables
        require "$VarsPath/System.cfg";
        require "$LibPath/Common.lib";
        require "$LibPath/Crypt.pm";
    };
    if ($@) {
        print<<HTML;
Content-type: text/html

<html>
<head>
<title>CGI Script Error</title>
</head>
<body>
<h1>Script Error</h1>
<p>"Couldn't load required libraries.<br>\nCheck that they exist, permissions are set correctly and that they compile.<br>\nReason: $@</p>
</body>
</html>
HTML
    }
	
    # Save the email address on Members.email
	open(DB,">>$MembersPath/Members.email")|| &CGIError("Couldn't write the Members.email file<br>\nPath: $MembersPath<br>\nReason : $!");
		flock(DB,2) if ($FLock);
		print DB $in{'REG_Email'}."\n";
		flock(DB,8) if ($FLock);
	close(DB);

    # Add one member into total members file
	open(DB,"$MembersPath/Members.total")||&CGIError("Couldn't open/read the Members.total file<br>\nPath: $MembersPath<br>\nReason : $!");
		flock(DB,1) if ($FLock);
		$TotalMembers=<DB>;
	close(DB);
	open(DB,">$MembersPath/Members.total")||&CGIError("Couldn't create/write the Members.total file<br>\nPath: $MembersPath<br>\nReason : $!");
		flock(DB,2) if ($FLock);
		print DB ++$TotalMembers;
		flock(DB,8) if ($FLock);
	close(DB);

    # Add this username into administrator group
	open(DB,">>$MembersPath/administrator.grp")||&CGIError("Couldn't write the administrator.grp file<br>\nPath: $MembersPath<br>\nReason : $!");
		flock(DB,2) if ($FLock);
		print DB $in{'REG_UserName'}."\n";
		flock(DB,8) if ($FLock);
	close(DB);
	 
    # Save user profile
    $NewPassword=Crypt::crypt($in{'REG_Password'},substr($in{'REG_UserName'}, 0, 2));
	$RegTime=time;
	&SaveMemberData($in{'REG_UserName'},
					$in{'REG_UserName'},
					$in{'REG_NickName'},
					$NewPassword,
					"administrator",
					$in{'REG_Email'},
					"0",
					"Activate",
					"N/A",
					"",
					"",
					"",
					"",
					"",
					"",
					"",
					"",
					$RegTime,
					"on",

	);

	if ($in{'REG_Remember'}) {
        @Cookies=("UserName",$in{'REG_UserName'},"Password",$in{'REG_Password'});

        my (@Days) = ("Sun","Mon","Tue","Wed","Thu","Fri","Sat");
        my (@Months) = ("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec");
        my ($Sec,$Min,$Hour,$MDay,$Mon,$Year,$WDay) = gmtime(time+31536000);
        if ($Year>50) {
            $Year+=1900;
        }else{
            $Year+=2000;
        }
        while(($Cookie,$Value)=@Cookies) {
            foreach $Char (@Cookie_Encode_Chars) {
                $Cookie =~ s/$Char/$Cookie_Encode_Chars{$Char}/g;
                $Value  =~ s/$Char/$Cookie_Encode_Chars{$Char}/g;
            }
            $Header.="Set-Cookie: ".$Cookie."=". $Value."; ";
            $Header.="expires=$Days[$WDay], $MDay-$Months[$Mon]-$Year $Hour:$Min:$Sec GMT;";
            $Header.="\n";
            shift(@Cookies);
            shift(@Cookies);
        }        
    }
		$Header.="Location: $URLCGI/Setup.$Ext?Action=Conclusion\n";
	$Header.="Content-type: text/html\n";
    $Header.="\n";
	print $Header;

}

###############################################################################
# Conclusion                                                                  #
###############################################################################
sub Conclusion {
    # Printing conclusion page...
    &Header();
    &ToolBar();
    print<<HTML;
<table width="100%" border="0" cellspacing="0" cellpadding="5">
	<tr>
		<td width="100%" valign="top">
			<font face="Verdana" size="4" color="#0033CC"><b>Conclusion</b></font>
		</td>
	</tr>
</table>
<center><img src="http://www.ultrascripts.com/UltraBoard/Remote/Black.gif" width=100% height=1 border=0 alt=""></center>
<table width="100%" border="0" cellspacing="0" cellpadding="5">
	<tr>
		<td width="100%" bgcolor="white" valign="top">
            <font face="Verdana" size="2">
                <font color="#0033CC"><b>Congratulations!</b></font><br>
                You have all files set up properly and are ready to enter the <a href=\"UBAdmin.$Ext?UserName=$in{'UserName'}&Password=$in{'Password'}\" target="_blank">UltraBoard Administrative Center</a><p>
                These steps will take you through the configuration of your board. These all refer to the list box next to the <b>RUN</b> button.  This box is how you navigate through administration center.
                <ol type="1">
                    <li><b>General Management</b> > <b>Configure General Options</b>.<br>
                        This is where you set up general board options, words filter, etc.<p>
                    <li><b>General Management</b> > <b>Configure Style Options</b>.<br>
                        This is where you change the style, color, fonts, icons, etc.<p>
                    <li><b>General Management</b> > <b>Modify Administrator Profile</b>.<br>
                        This is where you change your profile.<p>
                    
                    <li><b>Categories Management</b> > <b>Create New Category</b>.<br>
                        Create a category if desired.  Categories are not required, but if you plan on having a board with a wide range of topics, you should create different categories.<p>
                    <li><b>Boards Management</b> > <b>Create new boards</b>.<br>
                        This is where you create a board.<p>
                    <li><b>General Management</b> > <b>Configure System Options</b>.<br>
                        After your board is up and running, you may need to change things you originally began with.  You can also ban hosts/IPs here.
                </ol>
                Your UltraBoard is now set up!  Open up <a href="UltraBoard.$Ext" target="_blank">UltraBoard.$Ext</a> in your browser and check it out.<p>
                If you really like UltraBoard 1.62, please give us <a href="http://cgi.resourceindex.com/detail/03326.html" target="_blank">a rate</a> or <a href="http://cgi.resourceindex.com/detail/03326.html" target="_blank">leave a comment</a> for others people to read.
                <blockquote>
                <form method=POST action="http://cgi-resources.com/rate/index.cgi">
                    <input type=hidden name="referer" value="http://cgi-resources.com/">
                    <input type=hidden name="link_code" value="03326">
                    <input type=hidden name="category_name" value="Programs and Scripts/Perl/Bulletin Board Message Systems/">
                    <input type=hidden name="link_name" value="UltraBoard">
                    <font color="#0033CC"><b>Script Rating:</b></font><br>
                    <select name="rating" style="font-family : Verdana; font-size : 9pt;">
                        <option selected>--
                        <option>10
                        <option>9
                        <option>8
                        <option>7
                        <option>6
                        <option>5
                        <option>4
                        <option>3
                        <option>2
                        <option>1
                    </select> <input type="Submit" value="Rate it" style="background-color : 0033CC; color : FFFFFF; font-weight : bold; font-family : Verdana; font-size : 9pt;">
                </blockquote>
                If you finished setup the UltraBoard 1.62, and work fine. click here to <a href="Setup.$Ext?Action=SelfDelete" target="_blank">delete</a> this setup file.
            </font>
            <p>

            <font face="Verdana" size="2">
                <font color="#0033CC"><b>Copyright Notice</b></font><br>
                This program is free software; you can change or modify it as you see fit. However, modified versions cannot be sold or distributed. You cannot alter the copyright and "powered by" notices throughout the scripts. These notices must be clearly visible to the end users.
                <p>
                <font color="#0033CC"><b>Usage Disclaimer</b></font><br>
                THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.       
            </font>
		</td>
	</tr>
</table>
<center><img src="http://www.ultrascripts.com/UltraBoard/Remote/Black.gif" width=100% height=1 border=0 alt=""></center>
<table width="100%" border="0" cellspacing="0" cellpadding="1" algin="right">
	<tr>
		<td width="100%" align="right">
            <font face="Verdana" size="1" color="#0033CC">
                copyright &copy; 1999 jacky yung. all rights reserved.
            </font>
        </td>
	</tr>
</table>
HTML
    &Footer();
    exit;
}

###############################################################################
# SelfDelete                                                                  #
###############################################################################
sub SelfDelete {
	eval {
        require "$VarsPath/System.cfg";
    };
    if ($@) {
        print<<HTML;
Content-type: text/html

<html>
<head>
<title>CGI Script Error</title>
</head>
<body>
<h1>Script Error</h1>
<p>"Couldn't load required libraries.<br>\nCheck that they exist, permissions are set correctly and that they compile.<br>\nReason: $@</p>
</body>
</html>
HTML
    }
    unlink ("$CGIPath/Setup.$Ext");
    unlink ("$CGIPath/Upgrade.$Ext");
    print "Location: $URLCGI/UBAdmin.$Ext\n\n";
}

###############################################################################
# HTTP Cookie Library           Version 2.1                                   #
# Copyright 1996 Matt Wright    mattw@worldwidemart.com                       #
# Created 07/14/96              Last Modified 12/23/96                        #
###############################################################################
my @Cookie_Encode_Chars = ('\%', '\+', '\;', '\,', '\=', '\&', '\:\:', '\s');
my %Cookie_Encode_Chars = ('\%',   '%25',
									'\+',   '%2B',
									'\;',   '%3B',
									'\,',   '%2C',
									'\=',   '%3D',
									'\&',   '%26',
									'\:\:', '%3A%3A',
									'\s',   '+');

my @Cookie_Decode_Chars = ('\+', '\%3A\%3A', '\%26', '\%3D', '\%2C', '\%3B', '\%2B', '\%25');
my %Cookie_Decode_Chars = ('\+',       ' ',
									'\%3A\%3A', '::',
									'\%26',     '&',
									'\%3D',     '=',
									'\%2C',     ',',
									'\%3B',     ';',
									'\%2B',     '+',
									'\%25',     '%');

###############################################################################
# GetPermission                                                               #
###############################################################################
sub GetPermission {
    $_ = shift;
	if($_ eq "16895" || $_ eq "33279") {
		$_ = "777";
	}elsif($_ eq "33261" || $_ eq "16877") {
		$_ = "755";
	}elsif($_ eq "33204" || $_ eq "16820") {
		$_ = "664";
	}elsif($_ eq "33188" || $_ eq "16804") {
		$_ = "644";
	}elsif($_ eq "33060" || $_ eq "16676") {
		$_ = "444";
	}elsif($_ eq "33206" || $_ eq "16822") {
		$_ = "666";
	}elsif($_ eq "33277" || $_ eq "16893") {
		$_ = "775";
	}elsif($_ eq "33270" || $_ eq "16886") {
		$_ = "766";
	}elsif($_ eq "33252" || $_ eq "16868") {
		$_ = "744";
	}elsif($_ eq "33276" || $_ eq "16892") {
		$_ = "774";
	}else {
		$_ = "unknown";
	}
    return $_;
}

###############################################################################
# ChangesChars                                                                #
###############################################################################
sub ChangesChars {
    my (@Chars) = @_;
	for (my($i)=0;$i<=$#Chars;$i++){
        $Chars[$i]  =~ s/\"/\\\"/g;
        $Chars[$i]  =~ s/\n\n/\<p\>\\n\\n/g;
        $Chars[$i]  =~ s/\n/\<br\>\\\n/g;
        $Chars[$i]  =~ s/\@/\\\@/g;
        $Chars[$i]  =~ s/^\s+//g;
        $Chars[$i]  =~ s/\s+$//g;
	}
	return wantarray ? @Chars : $Chars[0];
}

###############################################################################
# ToolBar                                                                     #
###############################################################################
sub ToolBar {
    print<<HTML;
<table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="Black">
	<tr><td>
		<table width="100%" border="0" cellspacing="1" cellpadding="0">
			<tr bgcolor="#0033CC"><td>
				<table width="100%" border="0" cellspacing="0" cellpadding="5">
					<tr><td>
						<font face="Verdana" size="1" color="#FFFFFF"><b>
							<a href="http://www.ultrascripts.com" class="Menu">Home</a> |
							<a href="http://www.ultrascripts.com/features.shtml" class="Menu">features</a> |
							<a href="http://www.ultrascripts.com/download.shtml" class="Menu">download</a> |
							<a href="http://www.ultrascripts.com/demos.shtml" class="Menu">demos</a> |
							<a href="http://www.ultrascripts.com/support.shtml" class="Menu">support</a> |
							<a href="http://www.ultrascripts.com/links.shtml" class="Menu">links</a> |
							<a href="http://www.ultrascripts.com/credits.shtml" class="Menu">credits</a> |
							<a href="http://www.ultrascripts.com/contactus.shtml" class="Menu">contact us</a>
						</b></font>
					</td></tr>
				</table>
			</td></tr>
			<tr bgcolor="#FFFFCC" ><td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td><img src="http://www.ultrascripts.com/UltraBoard/Remote/Index.gif" width=477 height=50 border=0 alt="UltraBoard Setup"></td>
						<td align="right"><img src="http://www.ultrascripts.com/UltraBoard/Remote/Speed.gif" width=93 height=50 border=0 alt="UltraBoard Setup"></td>
					</tr>
				</table>
			</td></tr>
		</table>
	</td></tr>
</table>
HTML
}

###############################################################################
# Header                                                                      #
###############################################################################
sub Header {
    print "Content-type: text/html\n\n";
    print<<HTML;
<html>
<head>
	<title>UltraBoard Setup</title>
	<STYLE type="text/css">
	<!--
		A.Menu:Link {
			font-family : Verdana;
			font-size : xx-small;
			font-weight : bold;
			color : White;
			text-decoration : none;
		}
		A.Menu:Visited {
			font-family : Verdana;
			font-size : xx-small;
			font-weight : bold;
			color : White;
			text-decoration : none;
		}
		A.Menu:active {
			font-family : Verdana;
			font-size : xx-small;
			font-weight : bold;
			color : White;
			text-decoration : none;
		}
		A.Menu:hover {
			font-family : Verdana;
			font-size : xx-small;
			font-weight : bold;
			color : Yellow;
			text-decoration : none;
		}
		Input {
			font-family : Courier New;
		}
		TextArea {
			font-family : Courier New;
		}
	-->
	</STYLE>
</head>

<body bgcolor="White" text="Black" link="#0033CC" vlink="#FF3300" alink="#FF3300" leftmargin=8 topmargin=8>
HTML
}

###############################################################################
# Footer                                                                      #
###############################################################################
sub Footer {
    print<<HTML;
</form>
</body>
</html>
HTML
}

###############################################################################
# CGIError                                                                    #
###############################################################################
sub CGIError {
	my ($Message)=$_[0];
    print<<HTML;
Content-type: text/html

<html>
<head>
<title>CGI Script Error</title>
</head>
<body>
<h1>Script Error</h1>
<p>$Message</p>
</body>
</html>
HTML
	exit;
	#die @Message;
}

###############################################################################
# ParseForm                                                                   #
###############################################################################
sub ParseForm{
	my ($Buffer, @Pairs, $Pair, $Name, $Value);
	if($ENV{'REQUEST_METHOD'} eq "POST"){
    	read(STDIN, $Buffer, $ENV{'CONTENT_LENGTH'});
	}elsif($ENV{'REQUEST_METHOD'} eq "GET"){
		$Buffer=$ENV{'QUERY_STRING'};
	}
	@Pairs = split(/&/, $Buffer);
	foreach $Pair (@Pairs) {
		($Name, $Value) = split(/=/, $Pair);
		$Value =~ tr/+/ /;
		$Value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
		$Value =~ s/\r//g;
		$Value =~ s/^\s+//g;
		$Value =~ s/\s+$//g;
		$in{$Name} = $Value;
	}
}