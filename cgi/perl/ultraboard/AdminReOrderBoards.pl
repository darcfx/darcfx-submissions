###############################################################################
# AdminReOrderBoards.pl                                                       #
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
# ReOrderBoards                                                               #
###############################################################################
sub ReOrderBoards {
	open(BOARDS,"$DBPath/Boards.db")||&CGIError("Couldn't open/read the Boards.db file<br>\nPath: $DBPath<br>\nReason : $!");
		flock(BOARDS,1) if ($FLock);
		@BOARDS_DATA=<BOARDS>;
	close(BOARDS);
	open(CATEGORIES,"$DBPath/Categories.db")||&CGIError("Couldn't open/read the Categories.db file<br>\nPath: $DBPath<br>\nReason : $!");
		flock(CATEGORIES,1) if ($FLock);
		@CATEGORIES_DATA=<CATEGORIES>;
	close(CATEGORIES);
###############################################################################
	$HTML.=	&Table($TableWidth,$TableAlign,"","6","","").
                &Tr("","","").
					&Td("","","","","","","nowrap","","").
						&Form("UBAdmin.$Ext","POST","","").
                        &HiddenBox("Session",$SessionID).
			       "</td>".
				"</tr>".
				&Tr("","","").
					&Td("","","","","RIGHT","","","","").
                        &GetMenuList.
					"</td>".
				"</tr>".
                &Tr("","","").
					&Td("","","","","","","nowrap","","").
						"</form>".
						&Form("UBAdmin.$Ext","POST","","").
						&HiddenBox("Action","DoReOrderBoards").
						&HiddenBox("Count",scalar(@BOARDS_DATA)).
						&HiddenBox("Session",$SessionID).
					"</td>".
				"</tr>".
			"</table>".
			&BTable($TableWidth,$TableAlign,"0","0",$TableCellSpacing,$TableCellPadding,$TableBorderColor,"","").
				&Tr("","",$HeaderBGColor).
					&Td("","","4","","","","","","").
						&Font($FontFace,$HeaderTextSize,$HeaderTextColor).
							"<b>REORDER BOARDS</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","","","","","","","").
						"&nbsp;".
					"</td>".
					&Td("","","","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Board Name</b>".
						"</font>".
					"</td>".
					&Td("","","","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Board ID</b>".
						"</font>".
					"</td>".
					&Td("","","","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b># Posts</b>".
						"</font>".
					"</td>".
				"</tr>";
	for (my ($i)=0,my ($j);$i<=$#CATEGORIES_DATA;$i++) {
		@CategoryInfo=&DecodeDBOutput($CATEGORIES_DATA[$i]);
		$HTML.=	&Tr("","",$CategoryBGColor).
					&Td("","","4","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>".$CategoryInfo[1]."<b>".
						"</font>".
					"</td>".
				"</tr>";

		open(CATEGORY,"$DBPath/$CategoryInfo[0].cat")||&CGIError("Couldn't open/read the $CategoryInfo[0].cat file<br>\nPath: $DBPath<br>\nReason : $!");
			flock(CATEGORY,1) if ($FLock);
			@CATEGORY_DATA=<CATEGORY>;
		close(CATEGORY);

		@Select=();
		$RowColor=$RowOddBGColor;
		for ($j=1;$j<scalar(@CATEGORY_DATA);$j++) {
			push (@Select,$j,$j);
		}
		for ($j=1;$j<=$#CATEGORY_DATA;$j++) {
			@BoardInfo=&DecodeDBOutput($CATEGORY_DATA[$j]);
			open(COUNT,"$DBPath/$BoardInfo[0]/board.count")||&CGIError("Couldn't open/read the board.count file<br>\nPath: $DBPath/$BoardInfo[0]<br>\nReason : $!");
				flock(COUNT,1) if ($FLock);
				@BoardCount=&DecodeDBOutput(<COUNT>);
			close(COUNT);
			$HTML.=	&Tr("","",$RowColor).
						&Td("","","","","","","",$ColumnOddBGColor,"").
							&Select("Board_".$BoardInfo[0],"","","",$j,
								@Select
							).
						"</td>".
						&Td("50%","","","","","","",$ColumnEvenBGColor,"").
							&Font($FontFace,$TextSize,$TextColor).
								&Link("UltraBoard.$Ext?Action=ShowBoard&Board=$BoardInfo[0]&Session=$SessionID","Board","$BoardInfo[2] ($BoardInfo[4])").
									$BoardInfo[1].
								"</a>".
							"</font>".
						"</td>".
						&Td("30%","","","","","","",$ColumnOddBGColor,"").
							&Font($FontFace,$TextSize,$TextColor).
								$BoardInfo[0].
							"</font>".
						"</td>".
						&Td("20%","","","","","","",$ColumnEvenBGColor,"").
							&Font($FontFace,$TextSize,$TextColor).
								$BoardCount[2]." Posts".
							"</font>".
						"</td>".
					"</tr>";
			if ($RowColor eq $RowOddBGColor) {
				$RowColor=$RowEvenBGColor;
			}else{
				$RowColor=$RowOddBGColor;
			}
		}
	}
	$HTML.=		&Tr("","",$CategoryBGColor).
					&Td("","","4","","","","","","").
						"<center>".&Submit("","REORDER THESE BOARDS","width:$IETextBoxSize")."</center>".
					"</td>".
				"</tr>".
				&Tr("","",$MenuBGColor).
					&Td("","","4","","","","","","").
						&PrintVersion().
					"</td>".
				"</tr>".
			"</table></td></tr></table>".
			"</form>";
	&PrintTheme("$UBName Administrative Center - ReOrder Boards",$HTML);
	exit;
}
###############################################################################
1;# End of ReOrderBoards Function
###############################################################################