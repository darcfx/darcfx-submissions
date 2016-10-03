###############################################################################
# AdminDoCreateGroup.pl                                                       #
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
# DoCreateGroup                                                               #
###############################################################################
sub DoCreateGroup {
	&ShowError("CREATING PROBLEM","You forgot to fill the id for the group.") if (!$in{'ID'});
	&ShowError("CREATING PROBLEM","You forgot to fill the name for the group.") if (!$in{'Name'});
	&ShowError("CREATING PROBLEM","the group id must not contain any blank spaces, and special characters.") if ($in{'ID'}=~/\W/);
	&ShowError("CREATING PROBLEM","the id for the group has been taken.") if (-e "$MembersPath/$in{'ID'}.grp");
###############################################################################	
	open(GROUP,">>$MembersPath/Groups.db")||&CGIError("Couldn't write the Groups.db file<br>\nPath: $MembersPath<br>\nReason : $!");
		flock(GROUP,2) if ($FLock);
		print GROUP &EncodeDBInput($in{'ID'},$in{'Name'});
		flock(GROUP,8) if ($FLock);
	close(GROUP);
	open(GROUP,">$MembersPath/$in{'ID'}.grp")||&CGIError("Couldn't create/write the $in{'ID'}.grp file<br>\nPath: $MembersPath<br>\nReason : $!");
		flock(GROUP,2) if ($FLock);
		print GROUP &EncodeDBInput($in{'ID'},$in{'Name'});
		flock(GROUP,8) if ($FLock);
	close(GROUP);
###############################################################################
	&ShowThank(	"CREATED A NEW MEMBERS GROUP",
				"The $in{'Name'} ($in{'ID'}) members group has been created.\n",
				"3",
				"UBAdmin.$Ext?Session=$SessionID"				
	);	
	exit;
}
###############################################################################
1;# End of DoCreateGroup Function
###############################################################################