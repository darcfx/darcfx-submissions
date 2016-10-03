###############################################################################
# AdminCreateBoard.pl                                                         #
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
# CreateBoard                                                                 #
###############################################################################
sub CreateBoard {
	open(GROUPS,"$MembersPath/Groups.db")||&CGIError("Couldn't open/read the Groups.db file<br>\nPath: $MembersPath<br>\nReason : $!");
		flock(GROUPS,1) if ($FLock);
		@GROUPS_DATA=<GROUPS>;
	close(GROUPS);
	for (my ($i)=0;$i<=$#GROUPS_DATA;$i++) {
		@GroupInfo=&DecodeDBOutput($GROUPS_DATA[$i]);
		if ($GroupInfo[0] ne $DefaultGroup) {
			push (@ModeratorsGroup, $GroupInfo[1]." ($GroupInfo[0])", $GroupInfo[0]);
		}
	}
	open(CATEGORIES,"$DBPath/Categories.db")||&CGIError("Couldn't open/read the Categories.db file<br>\nPath: $DBPath<br>\nReason : $!");
		flock(CATEGORIES,1) if ($FLock);
		@CATEGORIES_DATA=<CATEGORIES>;
	close(CATEGORIES);
	for ($i=0;$i<=$#CATEGORIES_DATA;$i++) {
		@CategoryInfo=&DecodeDBOutput($CATEGORIES_DATA[$i]);
		push (@Categories, $CategoryInfo[1], $CategoryInfo[0]);
	}
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
						&HiddenBox("Action","DoCreateBoard").
						&HiddenBox("Count",(scalar(@GROUPS_DATA)-1)).
						&HiddenBox("Session",$SessionID).
					"</td>".
				"</tr>".
			"</table>".
			&BTable($TableWidth,$TableAlign,"0","0",$TableCellSpacing,$TableCellPadding,$TableBorderColor,"","").
				&Tr("","",$HeaderBGColor).
					&Td("","","4","","","","","","").
						&Font($FontFace,$HeaderTextSize,$HeaderTextColor).
							"<b>CREATE A NEW BOARD</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","4","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Board ID</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","4","","","","",$ColumnOddBGColor,"").
						&TextBox("ID","",$TextBoxSize,"","width:$IETextBoxSize").
					"</td>".
				"</tr>".
                &Tr("","",$CategoryBGColor).
					&Td("","","4","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Board Name</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","4","","","","",$ColumnOddBGColor,"").
						&TextBox("Name","",$TextBoxSize,"","width:$IETextBoxSize").
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","4","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Board Moderators Group</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","4","","","","",$ColumnOddBGColor,"").
						&Select("Moderators","","width:$IETextBoxSize","","",
							"No Moderator","",
							@ModeratorsGroup
						).
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","4","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Category</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","4","","","","",$ColumnOddBGColor,"").
						&Select("Category","","width:$IETextBoxSize","","",
							@Categories
						).
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","4","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Board Description</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","4","","","","",$ColumnOddBGColor,"").
						&TextBox("Description","",$TextBoxSize,"","width:$IETextBoxSize").
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","4","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Board Status</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","4","","","","",$ColumnOddBGColor,"").
						&Select("Status","","width:$IETextBoxSize","","",
							"Active","Active",
							"Inactive","Inactive"
						).
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","4","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Members Groups Status</b><br>\n".
							&Font("",$CategoryDesTextSize,"").
								"Which groups of members can read and/or post in this board?".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("70","","","","CENTER","","","","").
						&Font($FontFace,$CategoryDesTextSize,$CategoryTextColor).
							"<b>READ</b>".
						"</font>".
					"</td>".
					&Td("70","","","","CENTER","","","","").
						&Font($FontFace,$CategoryDesTextSize,$CategoryTextColor).
							"<b>POST</b>".
						"</font>".
					"</td>".
					&Td("80%","","","","","","","","").
						&Font($FontFace,$CategoryDesTextSize,$CategoryTextColor).
							"<b>GROUP</b>".
						"</font>".
					"</td>".
					&Td("20%","","","","","","","","").
						&Font($FontFace,$CategoryDesTextSize,$CategoryTextColor).
							"<b># MEMBERS</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("70","","","","CENTER","","",$ColumnOddBGColor,"").
						&Checkbox("AllGroupsRead","on","","","onClick=\"CheckAllRead()\"").
					"</td>".
					&Td("70","","","","CENTER","","",$ColumnEvenBGColor,"").
						&Checkbox("AllGroupsPost","on","","","onClick=\"CheckAllPost()\"").
					"</td>".
					&Td("80%","","","","","","",$ColumnOddBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"Guest".
						"</font>".
					"</td>".
					&Td("20%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"? Members".
						"</font>".
					"</td>".
				"</tr>";
	$RowColor=$RowEvenBGColor;
	for ($i=0;$i<=$#GROUPS_DATA;$i++) {
		@GroupInfo=&DecodeDBOutput($GROUPS_DATA[$i]);
		if ($GroupInfo[0] ne "administrator") {
			open(GROUP,"$MembersPath/$GroupInfo[0].grp")||&CGIError("Couldn't open/read the $GroupInfo[0].grp file<br>\nPath: $MembersPath<br>\nReason : $!");
				flock(GROUP,1) if ($FLock);
				@GROUP_DATA=<GROUP>;
			close(GROUP);
			$HTML.=	&Tr("","",$RowColor).
						&Td("70","","","","CENTER","","",$ColumnOddBGColor,"").
							&Checkbox("ReadGroupID_$i","$GroupInfo[0]","","","onClick=\"UnAllGroups('$i','Read')\"").
						"</td>".
						&Td("70","","","","CENTER","","",$ColumnEvenBGColor,"").
							&Checkbox("PostGroupID_$i","$GroupInfo[0]","","","onClick=\"UnAllGroups('$i','Post')\"").
						"</td>".
						&Td("80%","","","","","","",$ColumnOddBGColor,"").
							&Font($FontFace,$TextSize,$TextColor).
								$GroupInfo[1]." ($GroupInfo[0])".
							"</font>".
						"</td>".
						&Td("20%","","","","","","",$ColumnEvenBGColor,"").
							&Font($FontFace,$TextSize,$TextColor).
								scalar(@GROUP_DATA)." Members".
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
						"<center>".&Submit("","CREATE THIS BOARD","width:$IETextBoxSize")."</center>".
					"</td>".
				"</tr>".
				&Tr("","",$MenuBGColor).
					&Td("","","4","","","","","","").
						&PrintVersion().
					"</td>".
				"</tr>".
			"</table></td></tr></table>".
			"</form>";
	($HTML.=<<'			HTML')=~s/^\s+//gm;
			
			<SCRIPT LANGUAGE="JavaScript">
			<!--
				function CheckAllRead () {
					if (document.form.AllGroupsRead.checked == true) {
						var Num=document.form.Count.value;
						for (var i=1;i<=Num;i++) {
							eval ("document.form.ReadGroupID_"+i+".checked = true");
                            eval ("document.form.PostGroupID_"+i+".checked = true");
                        }
					}else{
						document.form.AllGroupsPost.checked = false;
					}
				}
				function CheckAllPost () {
					if (document.form.AllGroupsPost.checked == true) {
						var Num=document.form.Count.value;
						for (var i=1;i<=Num;i++) {
							eval ("document.form.ReadGroupID_"+i+".checked = true");
							eval ("document.form.PostGroupID_"+i+".checked = true");
						}
						document.form.AllGroupsRead.checked = true;
					}
				}
				function UnAllGroups (name,type) {
					eval ("var s=document.form."+type+"GroupID_"+name+".checked");
					if (s == false) {
						document.form.AllGroupsRead.checked = false;
						document.form.AllGroupsPost.checked = false;
					}
					if (type == 'Read') {
						eval ("document.form.PostGroupID_"+name+".checked = false");
					}else{
						if (s == true) {
							eval ("document.form.ReadGroupID_"+name+".checked = true");
						}
					}
				}
			//-->
			</SCRIPT>
			HTML
	&PrintTheme("$UBName Administrative Center - Create a New Board",$HTML);
	exit;
}
###############################################################################
1;# End of CreateBoard Function
###############################################################################