###############################################################################
# ShowCategory.pl                                                             #
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
# ShowCategory                                                                #
###############################################################################
sub ShowCategory {
	if ($DisplayFront eq "") {
		print "Location: $URLSite\n\n";
		exit;
	}
	my ($HTML, $Menu, $List);
	$ColSpan="3";
###############################################################################
	if ((-e "$DBPath/$CATEGORIES_INFO[0].acc")&&($Group ne "administrator")) {
		require "$DBPath/$CATEGORIES_INFO[0].acc";
		if ($ACCESS{$Group} ne "Visable") {
			%ACCESS={};
			print "Location: UltraBoard.$Ext?Session=$SessionID\n\n";
		}
	}
	unless (-e "$DBPath/$in{'Category'}.cat") {
		&ShowError("ACCESS DENIED","The category that you want to access is not found.<br>Please contact the webmaster (".&Link("mailto:$EmailAddress","","").$EmailAddress."</a>".") for more information.");
	}
	$Title.=&Td("","","","","","","","","").&Font($FontFace,$HeaderTextSize,$HeaderTextColor)."<b>Board Name</b>"."</font>"."</td>".
			&Td("","","","","","","","","").&Font($FontFace,$HeaderTextSize,$HeaderTextColor)."<b>Moderators</b>"."</font>"."</td>";
	if (($ShowTotal eq "Both")||($ShowTotal eq "Topics")) {
		$Title.=&Td("","","","","","","","","").&Font($FontFace,$HeaderTextSize,$HeaderTextColor)."<center><b>Topics</b></center>"."</font>"."</td>";
		$ColSpan++;
	}
	if (($ShowTotal eq "Both")||($ShowTotal eq "Posts")) {
		$Title.=&Td("","","","","","","","","").&Font($FontFace,$HeaderTextSize,$HeaderTextColor)."<center><b>Posts</b></center>"."</font>"."</td>";
		$ColSpan++;
	}
	$Title.=&Td("","","","","","","","","").&Font($FontFace,$HeaderTextSize,$HeaderTextColor)."<b>Last Posts</b>"."</font>"."</td>";
###############################################################################
	open(CATEGORY,"$DBPath/$in{'Category'}.cat")||&CGIError("Couldn't open/read the $in{'Category'}.cat file<br>\nPath: $DBPath<br>\nReason : $!");
		flock(CATEGORY,1) if ($FLock);
		@CATEGORY_DATA=<CATEGORY>;
	close(CATEGORY);
	@CATEGORY_INFO=&DecodeDBOutput($CATEGORY_DATA[0]);
	for (my ($i)=1;$i<=$#CATEGORY_DATA;$i++) {
		@BOARD_DATA=&DecodeDBOutput($CATEGORY_DATA[$i]);
		open(BOARD,"$DBPath/$BOARD_DATA[0]/board.count")||&CGIError("Couldn't open/read the board.count file<br>\nPath: $DBPath/$BOARD_DATA[0]<br>\nReason : $!");
			flock(BOARD,1) if ($FLock);
			@BOARD_INFO=&DecodeDBOutput(<BOARD>);
		close(BOARD);
		if ($BOARD_DATA[5] eq "Active") {
			if (($BOARD_DATA[6] eq "Private")&&($Group ne "administrator")) {
				if ($Group eq "Guest") {
					next;
				}
				require "$DBPath/$BOARD_DATA[0]/Access.db";
				if (!$Access{$MemberData[3]}) {
					next;
				}
			}
			if ($Cookies{"B_".$BOARD_DATA[0]."_TIME"}>$BOARD_INFO[3]) {
				$MessageIcon=&Image("$URLImages/Board.gif","","","","","0","$BOARD_DATA[1] - $BOARD_DATA[2]");
			}else{
				$MessageIcon=&Image("$URLImages/NewBoard.gif","","","","","0","$BOARD_DATA[1] - $BOARD_DATA[2]");
			}

			$UnRead=$BOARD_INFO[2]-$Cookies{"B_".$BOARD_DATA[0]."_POST"};
			if ($UnRead > 0) {
				$UnRead.=" Messages are Unread";
			}else{
				$UnRead="Read All";
			}

			if ($Group eq "administrator") {
				$AccessStatus="Full Access";
			}elsif ($Group eq "Guest") {
				if ($BOARD_DATA[6] eq "Protected") {
					$AccessStatus="Read Only";
				}else{
					$AccessStatus="Full Access";
				}
			}else{
				if (($BOARD_DATA[6] eq "Protected")||($BOARD_DATA[6] eq "Public")) {
					$AccessStatus="Full Access";
				}else{
					if ($Access{$MemberData[3]}) {
						if ($Access{$MemberData[3]} eq "FullAccess") {
							$AccessStatus="Full Access";
						}else{
							$AccessStatus="Read Only";
						}
					}
				}
			}
			
			$WindowStatus=$BOARD_DATA[6]." Board (".$AccessStatus."), You have $UnRead";

			$List.=	&Tr("","",$RowOddBGColor).
						&Td("","","","","","","",$ColumnOddBGColor,"").
							&Table("","","0","0","","").
								&Tr("","","").
									&Td("20","","","","","","","","").
										$MessageIcon.
									"</td>".
									&Td("","","","","","","","","").
										&Font($FontFace,$BoardNameTextSize,$TextColor).
											&Link("UltraBoard.$Ext?Action=ShowBoard&Board=$BOARD_DATA[0]&Idle=$in{'Idle'}&Sort=$in{'Sort'}&Order=$in{'Order'}&Session=$SessionID","","",
												"$WindowStatus").
												"<b>".$BOARD_DATA[1]."</b>".
											"</a>".													
										"</font>".
									"</td>".
								"</tr>".
							"</table>".
						"</td>".
						&Td("","","","","","","",$ColumnEvenBGColor,"").
							&Font($FontFace,$TextSize,$TextColor);
			if ($BOARD_DATA[4]) {
				open(GROUP,"$MembersPath/$BOARD_DATA[4].grp")||&CGIError("Couldn't open/read the $BOARD_DATA[4].grp file<br>\nPath: $MembersPath<br>\nReason : $!");
					flock(GROUP,1) if ($FLock);
					@GROUP_DATA=<GROUP>;
				close(GROUP);
				@GroupInfo=&DecodeDBOutput($GROUP_DATA[0]);
				$List.=			$GroupInfo[1];
			}else{
				$List.=			"N/A";
			}			
			$List.=			"</font>".
						"</td>";
			if (($ShowTotal eq "Both")||($ShowTotal eq "Topics")) {
				$List.=	&Td("","","","","","","",$ColumnOddBGColor,"").
							&Font($FontFace,$TextSize,$TextColor).
								"<center>".$BOARD_INFO[1]."</center>".
							"</font>".
						"</td>";
			}
			if (($ShowTotal eq "Both")||($ShowTotal eq "Posts")) {
				$List.=	&Td("","","","","","","",$ColumnEvenBGColor,"").
							&Font($FontFace,$TextSize,$TextColor).
								"<center>".$BOARD_INFO[2]."</center>".
							"</font>".
						"</td>";
			}
			$List.=		&Td("","","","","","","",$ColumnOddBGColor,"").
							&Font($FontFace,$DateTextSize,$DateTextColor).
								&GetDate($BOARD_INFO[3],$DateTextColor,$TimeTextColor,$DateTextSize,$TimeTextSize).
							"</font>".
						"</td>".
					"</tr>";
            
			if (($DisplayBoardDes)&&($BOARD_DATA[2])) {
				$List.=	&Tr("","",$RowEvenBGColor).
							&Td("","",$ColSpan,"","","","","","").
						        &Font($FontFace,$BoardDesTextSize,$TextColor).
									$BOARD_DATA[2].
								"</font>".
								"<p>".
							"</td>".
						"</tr>";
            }
			$Access={};		# Clean Member List in Private Board
		}
	}
###############################################################################
	$HTML.=	"<p>".&BTable($TableWidth,$TableAlign,"0","0",$TableCellSpacing,$TableCellPadding,$TableBorderColor,"","").
				&Tr("","",$CategoryBGColor).
					&Td("","","","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
						&Link("UltraBoard.$Ext?Session=$SessionID","","").
							"<b>Home</b>".
						"</a>".
						" <b>/ </b>".
						"<b>".$CATEGORY_INFO[1]."</b>".
						"</font>".
					"</td>".
				"</tr>";
	if ($CATEGORY_INFO[2] ne "") {
		$HTML.=	&Tr("","",$RowOddBGColor).
					&Td("","","","","","","","","").
						&Font($FontFace,$CategoryDesTextSize,$CategoryTextColor).
						$CATEGORY_INFO[2].
						"</font>".
					"</td>".
				"</tr>";
	}
	$HTML.=	"</table></td></tr></table>".
			"<p>".
			&BTable($TableWidth,$TableAlign,"0","0",$TableCellSpacing,$TableCellPadding,$TableBorderColor,"","").
				&Tr("","",$HeaderBGColor).
					$Title.
				"</tr>".
				$List.
				&Tr("","",$MenuBGColor).
					&Td("","",$ColSpan,"","","","","","").
						&PrintVersion("YES").
					"</td>".
				"</tr>".
			&CBTable();
	&PrintTheme("$UBName",$HTML);
	exit;
}
###############################################################################
1;# End of ShowCategory Function
###############################################################################