###############################################################################
# AdminModifyThread.pl                                                        #
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
# ModifyThread                                                                #
###############################################################################
sub ModifyThread {
	require "$LibPath/SearchMessages.lib";
	&SearchMessages();
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
						&HiddenBox("Action","DoModifyThread").
						&HiddenBox("Count",scalar(@SortedList)).
						&HiddenBox("Session",$SessionID).
					"</td>".
				"</tr>".
			"</table>".
			&BTable($TableWidth,$TableAlign,"0","0",$TableCellSpacing,$TableCellPadding,$TableBorderColor,"","").
				&Tr("","",$HeaderBGColor).
					&Td("","","5","","","","","","").
						&Font($FontFace,$HeaderTextSize,$HeaderTextColor).
							"<b>MODIFY THREAD</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","","","","","","","").
						"&nbsp;".
					"</td>".
					&Td("","","","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Topic</b>".
						"</font>".
					"</td>".
					&Td("","","","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Originator</b>".
						"</font>".
					"</td>".
					&Td("","","","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Board</b>".
						"</font>".
					"</td>".
					&Td("","","","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Last Modified</b>".
						"</font>".
					"</td>".
				"</tr>";
	for ($i=0;$i<=$#SortedList;$i++) {
        @PostInfo=&DecodeDBOutput($PostID[$SortedList[$i]]);
		$HTML.=	&Tr("","",$RowColor).
						&Td("20","","","","CENTER","","",$ColumnOddBGColor,"").
							&Radio("PostID",$PostInfo[8].$Spliter.$PostInfo[6],"","").
						"</td>".
						&Td("36%","","","","","","",$ColumnEvenBGColor,"").
							&Font($FontFace,$TextSize,$TextColor).
								"[".$PostInfo[4]."] ".
								&Link("UltraBoard.$Ext?Action=ShowPost&Board=$PostInfo[6]&Post=$PostInfo[8]&Session=$SessionID","Post",$PostInfo[3]." (Replies: ".$PostInfo[4].")").
									"<b>$PostInfo[0]</b>".
								"</a>".
							"</font>".
						"</td>".
						&Td("20%","","","","","","",$ColumnOddBGColor,"").
							&Font($FontFace,$TextSize,$TextColor);
		if ($PostInfo[2]) {
			$HTML.=				&Link("UltraBoard.$Ext?Action=ShowProfile&ID=$PostInfo[2]&Session=$SessionID","Profile","UserName: $PostInfo[2]").
									$PostInfo[1].
								"</a>";
		}else{
			$HTML.=				$PostInfo[1];
		}
		$HTML.=				"</font>".
						"</td>".
						&Td("20%","","","","","","",$ColumnEvenBGColor,"").
							&Font($FontFace,$TextSize,$TextColor).
								&Link("UltraBoard.$Ext?Action=ShowBoard&Board=$PostInfo[6]&Session=$SessionID","Board","Board ID: $PostInfo[6]").
									$PostInfo[7].
								"</a>".
							"</font>".
						"</td>".
						&Td("24%","","","","","","",$ColumnOddBGColor,"").
							&Font($FontFace,$TextSize,$TextColor).
								&GetDate($PostInfo[5],$DateTextColor,$TimeTextColor,$DateTextSize,$TimeTextSize).
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
					&Td("","","5","","","","","","").
						"<center>".&Submit("","MODIFY THIS THREAD","width:$IETextBoxSize")."</center>".
					"</td>".
				"</tr>".
				&Tr("","",$MenuBGColor).
					&Td("","","5","","","","","","").
						&PrintVersion().
					"</td>".
				"</tr>".
			"</table></td></tr></table>".
			"</form>";
	&PrintTheme("$UBName Administrative Center - Modify Thread",$HTML);
	exit;
}
###############################################################################
1;# End of ModifyThread Function
###############################################################################