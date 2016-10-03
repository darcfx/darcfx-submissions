###############################################################################
# AdminDoCreateAccount.pl                                                     #
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
# DoCreateAccount                                                             #
###############################################################################
sub DoCreateAccount {
	&ShowError("ACCOUNT CREATION ERROR","You forgot to fill the \"UserName\" field.") if (!$in{'REG_UserName'});
	&ShowError("ACCOUNT CREATION ERROR","You forgot to fill the \"Password\" field.") if (!$in{'REG_Password'});
	&ShowError("ACCOUNT CREATION ERROR","You forgot to fill the \"Verfiy Password\" field.") if (!$in{'REG_VerfiyPassword'});

	&ShowError("ACCOUNT CREATION ERROR","The Password only can contain characters or numbers.") if ($in{'REG_Password'}!~/^[A-Za-z0-9]+$/);
	&ShowError("ACCOUNT CREATION ERROR","The Password must not more than 26 characters.") if (length($in{'REG_Password'})>26);
	&ShowError("ACCOUNT CREATION ERROR","The Password must not less than 6 characters.") if (length($in{'REG_Password'})<6);

	&ShowError("ACCOUNT CREATION ERROR","The Password is different than the Verfiy Password.") if ($in{'REG_Password'} ne $in{'REG_VerfiyPassword'});

	&ShowError("ACCOUNT CREATION ERROR","You forgot to fill the \"Nick Name\" field.") if (!$in{'REG_NickName'});
	&ShowError("ACCOUNT CREATION ERROR","You forgot to fill the \"Email\" field.") if (!$in{'REG_Email'});

	&ShowError("ACCOUNT CREATION ERROR","The UserName must not contain any blank spaces, or special characters.") if ($in{'REG_UserName'}=~/\W/);
	&ShowError("ACCOUNT CREATION ERROR","The UserName must not more than 26 characters.") if (length($in{'REG_UserName'})>26);
	&ShowError("ACCOUNT CREATION ERROR","The UserName must not less than 2 characters.") if (length($in{'REG_UserName'})<2);

	&ShowError("ACCOUNT CREATION ERROR","The Nick Name must not more than 20 characters.") if (length($in{'REG_NickName'})>20);
	&ShowError("ACCOUNT CREATION ERROR","The Nick Name must not less than 4 characters.") if (length($in{'REG_NickName'})<4);		
	
	&ShowError("ACCOUNT CREATION ERROR","The Email must not contain any blank spaces, and special characters.") if ($in{'REG_Email'}=~/[\!\#\$\%\^\&\*\(\)\{\}\;\:\'\`]/);
	&ShowError("ACCOUNT CREATION ERROR","The Email format is wrong.") if ($in{'REG_Email'}!~/.*\@.*\..*/);
	
	&ShowError("ACCOUNT CREATION ERROR","The HomePage address format is wrong.") if (($in{'REG_HomePage'}!~/^http:\/\/.*/)&&($in{'REG_HomePage'}));

	&ShowError("ACCOUNT CREATION ERROR","The Age only contain numbers.") if (($in{'REG_Age'}=~/\D/)&&($in{'REG_Age'}));

	&ShowError("ACCOUNT CREATION ERROR","The ICQ Numbers only contain numbers.") if (($in{'REG_ICQ'}=~/\D/)&&($in{'REG_ICQ'}));

	&ShowError("ACCOUNT CREATION ERROR","The comments must not more than $CommentLength characters.") if (length($in{'REG_Comments'})>$CommentLength);
    &ShowError("ACCOUNT CREATION ERROR","The signature must not more than $SignaturesLength characters.") if (length($in{'REG_Signature'})>$SignaturesLength);

	$in{'REG_UserName'}=lc($in{'REG_UserName'});
	&ShowError("ACCOUNT CREATION ERROR","The UserName has been taken.") if (-e "$MembersPath/$in{'REG_UserName'}.info");
###############################################################################
	if ($CheckEmail) {
		open(DB,"$MembersPath/Members.email")||&CGIError("Couldn't open/read the Members.email file<br>\nPath: $MembersPath<br>\nReason : $!");
			flock(DB,1) if ($FLock);
			@MembersEmail=<DB>;
		close(DB);
		for (my($i)=0;$i<=$#MembersEmail;$i++) {
			chomp($MembersEmail[$i]);
			if ($MembersEmail[$i] =~/^$in{'REG_Email'}$/i) {
				&ShowError("ACCOUNT CREATION ERROR","The Email address has been used once.");
			}
		}
	}
	open(DB,">>$MembersPath/Members.email")||&CGIError("Couldn't write the Members.email file<br>\nPath: $MembersPath<br>\nReason : $!");
		flock(DB,2) if ($FLock);
		print DB $in{'REG_Email'}."\n";
		flock(DB,8) if ($FLock);
	close(DB);
###############################################################################
	open(DB,"$MembersPath/Members.total")||&CGIError("Couldn't open/read the Members.total file<br>\nPath: $MembersPath<br>\nReason : $!");
		flock(DB,1) if ($FLock);
		$TotalMembers=<DB>;
	close(DB);
	open(DB,">$MembersPath/Members.total")||&CGIError("Couldn't create/write the Members.total file<br>\nPath: $MembersPath<br>\nReason : $!");
		flock(DB,2) if ($FLock);
		print DB ++$TotalMembers;
		flock(DB,8) if ($FLock);
	close(DB);
###############################################################################
	open(DB,">>$MembersPath/$in{'REG_Group'}.grp")||&CGIError("Couldn't write the $in{'REG_Group'}.grp file<br>\nPath: $MembersPath<br>\nReason : $!");
		flock(DB,2) if ($FLock);
		print DB $in{'REG_UserName'}."\n";
		flock(DB,8) if ($FLock);
	close(DB);
###############################################################################
    $NewPassword=Crypt::crypt($in{'REG_Password'},substr($in{'REG_UserName'}, 0, 2));
	$RegTime=time;
	&SaveMemberData($in{'REG_UserName'},
					$in{'REG_UserName'},
					$in{'REG_NickName'},
					$NewPassword,
					$in{'REG_Group'},
					$in{'REG_Email'},
					"0",
					$in{'REG_Status'},
					"N/A",
					$in{'REG_HomePage'},
					&RemoveCensorWords($in{'REG_Location'}),
					$in{'REG_Age'},
					&RemoveCensorWords($in{'REG_Occupation'}),
					&RemoveCensorWords($in{'REG_Interests'}),
					$in{'REG_ICQ'},
					&RemoveCensorWords($in{'REG_Comments'}),
					&RemoveCensorWords($in{'REG_Signature'}),
					$RegTime,
					$in{'REG_ShowEmail'},

	);
###############################################################################
	my ($Subject, $Message);
	$Subject = "Registration information from $UBName ($URLSite)";
	$Message = "Hello, $in{'REG_NickName'}\n\n";
	$Message .= "Following is your login information:\n";
	$Message .= "------------------------------------\n";
	$Message .= "UserName: $in{'REG_UserName'}\n";
	$Message .= "Password: $in{'REG_Password'}\n";
	$Message .= "Status: $in{'REG_Status'}\n";
	$Message .= "------------------------------------\n";
	$Message .= "NickName: $in{'REG_NickName'}\n";
	$Message .= "Email: $in{'REG_Email'}\n";
	$Message .= "HomePage: $in{'REG_HomePage'}\n";
	$Message .= "ICQ Number: $in{'REG_ICQ'}\n";
	$Message .= "Age: $in{'REG_Age'}\n";
	$Message .= "Location: ".&RemoveCensorWords($in{'REG_Location'})."\n";
	$Message .= "Qccupation: ".&RemoveCensorWords($in{'REG_Occupation'})."\n";
	$Message .= "Interests: ".&RemoveCensorWords($in{'REG_Interests'})."\n";
	$Message .= "Comment:\n".&RemoveCensorWords($in{'REG_Comments'})."\n";
	$Message .= "------------------------------------\n";
	$Message .= "WebMaster, $UBName\n";
	$Message .= "$EmailAddress\n";
	$Message .= "$URLSite\n";
	$Message .= "------------------------------------\n";
	$Message .= "Powered by UltraScripts.com\n";
	&SendMail($EmailAddress,$Subject,$Message,$in{'REG_Email'});
###############################################################################
	&ShowThank(	"CREATED A NEW MEMBER ACCOUNT",
				"The member account ($in{'REG_UserName'}) has been created. I will send the email to him/her.",
				"3",
				"UBAdmin.$Ext?Session=$SessionID"			
	);
	exit;
}
###############################################################################
1;# End of DoCreateAccount Function
###############################################################################