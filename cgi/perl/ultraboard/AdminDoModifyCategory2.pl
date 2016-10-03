###############################################################################
# AdminDoModifyCategory2.pl                                                   #
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
# DoModifyCategory2                                                           #
###############################################################################
sub DoModifyCategory2 {
	&ShowError("MODIFYING PROBLEM","You forgot to select which category to modify.") if (!$in{'CategoryID'});
	&ShowError("MODIFYING PROBLEM","You forgot to fill the name for the category.") if (!$in{'CategoryName'});
###############################################################################
	open(CATEGORIES,"$DBPath/Categories.db")||&CGIError("Couldn't open/read the Categories.db file<br>\nPath: $DBPath<br>\nReason : $!");
		flock(CATEGORIES,1) if ($FLock);
		@CATEGORIES_DATA=<CATEGORIES>;
	close(CATEGORIES);
	for (my($i)=0;$i<=$#CATEGORIES_DATA;$i++) {
		@CategoryInfo=&DecodeDBOutput($CATEGORIES_DATA[$i]);
		if ($CategoryInfo[0] eq $in{'CategoryID'}) {
			$CategoryInfo[1]=$in{'CategoryName'};
			$CategoryInfo[2]=$in{'CategoryDescription'};
			$CATEGORIES_DATA[$i]=&EncodeDBInput(@CategoryInfo);
			last;
		}
	}
	open(CATEGORIES,">$DBPath/Categories.db")||&CGIError("Couldn't create/write the Categories.db file<br>\nPath: $DBPath<br>\nReason : $!");
		flock(CATEGORIES,2) if ($FLock);
		print CATEGORIES @CATEGORIES_DATA;
		flock(CATEGORIES,8) if ($FLock);
	close(CATEGORIES);

	open(CATEGORY,"$DBPath/$in{'CategoryID'}.cat")||&CGIError("Couldn't open/read the $in{'CategoryID'}.cat file<br>\nPath: $DBPath<br>\nReason : $!");
		flock(CATEGORY,1) if ($FLock);
		@CATEGORY_DATA=<CATEGORY>;
	close(CATEGORY);
	$CATEGORY_DATA[0]=&EncodeDBInput(@CategoryInfo);
	open(CATEGORY,">$DBPath/$in{'CategoryID'}.cat")||&CGIError("Couldn't create/read the $in{'CategoryID'}.cat file<br>\nPath: $DBPath<br>\nReason : $!");
		flock(CATEGORY,2) if ($FLock);
		print CATEGORY @CATEGORY_DATA;
		flock(CATEGORY,8) if ($FLock);
	close(CATEGORY);

	if ($in{'AllGroups'}) {
		unlink ("$DBPath/$in{'CategoryID'}.acc");
	}else{
		open(ACCESS,">$DBPath/$in{'CategoryID'}.acc")||&CGIError("Couldn't create/read the $in{'CategoryID'}.acc file<br>\nPath: $DBPath<br>\nReason : $!");
			flock(ACCESS,2) if ($FLock);
			print ACCESS "\%ACCESS={};\n";
			for ($i=0;$i<=$in{'Count'};$i++) {
				if ($in{"GroupID_".$i}) {
					print ACCESS "\$ACCESS{'".$in{"GroupID_".$i}."'}=\"Visable\";\n";
				}
			}
			print ACCESS "1;";
			flock(ACCESS,8) if ($FLock);
		close(ACCESS);
	}
###############################################################################
	&ShowThank(	"MODIFIED THE CATEGORY",
				"The $in{'CategoryName'} ($in{'CategoryID'}) category has been modified.\n",
				"3",
				"UBAdmin.$Ext?Session=$SessionID"				
	);	
	exit;
}
###############################################################################
1;# End of DoModifyCategory2 Function
###############################################################################