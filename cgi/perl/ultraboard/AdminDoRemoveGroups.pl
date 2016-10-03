###############################################################################
# AdminDoRemoveGroups.pl                                                      #
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
# DoRemoveGroups                                                              #
###############################################################################
sub DoRemoveGroups {
	open(GROUPS,"$MembersPath/Groups.db")||&CGIError("Couldn't open/read the Groups.db file<br>\nPath: $MembersPath<br>\nReason : $!");
		flock(GROUPS,1) if ($FLock);
		@GROUPS_DATA=<GROUPS>;
	close(GROUPS);
	for (my($i)=0,my($j)=0;$i<=$#GROUPS_DATA;$i++) {
		$Found=0;
		@GroupInfo=&DecodeDBOutput($GROUPS_DATA[$i]);
		for ($j=0;$j<$in{'Count'};$j++) {
			if ($GroupInfo[0] eq $in{"GroupID_".$j}) {
				unlink("$MembersPath/".$in{"GroupID_".$j}.".grp");
				$Found=1;
				last;
			}
		}
		if ($Found != 1) {
			push (@GroupList, $GROUPS_DATA[$i]);
		}
	}
	open(GROUP,">$MembersPath/Groups.db")||&CGIError("Couldn't create/write the Groups.db file<br>\nPath: $MembersPath<br>\nReason : $!");
		flock(GROUP,2) if ($FLock);
		print GROUP @GroupList;
		flock(GROUP,8) if ($FLock);
	close(GROUP);
	
###############################################################################
	&ShowThank(	"REMOVED THOSE MEMBERS GROUPS",
				"Those members groups have been removed.\n",
				"3",
				"UBAdmin.$Ext?Session=$SessionID"				
	);	
	exit;
}
###############################################################################
1;# End of DoRemoveGroups Function
###############################################################################