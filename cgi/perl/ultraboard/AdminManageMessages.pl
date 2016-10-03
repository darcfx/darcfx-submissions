###############################################################################
# AdminManageMessages.pl                                                      #
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
# ManageMessages                                                              #
###############################################################################
sub ManageMessages {
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
						&Form("UBAdmin.$Ext","POST","","","name=\"form\"").
						&HiddenBox("Count",scalar(@BOARDS_DATA)).
						&HiddenBox("Session",$SessionID).
					"</td>".
				"</tr>".
			"</table>".
			&BTable($TableWidth,$TableAlign,"0","0",$TableCellSpacing,$TableCellPadding,$TableBorderColor,"","").
				&Tr("","",$HeaderBGColor).
					&Td("","","5","","","","","","").
						&Font($FontFace,$HeaderTextSize,$HeaderTextColor).
							"<b>MANAGES MESSAGES</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","5","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Keywords</b><br>".
							&Font($FontFace,$CategoryDesTextSize,$CategoryTextColor).
								"use space to sperate every words".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","5","","","","",$ColumnOddBGColor,"").
						&TextBox("Keywords","",$TextBoxSize,"","width:$IETextBoxSize").
					"</td>".
				"</tr>".
				&Tr("","",$RowEvenBGColor).
					&Td("20","","","","","","",$ColumnOddBGColor,"").
						&Radio("Bealoon","And","","").		
					"</td>".
					&Td("100%","","4","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"Match All Words".
						"</font>".		
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("20","","","","","","",$ColumnOddBGColor,"").
						&Radio("Bealoon","Or","Or","").		
					"</td>".
					&Td("100%","","4","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"Match Any Words".
						"</font>".		
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","5","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Date</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","5","","","","",$ColumnOddBGColor,"").
						&Table("100%","","0","0","","").
							&Tr("","","").
								&Td("","","","","","","","","").
									&Select("DateType","","","","less",
										"more than","more",
										"less than","less",
									).
								"</td>".
								&Td("100%","","","","","","","","").
									&Select("DateDays","","width:$IETextBoxSize","","",
										"any time","",
										"1 day","1",
										"2 days","2",
										"3 days","3",
										"7 days","7",
										"10 days","10",
										"20 days","20",
										"30 days","30",
										"45 days","45",
										"60 days","60",
										"90 days","90",
										"365 days","365"
									).
								"</td>".
							"</tr>".
						"</table>".
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","5","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Search Method</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","5","","","","",$ColumnOddBGColor,"").
						&Select("Method","","width:$IETextBoxSize","","",
							"subject, message, and username","SubjectMessageUserName",
							"subject, and message","SubjectMessage",
							"subject, and username","SubjectUserName",
							"message, and username","MessageUserName",
							"subject only","Subject",
							"message only","Message",
							"username only","UserName"
						).			
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","5","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Sort</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","5","","","","",$ColumnOddBGColor,"").
						&Table("100%","","0","0","","").
							&Tr("","","").
								&Td("","","","","","","","","").
									&Select("SortOrder","","","","Descend",
										"sorted by ascending","Ascend",
										"sorted by descending","Descend",
									).
								"</td>".
								&Td("100%","","","","","","","","").
									&Select("SortField","","width:$IETextBoxSize","","lastmodified",
										"topic","topic",
										"originator","originator",
										"replies","replies",
										"last modified","lastmodified",
									).
								"</td>".
							"</tr>".
						"</table>".
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","5","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Manage Functions</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("20","","","","","","",$ColumnOddBGColor,"").
						&Radio("Action","CloseThreads","CloseMessages","").		
					"</td>".
					&Td("100%","","4","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"Close/Open Threads".
						"</font>".		
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("20","","","","","","",$ColumnOddBGColor,"").
						&Radio("Action","ModifyThread","","").		
					"</td>".
					&Td("100%","","4","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"Modify Thread".
						"</font>".		
					"</td>".
				"</tr>".
				&Tr("","",$RowEvenBGColor).
					&Td("20","","","","","","",$ColumnOddBGColor,"").
						&Radio("Action","MoveThreads","","").		
					"</td>".
					&Td("100%","","4","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"Move Threads".
						"</font>".		
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("20","","","","","","",$ColumnOddBGColor,"").
						&Radio("Action","RemoveThreads","","").		
					"</td>".
					&Td("100%","","4","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"Remove Threads".
						"</font>".		
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","5","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Boards</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","","","CENTER","","","","").
						&Link("#","","","","onClick=\"CheckAll();return false;\"").
						&Image("$URLImages/CheckAll.gif","","","","","0","Reverse Selection").
						"</a>".
					"</td>".
					&Td("","","","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Board Name</b>".
						"</font>".
					"</td>".
					&Td("","","","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Board Type</b>".
						"</font>".
					"</td>".
					&Td("","","","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Board Status</b>".
						"</font>".
					"</td>".
					&Td("","","","","CENTER","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Posts</b>".
						"</font>".
					"</td>".
				"</tr>";
	$Count=0;
	for (my ($i)=0,my ($j);$i<=$#CATEGORIES_DATA;$i++) {
		@CategoryInfo=&DecodeDBOutput($CATEGORIES_DATA[$i]);
		$HTML.=	&Tr("","",$CategoryBGColor).
					&Td("","","5","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>".$CategoryInfo[1]."<b>".
						"</font>".
					"</td>".
				"</tr>";
		open(CATEGORY,"$DBPath/$CategoryInfo[0].cat")||&CGIError("Couldn't open/read the $CategoryInfo[0].cat file<br>\nPath: $DBPath<br>\nReason : $!");
			flock(CATEGORY,1) if ($FLock);
			@CATEGORY_DATA=<CATEGORY>;
		close(CATEGORY);
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
						&Td("20","","","","CENTER","","",$ColumnOddBGColor,"").
							&Checkbox("BoardID_".$Count++,"$BoardInfo[0]","","").
						"</td>".
						&Td("55%","","","","","","",$ColumnEvenBGColor,"").
							&Font($FontFace,$TextSize,$TextColor).
								&Link("UltraBoard.$Ext?Action=ShowBoard&Board=$BoardInfo[0]&Session=$SessionID","Board","$BoardInfo[2] ($BoardInfo[4])").
									$BoardInfo[1].
								"</a>".
							"</font>".
						"</td>".
						&Td("20%","","","","","","",$ColumnOddBGColor,"").
							&Font($FontFace,$TextSize,$TextColor).
								$BoardInfo[6].
							"</font>".
						"</td>".
						&Td("20%","","","","","","",$ColumnEvenBGColor,"").
							&Font($FontFace,$TextSize,$TextColor).
								$BoardInfo[5].
							"</font>".
						"</td>".
						&Td("5%","","","","CENTER","","",$ColumnOddBGColor,"").
							&Font($FontFace,$TextSize,$TextColor).
								$BoardCount[2].
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
					&Td("","","5","","","","","","").
						"<center>".&Submit("","SEARCH MESSAGES","width:$IETextBoxSize")."</center>".
					"</td>".
				"</tr>".
				&Tr("","",$MenuBGColor).
					&Td("","","5","","","","","","").
						&PrintVersion().
					"</td>".
				"</tr>".
			"</table></td></tr></table>".
			"</form>";
	($HTML.=<<'			HTML')=~s/^\s+//gm;
			
			<SCRIPT LANGUAGE="JavaScript">
			<!--
				function CheckAll () {
					var Num=document.form.Count.value;
					for (var i=0;i<Num;i++) {
						eval ("document.form.BoardID_"+i+".checked = 1-document.form.BoardID_"+i+".checked");
					}
				}
			//-->
			</SCRIPT>
			HTML
	&PrintTheme("$UBName Administrative Center - Manage Messages",$HTML);
	exit;
}
###############################################################################
1;# End of ManageMessages Function
###############################################################################