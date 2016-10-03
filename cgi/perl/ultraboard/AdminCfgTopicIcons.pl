###############################################################################
# AdminCfgGeneral.pl                                                          #
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
# CfgTopicIcons                                                               #
###############################################################################
sub CfgTopicIcons {
    open(ICON,"$VarsPath/mIcons.txt");
		flock(ICON,2) if ($FLock);
		my (@Icons)=<ICON>;
	close(ICON);
    $Size=scalar(@Icons);
    $Size = 10 if ($Size<10);
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
						&HiddenBox("Action","DoCfgTopicIcons").
						&HiddenBox("Session",$SessionID).
                        &HiddenBox("COUNT",$Size).
					"</td>".
				"</tr>".
			"</table>".
	        &BTable($TableWidth,$TableAlign,"0","0",$TableCellSpacing,$TableCellPadding,$TableBorderColor,"","").
				&Tr("","",$HeaderBGColor).
					&Td("","","4","","","","","","").
						&Font($FontFace,$HeaderTextSize,$HeaderTextColor).
							"<b>TOPIC ICONS</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("20","","","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Default</b>".
						"</font>".
					"</td>".
                    &Td("","","","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>ID</b>".
						"</font>".
					"</td>".
                    &Td("","","","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Icon Description</b>".
						"</font>".
					"</td>".
                    &Td("","","","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Icon URL</b>".
						"</font>".
					"</td>".
				"</tr>";
    $RowColor=$RowOddBGColor;
    for ($i=0;$i<=$Size;$i++) {
		($ICON_ID,$ICON_DES,$ICON_URL,$ICON_DEF)=split(/\|\^\|/,$Icons[$i]);
        if ($ICON_DEF) {
            $s=$i;
        }else{
            $s="";
        }
        
		$HTML.=	&Tr("","",$RowColor).
					&Td("","","","","","","",$ColumnOddBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"<center>".&Radio("ICON_DEF",$i,$s,"")."</center>".
						"</font>".
					"</td>".
					&Td("20%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							&TextBox("ICON_ID_$i",$ICON_ID,"","","width:$IETextBoxSize").
						"</font>".
					"</td>".
                    &Td("40%","","","","","","",$ColumnOddBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							&TextBox("ICON_DES_$i",$ICON_DES,"","","width:$IETextBoxSize").
						"</font>".
					"</td>".
                    &Td("40%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							&TextBox("ICON_URL_$i",$ICON_URL,"","","width:$IETextBoxSize").
						"</font>".
					"</td>".
				"</tr>";
        if ($RowColor eq $RowEvenBGColor) {
			$RowColor=$RowOddBGColor;
		}else{
			$RowColor=$RowEvenBGColor;
		}
    }
    $HTML.=	&Tr("","",$CategoryBGColor).
					&Td("","","4","","","","","","").
						"<center>".&Submit("","SUBMIT AND SAVE CONFIGURATION","width:$IETextBoxSize")."</center>".
					"</td>".
				"</tr>".
				&Tr("","",$MenuBGColor).
					&Td("","","4","","","","","","").
						&PrintVersion().
					"</td>".
				"</tr>".
            "</table></td></tr></table>".
            "</form>";
    &PrintTheme("$UBName Administrative Center - Configure Topic Icons",$HTML);
	exit;
}
###############################################################################
1;# End of CfgTopicIcons Function
###############################################################################
