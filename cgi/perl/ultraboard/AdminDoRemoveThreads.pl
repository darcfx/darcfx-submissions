###############################################################################
# AdminDoRemoveThreads.pl                                                     #
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
# DoRemoveThreads                                                             #
###############################################################################
sub DoRemoveThreads {
	require "$LibPath/SearchPostID.lib";
	for (my ($i)=0;$i<$in{'Count'};$i++) {
		if ($in{"PostID_".$i}) {
			($PostID, $BoardID)=split(/\Q$Spliter\E/,$in{"PostID_".$i});
			push (@{$Posts{$BoardID}},$PostID);
		}
	}
	foreach $BoardID (keys %Posts) {
		# Read Old Board List file
		open(BOARD,"$DBPath/$BoardID/board.list")||&CGIError("Couldn't open/read the board.list file<br>\nPath: $DBPath/$BoardID<br>\nReason : $!");
			flock(BOARD,1) if ($FLock);
			@BOARD_DATA=<BOARD>;
		close(BOARD);
		# Read Old Board Counter file
		open(COUNT,"$DBPath/$BoardID/board.count")||&CGIError("Couldn't open/read the board.count file<br>\nPath: $DBPath/$BoardID<br>\nReason : $!");
			flock(COUNT,1) if ($FLock);
			@COUNT_DATA=&DecodeDBOutput(<COUNT>);
		close(COUNT);

		$TotalPosts=@BOARD_DATA;
		
		foreach $PostID (@{$Posts{$BoardID}}) {
			$PostPos = &SearchPostID($PostID);
			if ($PostPos > 0) {
				# Board Counter
				$COUNT_DATA[1]--;
				$COUNT_DATA[2]--;
				$COUNT_DATA[2]-=$PostInfo[2];
				# Delete Post in Posts List
				$BOARD_DATA[$PostPos]="";
				# Delete Post
				unlink("$DBPath/$BoardID/$PostID.post");
			}
		}			

		# Save the Old Board Counter file
		open(COUNT,">$DBPath/$BoardID/board.count")||&CGIError("Couldn't create/write the board.count file<br>\nPath: $DBPath/$BoardID<br>\nReason : $!");
			flock(COUNT,2) if ($FLock);
				print COUNT &EncodeDBInput(@COUNT_DATA);
			flock(COUNT,8) if ($FLock);
		close(COUNT);
		# Save the Old Board List file
		open(BOARD,">$DBPath/$BoardID/board.list")||&CGIError("Couldn't create/write the board.list file<br>\nPath: $DBPath/$BoardID<br>\nReason : $!");
			flock(BOARD,2) if ($FLock);
				print BOARD @BOARD_DATA;
			flock(BOARD,8) if ($FLock);
		close(BOARD);
	}
###############################################################################
	&ShowThank(	"REMOVED THOSE THREADS",
				"Those threads have been removed.\n",
				"3",
				"UBAdmin.$Ext?Action=ManageMessages&Session=$SessionID"				
	);	
	exit;
}
###############################################################################
1;# End of DoRemoveThreads Function
###############################################################################