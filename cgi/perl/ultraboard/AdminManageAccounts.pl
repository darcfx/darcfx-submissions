###############################################################################
# AdminManageAccounts.pl                                                      #
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
# ManageAccounts                                                              #
###############################################################################
sub ManageAccounts {
	open(GROUPS,"$MembersPath/Groups.db")||&CGIError("Couldn't open/read the Groups.db file<br>\nPath: $MembersPath<br>\nReason : $!");
		flock(GROUPS,1) if ($FLock);
		@GROUPS_DATA=<GROUPS>;
	close(GROUPS);
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
						&HiddenBox("Count",scalar(@GROUPS_DATA)).
						&HiddenBox("Session",$SessionID).
					"</td>".
				"</tr>".
			"</table>".
			&BTable($TableWidth,$TableAlign,"0","0",$TableCellSpacing,$TableCellPadding,$TableBorderColor,"","").
				&Tr("","",$HeaderBGColor).
					&Td("","","5","","","","","","").
						&Font($FontFace,$HeaderTextSize,$HeaderTextColor).
							"<b>MANAGES MEMBERS ACCOUNT</b>".
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
							"<b>Last Post</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","5","","","","",$ColumnOddBGColor,"").
						&Table("100%","","0","0","","").
							&Tr("","","").
								&Td("","","","","","","","","").
									&Select("LastPostType","","","","less",
										"more than","more",
										"less than","less",
									).
								"</td>".
								&Td("100%","","","","","","","","").
									&Select("LastPostDays","","width:$IETextBoxSize","","",
										"any time","",
										"never post","N/A",
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
							"<b>Total Post</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","5","","","","",$ColumnOddBGColor,"").
						&Table("100%","","0","0","","").
							&Tr("","","").
								&Td("","","","","","","","","").
									&Select("TotalPostType","","","","less",
										"more than","more",
										"less than","less",
									).
								"</td>".
								&Td("100%","","","","","","","","").
									&Select("TotalPostMessages","","width:$IETextBoxSize","","",
										"any number","",
										"25 messages","25",
										"50 messages","50",
										"75 messages","75",
										"100 messages","100",
										"150 messages","150",
										"200 messages","200",
										"250 messages","250",
										"300 messages","300",
										"350 messages","350",
										"400 messages","400",
										"450 messages","450"
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
							"all","All",	
							"nick name, and username","NickNameUserName",
							"location, occupation, and interests","LocationOccupationInterests",
							"comments, and signature","CommentsSignature",
							"nick name only","NickName",
							"username only","UserName",
							"location only","Location",
							"occupation only","Occupation",
							"interests only","Interests",
							"comments only","Comments",
							"signature only","Signature"
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
										"nick name","nickname",
										"email","email",
										"total posts","totalposts",
										"last post","lastpost"
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
						&Radio("Action","ActivateAccounts","ActivateAccounts","").		
					"</td>".
					&Td("100%","","4","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"Activate/Deactivate Members Account".
						"</font>".		
					"</td>".
				"</tr>";
    if ($EmailFunction) {
        $HTML.= &Tr("","",$RowEvenBGColor).
					&Td("20","","","","","","",$ColumnOddBGColor,"").
						&Radio("Action","EmailMembers","","").		
					"</td>".
					&Td("100%","","4","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"Email to Members".
						"</font>".		
					"</td>".
				"</tr>";
    }
    $HTML.=     &Tr("","",$RowOddBGColor).
					&Td("20","","","","","","",$ColumnOddBGColor,"").
						&Radio("Action","ModifyAccount","","").		
					"</td>".
					&Td("100%","","4","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"Modify Member Account".
						"</font>".		
					"</td>".
				"</tr>".
				&Tr("","",$RowEvenBGColor).
					&Td("20","","","","","","",$ColumnOddBGColor,"").
						&Radio("Action","MoveAccounts","","").		
					"</td>".
					&Td("100%","","4","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"Move Members Account".
						"</font>".		
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("20","","","","","","",$ColumnOddBGColor,"").
						&Radio("Action","RemoveAccounts","","").		
					"</td>".
					&Td("100%","","4","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"Remove Members Account".
						"</font>".		
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","5","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Members Groups</b>".
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
							"<b>Group Name</b>".
						"</font>".
					"</td>".
					&Td("","","","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Group ID</b>".
						"</font>".
					"</td>".
					&Td("","","","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b># Members</b>".
						"</font>".
					"</td>".
				"</tr>";
	$RowColor=$RowOddBGColor;
	for (my ($i)=0;$i<=$#GROUPS_DATA;$i++) {
		@GroupInfo=&DecodeDBOutput($GROUPS_DATA[$i]);
		if ($GroupInfo[0] ne "administrator") {
			open(GROUP,"$MembersPath/$GroupInfo[0].grp")||&CGIError("Couldn't open/read the $GroupInfo[0].grp file<br>\nPath: $MembersPath<br>\nReason : $!");
				flock(GROUP,1) if ($FLock);
				@GROUP_DATA=<GROUP>;
			close(GROUP);
			$HTML.=	&Tr("","",$RowColor).
						&Td("20","","","","CENTER","","",$ColumnOddBGColor,"").
							&Checkbox("GroupID_$i","$GroupInfo[0]","","").
						"</td>".
						&Td("50%","","","","","","",$ColumnEvenBGColor,"").
							&Font($FontFace,$TextSize,$TextColor).
								$GroupInfo[1].
							"</font>".
						"</td>".
						&Td("30%","","","","","","",$ColumnOddBGColor,"").
							&Font($FontFace,$TextSize,$TextColor).
								$GroupInfo[0].
							"</font>".
						"</td>".
						&Td("20%","","","","","","",$ColumnEvenBGColor,"").
							&Font($FontFace,$TextSize,$TextColor).
								(scalar(@GROUP_DATA)-1)." Members".
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
						"<center>".&Submit("","SEARCH MEMBERS ACCOUNT","width:$IETextBoxSize")."</center>".
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
					for (var i=1;i<Num;i++) {
						eval ("document.form.GroupID_"+i+".checked = 1-document.form.GroupID_"+i+".checked");
					}
				}
			//-->
			</SCRIPT>
			HTML
	&PrintTheme("$UBName Administrative Center - Manage Members Account",$HTML);
	exit;
}
###############################################################################
1;# End of ManageAccounts Function
###############################################################################