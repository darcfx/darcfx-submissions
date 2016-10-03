###############################################################################
# DoModifyAccount.pl                                                          #
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
# DoModifyAccount                                                             #
###############################################################################
sub DoModifyAccount {
	if (($Group eq "Guest")||(!$Group)) {
        print "Location: UltraBoard.$Ext?Action=SignIn&Ref=ModifyAccount&Idle=$in{'Idle'}&Sort=$in{'Sort'}&Order=$in{'Order'}&Page=$in{'Page'}\n\n";
		exit;
	}
	#&ShowError("ACCOUNT CREATION ERROR","You forgot to fill the \"New Password\" field.") if (!$in{'MOD_NewPassword'});
	#&ShowError("ACCOUNT CREATION ERROR","You forgot to fill the \"Verfiy New Password\" field.") if (!$in{'MOD_VerfiyNewPassword'});
	if ($in{'MOD_NewPassword'} ne "") {
		&ShowError("ACCOUNT CREATION ERROR","Your New Password only can contain characters or numbers.") if ($in{'MOD_NewPassword'}!~/^[A-Za-z0-9]+$/);
		&ShowError("ACCOUNT CREATION ERROR","Your New Password must not more than 26 characters.") if (length($in{'MOD_NewPassword'})>26);
		&ShowError("ACCOUNT CREATION ERROR","Your New Password must not less than 6 characters.") if (length($in{'MOD_NewPassword'})<6);
	}

	&ShowError("ACCOUNT CREATION ERROR","Your New Password is different than the Verfiy New Password.") if ($in{'MOD_NewPassword'} ne $in{'MOD_VerfiyNewPassword'});

	&ShowError("ACCOUNT CREATION ERROR","You forgot to fill the \"Nick Name\" field.") if (!$in{'MOD_NickName'});
	&ShowError("ACCOUNT CREATION ERROR","You forgot to fill the \"Email\" field.") if (!$in{'MOD_Email'});

	&ShowError("ACCOUNT CREATION ERROR","Your Nick Name must not more than 20 characters.") if (length($in{'MOD_NickName'})>20);
	&ShowError("ACCOUNT CREATION ERROR","Your Nick Name must not less than 4 characters.") if (length($in{'MOD_NickName'})<4);		
	
	&ShowError("ACCOUNT CREATION ERROR","Your Email must not contain any blank spaces, and special characters.") if ($in{'MOD_Email'}=~/[\!\#\$\%\^\&\*\(\)\{\}\;\:\'\`]/);
	&ShowError("ACCOUNT CREATION ERROR","Your Email format is wrong.") if ($in{'MOD_Email'}!~/.*\@.*\..*/);
	
	&ShowError("ACCOUNT CREATION ERROR","Your HomePage address format is wrong.") if (($in{'MOD_HomePage'}!~/^http:\/\/.*/)&&($in{'MOD_HomePage'}));

	&ShowError("ACCOUNT CREATION ERROR","Your Age only contain numbers.") if (($in{'MOD_Age'}=~/\D/)&&($in{'MOD_Age'}));

	&ShowError("ACCOUNT CREATION ERROR","Your ICQ Numbers only contain numbers.") if (($in{'MOD_ICQ'}=~/\D/)&&($in{'MOD_ICQ'}));

    &ShowError("ACCOUNT CREATION ERROR","Your comments must not more than $CommentLength characters.") if (length($in{'MOD_Comments'})>$CommentLength);
	&ShowError("ACCOUNT CREATION ERROR","Your signature must not more than $SignaturesLength characters.") if (length($in{'MOD_Signature'})>$SignaturesLength);

	$UserName=lc($UserName);
###############################################################################
    if ($in{'OldEmail'} ne $in{'MOD_Email'}) {
        open(DB,"$MembersPath/Members.email")||&CGIError("Couldn't open/read the Members.email file<br>\nPath: $MembersPath<br>\nReason : $!");
            flock(DB,1) if ($FLock);
            @MembersEmail=<DB>;
        close(DB);
        @EmailList=();
        for (my($i)=0;$i<=$#MembersEmail;$i++) {
            chomp($MembersEmail[$i]);
            if ($MembersEmail[$i] !~/^$in{'OldEmail'}$/i) {
                if (($MembersEmail[$i] =~/^$in{'MOD_Email'}$/i)&&($CheckEmail)) {
                    &ShowError("ACCOUNT CREATION ERROR","Your Email address has been used once.");
                }
                push (@EmailList,$MembersEmail[$i]);
            }
        }
        push (@EmailList,$in{'MOD_Email'});
        $EmailDATA=join("\n",@EmailList);
        open(DB,">$MembersPath/Members.email")||&CGIError("Couldn't create/write the Members.email file<br>\nPath: $MembersPath<br>\nReason : $!");
            flock(DB,2) if ($FLock);
            print DB $EmailDATA."\n";
            flock(DB,8) if ($FLock);
        close(DB);
    }
###############################################################################
	if ($in{'MOD_NewPassword'} ne "") {
		$NewPassword=$in{'MOD_NewPassword'};
		$EPassword=Crypt::crypt($NewPassword,substr($UserName, 0, 2));
	}else{
		$NewPassword=$Password;
		$EPassword=$MemberData[2];
	}
    if (($ENV{'REMOTE_HOST'})&&($TrackIP=~/Host/)) {
		$IP=$ENV{'REMOTE_HOST'};
	}elsif ($TrackIP=~/IP/){
		$IP=$ENV{'REMOTE_ADDR'};
	}
	&SaveMemberData($UserName,
					$UserName,
					$in{'MOD_NickName'},
					$EPassword,
					$MemberData[3],
					$in{'MOD_Email'},
					$MemberData[5],
					$MemberData[6],
					$MemberData[7],
					$in{'MOD_HomePage'},
					&RemoveCensorWords($in{'MOD_Location'}),
					$in{'MOD_Age'},
					&RemoveCensorWords($in{'MOD_Occupation'}),
					&RemoveCensorWords($in{'MOD_Interests'}),
					$in{'MOD_ICQ'},
					&RemoveCensorWords($in{'MOD_Comments'}),
					&RemoveCensorWords($in{'MOD_Signature'}),
					$MemberData[16],
					$in{'MOD_ShowEmail'},
                    $IP
	);
###############################################################################
	if ($in{'MOD_Idle'} ne "default") {
		$in{'Idle'}=$in{'MOD_Idle'};
		$in{'Sort'}=$in{'MOD_Sort'};
		$in{'Order'}=$in{'MOD_Order'};
	}
	if (($in{'MOD_Remember'})&&($in{'MOD_Idle'} eq "default")) {
		print &CookiesHeader(time+31536000,"UserName",$UserName,"Password",$NewPassword,"Idle","","Order","","Sort","");
	}elsif (($in{'MOD_Remember'})&&($in{'MOD_Idle'} ne "default")) {
		print &CookiesHeader(time+31536000,"UserName",$UserName,"Password",$NewPassword,"Idle",$in{'MOD_Idle'},"Order",$in{'MOD_Order'},"Sort",$in{'MOD_Sort'});
	}elsif ($in{'MOD_Remember'}) {
		print &CookiesHeader(time+31536000,"UserName",$UserName,"Password",$NewPassword);
	}elsif ($in{'MOD_Idle'} eq "default") {
		print &CookiesHeader(time+31536000,"Idle","","Order","","Sort","");
	}elsif ($in{'MOD_Idle'} ne "default") {
		print &CookiesHeader(time+31536000,"Idle",$in{'MOD_Idle'},"Order",$in{'MOD_Order'},"Sort",$in{'MOD_Sort'});
	}
	&ShowThank(	"MODIFIED YOUR ACCOUNT",
				"Your account has been modified.",
				"3",
				"UltraBoard.$Ext?Action=$in{'Ref'}&Category=$in{'Category'}&Board=$in{'Board'}&Post=$in{'Post'}&ID=$in{'ID'}&Idle=$in{'Idle'}&Sort=$in{'Sort'}&Order=$in{'Order'}&Page=$in{'Page'}&Session=$SessionID"				
	);
	exit;
}
###############################################################################
1;# End of DoModifyAccount Function
###############################################################################