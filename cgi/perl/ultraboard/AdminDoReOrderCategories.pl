###############################################################################
# AdminDoReOrderCategories.pl                                                 #
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
# DoReOrderCategories                                                         #
###############################################################################
sub DoReOrderCategories {
	open(CATEGORIES,"$DBPath/Categories.db")||&CGIError("Couldn't open/read the Categories.db file<br>\nPath: $DBPath<br>\nReason : $!");
		flock(CATEGORIES,1) if ($FLock);
		@CATEGORIES_DATA=<CATEGORIES>;
	close(CATEGORIES);
	for (my ($i)=0;$i<=$#CATEGORIES_DATA;$i++) {
		@CategoryInfo=&DecodeDBOutput($CATEGORIES_DATA[$i]);
		$Categories{$CategoryInfo[0]}=$CATEGORIES_DATA[$i];
	}
	for ($i=1;$i<=scalar(@CATEGORIES_DATA);$i++) {
		foreach $Category (keys %Categories) {
			if ($in{"Category_".$Category} == $i) {
				push (@CategoryList, $Categories{$Category});
			}
		}
	}
	open(CATEGORIES,">$DBPath/Categories.db")||&CGIError("Couldn't create/write the Categories.db file<br>\nPath: $DBPath<br>\nReason : $!");
		flock(CATEGORIES,2) if ($FLock);
		print CATEGORIES @CategoryList;
		flock(CATEGORIES,8) if ($FLock);
	close(CATEGORIES);
###############################################################################
	&ShowThank(	"REORDERED THOSE CATEGORIES",
				"Those categories have been reordered.\n",
				"3",
				"UBAdmin.$Ext?Session=$SessionID"				
	);	
	exit;
}
###############################################################################
1;# End of DoReOrderCategories Function
###############################################################################