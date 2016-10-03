###############################################################################
# AdminDoReOrderBoards.pl                                                     #
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
# DoReOrderBoards                                                             #
###############################################################################
sub DoReOrderBoards {
	open(CATEGORIES,"$DBPath/Categories.db")||&CGIError("Couldn't open/read the Categories.db file<br>\nPath: $DBPath<br>\nReason : $!");
		flock(CATEGORIES,1) if ($FLock);
		@CATEGORIES_DATA=<CATEGORIES>;
	close(CATEGORIES);
	#print &HTMLHeader();
	for (my ($i)=0,my($j);$i<=$#CATEGORIES_DATA;$i++) {
		@BoardList=();
		%Boards=();
		@CategoryInfo=&DecodeDBOutput($CATEGORIES_DATA[$i]);
		#print "$CategoryInfo[0]<br>\n";
		open(CATEGORY,"$DBPath/$CategoryInfo[0].cat")||&CGIError("Couldn't open/read the $CategoryInfo[0].cat file<br>\nPath: $DBPath<br>\nReason : $!");
			flock(CATEGORY,1) if ($FLock);
			@CATEGORY_DATA=<CATEGORY>;
		close(CATEGORY);
		#print "$CATEGORY_DATA[0]<br>\n";
		for ($j=1;$j<=$#CATEGORY_DATA;$j++) {
			@BoardInfo=&DecodeDBOutput($CATEGORY_DATA[$j]);
			#print "$BoardInfo[0]<br>\n";
			$Boards{$BoardInfo[0]}=$CATEGORY_DATA[$j];
		}
		for ($j=1;$j<=$#CATEGORY_DATA;$j++) {
			foreach $Board (keys %Boards) {
				#print "-$Board=".$in{"Board_".$Board}."<br>\n";
				if ($in{"Board_".$Board} == $j) {
					push (@BoardList, $Boards{$Board});
				}
			}
		}
		#print "@BoardList<br>\n";
		open(CATEGORY,">$DBPath/$CategoryInfo[0].cat")||&CGIError("Couldn't open/read the $CategoryInfo[0].cat file<br>\nPath: $DBPath<br>\nReason : $!");
			flock(CATEGORY,2) if ($FLock);
			print CATEGORY $CATEGORY_DATA[0];
			print CATEGORY @BoardList;
			flock(CATEGORY,8) if ($FLock);
		close(CATEGORY);
	}
###############################################################################
	&ShowThank(	"REORDERED THOSE BOARDS",
				"Those boards have been reordered.\n",
				"3",
				"UBAdmin.$Ext?Session=$SessionID"	
	);	
	exit;
}
###############################################################################
1;# End of DoReOrderBoards Function
###############################################################################