###############################################################################
# AdminRemoveGroups.pl                                                        #
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
# RemoveGroups                                                                #
###############################################################################
sub RemoveGroups {
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
						&HiddenBox("Action","DoRemoveGroups").
						&HiddenBox("Count",scalar(@GROUPS_DATA)).
						&HiddenBox("Session",$SessionID).
					"</td>".
				"</tr>".
			"</table>".
			&BTable($TableWidth,$TableAlign,"0","0",$TableCellSpacing,$TableCellPadding,$TableBorderColor,"","").
				&Tr("","",$HeaderBGColor).
					&Td("","","4","","","","","","").
						&Font($FontFace,$HeaderTextSize,$HeaderTextColor).
							"<b>REMOVE MEMBERS GROUPS</b>".
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
	$HTML.=		&Tr("","",$CategoryBGColor).
					&Td("","","4","","","","","","").
						"<center>".&Submit("","REMOVE THESE MEMBERS GROUPS","width:$IETextBoxSize")."</center>".
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
				function CheckAll () {
					var Num=document.form.Count.value;
					for (var i=0;i<Num;i++) {
						eval ("document.form.GroupID_"+i+".checked = 1-document.form.GroupID_"+i+".checked");
					}
				}
			//-->
			</SCRIPT>
			HTML
	&PrintTheme("$UBName Administrative Center - Remove Members Groups",$HTML);
	exit;
}
###############################################################################
1;# End of RemoveGroups Function
###############################################################################