###############################################################################
# AdminDoCreateBoard.pl                                                       #
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
# DoCreateBoard                                                               #
###############################################################################
sub DoCreateBoard {
	&ShowError("CREATING PROBLEM","You forgot to fill the id for the board.") if (!$in{'ID'});
	&ShowError("CREATING PROBLEM","You forgot to fill the name for the board.") if (!$in{'Name'});
	&ShowError("CREATING PROBLEM","You forgot to select the category for the board.") if (!$in{'Category'});
	&ShowError("CREATING PROBLEM","the board id must not contain any blank spaces, and special characters.") if ($in{'ID'}=~/\W/);
	&ShowError("CREATING PROBLEM","the id for the board has been taken.") if (-e "$DataPath/$in{'ID'}/");
###############################################################################	
	if ($in{'AllGroupsRead'} and $in{'AllGroupsPost'}) {
		$Type="Public";
	}elsif ($in{'AllGroupsRead'}) {
		$Type="Protected";
	}elsif (!$in{'AllGroupsRead'} and !$in{'AllGroupsPost'}) {
		$Type="Private";
	}
	$InputLine=&EncodeDBInput($in{'ID'},$in{'Name'},$in{'Description'},$in{'Category'},$in{'Moderators'},$in{'Status'},$Type);
	open(BOARDS,">>$DBPath/Boards.db")||&CGIError("Couldn't write the Boards.db file<br>\nPath: $DBPath<br>\nReason : $!");
		flock(BOARDS,2) if ($FLock);
		print BOARDS $InputLine;
		flock(BOARDS,8) if ($FLock);
	close(BOARDS);
	open(CATEGORY,">>$DBPath/$in{'Category'}.cat")||&CGIError("Couldn't write the $in{'Category'}.cat file<br>\nPath: $DBPath<br>\nReason : $!");
		flock(CATEGORY,2) if ($FLock);
		print CATEGORY $InputLine;
		flock(CATEGORY,8) if ($FLock);
	close(CATEGORY);
	mkdir("$DBPath/$in{'ID'}",0777);
	open(BOARD,">$DBPath/$in{'ID'}/board.list")||&CGIError("Couldn't create/write the board.list file<br>\nPath: $DBPath/$in{'ID'}<br>\nReason : $!");
		flock(BOARD,2) if ($FLock);
		print BOARD $InputLine;
		flock(BOARD,8) if ($FLock);
	close(BOARD);
	open(COUNT,">$DBPath/$in{'ID'}/board.count")||&CGIError("Couldn't create/write the board.count file<br>\nPath: $DBPath/$in{'ID'}<br>\nReason : $!");
		#Post Number, Total Topics Number, Total Posts Number, Last Update Time
		flock(COUNT,2) if ($FLock);
		print COUNT "0".$Spliter."0".$Spliter."0".$Spliter."N/A";
		flock(COUNT,8) if ($FLock);
	close(COUNT);

	if ($Type eq "Private") {
		open(ACCESS,">$DBPath/$in{'ID'}/Access.db")||&CGIError("Couldn't create/read the Access.db file<br>\nPath: $DBPath/$in{'ID'}<br>\nReason : $!");
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
	}
###############################################################################
	&ShowThank(	"CREATED A NEW BOARD",
				"The $in{'Name'} ($in{'ID'}) board has been created.\n",
				"3",
				"UBAdmin.$Ext?Session=$SessionID"				
	);	
	exit;
}
###############################################################################
1;# End of DoCreateBoard Function
###############################################################################