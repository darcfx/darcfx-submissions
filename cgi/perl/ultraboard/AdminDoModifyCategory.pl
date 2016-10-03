###############################################################################
# AdminDoModifyCategory.pl                                                    #
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
# DoModifyCategory                                                            #
###############################################################################
sub DoModifyCategory {
	&ShowError("MODIFYING PROBLEM","You forgot to select which category to modify.") if (!$in{'CategoryID'});
###############################################################################
	open(CATEGORY,"$DBPath/$in{'CategoryID'}.cat")||&CGIError("Couldn't open/read the $in{'CategoryID'}.cat file<br>\nPath: $DBPath<br>\nReason : $!");
		flock(CATEGORY,1) if ($FLock);
		@CATEGORY_DATA=<CATEGORY>;
		@CategoryInfo=&DecodeDBOutput($CATEGORY_DATA[0]);
	close(CATEGORY);
	open(GROUPS,"$MembersPath/Groups.db")||&CGIError("Couldn't open/read the Groups.db file<br>\nPath: $MembersPath<br>\nReason : $!");
		flock(GROUPS,1) if ($FLock);
		@GROUPS_DATA=<GROUPS>;
	close(GROUPS);
	unless (-e "$DBPath/$in{'CategoryID'}.acc") {
		$CheckAllGroup="on";
	}else{
		require "$DBPath/$in{'CategoryID'}.acc";
		$CheckAllGroup="";
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
						&HiddenBox("Action","DoModifyCategory2").
						&HiddenBox("CategoryID",$in{'CategoryID'}).
						&HiddenBox("Count",(scalar(@GROUPS_DATA)-1)).
						&HiddenBox("Session",$SessionID).
					"</td>".
				"</tr>".
			"</table>".
			&BTable($TableWidth,$TableAlign,"0","0",$TableCellSpacing,$TableCellPadding,$TableBorderColor,"","").
				&Tr("","",$HeaderBGColor).
					&Td("","","3","","","","","","").
						&Font($FontFace,$HeaderTextSize,$HeaderTextColor).
							"<b>MODIFY CATEGORY (".uc($CategoryInfo[0]).")</b>".
						"</font>".
					"</td>".
				"</tr>".
                &Tr("","",$CategoryBGColor).
					&Td("","","3","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Category Name</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","3","","","","",$ColumnOddBGColor,"").
						&TextBox("CategoryName",$CategoryInfo[1],$TextBoxSize,"","width:$IETextBoxSize").
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","3","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Category Description</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","3","","","","","","").
						&TextBox("CategoryDescription",$CategoryInfo[2],$TextBoxSize,"","width:$IETextBoxSize").
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","3","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Members Groups Status</b><br>\n".
							&Font("",$CategoryDesTextSize,"").
								"Which groups of members can view this category?".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("20","","","","","","",$ColumnOddBGColor,"").
						&Checkbox("AllGroups","","","","onClick=\"CheckAll()\"").
					"</td>".
					&Td("80%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"Guest".
						"</font>".
					"</td>".
					&Td("20%","","","","","","",$ColumnOddBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"? Members".
						"</font>".
					"</td>".
				"</tr>";
	$RowColor=$RowEvenBGColor;
	for (my ($i)=0;$i<=$#GROUPS_DATA;$i++) {
		@GroupInfo=&DecodeDBOutput($GROUPS_DATA[$i]);
		if ($GroupInfo[0] ne "administrator") {
			open(GROUP,"$MembersPath/$GroupInfo[0].grp")||&CGIError("Couldn't open/read the $GroupInfo[0].grp file<br>\nPath: $MembersPath<br>\nReason : $!");
				flock(GROUP,1) if ($FLock);
				@GROUP_DATA=<GROUP>;
			close(GROUP);
			if ($ACCESS{$GroupInfo[0]}) {
				$CheckGroup=$GroupInfo[0];
			}
			$HTML.=	&Tr("","",$RowColor).
						&Td("20","","","","","","",$ColumnOddBGColor,"").
							&Checkbox("GroupID_$i","$GroupInfo[0]","",$CheckGroup,"onClick=\"UnAllGroups('GroupID_$i')\"").
						"</td>".
						&Td("80%","","","","","","",$ColumnEvenBGColor,"").
							&Font($FontFace,$TextSize,$TextColor).
								$GroupInfo[1].
							"</font>".
						"</td>".
						&Td("20%","","","","","","",$ColumnOddBGColor,"").
							&Font($FontFace,$TextSize,$TextColor).
								scalar(@GROUP_DATA)." Members".
							"</font>".
						"</td>".
					"</tr>";
			$CheckGroup="";
			if ($RowColor eq $RowOddBGColor) {
				$RowColor=$RowEvenBGColor;
			}else{
				$RowColor=$RowOddBGColor;
			}
		}
	}
	$HTML.=		&Tr("","",$CategoryBGColor).
					&Td("","","3","","","","","","").
						"<center>".&Submit("","MODIFY THIS CATEGORY","width:$IETextBoxSize")."</center>".
					"</td>".
				"</tr>".
				&Tr("","",$MenuBGColor).
					&Td("","","3","","","","","","").
						&PrintVersion().
					"</td>".
				"</tr>".
			"</table></td></tr></table>".
			"</form>";
	($HTML.=<<'			HTML')=~s/^\s+//gm;
			
			<SCRIPT LANGUAGE="JavaScript">
			<!--
				function CheckAll () {
					if (document.form.AllGroups.checked == true) {
						var Num=document.form.Count.value;
						for (var i=1;i<=Num;i++) {
							eval ("document.form.GroupID_"+i+".checked = true");
						}
					}
				}
				function UnAllGroups (name) {
					eval ("var s=document.form."+name+".checked");
					if (s == false) {
						document.form.AllGroups.checked = false;
					}
				}
			//-->
			</SCRIPT>
			HTML
	&PrintTheme("$UBName Administrative Center - Modify Category",$HTML);
	exit;
}
###############################################################################
1;# End of DoModifyCategory Function
###############################################################################