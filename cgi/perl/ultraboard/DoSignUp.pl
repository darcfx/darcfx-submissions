###############################################################################
# DoSignUp.pl                                                                 #
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
# DoSignUp                                                                    #
###############################################################################
sub DoSignUp {
	if (!$AllowRegister) {
		print "Location: UltraBoard.$Ext\n\n";
	}
	&ShowError("ACCOUNT CREATION ERROR","You forgot to fill the \"UserName\" field.") if (!$in{'REG_UserName'});
	if (!$VerifyReg) {
		&ShowError("ACCOUNT CREATION ERROR","You forgot to fill the \"Password\" field.") if (!$in{'REG_Password'});
		&ShowError("ACCOUNT CREATION ERROR","You forgot to fill the \"Verfiy Password\" field.") if (!$in{'REG_VerfiyPassword'});

		&ShowError("ACCOUNT CREATION ERROR","Your Password only can contain characters or numbers.") if ($in{'REG_Password'}!~/^[A-Za-z0-9]+$/);
		&ShowError("ACCOUNT CREATION ERROR","Your Password must not more than 26 characters.") if (length($in{'REG_Password'})>26);
		&ShowError("ACCOUNT CREATION ERROR","Your Password must not less than 6 characters.") if (length($in{'REG_Password'})<6);

		&ShowError("ACCOUNT CREATION ERROR","Your Password is different than the Verfiy Password.") if ($in{'REG_Password'} ne $in{'REG_VerfiyPassword'});
	}else{
		$in{'REG_Password'}=&RandomPassword();
	}

	&ShowError("ACCOUNT CREATION ERROR","You forgot to fill the \"Nick Name\" field.") if (!$in{'REG_NickName'});
	&ShowError("ACCOUNT CREATION ERROR","You forgot to fill the \"Email\" field.") if (!$in{'REG_Email'});

	&ShowError("ACCOUNT CREATION ERROR","Your UserName must not contain any blank spaces, or special characters.") if ($in{'REG_UserName'}=~/\W/);
	&ShowError("ACCOUNT CREATION ERROR","Your UserName must not more than 26 characters.") if (length($in{'REG_UserName'})>26);
	&ShowError("ACCOUNT CREATION ERROR","Your UserName must not less than 2 characters.") if (length($in{'REG_UserName'})<2);

	&ShowError("ACCOUNT CREATION ERROR","Your Nick Name must not more than 20 characters.") if (length($in{'REG_NickName'})>20);
	&ShowError("ACCOUNT CREATION ERROR","Your Nick Name must not less than 4 characters.") if (length($in{'REG_NickName'})<4);		
	
	&ShowError("ACCOUNT CREATION ERROR","Your Email must not contain any blank spaces, and special characters.") if ($in{'REG_Email'}=~/[\!\#\$\%\^\&\*\(\)\{\}\;\:\'\`]/);
	&ShowError("ACCOUNT CREATION ERROR","Your Email format is wrong.") if ($in{'REG_Email'}!~/.*\@.*\..*/);
	
	&ShowError("ACCOUNT CREATION ERROR","Your HomePage address format is wrong.") if (($in{'REG_HomePage'}!~/^http:\/\/.*/)&&($in{'REG_HomePage'}));

	&ShowError("ACCOUNT CREATION ERROR","Your Age only contain numbers.") if (($in{'REG_Age'}=~/\D/)&&($in{'REG_Age'}));

	&ShowError("ACCOUNT CREATION ERROR","Your ICQ Numbers only contain numbers.") if (($in{'REG_ICQ'}=~/\D/)&&($in{'REG_ICQ'}));

    &ShowError("ACCOUNT CREATION ERROR","Your comments must not more than $CommentLength characters.") if (length($in{'REG_Comments'})>$CommentLength);
	&ShowError("ACCOUNT CREATION ERROR","Your signature must not more than $SignaturesLength characters.") if (length($in{'REG_Signature'})>$SignaturesLength);

	$in{'REG_UserName'}=lc($in{'REG_UserName'});
	&ShowError("ACCOUNT CREATION ERROR","Your UserName has been taken.") if (-e "$MembersPath/$in{'REG_UserName'}.info");
###############################################################################
	if ($CheckEmail) {
		open(DB,"$MembersPath/Members.email")||&CGIError("Couldn't open/read the Members.email file<br>\nPath: $MembersPath<br>\nReason : $!");
			flock(DB,1) if ($FLock);
			@MembersEmail=<DB>;
		close(DB);
		for (my($i)=0;$i<=$#MembersEmail;$i++) {
			chomp($MembersEmail[$i]);
			if ($MembersEmail[$i] =~/^$in{'REG_Email'}$/i) {
				&ShowError("ACCOUNT CREATION ERROR","Your Email address has been used once.");
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
	open(DB,">>$MembersPath/$DefaultGroup.grp")||&CGIError("Couldn't write the $DefaultGroup.grp file<br>\nPath: $MembersPath<br>\nReason : $!");
		flock(DB,2) if ($FLock);
		print DB $in{'REG_UserName'}."\n";
		flock(DB,8) if ($FLock);
	close(DB);
###############################################################################
	$RegTime=time;
	if ($ViewRegister) {
		$Status="Disactivate";
        if ($VerifyReg eq "") {
            $NewPassword=Crypt::crypt($in{'REG_Password'},substr($in{'REG_UserName'}, 0, 2));
        }
	}else{
		$Status="Activate";
        $NewPassword=Crypt::crypt($in{'REG_Password'},substr($in{'REG_UserName'}, 0, 2));
	}
    if (($ENV{'REMOTE_HOST'})&&($TrackIP=~/Host/)) {
		$IP=$ENV{'REMOTE_HOST'};
	}elsif ($TrackIP=~/IP/){
		$IP=$ENV{'REMOTE_ADDR'};
	}
	&SaveMemberData($in{'REG_UserName'},
					$in{'REG_UserName'},
					$in{'REG_NickName'},
					$NewPassword,
					$DefaultGroup,
					$in{'REG_Email'},
					"0",
					$Status,
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
                    $IP
	);
###############################################################################
	if ($ViewRegister) {
		open(DB,">>$MembersPath/Members.rev")||&CGIError("Couldn't write the Members.rev file<br>\nPath: $MembersPath<br>\nReason : $!");
			flock(DB,2) if ($FLock);
			print DB $in{'REG_UserName'}."\n";
			flock(DB,8) if ($FLock);
		close(DB);
		my ($Subject) = "New member has registered from $UBName";
		my ($Message) = "Hello,\n";
			$Message .= "New member($in{'REG_UserName'}) has registered at ".&GetDate($RegTime)."\n";
			$Message .= "You can approve or disapprove this members at\n";
			$Message .= "$URLCGI/UBAdmin.$Ext\n\n";
			$Message .= "Following is the new member information:\n";
			$Message .= "----------------------------------------\n";
			$Message .= "UserName: $in{'REG_UserName'}\n";
			$Message .= "NickName: $in{'REG_NickName'}\n";
			$Message .= "Email: $in{'REG_Email'}\n";
			$Message .= "HomePage: $in{'REG_HomePage'}\n";
			$Message .= "ICQ Number: $in{'REG_ICQ'}\n";
			$Message .= "Age: $in{'REG_Age'}\n";
			$Message .= "Location: ".&RemoveCensorWords($in{'REG_Location'})."\n";
			$Message .= "Qccupation: ".&RemoveCensorWords($in{'REG_Occupation'})."\n";
			$Message .= "Interests: ".&RemoveCensorWords($in{'REG_Interests'})."\n";
			$Message .= "Comment:\n".&RemoveCensorWords($in{'REG_Comments'})."\n";
			$Message .= "----------------------------------------\n";
			$Message .= "UltraBoard Administrative Center\n";
			$Message .= "Powered by UltraScripts.com\n";
		&SendMail($EmailAddress,$Subject,$Message,$EmailAddress);
	}else{
		my ($Subject, $Message);
		if ($NotifyRegister) {
			$Subject = "New member has registered from $UBName";
			$Message = "Hello,\n";
			$Message .= "New member($in{'REG_UserName'}) has registered at ".&GetDate($RegTime)."\n\n";
			$Message .= "Following is the new member information:\n";
			$Message .= "----------------------------------------\n";
			$Message .= "UserName: $in{'REG_UserName'}\n";
			$Message .= "NickName: $in{'REG_NickName'}\n";
			$Message .= "Email: $in{'REG_Email'}\n";
			$Message .= "HomePage: $in{'REG_HomePage'}\n";
			$Message .= "ICQ Number: $in{'REG_ICQ'}\n";
			$Message .= "Age: $in{'REG_Age'}\n";
			$Message .= "Location: ".&RemoveCensorWords($in{'REG_Location'})."\n";
			$Message .= "Qccupation: ".&RemoveCensorWords($in{'REG_Occupation'})."\n";
			$Message .= "Interests: ".&RemoveCensorWords($in{'REG_Interests'})."\n";
			$Message .= "Comment:\n".&RemoveCensorWords($in{'REG_Comments'})."\n";
			$Message .= "----------------------------------------\n";
			$Message .= "UltraBoard Administrative Center\n";
			$Message .= "Powered by UltraScripts.com\n";
			&SendMail($EmailAddress,$Subject,$Message,$EmailAddress);
		}
		if ($VerifyReg) {
			$Subject = "Registration information at $UBName ($URLSite)";
			$Message = "Hello, $in{'REG_NickName'}\n\n";
			$Message .= "Following is your login information:\n";
			$Message .= "------------------------------------\n";
			$Message .= "UserName: $in{'REG_UserName'}\n";
			$Message .= "Password: $in{'REG_Password'}\n";	
			$Message .= "------------------------------------\n";
			$Message .= "Thank you for registering our $UBName forum,\n";
			$Message .= "WebMaster, $UBName\n";
			$Message .= "$EmailAddress\n";
			$Message .= "$URLSite\n";
			$Message .= "------------------------------------\n";
			$Message .= "Powered by UltraScripts.com\n";
			&SendMail($EmailAddress,$Subject,$Message,$in{'REG_Email'});
		}
	}
###############################################################################
	if ($VerifyReg or $ViewRegister) {
		$in{'REG_Password'}="";
	}
	if (($in{'REG_Remember'})&&($in{'REG_Idle'} eq "default")) {
		print &CookiesHeader(time+31536000,"UserName",$in{'REG_UserName'},"Password",$in{'REG_Password'},"Idle","","Order","","Sort","");
	}elsif (($in{'REG_Remember'})&&($in{'REG_Idle'} ne "default")) {
		print &CookiesHeader(time+31536000,"UserName",$in{'REG_UserName'},"Password",$in{'REG_Password'},"Idle",$in{'REG_Idle'},"Order",$in{'REG_Order'},"Sort",$in{'REG_Sort'});
	}elsif ($in{'REG_Remember'}) {
		print &CookiesHeader(time+31536000,"UserName",$in{'REG_UserName'},"Password",$in{'REG_Password'});
	}elsif ($in{'REG_Idle'} eq "default") {
		print &CookiesHeader(time+31536000,"Idle","","Order","","Sort","");
	}elsif ($in{'REG_Idle'} ne "default") {
		print &CookiesHeader(time+31536000,"Idle",$in{'REG_Idle'},"Order",$in{'REG_Order'},"Sort",$in{'REG_Sort'});
	}
	if ($VerifyReg and $ViewRegister) {
		$Message=" You will recieve an e-mail with your password when your account has been verified by the administrator.";
	}elsif ($VerifyReg) {
		$Message=" You will recieve an e-mail with your password.<br>If you have not receive the password after 24 hours, please contact the administrator (".&Link("mailto:$EmailAddress","","").$EmailAddress."</a>".") for more information.";
	}elsif ($ViewRegister) {
		$Message=" You will recieve an e-mail when your account has been verified by the administrator.";
	}
	&ShowThank(	"ACCOUNT CREATED",
				"Your account has been created.$Message",
				"5",
				"UltraBoard.$Ext?Action=$in{'Ref'}&Category=$in{'Category'}&Board=$in{'Board'}&Post=$in{'Post'}&ID=$in{'ID'}&Idle=$in{'Idle'}&Sort=$in{'Sort'}&Order=$in{'Order'}&Page=$in{'Page'}"				
	);
	exit;
}
###############################################################################
1;# End of DoSignUp Function
###############################################################################