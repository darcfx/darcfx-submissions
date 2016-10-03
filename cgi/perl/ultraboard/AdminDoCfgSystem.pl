###############################################################################
# AdminDoCfgSystem.pl                                                         #
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

###############################################################################
# DoCfgSystem                                                                 #
###############################################################################
sub DoCfgSystem {
    
    if ($in{'EmailFunction'} eq "SendMail") {
        $in{'SendMailLocation'}=$in{'SendMailPath'};
    }elsif ($in{'EmailFunction'} eq "SMTP") {
        $in{'SendMailLocation'}=$in{'SMTPAddress'};
    }else{
        $in{'SendMailLocation'}="";
    }

	&ShowError("SAVING PROBLEM","You forgot to fill the absolute path of the directory where all the ultraboard data files will be located.")           if (!$in{'DBPath'});
	&ShowError("SAVING PROBLEM","You forgot to fill the absolute path of the directory where all the ultraboard members data files will be located.")   if (!$in{'MembersPath'});
    &ShowError("SAVING PROBLEM","You forgot to fill the absolute path of the directory where all the ultraboard members session files will be located.")   if (!$in{'SessionPath'});
    &ShowError("SAVING PROBLEM","You forgot to fill the absolute path of directory that where all the ultraboard log and stats files will be located.") if (!$in{'StatsPath'});
    &ShowError("SAVING PROBLEM","You forgot to fill the absolute path of directory where the UltraBoard.pl and UBAdmin.pl are located.")                if (!$in{'CGIPath'});
    &ShowError("SAVING PROBLEM","You forgot to fill the location where the UltraBoard.pl and UBAdmin.pl are located.")                                  if (!$in{'URLCGI'});
    &ShowError("SAVING PROBLEM","You forgot to fill the location where the UltraBoard images (*.gif) are located.")                                     if (!$in{'URLImages'});
    &ShowError("SAVING PROBLEM","You forgot to fill the address of your smtp server.")                                                                  if ((!$in{'SendMailLocation'})&&($in{'EmailFunction'} eq "SMTP"));
    &ShowError("SAVING PROBLEM","You forgot to fill the location of the sendmail program on your server.")                                              if ((!$in{'SendMailLocation'})&&($in{'EmailFunction'} eq "SendMail"));

    chop ($in{'DBPath'})        if ($in{'DBPath'}=~/\/$/);
    chop ($in{'MembersPath'})   if ($in{'MembersPath'}=~/\/$/);
    chop ($in{'SessionPath'})   if ($in{'SessionPath'}=~/\/$/);
    chop ($in{'StatsPath'})     if ($in{'StatsPath'}=~/\/$/);
    chop ($in{'CGIPath'})       if ($in{'CGIPath'}=~/\/$/);
    
    &ShowError("SAVING PROBLEM","Couldn't find the absolute path of the directory where all the ultraboard data files will be located.")                unless (-e $in{'DBPath'});
	&ShowError("SAVING PROBLEM","Couldn't find the absolute path of the directory where all the ultraboard members data files will be located.")        unless (-e $in{'MembersPath'});
    &ShowError("SAVING PROBLEM","Couldn't find the absolute path of directory that where all the ultraboard log and stats files will be located.")      unless (-e $in{'StatsPath'});
    &ShowError("SAVING PROBLEM","Couldn't find the absolute path of directory where the UltraBoard.pl and UBAdmin.pl are located.")                     unless (-e $in{'CGIPath'});
    
    &ShowError("SAVING PROBLEM","You forgot to fill out the CGI URL")       unless ($in{'URLCGI'});
	&ShowError("SAVING PROBLEM","You forgot to fill out the Images URL")    unless ($in{'URLImages'});
    &ShowError("SAVING PROBLEM","You forgot to fill out the Site URL")      unless ($in{'URLSite'});
    &ShowError("SAVING PROBLEM","You forgot to fill out the Email Address") unless ($in{'EmailAddress'});
    &ShowError("SAVING PROBLEM","You forgot to fill out the Email Address") unless ($in{'EmailAddress'});

    &ShowError("SAVING PROBLEM","Invaild format of the email address")          if ((($in{'EmailAddress'}!~/.*\@.*\..*/)||($in{'EmailAddress'}=~/[\!\#\$\%\^\&\*\(\)\{\}\;\:\'\`]/))&&($in{'EmailAddress'}));
    &ShowError("SAVING PROBLEM","You forgot to fill out the sendmail location") if ((!$in{'SendMailPath'})&&($in{'EmailFunction'} eq "SendMail"));
    &ShowError("SAVING PROBLEM","Couldn't find the sendmail location")          if (!((-e $in{'SendMailPath'}))&&($in{'EmailFunction'} eq "SendMail")&&($in{'SendMailPath'}));
    &ShowError("SAVING PROBLEM","You forgot to fill out the clean up time")     if (!$in{'CleanUpTime'});
    &ShowError("SAVING PROBLEM","You forgot to fill out the maximun number of action/visitor log information")     if (((!$in{'MaxActionLog'})||(!$in{'MaxVisitorLog'}))&&($in{'UseLog'}));
    
    opendir(DIR,"$in{'DBPath'}")
        ||&ShowError("SAVING PROBLEM","Couldn't open the absolute path of the directory where all the ultraboard data files will be located.");
	closedir(DIR);
    opendir(DIR,"$in{'MembersPath'}")
        ||&ShowError("SAVING PROBLEM","Couldn't open the absolute path of the directory where all the ultraboard members data files will be located.");
	closedir(DIR);
    opendir(DIR,"$in{'SessionPath'}")
        ||&ShowError("SAVING PROBLEM","Couldn't open the absolute path of the directory where all the ultraboard members session files will be located.");
	closedir(DIR);
    opendir(DIR,"$in{'StatsPath'}")
        ||&ShowError("SAVING PROBLEM","Couldn't open the absolute path of directory that where all the ultraboard log and stats files will be located.");
	closedir(DIR);
    opendir(DIR,"$in{'CGIPath'}")
        ||&ShowError("SAVING PROBLEM","Couldn't open the absolute path of directory where the UltraBoard.pl and UBAdmin.pl are located.");
	closedir(DIR);

###############################################################################
    $in{'EmailAddress'}     =&ChangesChars($in{'EmailAddress'});
    $in{'TimeZoneName'}     =&ChangesChars($in{'TimeZoneName'});
    $in{'ClosedMessage'}    =&ChangesChars($in{'ClosedMessage'});
    @IPBanList              =split(/\s/,$in{'IPBanList'});
    @IPBanList              =&ChangesChars(@IPBanList);
    @HostBanList            =split(/\s/,$in{'HostBanList'});
    @HostBanList            =&ChangesChars(@HostBanList);
    $in{'Ban'}="on"         if (@IPBanList or @HostBanList);
    $in{'EmailFunction'}="" if ($in{'EmailFunction'} eq "no");
    $in{'CleanUpTime'}=3600 if ($in{'CleanUpTime'}<3600);

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
###############################################################################
	&ShowThank(	"SAVED SYSTEM CONFIGURATION",
				"Saved all the system configurations.\n",
				"3",
				"UBAdmin.$Ext?Session=$SessionID"
	);
	exit;
}
###############################################################################
1;# End of DoCfgSystem Function
###############################################################################