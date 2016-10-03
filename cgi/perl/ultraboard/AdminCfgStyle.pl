###############################################################################
# AdminCfgStyle.pl                                                            #
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
# CfgStyle                                                                    #
###############################################################################
sub CfgStyle {
	open(GROUPS,"$MembersPath/Groups.db")||&CGIError("Couldn't open/read the Groups.db file<br>\nPath: $MembersPath<br>\nReason : $!");
		flock(GROUPS,1) if ($FLock);
		@GROUPS_DATA=<GROUPS>;
	close(GROUPS);
	for (my ($i)=0;$i<=$#GROUPS_DATA;$i++) {
		@GroupInfo=&DecodeDBOutput($GROUPS_DATA[$i]);
		if ($GroupInfo[0] ne "administrator") {
			push (@Groups, $GroupInfo[1]." ($GroupInfo[0])", $GroupInfo[0]);
		}
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
						&Form("UBAdmin.$Ext","POST","","").
						&HiddenBox("Action","DoCfgStyle").
						&HiddenBox("Session",$SessionID).
					"</td>".
				"</tr>".
			"</table>".
			&BTable($TableWidth,$TableAlign,"0","0",$TableCellSpacing,$TableCellPadding,$TableBorderColor,"","").
				&Tr("","",$HeaderBGColor).
					&Td("","","3","","","","","","").
						&Font($FontFace,$HeaderTextSize,$HeaderTextColor).
							"<b>FONT, TEXT SIZE, COLOR OPTIONS</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","3","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Table Properties</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("60%","","","","","","",$ColumnOddBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"<b>Table Width</b>".
						"</font>".
					"</td>".
					&Td("40%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							&TextBox("TableWidth",$TableWidth,"4","4","width:$IETextBoxSize").
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("60%","","","","","","",$ColumnOddBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"<b>Table Cell Padding</b>".
						"</font>".
					"</td>".
					&Td("40%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							&TextBox("TableCellPadding",$TableCellPadding,"2","2","width:$IETextBoxSize").
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("60%","","","","","","",$ColumnOddBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"<b>Table Cell Spacing</b>".
						"</font>".
					"</td>".
					&Td("40%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							&TextBox("TableCellSpacing",$TableCellSpacing,"2","2","width:$IETextBoxSize").
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("60%","","","","","","",$ColumnOddBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"<b>Table Border Color</b>".
						"</font>".
					"</td>".
					&Td("40%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							&TextBox("TableBorderColor",$TableBorderColor,"6","6","width:$IETextBoxSize").
						"</font>".
					"</td>".
				"</tr>".
                &Tr("","",$CategoryBGColor).
					&Td("","","3","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Rows And Columns Color Options</b>".
						"</font>".
					"</td>".
				"</tr>".
                &Tr("","",$RowOddBGColor).
					&Td("60%","","","","","","",$ColumnOddBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"<b>Odd Row Background Color</b>".
						"</font>".
					"</td>".
					&Td("40%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							&TextBox("RowOddBGColor",$RowOddBGColor,"6","6","width:$IETextBoxSize").
						"</font>".
					"</td>".
				"</tr>".
                &Tr("","",$RowOddBGColor).
					&Td("60%","","","","","","",$ColumnOddBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"<b>Even Row Background Color</b>".
						"</font>".
					"</td>".
					&Td("40%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							&TextBox("RowEvenBGColor",$RowEvenBGColor,"6","6","width:$IETextBoxSize").
						"</font>".
					"</td>".
				"</tr>".
                &Tr("","",$RowOddBGColor).
					&Td("60%","","","","","","",$ColumnOddBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"<b>Odd Column Background Color</b>".
						"</font>".
					"</td>".
					&Td("40%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							&TextBox("ColumnOddBGColor",$ColumnOddBGColor,"6","6","width:$IETextBoxSize").
						"</font>".
					"</td>".
				"</tr>".
                &Tr("","",$RowOddBGColor).
					&Td("60%","","","","","","",$ColumnOddBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"<b>Even Column Background Color</b>".
						"</font>".
					"</td>".
					&Td("40%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							&TextBox("ColumnEvenBGColor",$ColumnEvenBGColor,"6","6","width:$IETextBoxSize").
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","3","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Header Strip Properties</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("60%","","","","","","",$ColumnOddBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"<b>Header Background Color</b>".
						"</font>".
					"</td>".
					&Td("40%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							&TextBox("HeaderBGColor",$HeaderBGColor,"6","6","width:$IETextBoxSize").
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("60%","","","","","","",$ColumnOddBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"<b>Header Text Color</b>".
						"</font>".
					"</td>".
					&Td("40%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							&TextBox("HeaderTextColor",$HeaderTextColor,"6","6","width:$IETextBoxSize").
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("60%","","","","","","",$ColumnOddBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"<b>Header Text Size</b>".
						"</font>".
					"</td>".
					&Td("40%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							&TextBox("HeaderTextSize",$HeaderTextSize,"1","1","width:$IETextBoxSize").
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","3","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Category Strip Properties</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("60%","","","","","","",$ColumnOddBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"<b>Category Background Color</b>".
						"</font>".
					"</td>".
					&Td("40%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							&TextBox("CategoryBGColor",$CategoryBGColor,"6","6","width:$IETextBoxSize").
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("60%","","","","","","",$ColumnOddBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"<b>Category Text Color</b>".
						"</font>".
					"</td>".
					&Td("40%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							&TextBox("CategoryTextColor",$CategoryTextColor,"6","6","width:$IETextBoxSize").
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("60%","","","","","","",$ColumnOddBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"<b>Category Name Text Size</b>".
						"</font>".
					"</td>".
					&Td("40%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							&TextBox("CategoryNameTextSize",$CategoryNameTextSize,"1","1","width:$IETextBoxSize").
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("60%","","","","","","",$ColumnOddBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"<b>Category Description Text Size</b>".
						"</font>".
					"</td>".
					&Td("40%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							&TextBox("CategoryDesTextSize",$CategoryDesTextSize,"1","1","width:$IETextBoxSize").
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","3","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Board Font Properties</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("60%","","","","","","",$ColumnOddBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"<b>Board Name Text Size</b>".
						"</font>".
					"</td>".
					&Td("40%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							&TextBox("BoardNameTextSize",$BoardNameTextSize,"1","1","width:$IETextBoxSize").
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("60%","","","","","","",$ColumnOddBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"<b>Board Description Text Size</b>".
						"</font>".
					"</td>".
					&Td("40%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							&TextBox("BoardDesTextSize",$BoardDesTextSize,"1","1","width:$IETextBoxSize").
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","3","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Menu Font Properties</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("60%","","","","","","",$ColumnOddBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"<b>Menu Background Color</b>".
						"</font>".
					"</td>".
					&Td("40%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							&TextBox("MenuBGColor",$MenuBGColor,"6","6","width:$IETextBoxSize").
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("60%","","","","","","",$ColumnOddBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"<b>Menu Text Color</b>".
						"</font>".
					"</td>".
					&Td("40%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							&TextBox("MenuTextColor",$MenuTextColor,"6","6","width:$IETextBoxSize").
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("60%","","","","","","",$ColumnOddBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"<b>Menu Text Size</b>".
						"</font>".
					"</td>".
					&Td("40%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							&TextBox("MenuTextSize",$MenuTextSize,"1","1","width:$IETextBoxSize").
						"</font>".
					"</td>".
				"</tr>".
                &Tr("","",$CategoryBGColor).
					&Td("","","3","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Date and Time Font Properties</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("60%","","","","","","",$ColumnOddBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"<b>Date Text Color</b>".
						"</font>".
					"</td>".
					&Td("40%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							&TextBox("DateTextColor",$DateTextColor,"6","6","width:$IETextBoxSize").
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("60%","","","","","","",$ColumnOddBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"<b>Date Text Size</b>".
						"</font>".
					"</td>".
					&Td("40%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							&TextBox("DateTextSize",$DateTextSize,"1","1","width:$IETextBoxSize").
						"</font>".
					"</td>".
				"</tr>".
                &Tr("","",$RowOddBGColor).
					&Td("60%","","","","","","",$ColumnOddBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"<b>Time Text Color</b>".
						"</font>".
					"</td>".
					&Td("40%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							&TextBox("TimeTextColor",$TimeTextColor,"6","6","width:$IETextBoxSize").
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("60%","","","","","","",$ColumnOddBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"<b>Time Text Size</b>".
						"</font>".
					"</td>".
					&Td("40%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							&TextBox("TimeTextSize",$TimeTextSize,"1","1","width:$IETextBoxSize").
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","3","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Normal Font Properties</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("60%","","","","","","",$ColumnOddBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"<b>Text Face</b>".
						"</font>".
					"</td>".
					&Td("40%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							&TextBox("FontFace",$FontFace,"","","width:$IETextBoxSize").
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("60%","","","","","","",$ColumnOddBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"<b>Normal Text Color</b>".
						"</font>".
					"</td>".
					&Td("40%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							&TextBox("TextColor",$TextColor,"6","6","width:$IETextBoxSize").
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("60%","","","","","","",$ColumnOddBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"<b>Normal Text Size</b>".
						"</font>".
					"</td>".
					&Td("40%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							&TextBox("TextSize",$TextSize,"1","1","width:$IETextBoxSize").
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$HeaderBGColor).
					&Td("","","3","","","","","","").
						&Font($FontFace,$HeaderTextSize,$HeaderTextColor).
							"<b>GRAPHICS/TEXT MENU OPTIONS</b>".
						"</font>".
					"</td>".
				"</tr>".
                &Tr("","",$CategoryBGColor).
					&Td("","","3","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Button Icon</b>".
						"</font>".
					"</td>".
				"</tr>".
                &Tr("","",$RowOddBGColor).
					&Td("60%","","","","","","",$ColumnOddBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"<b>Your Site Icon/Text</b>".
						"</font>".
					"</td>".
					&Td("40%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							&TextBox("imgSite",&RemoveQuot($imgSite),"","","width:$IETextBoxSize").
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("60%","","","","","","",$ColumnOddBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"<b>Home Icon/Text</b>".
						"</font>".
					"</td>".
					&Td("40%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							&TextBox("imgHome",&RemoveQuot($imgHome),"","","width:$IETextBoxSize").
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("60%","","","","","","",$ColumnOddBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"<b>Sign In Icon/Text</b>".
						"</font>".
					"</td>".
					&Td("40%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							&TextBox("imgSignIn",&RemoveQuot($imgSignIn),"","","width:$IETextBoxSize").
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("60%","","","","","","",$ColumnOddBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"<b>Sign Out Icon/Text</b>".
						"</font>".
					"</td>".
					&Td("40%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							&TextBox("imgSignOut",&RemoveQuot($imgSignOut),"","","width:$IETextBoxSize").
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("60%","","","","","","",$ColumnOddBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"<b>Sign Up Icon/Text</b>".
						"</font>".
					"</td>".
					&Td("40%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							&TextBox("imgSignUp",&RemoveQuot($imgSignUp),"","","width:$IETextBoxSize").
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("60%","","","","","","",$ColumnOddBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"<b>Modify Account Icon/Text</b>".
						"</font>".
					"</td>".
					&Td("40%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							&TextBox("imgModifyAccount",&RemoveQuot($imgModifyAccount),"","","width:$IETextBoxSize").
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("60%","","","","","","",$ColumnOddBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"<b>Help Icon/Text</b>".
						"</font>".
					"</td>".
					&Td("40%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							&TextBox("imgHelp",&RemoveQuot($imgHelp),"","","width:$IETextBoxSize").
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("60%","","","","","","",$ColumnOddBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"<b>Search Icon/Text</b>".
						"</font>".
					"</td>".
					&Td("40%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							&TextBox("imgSearch",&RemoveQuot($imgSearch),"","","width:$IETextBoxSize").
						"</font>".
					"</td>".
				"</tr>".
                &Tr("","",$RowOddBGColor).
					&Td("60%","","","","","","",$ColumnOddBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"<b>Administrative Center Icon/Text</b>".
						"</font>".
					"</td>".
					&Td("40%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							&TextBox("imgAdmin",&RemoveQuot($imgAdmin),"","","width:$IETextBoxSize").
						"</font>".
					"</td>".
				"</tr>".
                &Tr("","",$RowOddBGColor).
					&Td("60%","","","","","","",$ColumnOddBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"<b>Profile Icon/Text</b>".
						"</font>".
					"</td>".
					&Td("40%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							&TextBox("imgProfile",&RemoveQuot($imgProfile),"","","width:$IETextBoxSize").
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("60%","","","","","","",$ColumnOddBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"<b>Email Icon/Text</b>".
						"</font>".
					"</td>".
					&Td("40%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							&TextBox("imgEmail",&RemoveQuot($imgEmail),"","","width:$IETextBoxSize").
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("60%","","","","","","",$ColumnOddBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"<b>Post Icon/Text</b>".
						"</font>".
					"</td>".
					&Td("40%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							&TextBox("imgPost",&RemoveQuot($imgPost),"","","width:$IETextBoxSize").
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("60%","","","","","","",$ColumnOddBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"<b>Reply Icon/Text</b>".
						"</font>".
					"</td>".
					&Td("40%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							&TextBox("imgReply",&RemoveQuot($imgReply),"","","width:$IETextBoxSize").
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("60%","","","","","","",$ColumnOddBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"<b>Print Icon/Text</b>".
						"</font>".
					"</td>".
					&Td("40%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							&TextBox("imgPrint",&RemoveQuot($imgPrint),"","","width:$IETextBoxSize").
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("60%","","","","","","",$ColumnOddBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"<b>Forward Icon/Text</b>".
						"</font>".
					"</td>".
					&Td("40%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							&TextBox("imgForward",&RemoveQuot($imgForward),"","","width:$IETextBoxSize").
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("60%","","","","","","",$ColumnOddBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"<b>Modify Message Icon/Text</b>".
						"</font>".
					"</td>".
					&Td("40%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							&TextBox("imgModify",&RemoveQuot($imgModify),"","","width:$IETextBoxSize").
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("60%","","","","","","",$ColumnOddBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"<b>Remove Reply Icon/Text</b>".
						"</font>".
					"</td>".
					&Td("40%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							&TextBox("imgRemove",&RemoveQuot($imgRemove),"","","width:$IETextBoxSize").
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("60%","","","","","","",$ColumnOddBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"<b>Remove Thread Icon/Text</b>".
						"</font>".
					"</td>".
					&Td("40%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							&TextBox("imgRemoveThread",&RemoveQuot($imgRemoveThread),"","","width:$IETextBoxSize").
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("60%","","","","","","",$ColumnOddBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"<b>Close Thread Icon/Text</b>".
						"</font>".
					"</td>".
					&Td("40%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							&TextBox("imgCloseThread",&RemoveQuot($imgCloseThread),"","","width:$IETextBoxSize").
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("60%","","","","","","",$ColumnOddBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"<b>Open Thread Icon/Text</b>".
						"</font>".
					"</td>".
					&Td("40%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							&TextBox("imgOpenThread",&RemoveQuot($imgOpenThread),"","","width:$IETextBoxSize").
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("60%","","","","","","",$ColumnOddBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"<b>Previous Icon/Text</b>".
						"</font>".
					"</td>".
					&Td("40%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							&TextBox("imgPrevious",&RemoveQuot($imgPrevious),"","","width:$IETextBoxSize").
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("60%","","","","","","",$ColumnOddBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"<b>Next Icon/Text</b>".
						"</font>".
					"</td>".
					&Td("40%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							&TextBox("imgNext",&RemoveQuot($imgNext),"","","width:$IETextBoxSize").
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("60%","","","","","","",$ColumnOddBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"<b>Sperater Icon/Text</b>".
						"</font>".
					"</td>".
					&Td("40%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							&TextBox("imgSperater",&RemoveQuot($imgSperater),"","","width:$IETextBoxSize").
						"</font>".
					"</td>".
				"</tr>".
                &Tr("","",$CategoryBGColor).
					&Td("","","3","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Emotions Icon</b>".
						"</font>".
					"</td>".
				"</tr>".
                &Tr("","",$RowOddBGColor).
					&Td("60%","","","","","","",$ColumnOddBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"<b>Emotion \":)\" Icon</b>".
						"</font>".
					"</td>".
					&Td("40%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							&TextBox("imgEmotion_1",&RemoveQuot($imgEmotion_1),"","","width:$IETextBoxSize").
						"</font>".
					"</td>".
				"</tr>".
                &Tr("","",$RowOddBGColor).
					&Td("60%","","","","","","",$ColumnOddBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"<b>Emotion \":(\" Icon</b>".
						"</font>".
					"</td>".
					&Td("40%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							&TextBox("imgEmotion_2",&RemoveQuot($imgEmotion_2),"","","width:$IETextBoxSize").
						"</font>".
					"</td>".
				"</tr>".
                &Tr("","",$RowOddBGColor).
					&Td("60%","","","","","","",$ColumnOddBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"<b>Emotion \";)\" Icon</b>".
						"</font>".
					"</td>".
					&Td("40%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							&TextBox("imgEmotion_3",&RemoveQuot($imgEmotion_3),"","","width:$IETextBoxSize").
						"</font>".
					"</td>".
				"</tr>".
                &Tr("","",$RowOddBGColor).
					&Td("60%","","","","","","",$ColumnOddBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"<b>Emotion \":P\" Icon</b>".
						"</font>".
					"</td>".
					&Td("40%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							&TextBox("imgEmotion_4",&RemoveQuot($imgEmotion_4),"","","width:$IETextBoxSize").
						"</font>".
					"</td>".
				"</tr>".
                &Tr("","",$RowOddBGColor).
					&Td("60%","","","","","","",$ColumnOddBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"<b>Emotion \";P\" Icon</b>".
						"</font>".
					"</td>".
					&Td("40%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							&TextBox("imgEmotion_5",&RemoveQuot($imgEmotion_5),"","","width:$IETextBoxSize").
						"</font>".
					"</td>".
				"</tr>".
                &Tr("","",$RowOddBGColor).
					&Td("60%","","","","","","",$ColumnOddBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"<b>Emotion \":o\" Icon</b>".
						"</font>".
					"</td>".
					&Td("40%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							&TextBox("imgEmotion_6",&RemoveQuot($imgEmotion_6),"","","width:$IETextBoxSize").
						"</font>".
					"</td>".
				"</tr>".
                &Tr("","",$RowOddBGColor).
					&Td("60%","","","","","","",$ColumnOddBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"<b>Emotion \":o)\" Icon</b>".
						"</font>".
					"</td>".
					&Td("40%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							&TextBox("imgEmotion_7",&RemoveQuot($imgEmotion_7),"","","width:$IETextBoxSize").
						"</font>".
					"</td>".
				"</tr>".
                &Tr("","",$RowOddBGColor).
					&Td("60%","","","","","","",$ColumnOddBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"<b>Emotion \"^_^\" Icon</b>".
						"</font>".
					"</td>".
					&Td("40%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							&TextBox("imgEmotion_8",&RemoveQuot($imgEmotion_8),"","","width:$IETextBoxSize").
						"</font>".
					"</td>".
				"</tr>".
                &Tr("","",$RowOddBGColor).
					&Td("60%","","","","","","",$ColumnOddBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"<b>Emotion \"^^;\" Icon</b>".
						"</font>".
					"</td>".
					&Td("40%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							&TextBox("imgEmotion_9",&RemoveQuot($imgEmotion_9),"","","width:$IETextBoxSize").
						"</font>".
					"</td>".
				"</tr>".
                &Tr("","",$RowOddBGColor).
					&Td("60%","","","","","","",$ColumnOddBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"<b>Emotion \"^^\" Icon</b>".
						"</font>".
					"</td>".
					&Td("40%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							&TextBox("imgEmotion_10",&RemoveQuot($imgEmotion_10),"","","width:$IETextBoxSize").
						"</font>".
					"</td>".
				"</tr>".
                &Tr("","",$RowOddBGColor).
					&Td("60%","","","","","","",$ColumnOddBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"<b>Emotion \"8-)\" Icon</b>".
						"</font>".
					"</td>".
					&Td("40%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							&TextBox("imgEmotion_11",&RemoveQuot($imgEmotion_11),"","","width:$IETextBoxSize").
						"</font>".
					"</td>".
				"</tr>".
                &Tr("","",$RowOddBGColor).
					&Td("60%","","","","","","",$ColumnOddBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"<b>Emotion \"8)\" Icon</b>".
						"</font>".
					"</td>".
					&Td("40%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							&TextBox("imgEmotion_12",&RemoveQuot($imgEmotion_12),"","","width:$IETextBoxSize").
						"</font>".
					"</td>".
				"</tr>".
                &Tr("","",$RowOddBGColor).
					&Td("60%","","","","","","",$ColumnOddBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"<b>Emotion \":D\" Icon</b>".
						"</font>".
					"</td>".
					&Td("40%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							&TextBox("imgEmotion_13",&RemoveQuot($imgEmotion_13),"","","width:$IETextBoxSize").
						"</font>".
					"</td>".
				"</tr>";
    $HTML.=		&Tr("","",$HeaderBGColor).
					&Td("","","3","","","","","","").
						&Font($FontFace,$HeaderTextSize,$HeaderTextColor).
							"<b>MISCELLANEOUS OPTIONS</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("60%","","","","","","",$ColumnOddBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"<b>Text Box Size</b>".
						"</font>".
					"</td>".
					&Td("40%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							&TextBox("TextBoxSize",$TextBoxSize,"3","3","width:$IETextBoxSize").
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("60%","","","","","","",$ColumnOddBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"<b>Text Box Width (for IE 4 or higher)</b>".
						"</font>".
					"</td>".
					&Td("40%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							&TextBox("IETextBoxSize",$IETextBoxSize,"4","4","width:$IETextBoxSize").
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","3","","","","","","").
						"<center>".&Submit("","SUBMIT AND SAVE CONFIGURATION","width:$IETextBoxSize")."</center>".
					"</td>".
				"</tr>".
				&Tr("","",$MenuBGColor).
					&Td("","","3","","","","","","").
						&PrintVersion().
					"</td>".
				"</tr>".
			"</table></td></tr></table>".
			"</form>";
	&PrintTheme("$UBName Administrative Center - Configure Style Options",$HTML);
	exit;
}
###############################################################################
sub RemoveQuot {
	$_ = shift;
	$_ =~ s/\"/\&quot\;/g;
	return $_;
}
###############################################################################
1;# End of CfgStyle Function
###############################################################################