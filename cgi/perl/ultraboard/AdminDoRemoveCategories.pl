###############################################################################
# AdminDoRemoveCategories.pl                                                  #
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
# DoRemoveCategories                                                          #
###############################################################################
sub DoRemoveCategories {
	open(CATEGORIES,"$DBPath/Categories.db")||&CGIError("Couldn't open/read the Categories.db file<br>\nPath: $DBPath<br>\nReason : $!");
		flock(CATEGORIES,1) if ($FLock);
		@CATEGORIES_DATA=<CATEGORIES>;
	close(CATEGORIES);
	for (my($i)=0,my($j)=0;$i<=$#CATEGORIES_DATA;$i++) {
		$Found=0;
		@CategoryInfo=&DecodeDBOutput($CATEGORIES_DATA[$i]);
		for ($j=0;$j<$in{'Count'};$j++) {
			if ($CategoryInfo[0] eq $in{"CategoryID_".$j}) {
				unlink("$DBPath/".$in{"CategoryID_".$j}.".cat");
				$Found=1;
				last;
			}
		}
		if ($Found != 1) {
			push (@CategoryList, $CATEGORIES_DATA[$i]);
		}
	}
	open(CATEGORIES,">$DBPath/Categories.db")||&CGIError("Couldn't create/write the Categories.db file<br>\nPath: $DBPath<br>\nReason : $!");
		flock(CATEGORIES,2) if ($FLock);
		print CATEGORIES @CategoryList;
		flock(CATEGORIES,8) if ($FLock);
	close(CATEGORIES);
	
###############################################################################
	&ShowThank(	"REMOVED THOSE CATEGORIES",
				"Those categories have been removed.\n",
				"3",
				"UBAdmin.$Ext?Session=$SessionID"				
	);	
	exit;
}
###############################################################################
1;# End of DoRemoveCategories Function
###############################################################################