###############################################################################
# AdminDoModifyAccount2.pl                                                    #
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
# DoModifyAccount2                                                            #
###############################################################################
sub DoModifyAccount2 {
	#&ShowError("ACCOUNT CREATION ERROR","You forgot to fill the \"New Password\" field.") if (!$in{'MOD_NewPassword'});
	#&ShowError("ACCOUNT CREATION ERROR","You forgot to fill the \"Verfiy New Password\" field.") if (!$in{'MOD_VerfiyNewPassword'});

	if ($in{'MOD_NewPassword'} ne "") {
		&ShowError("ACCOUNT CREATION ERROR","The New Password only can contain characters or numbers.") if ($in{'MOD_NewPassword'}!~/^[A-Za-z0-9]+$/);
		&ShowError("ACCOUNT CREATION ERROR","The New Password must not more than 26 characters.") if (length($in{'MOD_NewPassword'})>26);
		&ShowError("ACCOUNT CREATION ERROR","The New Password must not less than 6 characters.") if (length($in{'MOD_NewPassword'})<6);
	}

	&ShowError("ACCOUNT CREATION ERROR","The New Password is different than the Verfiy New Password.") if ($in{'MOD_NewPassword'} ne $in{'MOD_VerfiyNewPassword'});

	&ShowError("ACCOUNT CREATION ERROR","You forgot to fill the \"Nick Name\" field.") if (!$in{'MOD_NickName'});
	&ShowError("ACCOUNT CREATION ERROR","You forgot to fill the \"Email\" field.") if (!$in{'MOD_Email'});

	&ShowError("ACCOUNT CREATION ERROR","The Nick Name must not more than 20 characters.") if (length($in{'MOD_NickName'})>20);
	&ShowError("ACCOUNT CREATION ERROR","The Nick Name must not less than 4 characters.") if (length($in{'MOD_NickName'})<4);		
	
	&ShowError("ACCOUNT CREATION ERROR","The Email must not contain any blank spaces, and special characters.") if ($in{'MOD_Email'}=~/[\!\#\$\%\^\&\*\(\)\{\}\;\:\'\`]/);
	&ShowError("ACCOUNT CREATION ERROR","The Email format is wrong.") if ($in{'MOD_Email'}!~/.*\@.*\..*/);
	
	&ShowError("ACCOUNT CREATION ERROR","The HomePage address format is wrong.") if (($in{'MOD_HomePage'}!~/^http:\/\/.*/)&&($in{'MOD_HomePage'}));

	&ShowError("ACCOUNT CREATION ERROR","The Age only contain numbers.") if (($in{'MOD_Age'}=~/\D/)&&($in{'MOD_Age'}));

	&ShowError("ACCOUNT CREATION ERROR","The ICQ Numbers only contain numbers.") if (($in{'MOD_ICQ'}=~/\D/)&&($in{'MOD_ICQ'}));

	&ShowError("ACCOUNT CREATION ERROR","The comments must not more than $CommentLength characters.") if (length($in{'MOD_Comments'})>$CommentLength);
	&ShowError("ACCOUNT CREATION ERROR","The signature must not more than $SignaturesLength characters.") if (length($in{'MOD_Signature'})>$SignaturesLength);

	$in{'MemberID'}=lc($in{'MemberID'});
###############################################################################
	@MemberInfo=&GetMemberData($in{'MemberID'});
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
                    &ShowError("ACCOUNT CREATION ERROR","The Email address has been used once.");
                }
                push (@EmailList,$MembersEmail[$i]);
            }
        }
        $EmailDATA=join("\n",@EmailList);
        open(DB,">$MembersPath/Members.email")||&CGIError("Couldn't create/write the Members.email file<br>\nPath: $MembersPath<br>\nReason : $!");
            flock(DB,2) if ($FLock);
            print DB $EmailDATA."\n";
			print DB $in{'MOD_Email'}."\n";
            flock(DB,8) if ($FLock);
        close(DB);
    }
###############################################################################
    if ($in{'OldGroup'} ne $in{'MOD_Group'}) {
        open(GROUP,"$MembersPath/$in{'OldGroup'}.grp")||&CGIError("Couldn't read/open the $in{'OldGroup'}.grp file<br>\nPath: $MembersPath<br>\nReason : $!");
            flock(GROUP,1) if ($FLock);
            @GROUP_DATA=<GROUP>;
        close(GROUP);
        for ($j=1;$j<=$#GROUP_DATA;$j++) {
            $Group=$GROUP_DATA[$j];
            chomp($Group);
            if ($Group=~/^$in{'MemberID'}$/i) {
                $GROUP_DATA[$j]="";
                last;
            }
        }
        open(GROUP,">$MembersPath/$in{'OldGroup'}.grp")||&CGIError("Couldn't create/write the $in{'OldGroup'}.grp file<br>\nPath: $MembersPath<br>\nReason : $!");
            flock(GROUP,2) if ($FLock);
            print GROUP @GROUP_DATA;
            flock(GROUP,8) if ($FLock);
        close(GROUP);
        open(DB,">>$MembersPath/$in{'MOD_Group'}.grp")||&CGIError("Couldn't write the $in{'MOD_Group'}.grp file<br>\nPath: $MembersPath<br>\nReason : $!");
            flock(DB,2) if ($FLock);
            print DB $in{'MemberID'}."\n";
            flock(DB,8) if ($FLock);
        close(DB);
    }
###############################################################################
	if ($in{'MOD_NewPassword'} ne "") {
		$EPassword=Crypt::crypt($in{'MOD_NewPassword'},substr($in{'MemberID'}, 0, 2));
	}else{
		$EPassword=$MemberInfo[2];
	}
	&SaveMemberData($in{'MemberID'},
					$in{'MemberID'},
					$in{'MOD_NickName'},
					$EPassword,
					$in{'MOD_Group'},
					$in{'MOD_Email'},
					$MemberInfo[5],
					$in{'MOD_Status'},
					$MemberInfo[7],
					$in{'MOD_HomePage'},
					&RemoveCensorWords($in{'MOD_Location'}),
					$in{'MOD_Age'},
					&RemoveCensorWords($in{'MOD_Occupation'}),
					&RemoveCensorWords($in{'MOD_Interests'}),
					$in{'MOD_ICQ'},
					&RemoveCensorWords($in{'MOD_Comments'}),
					&RemoveCensorWords($in{'MOD_Signature'}),
					$MemberInfo[16],
					$in{'MOD_ShowEmail'},
                    $MemberInfo[18]
	);
###############################################################################
	&ShowThank(	"MODIFIED THE MEMBER ACCOUNT",
				"The member account has been modified.",
				"3",
				"UBAdmin.$Ext?Action=ManageAccounts&Session=$SessionID"
	);
	exit;
}
###############################################################################
1;# End of DoModifyAccount2 Function
###############################################################################