###############################################################################
# AdminModifyProfile.pl                                                       #
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
# ModifyProfile                                                               #
###############################################################################
sub ModifyProfile {
	open(GROUPS,"$MembersPath/administrator.grp")||&CGIError("Couldn't open/read the administrator.grp file<br>\nPath: $MembersPath<br>\nReason : $!");
		flock(GROUPS,1) if ($FLock);
		@GROUPS_DATA=<GROUPS>;
	close(GROUPS);
	@GroupInfo=&DecodeDBOutput($GROUPS_DATA[0]);
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
						&HiddenBox("Action","DoModifyProfile").
						&HiddenBox("Session",$SessionID).
                        &HiddenBox("OldEmail",$MemberData[4]).
					"</td>".
				"</tr>".
			"</table>".
			&BTable($TableWidth,$TableAlign,"0","0",$TableCellSpacing,$TableCellPadding,$TableBorderColor,"","").
				&Tr("","",$HeaderBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$HeaderTextSize,$HeaderTextColor).
							"<b>MODIFY ADMINISTRATOR PROFILE</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Password (require)</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"password can be up to 26 characters with letters or numbers, and it is case-sensitive! Leave it blank, if you don't want to change your password.".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","2","","","","",$ColumnOddBGColor,"").
						&PasswordBox("MOD_NewPassword","",$TextBoxSize,"26","width:$IETextBoxSize").
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Verfiy Password (require)</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"please enter the password again.".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","2","","","","",$ColumnOddBGColor,"").
						&PasswordBox("MOD_VerfiyNewPassword","",$TextBoxSize,"26","width:$IETextBoxSize").
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Members Group</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","2","","","","",$ColumnOddBGColor,"").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>$GroupInfo[1] ($GroupInfo[0])</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Status</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","2","","","","",$ColumnOddBGColor,"").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Activate</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Nick Name (require)</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"nick name can be up to 20 characters, it will used in your every messages.".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","2","","","","",$ColumnOddBGColor,"").
						&TextBox("MOD_NickName",$MemberData[1],$TextBoxSize,"20","width:$IETextBoxSize").
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Email (require)</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"please use real email address, so members can contact you. ".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","2","","","","",$ColumnOddBGColor,"").
						&TextBox("MOD_Email",$MemberData[4],$TextBoxSize,"","width:$IETextBoxSize").
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Home Page</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","2","","","","",$ColumnOddBGColor,"").
						&TextBox("MOD_HomePage",$MemberData[8],$TextBoxSize,"","width:$IETextBoxSize").
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Location</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","2","","","","",$ColumnOddBGColor,"").
						&TextBox("MOD_Location",$MemberData[9],$TextBoxSize,"","width:$IETextBoxSize").
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>ICQ Number</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","2","","","","",$ColumnOddBGColor,"").
						&TextBox("MOD_ICQ",$MemberData[13],$TextBoxSize,"","width:$IETextBoxSize").
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Age</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","2","","","","",$ColumnOddBGColor,"").
						&TextBox("MOD_Age",$MemberData[10],$TextBoxSize,"2","width:$IETextBoxSize").
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Occupation</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","2","","","","",$ColumnOddBGColor,"").
						&TextBox("MOD_Occupation",$MemberData[11],$TextBoxSize,"","width:$IETextBoxSize").
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Interests</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","2","","","","",$ColumnOddBGColor,"").
						&TextBox("MOD_Interests",$MemberData[12],$TextBoxSize,"","width:$IETextBoxSize").
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Comments</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","2","","","","",$ColumnOddBGColor,"").
						&TextArea("MOD_Comments",$MemberData[14],$TextBoxSize,"3","VIRUAL","width:$IETextBoxSize").
					"</td>".
				"</tr>";
	if ($UseSignatures) {
		$HTML.=	&Tr("","",$CategoryBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Signature</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"the signature will appear at bottom of your messages. you can use ultraboard codes on your signature.".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","2","","","","",$ColumnOddBGColor,"").
						&TextArea("MOD_Signature",&DecodeUBCodes($MemberData[15]),$TextBoxSize,"5","$TextAreaType","width:$IETextBoxSize").
					"</td>".
				"</tr>";
	}
	if ($Cookies{'Idle'} ne "") {
		$in{'Idle'}=$Cookies{'Idle'};
	} else {
		$in{'Idle'}="default";
	}
	if ($Cookies{'Sort'} ne "") {
		$in{'Sort'}=$Cookies{'Sort'};
	} else {
		$in{'Sort'}=$SortTopics;
	}
	if ($Cookies{'Order'} ne "") {
		$in{'Order'}=$Cookies{'Order'};
	} else {
		$in{'Order'}=$SortOrder;
	}

	$HTML.=		&Tr("","",$CategoryBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Default Show Topics?</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","2","","","","","","").
						&Table("100%","CENTER","0","0","","").
                            &Tr("","","").
                                &Td("","","","","","","","","").
                                    &Select("MOD_Idle","","","",$in{'Idle'},
											"Use default ($ShowTopics days)","default",
											"Show topics from last day","1",
											"Show topics from last 2 days","2",
											"Show topics from last 3 days","3",
											"Show topics from last 7 days","7",
											"Show topics from last 10 days","10",
											"Show topics from last 20 days","20",
											"Show topics from last 30 days","30",
											"Show topics from last 45 days","45",
											"Show topics from last 60 days","60",
											"Show topics from last 90 days","90",
											"Show topics from last year","365",
											"Show all topics","0",
										   ).
                                "</td>".
                                &Td("","","","","","","","","").
                                    &Select("MOD_Order","","","",$in{'Order'},
											"that sorted by ascending","Ascend",
											"that sorted by descending","Descend",
										   ).
                                "</td>".
								&Td("100%","","","","","","","","").
                                    &Select("MOD_Sort","","width: $IETextBoxSize","",$in{'Sort'},
											"topic","3",
											"originator","5",
											"replies","2",
											"last modified","0",
										   ).
                                "</td>".
                            "</tr>".
                        "</table>".
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("20","","","","","","","","").
						&Checkbox("MOD_Remember","on","",$Remember).
					"</td>".
					&Td("100%","","","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							" <b>Remember Your Password?</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("20","","","","","","","","").
						&Checkbox("MOD_ShowEmail","on","",$MemberData[17]).
					"</td>".
					&Td("100%","","","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							" <b>Show Your Email Address?</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","2","","","","","","").
						"<center>".&Submit("","MODIFY YOUR PROFILE","width:$IETextBoxSize")."</center>".
					"</td>".
				"</tr>".
				&Tr("","",$MenuBGColor).
					&Td("","","2","","","","","","").
						&PrintVersion().
					"</td>".
				"</tr>".
			"</table></td></tr></table>".
			"</form>";
	&PrintTheme("$UBName Administrative Center - Modify Administrator Profile",$HTML);
	exit;
}
###############################################################################
1;# End of ModifyProfile Function
###############################################################################