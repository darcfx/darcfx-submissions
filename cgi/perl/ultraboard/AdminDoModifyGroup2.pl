###############################################################################
# AdminDoModifyGroup2.pl                                                      #
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
# DoModifyGroup2                                                              #
###############################################################################
sub DoModifyGroup2 {
	&ShowError("MODIFYING PROBLEM","You forgot to select which group to modify.") if (!$in{'GroupID'});
	&ShowError("MODIFYING PROBLEM","You forgot to fill the name for the group.") if (!$in{'GroupName'});
###############################################################################
	open(GROUPS,"$MembersPath/Groups.db")||&CGIError("Couldn't open/read the Groups.db file<br>\nPath: $MembersPath<br>\nReason : $!");
		flock(GROUPS,1) if ($FLock);
		@GROUPS_DATA=<GROUPS>;
	close(GROUPS);
	for (my($i)=0;$i<=$#GROUPS_DATA;$i++) {
		@GroupInfo=&DecodeDBOutput($GROUPS_DATA[$i]);
		if ($GroupInfo[0] eq $in{'GroupID'}) {
			$GroupInfo[1]=$in{'GroupName'};
			$GROUPS_DATA[$i]=&EncodeDBInput(@GroupInfo);
			last;
		}
	}
	open(GROUP,">$MembersPath/Groups.db")||&CGIError("Couldn't create/write the Groups.db file<br>\nPath: $MembersPath<br>\nReason : $!");
		flock(GROUP,2) if ($FLock);
		print GROUP @GROUPS_DATA;
		flock(GROUP,8) if ($FLock);
	close(GROUP);

	open(GROUP,"$MembersPath/$in{'GroupID'}.grp")||&CGIError("Couldn't open/read the $in{'GroupID'}.grp file<br>\nPath: $MembersPath<br>\nReason : $!");
		flock(GROUP,1) if ($FLock);
		@GROUP_DATA=<GROUP>;
	close(GROUP);
	$GROUP_DATA[0]=&EncodeDBInput($in{'GroupID'},$in{'GroupName'});
	open(GROUP,">$MembersPath/$in{'GroupID'}.grp")||&CGIError("Couldn't create/write the $in{'GroupID'}.grp file<br>\nPath: $MembersPath<br>\nReason : $!");
		flock(GROUP,2) if ($FLock);
		print GROUP @GROUP_DATA;
		flock(GROUP,8) if ($FLock);
	close(GROUP);
###############################################################################
	&ShowThank(	"MODIFIED THE MEMBERS GROUP",
				"The $in{'GroupName'} ($in{'GroupID'}) members group has been modified.\n",
				"3",
				"UBAdmin.$Ext?Session=$SessionID"				
	);	
	exit;
}
###############################################################################
1;# End of DoModifyGroup2 Function
###############################################################################