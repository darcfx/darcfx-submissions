###############################################################################
# Main.pl                                                                     #
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
# Main                                                                        #
###############################################################################
sub Main {
	if ($DisplayFront eq "") {
		print "Location: $URLSite\n\n";
		exit;
	}
	my ($HTML, $Menu, $List);
###############################################################################
	if (($OnlyCategory)&&($UseCategory)) {
		$ColSpan="2";
		$Title.=&Td("","","","","","","","","").&Font($FontFace,$HeaderTextSize,$HeaderTextColor)."<b>Category Name</b>"."</font>"."</td>".
				&Td("10%","","","","","","","","").&Font($FontFace,$HeaderTextSize,$HeaderTextColor)."<center><b>Boards</b></center>"."</font>"."</td>";
		open(CATEGORIES,"$DBPath/Categories.db")||&CGIError("Couldn't open/read the Categories.db file<br>\nPath: $DBPath<br>\nReason : $!");
			flock(CATEGORIES,1) if ($FLock);
			my (@CATEGORIES_INFO, @CATEGORY_DATA);
			while (<CATEGORIES>) {
				@CATEGORIES_INFO=&DecodeDBOutput($_);
				if ((-e "$DBPath/$CATEGORIES_INFO[0].acc")&&($Group ne "administrator")) {
					require "$DBPath/$CATEGORIES_INFO[0].acc";
					if ($ACCESS{$Group} ne "Visable") {
						%ACCESS={};
						next;
					}
				}
				open(CATEGORY,"$DBPath/$CATEGORIES_INFO[0].cat")||&CGIError("Couldn't open/read the $CATEGORIES_INFO[0].cat file<br>\nPath: $DBPath<br>\nReason : $!");
					flock(CATEGORY,1) if ($FLock);
					@CATEGORY_DATA=<CATEGORY>;
				close(CATEGORY);
				$List.=	&Tr("","",$RowOddBGColor).
							&Td("","","","","","","",$ColumnOddBGColor,"").
								&Table("100%","","0","0","","").
									&Tr("","","").
										&Td("20","","","","","","","","").
											&Image("$URLImages/Folder.gif","","","","","0","$CATEGORIES_INFO[1] - $CATEGORIES_INFO[2]").
										"</td>".
										Td("","","","","","","","","").
											&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
												&Link("UltraBoard.$Ext?Action=ShowCategory&Category=$CATEGORIES_INFO[0]&Idle=$in{'Idle'}&Sort=$in{'Sort'}&Order=$in{'Order'}&Session=$SessionID","","$CATEGORIES_INFO[1] - $CATEGORIES_INFO[2]",
													"View this ($CATEGORIES_INFO[1]) category.").
													"<b>".$CATEGORIES_INFO[1]."</b>".
												"</a>".
											"</font>".
										"</td>".
									"</tr>".
								"</table>".
							"</td>".
							&Td("","","","","","","",$ColumnEvenBGColor,"").
								&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
									"<center>$#CATEGORY_DATA</center>".
								"</font>".
							"</td>".
						"</tr>".
						&Tr("","",$RowEvenBGColor).
							&Td("","",$ColSpan,"","","","","","").
								&Font($FontFace,$CategoryDesTextSize,$CategoryTextColor);
				if ($DisplayCategoryDes) {
					$List.=$CATEGORIES_INFO[2];
				}
				$List.=			"</font>".
							"</td>".
						"</tr>";
			}
		close(CATEGORIES);
	}else{
		$ColSpan="3";
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
		$Title.=&Td("","","","","","","","","").&Font($FontFace,$HeaderTextSize,$HeaderTextColor)."<b>Last Post</b>"."</font>"."</td>";

        open(CATEGORIES,"$DBPath/Categories.db")||&CGIError("Couldn't open/read the Categories.db file<br>\nPath: $DBPath<br>\nReason : $!");
			flock(CATEGORIES,1) if ($FLock);
			my @CATEGORIES_DATA=<CATEGORIES>;
		close(CATEGORIES);	
		for (@CATEGORIES_DATA) {
			@CATEGORIES_INFO=&DecodeDBOutput($_);
			if ($UseCategory) {
				if ((-e "$DBPath/$CATEGORIES_INFO[0].acc")&&($Group ne "administrator")) {
					require "$DBPath/$CATEGORIES_INFO[0].acc";
					if ($ACCESS{$Group} ne "Visable") {
						%ACCESS={};
						next;
					}
				}
				$List.=	&Tr("","",$CategoryBGColor).
							&Td("","",$ColSpan,"","","","","","").
								&Table("","","0","0","","").
									&Tr("","","").
										&Td("20","","","","","","","","").
											&Image("$URLImages/Folder.gif","","","","","0","$CATEGORIES_INFO[1] - $CATEGORIES_INFO[2]").
										"</td>".
										&Td("","","","","","","","","").
											&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
												"<b>".$CATEGORIES_INFO[1]."</b>".
											"</font>".
										"</td>".
									"</tr>".
								"</table>".
							"</td>".
						"</tr>";
			}

			open(CATEGORY,"$DBPath/$CATEGORIES_INFO[0].cat")||&CGIError("Couldn't open/read the $CATEGORIES_INFO[0].cat file<br>\nPath: $DBPath<br>\nReason : $!");
				flock(CATEGORY,1) if ($FLock);
				@CATEGORY_DATA=<CATEGORY>;
			close(CATEGORY);
            
			for (my ($i)=1;$i<=$#CATEGORY_DATA;$i++) {
				@CATEGORY_INFO=&DecodeDBOutput($CATEGORY_DATA[$i]);
				open(BOARD,"$DBPath/$CATEGORY_INFO[0]/board.count")||&CGIError("Couldn't open/read the board.count file<br>\nPath: $DBPath/$CATEGORY_INFO[0]<br>\nReason : $!");
					flock(BOARD,1) if ($FLock);
					@BOARD_INFO=&DecodeDBOutput(<BOARD>);
				close(BOARD);
				if ($CATEGORY_INFO[5] eq "Active") {
					if (($CATEGORY_INFO[6] eq "Private")&&($Group ne "administrator")&&($Group ne $CATEGORY_INFO[4])) {
						if ($Group eq "Guest") {
							next;
						}
						require "$DBPath/$CATEGORY_INFO[0]/Access.db";
						if (!$Access{$MemberData[3]}) {
							next;
						}
					}
					if ($Cookies{"B_".$CATEGORY_INFO[0]."_TIME"}>$BOARD_INFO[3]) {
						$MessageIcon=&Image("$URLImages/Board.gif","","","","","0","$CATEGORY_INFO[1] - $CATEGORY_INFO[2]");
					}else{
						$MessageIcon=&Image("$URLImages/NewBoard.gif","","","","","0","$CATEGORY_INFO[1] - $CATEGORY_INFO[2]");
					}

					$UnRead=$BOARD_INFO[2]-$Cookies{"B_".$CATEGORY_INFO[0]."_POST"};
					if ($UnRead > 0) {
						$UnRead.=" Messages are Unread";
					}else{
						$UnRead="Read All";
					}

					if ($Group eq "administrator") {
						$AccessStatus="Full Access";
					}elsif ($Group eq "Guest") {
						if ($CATEGORY_INFO[6] eq "Protected") {
							$AccessStatus="Read Only";
						}else{
							$AccessStatus="Full Access";
						}
					}else{
						if (($CATEGORY_INFO[6] eq "Protected")||($CATEGORY_INFO[6] eq "Public")) {
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
					
					$WindowStatus=$CATEGORY_INFO[6]." Board (".$AccessStatus."), You have $UnRead";
					$List.=	&Tr("","",$RowOddBGColor).
								&Td("","","","","","","",$ColumnOddBGColor,"").
                                    &Table("","","0","0","","").
                                        &Tr("","","").
                                            &Td("20","","","","","","","","").
                                                $MessageIcon.
                                            "</td>".
                                            &Td("","","","","","","","","").
                                                &Font($FontFace,$BoardNameTextSize,$TextColor).
                                                    &Link("UltraBoard.$Ext?Action=ShowBoard&Board=$CATEGORY_INFO[0]&Idle=$in{'Idle'}&Sort=$in{'Sort'}&Order=$in{'Order'}&Session=$SessionID","","",
														"$WindowStatus").
                                                        "<b>".$CATEGORY_INFO[1]."</b>".
                                                    "</a>".													
                                                "</font>".
                                            "</td>".
                                        "</tr>".
                                    "</table>".
								"</td>".
								&Td("","","","","","","",$ColumnEvenBGColor,"").
									&Font($FontFace,$TextSize,$TextColor);
					if ($CATEGORY_INFO[4]) {
						open(GROUP,"$MembersPath/$CATEGORY_INFO[4].grp")||&CGIError("Couldn't open/read the $CATEGORY_INFO[4].grp file<br>\nPath: $MembersPath<br>\nReason : $!");
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
					
					if (($DisplayBoardDes)&&($CATEGORY_INFO[2])) {
						$List.=	&Tr("","",$RowEvenBGColor).
									&Td("","",$ColSpan,"","","","","","").
										&Font($FontFace,$BoardDesTextSize,$TextColor).
											$CATEGORY_INFO[2].
										"</font>".
										"<p>".
									"</td>".
								"</tr>";
					}
					%Access={};		# Clean Member List in Private Board
				}
			}
		}
	}
###############################################################################
	if ($MemberData[1]) {
		$Greet="<b>Welcome to the $UBName, ".$MemberData[1]."!</b>";
		$Logged="Username: $MemberData[0]";
	}else{
		$Greet="<b>Welcome to the $UBName".$MemberData[1]."!</b>";
		$Logged="Username: Guest";
	}
	if ($ShowNumberMembers) {
		open(DB,"$MembersPath/Members.total")||&CGIError("Couldn't open/read the Members.total file<br>\nPath: $MembersPath<br>\nReason : $!");
			flock(DB,1) if ($FLock);
			$TotalMembers=<DB>;
		close(DB);
		$NumberMembers=$TotalMembers." Registered Members.";
	}
	$HTML.=	"<p>".&BTable($TableWidth,$TableAlign,"0","0",$TableCellSpacing,$TableCellPadding,$TableBorderColor,"","").
				&Tr("","",$CategoryBGColor).
					&Td("","","","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							$Greet.
						"</font>".
					"</td>".
				"</tr>".	
				&Tr("","",$RowOddBGColor).
					&Td("","","","","","","","","").
						&Table("100%","","0","0","","").
							&Tr("","","").
								&Td("50%","","","","","","","","").
									&Font($FontFace,$CategoryDesTextSize,$CategoryTextColor).
										$Logged.
									"</font>".
								"</td>".
								&Td("50%","","","","RIGHT","","","","").
									&Font($FontFace,$CategoryDesTextSize,$CategoryTextColor).
										$NumberMembers.												
									"</font>".
								"</td>".
							"</tr>".
						"</table>".
					"</td>".
				"</tr>".	
			"</table></td></tr></table>".
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
1;# End of Main Function
###############################################################################