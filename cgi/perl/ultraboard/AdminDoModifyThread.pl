###############################################################################
# AdminDoModifyThread.pl                                                      #
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
# DoModifyThread                                                              #
###############################################################################
sub DoModifyThread {
	($PostID, $BoardID)=split(/\Q$Spliter\E/,$in{'PostID'});
###############################################################################
	open(BOARD,"$DBPath/$BoardID/board.list")||&CGIError("Couldn't open/read the board.list file<br>\nPath: $DBPath/$BoardID<br>\nReason : $!");
		flock(BOARD,1) if ($FLock);
		$BOARD_DATA=<BOARD>;
	close(BOARD);
	@BoardInfo=&DecodeDBOutput($BOARD_DATA);

	open(POST,"$DBPath/$BoardID/$PostID.post")||&CGIError("Couldn't open/read the $PostID.post file<br>\nPath: $DBPath/$BoardID<br>\nReason : $!");
		flock(POST,1) if ($FLock);
		@POST_DATA=<POST>;
	close(POST);
    @PostInfo=&DecodeDBOutput($POST_DATA[0]);
    $Topic=$PostInfo[0];
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
						&HiddenBox("Action","DoModifyThread2").
						&HiddenBox("Board",$BoardID).
						&HiddenBox("Post",$PostID).
						&HiddenBox("Count",scalar(@POST_DATA)-1).
						&HiddenBox("Session",$SessionID).
					"</td>".
				"</tr>".
			"</table>";
###############################################################################
	$HTML.=	&BTable($TableWidth,$TableAlign,"0","0",$TableCellSpacing,$TableCellPadding,$TableBorderColor,"","").
				&Tr("","",$HeaderBGColor).
					&Td("","","","","","","","","").
						&Table("100%","CENTER","0","0","","").
							&Tr("","","").
								&Td("10","","","","","","","","").
									&Image("$URLImages/SmallMessage.gif","","","","","0",$PostInfo[0]).
								"</td>".
								&Td("","","","","","","","","").
									&Font($FontFace,$HeaderTextSize,$HeaderTextColor).
										"<b>".$PostInfo[0]." (modified ".$PostInfo[10]." times)</b>".
									"</font>".
								"</td>".
								&Td("","","","","RIGHT","","","","").
									&Font($FontFace,$HeaderTextSize,$HeaderTextColor);
	if ($PostInfo[2]) {
		$HTML.=	"<b>$MemberData[1]</b>";
	}else{
		$HTML.=	"<b>".$PostInfo[1]."</b>";
	}
	$HTML.=							"</font>".
								"</td>".
							"</tr>".
						"</table>".
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Subject</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$TextSize,$TextColor).
							&TextBox("Subject_0",$PostInfo[9],$TextBoxSize,$TopicDesLen,"width:$IETextBoxSize").
				        "</font>".
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Description</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$TextSize,$TextColor).
							&TextBox("Description_0",$PostInfo[0],$TextBoxSize,$MaxSubjectLen,"width:$IETextBoxSize").
				        "</font>".
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Message</b> ".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","2","","","","","","").
						&TextArea("Message_0",&DecodeUBCodes($PostInfo[7]),$TextBoxSize,"6","$TextAreaType","width:$IETextBoxSize").
					"</td>".
				"</tr>".
				&Tr("","",$MenuBGColor).
					&Td("","","","","","","","","").
						&Table("100%","CENTER","0","0","","").
							&Tr("","","").
								&Td("","","","","","","","","").
									&Font($FontFace,$MenuTextSize,$MenuTextColor).
										&GetDate($PostInfo[5],$MenuTextColor,$MenuTextColor,$MenuTextSize,$MenuTextSize).
									"</font>".
								"</td>".
								&Td("","","","","RIGHT","","","","");
	if (($ShowIP eq "YES")||($ShowIP eq "YESAdmin")) {
		$HTML.=	&Font($FontFace,$MenuTextSize,$MenuTextColor).
					"HOST/IP: ".$PostInfo[6].
				"</font>";
	}
	$HTML.=						"</td>".
							"</tr>".
						"</table>".
					"</td>".
				"</tr>".
			&CBTable();
###############################################################################	            
	 for (my ($i)=2;$i<=$#POST_DATA;$i++) {
		@PostInfo=&DecodeDBOutput($POST_DATA[$i]);
		if ($PostInfo[2]) {
			@MemberInfo=&GetMemberData($PostInfo[2]);
		}
		$HTML.=	"<p>".
			&BTable($TableWidth,$TableAlign,"0","0",$TableCellSpacing,$TableCellPadding,$TableBorderColor,"","").
				&Tr("","",$HeaderBGColor).
					&Td("","","","","","","","","").
						&Table("100%","CENTER","0","0","","").
							&Tr("","","").
								&Td("10","","","","","","","","").
									&Image("$URLImages/SmallMessage.gif","","","","","0",$PostInfo[0]).
								"</td>".
								&Td("","","","","","","","","").
									&Font($FontFace,$HeaderTextSize,$HeaderTextColor).
										"<b>".$PostInfo[0]." (modified ".$PostInfo[8]." times)</b>".
									"</font>".
								"</td>".
								&Td("","","","","RIGHT","","","","").
									&Font($FontFace,$HeaderTextSize,$HeaderTextColor);
		if ($PostInfo[2]) {
			$HTML.=						"<b>".$MemberInfo[1]."</b>";
		}else{
			$HTML.=						"<b>".$PostInfo[1]."</b>";
		}
		$HTML.=						"</font>".
								"</td>".
							"</tr>".
						"</table>".
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Subject</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$TextSize,$TextColor).
							&TextBox("Subject_".($i-1),$PostInfo[0],$TextBoxSize,$MaxSubjectLen,"width:$IETextBoxSize").
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Message</b> ".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","2","","","","","","").
						&TextArea("Message_".($i-1),&DecodeUBCodes($PostInfo[7]),$TextBoxSize,"6","$TextAreaType","width:$IETextBoxSize").
					"</td>".
				"</tr>".
				&Tr("","",$MenuBGColor).
					&Td("","","","","","","","","").
						&Table("100%","CENTER","0","0","","").
							&Tr("","","").
								&Td("","","","","","","","","").
									&Font($FontFace,$MenuTextSize,$MenuTextColor).
										&GetDate($PostInfo[5],$MenuTextColor,$MenuTextColor,$MenuTextSize,$MenuTextSize).
									"</font>".
								"</td>".
								&Td("","","","","RIGHT","","","","");
		if (($ShowIP eq "YES")||($ShowIP eq "YESAdmin")) {
			$HTML.=					&Font($FontFace,$MenuTextSize,$MenuTextColor).
										"HOST/IP: ".$PostInfo[6].
									"</font>";
		}
		$HTML.=					"</td>".
							"</tr>".
						"</table>".
					"</td>".
				"</tr>".
			&CBTable();	
	}           
	$HTML.=	"<P>".
			&BTable($TableWidth,$TableAlign,"0","0",$TableCellSpacing,$TableCellPadding,$TableBorderColor,"","").
				&Tr("","",$HeaderBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$HeaderTextSize,$HeaderTextColor).
							"<b>MODIFY THREAD</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>At</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$TextSize,$TextColor).
							"<b>";
	if ($UseCategory) {
		open(CATEGORY,"$DBPath/$BoardInfo[3].cat")||&CGIError("Couldn't open/read the $BoardInfo[3].cat file<br>\nPath: $DBPath<br>\nReason : $!");
			flock(CATEGORY,1) if ($FLock);
			$CATEGORY_DATA=<CATEGORY>;
			@CategoryInfo=&DecodeDBOutput($CATEGORY_DATA);
		close(CATEGORY);
		$HTML.=	"$CategoryInfo[1] / ";
	}
	$HTML.=					"$BoardInfo[1] / $Topic</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","2","","","","","","").
						"<center>".&Submit("","MODIFY THIS THREAD","width:$IETextBoxSize")."</center>".
					"</td>".
				"</tr>".
				&Tr("","",$MenuBGColor).
					&Td("","","2","","","","","","").
						&PrintVersion("YES").
					"</td>".
				"</tr>".
			"</table></td></tr></table>".
			"</form>";
	&PrintTheme("$UBName Administrative Center - Modify Thread \"$Topic\"",$HTML);
	exit;
}
###############################################################################
1;# End of DoModifyThread Function
###############################################################################