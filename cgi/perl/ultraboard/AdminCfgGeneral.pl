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
# CfgGeneral                                                                  #
###############################################################################
sub CfgGeneral {
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
    open(RULE,"$VarsPath/Rule.txt");
		flock(RULE,2) if ($FLock);
		my (@Rule)=<RULE>;
        $Rule=join("",@Rule);
        $Rule=~s/<p>\\n\\n/\n\n/isg;
        $Rule=~s/<br>\\n/\n/isg;
	close(RULE);
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
						&HiddenBox("Action","DoCfgGeneral").
						&HiddenBox("Session",$SessionID).
					"</td>".
				"</tr>".
			"</table>".
			&BTable($TableWidth,$TableAlign,"0","0",$TableCellSpacing,$TableCellPadding,$TableBorderColor,"","").
				&Tr("","",$HeaderBGColor).
					&Td("","","4","","","","","","").
						&Font($FontFace,$HeaderTextSize,$HeaderTextColor).
							"<b>GENERAL INFORMATIONS</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","4","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Home Page Name (required)</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"the name of your home page.".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","4","","","","",$ColumnOddBGColor,"").
						&TextBox("SiteName",$SiteName,$TextBoxSize,"","width:$IETextBoxSize").
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","4","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>UltraBoard Name (required)</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"the name of your forum.".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","4","","","","",$ColumnOddBGColor,"").
						&TextBox("UBName",$UBName,$TextBoxSize,"","width:$IETextBoxSize").
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","4","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>UltraBoard Description</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"a little description of your forum.".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","4","","","","",$ColumnOddBGColor,"").
						&TextBox("UBDes",$UBDes,$TextBoxSize,"","width:$IETextBoxSize").
					"</td>".
				"</tr>".
				&Tr("","",$HeaderBGColor).
					&Td("","","4","","","","","","").
						&Font($FontFace,$HeaderTextSize,$HeaderTextColor).
							"<b>DISPLAY OPERATIONS</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("20","","","","","","","","").
						&Checkbox("DisplayFront","on","",$DisplayFront).
					"</td>".
					&Td("100%","","3","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Display UltraBoard Front Page</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"if you want to allow the visitor to see the front page of your board, check this option.".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("20","","","2","","","",$ColumnOddBGColor,"").
						"&nbsp;".
					"</td>".
					&Td("20","","","","","","",$CategoryBGColor,"").
						&Checkbox("UseCategory","on","",$UseCategory).
					"</td>".
					&Td("100%","","2","","","","",$CategoryBGColor,"").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Display Categories</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"if you want to allow the visitor to see the categories of your board, check this option.".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("20","","","","","","",$ColumnOddBGColor,"").
						"&nbsp;".
					"</td>".
					&Td("20","","","","","","",$CategoryBGColor,"").
						&Checkbox("OnlyCategory","on","",$OnlyCategory).
					"</td>".
					&Td("100%","","","","","","",$CategoryBGColor,"").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Display Categories on Front Page Only</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"check this if you only want categories displayed-no boards.".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("20","","","","","","","","").
						&Checkbox("DisplayCategoryDes","on","",$DisplayCategoryDes).
					"</td>".
					&Td("100%","","3","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Display Categories Description</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"if you want categories description displayed on your forum.".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("20","","","","","","","","").
						&Checkbox("DisplayBoardDes","on","",$DisplayBoardDes).
					"</td>".
					&Td("100%","","3","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Display Boards Description</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"check this if you want boards to be displayed. if not, uncheck this.".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("20","","","","","","","","").
						&Checkbox("ShowNumberMembers","on","",$ShowNumberMembers).
					"</td>".
					&Td("100%","","3","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Display Total Members Number</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"check this if you want total members number to be displayed. if not, uncheck this.".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","4","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Show Total Posts/Total Topics</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"choose which fields you want displayed on the main page by each forum.".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("20","","","","","","",$ColumnOddBGColor,"").
						&Radio("ShowTotal","Both",$ShowTotal,"").
					"</td>".
					&Td("100%","","3","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"Show both total topics and total posts.".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowEvenBGColor).
					&Td("20","","","","","","",$ColumnOddBGColor,"").
						&Radio("ShowTotal","Topics",$ShowTotal,"").
					"</td>".
					&Td("100%","","3","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"Show total topics only.".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowEvenBGColor).
					&Td("20","","","","","","",$ColumnOddBGColor,"").
						&Radio("ShowTotal","Posts",$ShowTotal,"").
					"</td>".
					&Td("100%","","3","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"Show total posts only.".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","4","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Default Topics View in Days</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"the default number of days that topics will be shown in each board.".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","4","","","","",$ColumnOddBGColor,"").
						&Select("ShowTopics","","width:$IETextBoxSize","",$ShowTopics,
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
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","4","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Default Sort and Order of Messages</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"the default way messages are ordered in the board.".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","4","","","","",$ColumnOddBGColor,"").
						&Table("100%","CENTER","0","0","","").
							 &Tr("","","").
                                &Td("","","","","","","","","").
                                    &Select("SortOrder","","","",$SortOrder,
											"all messages sorted by ascending order ","Ascend",
											"all messages sorted by descending order","Descend",
										   ).
                                "</td>".
								&Td("100%","","","","","","","","").
                                    &Select("SortTopics","","width: $IETextBoxSize","",$SortTopics,
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
					&Td("","","4","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Maximum Number of Topics Listed in a Page</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"how many topics should be displayed in each page.".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","4","","","","",$ColumnOddBGColor,"").
						&Select("NumPage","","width:$IETextBoxSize","",$NumPage,
								"List 10 Topics in a Page","10",
								"List 20 Topics in a Page","20",
								"List 30 Topics in a Page","30",
								"List 40 Topics in a Page","40",
								"List 50 Topics in a Page","50",
								"List 60 Topics in a Page","60",
								"List 70 Topics in a Page","70",
								"List 80 Topics in a Page","80",
								"List 90 Topics in a Page","90",
								"List 100 Topics in a Page","100",
								"List All Topics in a Page","99999999",
							   ).
					"</td>".
				"</tr>".
				&Tr("","",$HeaderBGColor).
					&Td("","","4","","","","","","").
						&Font($FontFace,$HeaderTextSize,$HeaderTextColor).
							"<b>REGISTRATION OPTIONS</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("20","","","","","","","","").
						&Checkbox("AllowRegister","on","",$AllowRegister).
					"</td>".
					&Td("100%","","3","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Allow Visitors to Register on UltraBoard</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"if you want to allow visitors to register an account on their own. otherwise, they will not be shown a sign up page when they try to register.".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
                &Tr("","",$RowOddBGColor).
                    &Td("20","","","8","","","",$ColumnOddBGColor,"").
						"&nbsp;".
					"</td>".
					&Td("20","","","","","","",$CategoryBGColor,"").
						&Checkbox("UseRule","on","",$UseRule).
					"</td>".
					&Td("100%","","2","","","","",$CategoryBGColor,"").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Use Rules and Terms of Agreement</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"if you want to use rules and terms of agreement on sign up page.".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
                &Tr("","",$RowOddBGColor).
                    &Td("20","","","","","","",$ColumnOddBGColor,"").
						"&nbsp;".
					"</td>".
					&Td("100%","","3","","","","",$ColumnOddBGColor,"").
						&TextArea("Rule",$Rule,$TextBoxSize,"5","VIRTUAL","width:$IETextBoxSize").
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("100%","","3","","","","",$CategoryBGColor,"").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Default Group During Registration</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"which group do you want your members in by default?".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("100%","","3","","","","",$ColumnOddBGColor,"").
						&Select("DefaultGroup","","width:$IETextBoxSize","",$DefaultGroup,
							@Groups
						).
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("20","","","","","","",$CategoryBGColor,"").
						&Checkbox("ViewRegister","on","",$ViewRegister).
					"</td>".
					&Td("100%","","2","","","","",$CategoryBGColor,"").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Review Members Account (required mail function)</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"if you want to review registration information before allowing a user to post on your board. you will be e-mailed every time someone registers.".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("20","","","","","","",$CategoryBGColor,"").
						&Checkbox("VerifyReg","on","",$VerifyReg).
					"</td>".
					&Td("100%","","2","","","","",$CategoryBGColor,"").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Verify Members Email Address (required mail function)</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"if you want to verify the e-mail address to see whether it is valid or not. (it will send the password to the registrant to determine this.)".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("20","","","","","","",$CategoryBGColor,"").
						&Checkbox("CheckEmail","on","",$CheckEmail).
					"</td>".
					&Td("100%","","2","","","","",$CategoryBGColor,"").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Email Duplicate Check</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"if you want to check whether an e-mail address is unique or has been used before on your forum.".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("20","","","","","","",$CategoryBGColor,"").
						&Checkbox("NotifyRegister","on","",$NotifyRegister).
					"</td>".
					&Td("100%","","2","","","","",$CategoryBGColor,"").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Notify You After Registration (required mail function)</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"if you want to notified after someone registers an account.".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("20","","","","","","","","").
						&Checkbox("ShowEmail","on","",$ShowEmail).
					"</td>".
					&Td("100%","","3","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Default Show Members Email</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"by default, do you want to board to show a user's e-mail address on his or her's posts and profile?".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
                &Tr("","",$RowOddBGColor).
					&Td("100%","","5","","","","",$CategoryBGColor,"").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Maximum Comments Length</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"the maximum number of characters allowed in the comments field.".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("100%","","5","","","","",$ColumnOddBGColor,"").
						&TextBox("CommentLength",$CommentLength,$TextBoxSize,"3","width:$IETextBoxSize").
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("20","","","","","","","","").
						&Checkbox("UseSignatures","on","",$UseSignatures).
					"</td>".
					&Td("100%","","3","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Allow Members to have signatures?</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"if you want members to be able to have signatures in their messages.".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
                &Tr("","",$RowOddBGColor).
					&Td("20","","","2","","","",$ColumnOddBGColor,"").
						"&nbsp;".
					"</td>".
					&Td("100%","","3","","","","",$CategoryBGColor,"").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Maximum Signature Length</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"the maximum number of characters allowed in the signature field.".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("100%","","3","","","","",$ColumnOddBGColor,"").
						&TextBox("SignaturesLength",$SignaturesLength,$TextBoxSize,"3","width:$IETextBoxSize").
					"</td>".
				"</tr>".
				&Tr("","",$HeaderBGColor).
					&Td("","","4","","","","","","").
						&Font($FontFace,$HeaderTextSize,$HeaderTextColor).
							"<b>POSTING OPTIONS</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("20","","","","","","","","").
						&Checkbox("NotifyPost","on","",$NotifyPost).
					"</td>".
					&Td("100%","","3","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Notify You For Posts? (required mail function)</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"if you want to be notified every time someone posts a topic.".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","4","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Show Notification Option During Posting/Replying (required mail function)</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"choose which notification options the members can select when posting/replying.".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowEvenBGColor).
					&Td("20","","","","","","",$ColumnOddBGColor,"").
						&Radio("NotifyMembers","Posts",$NotifyMembers,"").
					"</td>".
					&Td("100%","","3","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"Don't show notification option.".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("20","","","","","","",$ColumnOddBGColor,"").
						&Radio("NotifyMembers","PostReply",$NotifyMembers,"").
					"</td>".
					&Td("100%","","3","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"Show notification option during posting topic and replying message.".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowEvenBGColor).
					&Td("20","","","","","","",$ColumnOddBGColor,"").
						&Radio("NotifyMembers","Posts",$NotifyMembers,"").
					"</td>".
					&Td("100%","","3","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"Show notification during posting topic only.".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowEvenBGColor).
					&Td("20","","","","","","",$ColumnOddBGColor,"").
						&Radio("NotifyMembers","Reply",$NotifyMembers,"").
					"</td>".
					&Td("100%","","3","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"Show notification during replying message only.".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("100%","","4","","","","",$CategoryBGColor,"").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Maximum Subject Length</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"the maximum number of characters allowed in the subject field.".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("100%","","4","","","","",$ColumnOddBGColor,"").
						&TextBox("MaxSubjectLen",$MaxSubjectLen,$TextBoxSize,"3","width:$IETextBoxSize").
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("100%","","4","","","","",$CategoryBGColor,"").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Maximum Topic Description Length</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"the maximum number of characters allowed in the topic description field.".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("100%","","4","","","","",$ColumnOddBGColor,"").
						&TextBox("TopicDesLen",$TopicDesLen,$TextBoxSize,"3","width:$IETextBoxSize").
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("20","","","","","","","","").
						&Checkbox("EditMessage","on","",$EditMessage).
					"</td>".
					&Td("100%","","3","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Allow Members to Modify their Messages?</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"if you allow your members modify their own messages.".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("20","","","2","","","",$ColumnOddBGColor,"").
						"&nbsp;".
					"</td>".
					&Td("100%","","3","","","","",$CategoryBGColor,"").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Amount of Time Allotted to Modify their Message (in seconds)</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"the amount of time (in seconds) allotted for a member of modify his or her message.".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("100%","","3","","","","",$ColumnOddBGColor,"").
						&TextBox("ModifyTime",$ModifyTime,$TextBoxSize,"6","width:$IETextBoxSize").
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("20","","","","","","","","").
						&Checkbox("UBCodes","on","",$UBCodes).
					"</td>".
					&Td("100%","","3","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Allow Use of UltraBoard Codes</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"if you allow your members use ultraboard codes on their message.".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
                &Tr("","",$CategoryBGColor).
					&Td("20","","","","","","","","").
						&Checkbox("UBMessageIcon","on","",$UBMessageIcon).
					"</td>".
					&Td("100%","","3","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Allow Use of UltraBoard Topic Icon</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"if you allow your members use ultraboard topic icon on their message.".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("100%","","4","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Track Host/IP Address</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"which method would you like to use?".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("20","","","","","","",$ColumnOddBGColor,"").
						&Radio("TrackIP","HostIP",$TrackIP,"").
					"</td>".
					&Td("100%","","3","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"Track either Host/IP.".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowEvenBGColor).
					&Td("20","","","","","","",$ColumnOddBGColor,"").
						&Radio("TrackIP","IP",$TrackIP,"").
					"</td>".
					&Td("100%","","3","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"Track IP only.".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("20","","","","","","",$ColumnOddBGColor,"").
						&Radio("TrackIP","Host",$TrackIP,"").
					"</td>".
					&Td("100%","","3","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"Track Host only.".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("100%","","4","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Show Host/IP Address</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"which method would you like to use?".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("20","","","","","","",$ColumnOddBGColor,"").
						&Radio("ShowIP","",$ShowIP,"").
					"</td>".
					&Td("100%","","3","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"Don't show their host/IP on their messages.".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowEvenBGColor).
					&Td("20","","","","","","",$ColumnOddBGColor,"").
						&Radio("ShowIP","YESAdmin",$ShowIP,"").
					"</td>".
					&Td("100%","","3","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"Only allow administrators and moderators to see the host/IP.".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("20","","","","","","",$ColumnOddBGColor,"").
						&Radio("ShowIP","YES",$ShowIP,"").
					"</td>".
					&Td("100%","","3","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"Show to everyone their host/IP.".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","4","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Word Wrap Options</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"which type of word wrap do you want used in your forum?".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("20","","","","","","",$ColumnOddBGColor,"").
						&Radio("TextAreaType","OFF",$TextAreaType,"").
					"</td>".
					&Td("100%","","3","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"OFF (No Wrapping).".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowEvenBGColor).
					&Td("20","","","","","","",$ColumnOddBGColor,"").
						&Radio("TextAreaType","VIRTUAL",$TextAreaType,"").
					"</td>".
					&Td("100%","","3","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"VIRTUAL (Word-Wrapping).".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","4","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Censor Words Filter</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"list all the words you want to censor out. use a space to separate every word.".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","4","","","","",$ColumnOddBGColor,"").
						&TextArea("CensorWords",$CensorWords,$TextBoxSize,"3","VIRTUAL","width:$IETextBoxSize").
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
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
	&PrintTheme("$UBName Administrative Center - Configure General Options",$HTML);
	exit;
}
###############################################################################
1;# End of CfgGeneral Function
###############################################################################