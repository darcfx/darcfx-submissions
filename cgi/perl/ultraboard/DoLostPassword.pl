###############################################################################
# DoLostPassword.pl                                                           #
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
# DoLostPassword                                                              #
###############################################################################
sub DoLostPassword {
	&ShowError("INPUT PROBLEM","You forgot to fill the \"UserName\" field.") if (!$in{'LUserName'});
	&ShowError("INPUT PROBLEM","You forgot to fill the \"Email\" field.") if (!$in{'Email'});

	$in{'LUserName'}=lc($in{'LUserName'});
###############################################################################
	@MemberInfo=&GetMemberData($in{'LUserName'});
    &ShowError("INPUT PROBLEM","Your $UserName account has been disactivated.<br>Please contact the webmaster (".&Link("mailto:$EmailAddress","","").$EmailAddress."</a>".") for more information.") if ($MemberInfo[6] ne "Activate");
	$NewPassword=&RandomPassword();
	$MemberInfo[2]=Crypt::crypt($NewPassword,substr($in{'LUserName'}, 0, 2));
	&SaveMemberData($in{'LUserName'},@MemberInfo);
	if ($MemberInfo[4] ne $in{'Email'}) {
		&ShowError("INPUT PROBLEM","Your email is not match with your username.")
	}
	$Subject = "Login information at $UBName ($URLSite)";
	$Message = "Hello, $MemberInfo[1]\n\n";
	$Message .= "Following is your login information:\n";
	$Message .= "------------------------------------\n";
	$Message .= "UserName: $in{'LUserName'}\n";
	$Message .= "New Password: $NewPassword\n";	
	$Message .= "------------------------------------\n";
	$Message .= "WebMaster, $UBName\n";
	$Message .= "$EmailAddress\n";
	$Message .= "$URLSite\n";
	$Message .= "------------------------------------\n";
	$Message .= "Powered by UltraScripts.com\n";
	&SendMail($UBName."<".$EmailAddress.">",$Subject,$Message,$in{'Email'});
###############################################################################
	&ShowThank(	"PASSWORD SENT",
				"Your password has been mailed to $in{'Email'}.",
				"3",
				"UltraBoard.$Ext?Action=SignIn&Type=$in{'Type'}&Category=$in{'Category'}&Board=$in{'Board'}&Post=$in{'Post'}&ID=$in{'ID'}&Idle=$in{'Idle'}&Sort=$in{'Sort'}&Order=$in{'Order'}&Page=$in{'Page'}"				
	);
	exit;
}
###############################################################################
1;# End of DoLostPassword Function
###############################################################################