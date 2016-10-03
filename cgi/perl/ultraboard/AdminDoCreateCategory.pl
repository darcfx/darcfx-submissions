###############################################################################
# AdminDoCreateCategory.pl                                                    #
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
# DoCreateCategory                                                            #
###############################################################################
sub DoCreateCategory {
	&ShowError("CREATING PROBLEM","You forgot to fill the id for the category.") if (!$in{'ID'});
	&ShowError("CREATING PROBLEM","You forgot to fill the name for the category.") if (!$in{'Name'});
	&ShowError("CREATING PROBLEM","the category id must not contain any blank spaces, and special characters.") if ($in{'ID'}=~/\W/);
	&ShowError("CREATING PROBLEM","the id for the category has been taken.") if (-e "$DBPath/$in{'ID'}.cat");
###############################################################################	
	open(CATEGORIES,">>$DBPath/Categories.db")||&CGIError("Couldn't write the Categories.db file<br>\nPath: $DBPath<br>\nReason : $!");
		flock(CATEGORIES,2) if ($FLock);
		print CATEGORIES &EncodeDBInput($in{'ID'},$in{'Name'},$in{'Description'});
		flock(CATEGORIES,8) if ($FLock);
	close(CATEGORIES);
	open(CATEGORY,">$DBPath/$in{'ID'}.cat")||&CGIError("Couldn't create/write the $in{'ID'}.cat file<br>\nPath: $DBPath<br>\nReason : $!");
		flock(CATEGORY,2) if ($FLock);
		print CATEGORY &EncodeDBInput($in{'ID'},$in{'Name'},$in{'Description'});
		flock(CATEGORY,8) if ($FLock);
	close(CATEGORY);

	if (!$in{'AllGroups'}) {
		open(ACCESS,">$DBPath/$in{'ID'}.acc")||&CGIError("Couldn't create/read the $in{'ID'}.acc file<br>\nPath: $DBPath<br>\nReason : $!");
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
	&ShowThank(	"CREATED A NEW CATEGORY",
				"The $in{'Name'} ($in{'ID'}) category has been created.\n",
				"3",
				"UBAdmin.$Ext?Session=$SessionID"				
	);	
	exit;
}
###############################################################################
1;# End of DoCreateCategory Function
###############################################################################