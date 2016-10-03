###############################################################################
# AdminRemoveAccounts.pl                                                      #
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
# RemoveAccounts                                                              #
###############################################################################
sub RemoveAccounts {
	require "$LibPath/SearchAccounts.lib";
	&SearchAccounts();
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
						&HiddenBox("Action","DoRemoveAccounts").
						&HiddenBox("Count",scalar(@SortedList)).
						&HiddenBox("Session",$SessionID).
					"</td>".
				"</tr>".
			"</table>".
			&BTable($TableWidth,$TableAlign,"0","0",$TableCellSpacing,$TableCellPadding,$TableBorderColor,"","").
				&Tr("","",$HeaderBGColor).
					&Td("","","6","","","","","","").
						&Font($FontFace,$HeaderTextSize,$HeaderTextColor).
							"<b>REMOVE MEMBERS ACCOUNT</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("20","","","","CENTER","","","","").
						&Link("#","","","","onClick=\"CheckAll();return false;\"").
							&Image("$URLImages/CheckAll.gif","","","","","0","Reverse Selection").
						"</a>".
					"</td>".
					&Td("","","","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Nick Name</b>".
						"</font>".
					"</td>".
					&Td("","","","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Email</b>".
						"</font>".
					"</td>".
					&Td("","","","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Status</b>".
						"</font>".
					"</td>".
					&Td("","","","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Total Posts</b>".
						"</font>".
					"</td>".
					&Td("","","","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Last Post</b>".
						"</font>".
					"</td>".
				"</tr>";
    $RowColor=$RowOddBGColor;
	for ($i=0;$i<=$#SortedList;$i++) {
        @MemberInfo=&DecodeDBOutput($MemberID[$SortedList[$i]]);
		$HTML.=	&Tr("","",$RowColor).
					&Td("20","","","","CENTER","","",$ColumnOddBGColor,"").
						&Checkbox("MemberID_$i",$MemberInfo[0],"","").
					"</td>".
					&Td("26%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor)." ".
							&Link("UltraBoard.$Ext?Action=ShowProfile&ID=$MemberInfo[0]&Session=$SessionID","Profile",$MemberInfo[1]).
								"$MemberInfo[1]".
							"</a>".
						"</font>".
					"</td>".
					&Td("20%","","","","","","",$ColumnOddBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							&Link("mailto:$MemberInfo[3]","","").
								"$MemberInfo[3]".
							"</a>".
						"</font>".
					"</td>".
					&Td("15%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"$MemberInfo[5]".
						"</font>".
					"</td>".
					&Td("15%","","","","","","",$ColumnOddBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"$MemberInfo[4]".
						"</font>".
					"</td>".
					&Td("24%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							&GetDate($MemberInfo[6],$DateTextColor,$TimeTextColor,$DateTextSize,$TimeTextSize).
						"</font>".
					"</td>".
				"</tr>";
		if ($RowColor eq $RowEvenBGColor) {
			$RowColor=$RowOddBGColor;
		}else{
			$RowColor=$RowEvenBGColor;
		}
    }
	$HTML.=		&Tr("","",$CategoryBGColor).
					&Td("","","6","","","","","","").
						"<center>".&Submit("","REMOVE THESE MEMBERS ACCOUNT","width:$IETextBoxSize")."</center>".
					"</td>".
				"</tr>".
				&Tr("","",$MenuBGColor).
					&Td("","","6","","","","","","").
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
						eval ("document.form.MemberID_"+i+".checked = 1-document.form.MemberID_"+i+".checked");
					}
				}
			//-->
			</SCRIPT>
			HTML
	&PrintTheme("$UBName Administrative Center - Remove Members Account",$HTML);
	exit;
}
###############################################################################
1;# End of RemoveAccounts Function
###############################################################################