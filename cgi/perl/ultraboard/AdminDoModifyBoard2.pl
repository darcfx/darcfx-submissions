###############################################################################
# AdminDoModifyBoard2.pl                                                      #
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
# DoModifyBoard2                                                              #
###############################################################################
sub DoModifyBoard2 {
	&ShowError("MODIFYING PROBLEM","You forgot to fill the id for the board.") if (!$in{'BoardID'});
	&ShowError("MODIFYING PROBLEM","You forgot to fill the name for the board.") if (!$in{'BoardName'});
	&ShowError("MODIFYING PROBLEM","You forgot to select the category for the board.") if (!$in{'BoardCategory'});
###############################################################################	
	# Check Status of the board
	if ($in{'AllGroupsRead'} and $in{'AllGroupsPost'}) {
		$Type="Public";
	}elsif ($in{'AllGroupsRead'}) {
		$Type="Protected";
	}elsif (!$in{'AllGroupsRead'} and !$in{'AllGroupsPost'}) {
		$Type="Private";
	}
	# Make a data line
	$InputLine=&EncodeDBInput($in{'BoardID'},$in{'BoardName'},$in{'BoardDescription'},$in{'BoardCategory'},$in{'BoardModerators'},$in{'BoardStatus'},$Type);

	# Change the Boards file
	open(BOARDS,"$DBPath/Boards.db")||&CGIError("Couldn't open/read the Boards.db file<br>\nPath: $DBPath<br>\nReason : $!");
		flock(BOARDS,1) if ($FLock);
		@BOARDS_DATA=<BOARDS>;
	close(BOARDS);
	for (my($i)=0;$i<=$#BOARDS_DATA;$i++) {
		@BoardInfo=&DecodeDBOutput($BOARDS_DATA[$i]);
		if ($BoardInfo[0] eq $in{'BoardID'}) {
			$BOARDS_DATA[$i]=$InputLine;
			last;
		}
	}
	open(BOARDS,">$DBPath/Boards.db")||&CGIError("Couldn't create/write the Boards.db file<br>\nPath: $DBPath<br>\nReason : $!");
		flock(BOARDS,2) if ($FLock);
		print BOARDS @BOARDS_DATA;
		flock(BOARDS,8) if ($FLock);
	close(BOARDS);
	# Check the category is it changed
	if ($in{'BoardCategory'} eq $BoardInfo[3]) {
		# Change the category file
		open(CATEGORY,"$DBPath/$in{'BoardCategory'}.cat")||&CGIError("Couldn't open/read the $in{'BoardCategory'}.cat file<br>\nPath: $DBPath<br>\nReason : $!");
			flock(CATEGORY,1) if ($FLock);
			@CATEGORY_DATA=<CATEGORY>;
		close(CATEGORY);
		for ($i=0;$i<=$#CATEGORY_DATA;$i++) {
			@CategoryInfo=&DecodeDBOutput($CATEGORY_DATA[$i]);
			if ($CategoryInfo[0] eq $in{'BoardID'}) {
				$CATEGORY_DATA[$i]=$InputLine;
				last;
			}
		}
		open(CATEGORY,">$DBPath/$in{'BoardCategory'}.cat")||&CGIError("Couldn't create/read the $in{'BoardCategory'}.cat file<br>\nPath: $DBPath<br>\nReason : $!");
			flock(CATEGORY,2) if ($FLock);
			print CATEGORY @CATEGORY_DATA;
			flock(CATEGORY,8) if ($FLock);
		close(CATEGORY);
	}else{
		# Delete the board info in the old category file
		open(CATEGORY,"$DBPath/$BoardInfo[3].cat")||&CGIError("Couldn't open/read the $BoardInfo[3].cat file<br>\nPath: $DBPath<br>\nReason : $!");
			flock(CATEGORY,1) if ($FLock);
			@CATEGORY_DATA=<CATEGORY>;
		close(CATEGORY);
		for ($i=0;$i<=$#CATEGORY_DATA;$i++) {
			@CategoryInfo=&DecodeDBOutput($CATEGORY_DATA[$i]);
			if ($CategoryInfo[0] ne $in{'BoardID'}) {
				push (@CategoryList, $CATEGORY_DATA[$i]);
			}
		}
		open(CATEGORY,">$DBPath/$BoardInfo[3].cat")||&CGIError("Couldn't create/read the $BoardInfo[3].cat file<br>\nPath: $DBPath<br>\nReason : $!");
			flock(CATEGORY,2) if ($FLock);
			print CATEGORY @CategoryList;
			flock(CATEGORY,8) if ($FLock);
		close(CATEGORY);
		# Put the board info in the new category file
		open(CATEGORY,">>$DBPath/$in{'BoardCategory'}.cat")||&CGIError("Couldn't write the $in{'BoardCategory'}.cat file<br>\nPath: $DBPath<br>\nReason : $!");
			flock(CATEGORY,2) if ($FLock);
			print CATEGORY $InputLine;
			flock(CATEGORY,8) if ($FLock);
		close(CATEGORY);
	}
	# Change the Board file
	open(BOARD,"$DBPath/$in{'BoardID'}/board.list")||&CGIError("Couldn't open/read the board.list file<br>\nPath: $DBPath/$in{'BoardID'}<br>\nReason : $!");
		flock(BOARD,1) if ($FLock);
		@BOARD_DATA=<BOARD>;
	close(BOARD);
	$BOARD_DATA[0]=$InputLine;
	open(BOARD,">$DBPath/$in{'BoardID'}/board.list")||&CGIError("Couldn't create/read the board.list file<br>\nPath: $DBPath/$in{'BoardID'}<br>\nReason : $!");
		flock(BOARD,2) if ($FLock);
		print BOARD @BOARD_DATA;
		flock(BOARD,8) if ($FLock);
	close(BOARD);
	# Put the members status in access.db file of the board directory
	if ($Type eq "Private") {
		open(ACCESS,">$DBPath/$in{'BoardID'}/Access.db")||&CGIError("Couldn't create/read the Access.db file<br>\nPath: $DBPath/$in{'BoardID'}<br>\nReason : $!");
			flock(ACCESS,2) if ($FLock);
			print ACCESS "\%Access={};\n";
			for ($i=1;$i<=$in{'Count'};$i++) {
				if ($in{"ReadGroupID_".$i} and $in{"PostGroupID_".$i}) {
					print ACCESS "\$Access{'".$in{"ReadGroupID_".$i}."'}=\"FullAccess\";\n";
				}elsif ($in{"ReadGroupID_".$i}) {
					print ACCESS "\$Access{'".$in{"ReadGroupID_".$i}."'}=\"ReadOnly\";\n";
				}
			}
			print ACCESS "1;";
			flock(ACCESS,8) if ($FLock);
		close(ACCESS);
	}else{
		if (-e "$DBPath/$in{'BoardID'}/Access.db") {
			unlink ("$DBPath/$in{'BoardID'}/Access.db");
		}
	}
###############################################################################
	&ShowThank(	"MODIFY THE BOARD",
				"The $in{'BoardName'} ($in{'BoardID'}) board has been modified.\n",
				"3",
				"UBAdmin.$Ext?Session=$SessionID"				
	);	
	exit;
}
###############################################################################
1;# End of DoModifyBoard2 Function
###############################################################################