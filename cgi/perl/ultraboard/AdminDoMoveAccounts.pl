###############################################################################
# AdminDoMoveAccounts.pl                                                      #
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
# DoMoveAccounts                                                              #
###############################################################################
sub DoMoveAccounts {
	for (my ($i)=0;$i<$in{'Count'};$i++) {
		if ($in{"MemberID_".$i}) {
			($MemberID, $GroupID)=split(/\Q$Spliter\E/,$in{"MemberID_".$i});
			$Groups{$GroupID}.="\|".$MemberID."\|";
		}
	}
	foreach $GroupID (keys %Groups) {
		if ($GroupID ne $in{'ToGroup'}) {
			open(GROUP,"$MembersPath/$GroupID.grp")||&CGIError("Couldn't read/open the $GroupID.grp file<br>\nPath: $MembersPath<br>\nReason : $!");
				flock(GROUP,1) if ($FLock);
				@GROUP_DATA=<GROUP>;
			close(GROUP);
			for ($i=1;$i<=$#GROUP_DATA;$i++) {
				$MemberID=$GROUP_DATA[$i];
				chomp($MemberID);
				if ($Groups{$GroupID}=~/\|$MemberID\|/i) {
					$MemberList.=$GROUP_DATA[$i];
					@MemberInfo=&GetMemberData($MemberID);
					$MemberInfo[3]=$in{'ToGroup'};
					&SaveMemberData($MemberID,@MemberInfo);
					$GROUP_DATA[$i]="";
				}
			}
			open(GROUP,">$MembersPath/$GroupID.grp")||&CGIError("Couldn't create/write the $GroupID.grp file<br>\nPath: $MembersPath<br>\nReason : $!");
				flock(GROUP,2) if ($FLock);
				print GROUP @GROUP_DATA;
				flock(GROUP,8) if ($FLock);
			close(GROUP);
		}
	}
	open(GROUP,">>$MembersPath/$in{'ToGroup'}.grp")||&CGIError("Couldn't write the $in{'ToGroup'}.grp file<br>\nPath: $MembersPath<br>\nReason : $!");
		flock(GROUP,2) if ($FLock);
		print GROUP $MemberList;
		flock(GROUP,8) if ($FLock);
	close(GROUP);
###############################################################################
	&ShowThank(	"MOVED THOSE MEMBERS ACCOUNT",
				"Those members account have been moved.\n",
				"3",
				"UBAdmin.$Ext?Action=ManageAccounts&Session=$SessionID"				
	);	
	exit;
}
###############################################################################
1;# End of DoMoveAccounts Function
###############################################################################