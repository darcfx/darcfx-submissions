###############################################################################
# AdminDoRemoveBoards.pl                                                      #
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
# DoRemoveBoards                                                              #
###############################################################################
sub DoRemoveBoards {
	# Read data from the boards file
	open(BOARDS,"$DBPath/Boards.db")||&CGIError("Couldn't open/read the Boards.db file<br>\nPath: $DBPath<br>\nReason : $!");
		flock(BOARDS,1) if ($FLock);
		@BOARDS_DATA=<BOARDS>;
	close(BOARDS);
	for (my($i)=0,my($j,$k);$i<=$#BOARDS_DATA;$i++) {
		$Found=0;
		@BoardInfo=&DecodeDBOutput($BOARDS_DATA[$i]);
		for ($j=0;$j<$in{'Count'};$j++) {
			if ($BoardInfo[0] eq $in{"BoardID_".$j}) {
				# Read all files from the board directory
				opendir(DIR,"$DBPath/".$in{"BoardID_".$j})||&CGIError("Couldn't open/read the $DBPath/".$input{"BoardID_".$j}." directory<br>\nReason : $!");
					@FILES=readdir(DIR);
				closedir(DIR);			

				chdir("$DBPath/".$in{"BoardID_".$j});	# Change to board directory
				unlink(@FILES);							# Remove all the files of the board directory
				chdir("$DBPath");						# Change to data directory	
				rmdir("$DBPath/".$in{"BoardID_".$j});	# Remove the directory of the board
				
				# Remove the board from the category
				open(CATEGORY,"$DBPath/$BoardInfo[3].cat")||&CGIError("Couldn't open/read the $BoardInfo[3].cat file<br>\nPath: $DBPath<br>\nReason : $!");
					flock(CATEGORY,1) if ($FLock);
					@CATEGORY_DATA=<CATEGORY>;
				close(CATEGORY);
				open(CATEGORY,">$DBPath/$BoardInfo[3].cat")||&CGIError("Couldn't create/write the $BoardInfo[3].cat file<br>\nPath: $DBPath<br>\nReason : $!");
					flock(CATEGORY,1) if ($FLock);
					print CATEGORY $CATEGORY_DATA[0];
					for ($k=1;$k<=$#CATEGORY_DATA;$k++) {
						@CategoryInfo=&DecodeDBOutput($CATEGORY_DATA[$k]);
						if ($CategoryInfo[0] ne $in{"BoardID_".$j}) {
							print CATEGORY $CATEGORY_DATA[$k];
						}
					}
				close(CATEGORY);

				$Found=1;								# Set found the board
				last;									# Out of the for loop
			}
		}
		if ($Found != 1) {
			push (@BoardList, $BOARDS_DATA[$i]);	
		}
	}
	open(BOARDS,">$DBPath/Boards.db")||&CGIError("Couldn't create/write the Boards.db file<br>\nPath: $DBPath<br>\nReason : $!");
		flock(BOARDS,2) if ($FLock);
		print BOARDS @BoardList;
		flock(BOARDS,8) if ($FLock);
	close(BOARDS);
###############################################################################
	chdir($CGIPath);
	&ShowThank(	"REMOVED THOSE BOARDS",
				"Those boards have been removed.\n",
				"3",
				"UBAdmin.$Ext?Session=$SessionID"				
	);	
	exit;
}
###############################################################################
1;# End of DoRemoveBoards Function
###############################################################################