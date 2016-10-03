###############################################################################
# AdminCreateAccount.pl                                                       #
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
# CreateAccount                                                               #
###############################################################################
sub CreateAccount {
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
						&HiddenBox("Action","DoCreateAccount").
						&HiddenBox("Session",$SessionID).
					"</td>".
				"</tr>".
			"</table>".
			&BTable($TableWidth,$TableAlign,"0","0",$TableCellSpacing,$TableCellPadding,$TableBorderColor,"","").
				&Tr("","",$HeaderBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$HeaderTextSize,$HeaderTextColor).
							"<b>CREATE A NEW MEMBER ACCOUNT</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>UserName (require)</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"username can be up to 26 characters with letters or numbers, and it is non case-sensitive!".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","2","","","","",$ColumnOddBGColor,"").
						&TextBox("REG_UserName","",$TextBoxSize,"26","width:$IETextBoxSize").
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Password (require)</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"password can be up to 26 characters with letters or numbers, and it is case-sensitive!".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","2","","","","",$ColumnOddBGColor,"").
						&PasswordBox("REG_Password","",$TextBoxSize,"26","width:$IETextBoxSize").
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
						&PasswordBox("REG_VerfiyPassword","",$TextBoxSize,"","width:$IETextBoxSize").
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
						&Select("REG_Group","","width:$IETextBoxSize","","",
							@Groups
						).
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
						&Select("REG_Status","","width:$IETextBoxSize","","",
							"Activate","Activate",
							"Disactivate","Disactivate"
						).
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Nick Name (require)</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"his/her nick name can be up to 20 characters, it will used in his/her every message.".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","2","","","","",$ColumnOddBGColor,"").
						&TextBox("REG_NickName","",$TextBoxSize,"20","width:$IETextBoxSize").
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Email (require)</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"please use his/her real email address. ".$EmailMessage.
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","2","","","","",$ColumnOddBGColor,"").
						&TextBox("REG_Email","",$TextBoxSize,"","width:$IETextBoxSize").
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
						&TextBox("REG_HomePage","",$TextBoxSize,"","width:$IETextBoxSize").
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
						&TextBox("REG_Location","",$TextBoxSize,"","width:$IETextBoxSize").
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
						&TextBox("REG_ICQ","",$TextBoxSize,"","width:$IETextBoxSize").
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
						&TextBox("REG_Age","",$TextBoxSize,"2","width:$IETextBoxSize").
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
						&TextBox("REG_Occupation","",$TextBoxSize,"","width:$IETextBoxSize").
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
						&TextBox("REG_Interests","",$TextBoxSize,"","width:$IETextBoxSize").
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
						&TextArea("REG_Comments","",$TextBoxSize,"3","VIRUAL","width:$IETextBoxSize").
					"</td>".
				"</tr>";
	if ($UseSignatures) {
		$HTML.=	&Tr("","",$CategoryBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Signature</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"the signature will appear at bottom of his/her every posts. you can use ultraboard codes on this signature.".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","2","","","","",$ColumnOddBGColor,"").
						&TextArea("REG_Signature","",$TextBoxSize,"5","$TextAreaType","width:$IETextBoxSize").
					"</td>".
				"</tr>";
	}
	$HTML.=		&Tr("","",$CategoryBGColor).
					&Td("20","","","","","","","","").
						&Checkbox("REG_ShowEmail","on","",$ShowEmail).
					"</td>".
					&Td("100%","","","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							" <b>Show Your Email Address?</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","2","","","","","","").
						"<center>".&Submit("","CREATE THIS MEMBER ACCOUNT","width:$IETextBoxSize")."</center>".
					"</td>".
				"</tr>".
				&Tr("","",$MenuBGColor).
					&Td("","","2","","","","","","").
						&PrintVersion().
					"</td>".
				"</tr>".
			"</table></td></tr></table>".
			"</form>";
	&PrintTheme("$UBName Administrative Center - Create a New Member Account",$HTML);
	exit;
}
###############################################################################
1;# End of CreateAccount Function
###############################################################################