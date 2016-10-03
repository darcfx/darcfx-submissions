###############################################################################
# AdminModifyCategory.pl                                                      #
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
# ModifyCategory                                                              #
###############################################################################
sub ModifyCategory {
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
						&HiddenBox("Action","DoModifyCategory").
						&HiddenBox("Count",scalar(@CATEGORIES_DATA)).
						&HiddenBox("Session",$SessionID).
					"</td>".
				"</tr>".
			"</table>".
			&BTable($TableWidth,$TableAlign,"0","0",$TableCellSpacing,$TableCellPadding,$TableBorderColor,"","").
				&Tr("","",$HeaderBGColor).
					&Td("","","4","","","","","","").
						&Font($FontFace,$HeaderTextSize,$HeaderTextColor).
							"<b>MODIFY CATEGORY</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","","","","","","","").
						"&nbsp;".
					"</td>".
					&Td("","","","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Category Name</b>".
						"</font>".
					"</td>".
					&Td("","","","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Category ID</b>".
						"</font>".
					"</td>".
					&Td("","","","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b># Boards</b>".
						"</font>".
					"</td>".
				"</tr>";
	$RowColor=$RowOddBGColor;
	for (my ($i)=0;$i<=$#CATEGORIES_DATA;$i++) {
		@CategoryInfo=&DecodeDBOutput($CATEGORIES_DATA[$i]);
		open(CATEGORY,"$DBPath/$CategoryInfo[0].cat")||&CGIError("Couldn't open/read the $CategoryInfo[0].cat file<br>\nPath: $DBPath<br>\nReason : $!");
			flock(CATEGORY,1) if ($FLock);
			@CATEGORY_DATA=<CATEGORY>;
		close(CATEGORY);
		$HTML.=	&Tr("","",$RowColor).
					&Td("20","","","","","","",$ColumnOddBGColor,"").
						&Radio("CategoryID","$CategoryInfo[0]","","").
					"</td>".
					&Td("50%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							&Link("UltraBoard.$Ext?Action=ShowCategory&Category=$CategoryInfo[0]&Session=$SessionID","Category","$CategoryInfo[2]").
								$CategoryInfo[1].
							"</a>".
						"</font>".
					"</td>".
					&Td("30%","","","","","","",$ColumnOddBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							$CategoryInfo[0].
						"</font>".
					"</td>".
					&Td("20%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							(scalar(@CATEGORY_DATA)-1)." Boards".
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
						"<center>".&Submit("","MODIFY THIS CATEGORY","width:$IETextBoxSize")."</center>".
					"</td>".
				"</tr>".
				&Tr("","",$MenuBGColor).
					&Td("","","4","","","","","","").
						&PrintVersion().
					"</td>".
				"</tr>".
			"</table></td></tr></table>".
			"</form>";
	&PrintTheme("$UBName Administrative Center - Modify Category",$HTML);
	exit;
}
###############################################################################
1;# End of ModifyCategory Function
##############################################################