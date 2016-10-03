###############################################################################
# AdminDoRemoveAccounts.pl                                                    #
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
# DoRemoveAccounts                                                            #
###############################################################################
sub DoRemoveAccounts {
	for (my ($i)=0;$i<$in{'Count'};$i++) {
		if ($in{"MemberID_".$i} ne "") {
			@MemberInfo=&GetMemberData($in{"MemberID_".$i});
			open(DB,"$MembersPath/Members.total")||&CGIError("Couldn't open/read the Members.total file<br>\nPath: $MembersPath<br>\nReason : $!");
				flock(DB,1) if ($FLock);
				$TotalMembers=<DB>;
			close(DB);
			open(DB,">$MembersPath/Members.total")||&CGIError("Couldn't create/write the Members.total file<br>\nPath: $MembersPath<br>\nReason : $!");
				flock(DB,2) if ($FLock);
				print DB --$TotalMembers;
				flock(DB,8) if ($FLock);
			close(DB);

            open(DB,"$MembersPath/Members.email")||&CGIError("Couldn't open/read the Members.email file<br>\nPath: $MembersPath<br>\nReason : $!");
                flock(DB,1) if ($FLock);
                @MembersEmail=<DB>;
            close(DB);
            @EmailList=();
            for (my($j)=0;$j<=$#MembersEmail;$j++) {
                chomp($MembersEmail[$j]);
                if ($MembersEmail[$j] !~/^$MemberInfo[4]$/i) {
                    push (@EmailList,$MembersEmail[$j]);
                }
            }
            $EmailDATA=join("\n",@EmailList);
            open(DB,">$MembersPath/Members.email")||&CGIError("Couldn't create/write the Members.email file<br>\nPath: $MembersPath<br>\nReason : $!");
                flock(DB,2) if ($FLock);
                print DB $EmailDATA."\n";
                flock(DB,8) if ($FLock);
            close(DB);

			open(GROUP,"$MembersPath/$MemberInfo[3].grp")||&CGIError("Couldn't read/open the $MemberInfo[3].grp file<br>\nPath: $MembersPath<br>\nReason : $!");
				flock(GROUP,1) if ($FLock);
				@GROUP_DATA=<GROUP>;
			close(GROUP);
			for ($j=1;$j<=$#GROUP_DATA;$j++) {
				$Group=$GROUP_DATA[$j];
				chomp($Group);
				if ($Group=~/^$MemberInfo[0]$/i) {
					$GROUP_DATA[$j]="";
					last;
				}
			}
			open(GROUP,">$MembersPath/$MemberInfo[3].grp")||&CGIError("Couldn't create/write the $MemberInfo[3].grp file<br>\nPath: $MembersPath<br>\nReason : $!");
				flock(GROUP,2) if ($FLock);
				print GROUP @GROUP_DATA;
				flock(GROUP,8) if ($FLock);
			close(GROUP);
			unlink("$MembersPath/".$MemberInfo[0].".info");
		}
	}
###############################################################################
	&ShowThank(	"REMOVED THOSE MEMBERS ACCOUNT",
				"Those members account have been removed.\n",
				"3",
				"UBAdmin.$Ext?Action=ManageAccounts&Session=$SessionID"				
	);	
	exit;
}
###############################################################################
1;# End of DoRemoveAccounts Function
###############################################################################