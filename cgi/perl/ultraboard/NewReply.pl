###############################################################################
# NewReply.pl                                                                 #
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
# NewReply                                                                    #
###############################################################################
sub NewReply {
	my ($HTML);
	unless (-e "$DBPath/$in{'Board'}/board.list") {
		&ShowError("POSTING PROBLEM","The board you want to reply topic is not found.<br>Please contact the webmaster (".&Link("mailto:$EmailAddress","","").$EmailAddress."</a>".") for more information.");
	}
	unless (-e "$DBPath/$in{'Board'}/$in{'Post'}.post") {
		&ShowError("POSTING PROBLEM","The topic you want to reply is not found.<br>Please contact the webmaster (".&Link("mailto:$EmailAddress","","").$EmailAddress."</a>".") for more information.");
	}
	open(BOARD,"$DBPath/$in{'Board'}/board.list")||&CGIError("Couldn't open/read the board.list file<br>\nPath: $DBPath/$in{'Board'}<br>\nReason : $!");
		flock(BOARD,1) if ($FLock);
		$BOARD_DATA=<BOARD>;
	close(BOARD);
	@BoardInfo=&DecodeDBOutput($BOARD_DATA);
	if ($Group ne "administrator") {
		if ($BoardInfo[5] ne "Active") {
			&ShowError("ACCESS DENIED","The \"$BoardInfo[1]\" board is currently inactive.<br>Please contact the webmaster (".&Link("mailto:$EmailAddress","","").$EmailAddress."</a>".") for more information.");
		}
		if (($BoardInfo[6] ne "Public")&&($Group eq "Guest")) {
			print "Location: UltraBoard.$Ext?Action=SignIn&Ref=NewReply&Post=$in{'Post'}&Board=$in{'Board'}&Idle=$in{'Idle'}&Sort=$in{'Sort'}&Order=$in{'Order'}&Page=$in{'Page'}\n\n";
		}elsif ($BoardInfo[6] eq "Private") {
			require "$DBPath/$in{'Board'}/Access.db";
			if ($Access{$MemberData[3]} ne "FullAccess") {
				print "Location: UltraBoard.$Ext?Action=SignIn&Ref=NewReply&Post=$in{'Post'}&Board=$in{'Board'}&Idle=$in{'Idle'}&Sort=$in{'Sort'}&Order=$in{'Order'}&Page=$in{'Page'}\n\n";
			}
		}
	}
###############################################################################
	open(POST,"$DBPath/$in{'Board'}/$in{'Post'}.post")||&CGIError("Couldn't open/read the $in{'Post'}.post file<br>\nPath: $DBPath/$in{'Board'}<br>\nReason : $!");
		flock(POST,1) if ($FLock);
		@POST_DATA=<POST>;
	close(POST);
	@PostInfo=&DecodeDBOutput($POST_DATA[0]);
    if ($PostInfo[8] ne "") {
        &ShowError("POSTING PROBLEM","The topic that you want to reply was closed.");
    }
	$Topic=$PostInfo[0];
###############################################################################
	$HTML.=	"<p>".&Form("UltraBoard.$Ext","POST","","").
			&HiddenBox("Action","DoNewReply").
			&HiddenBox("Board",$in{'Board'}).
			&HiddenBox("Post",$in{'Post'}).
            &HiddenBox("Idle",$in{'Idle'}).
            &HiddenBox("Sort",$in{'Sort'}).
            &HiddenBox("Order",$in{'Order'}).
            &HiddenBox("Page",$in{'Page'}).
			&HiddenBox("Session",$SessionID).
			&BTable($TableWidth,$TableAlign,"0","0",$TableCellSpacing,$TableCellPadding,$TableBorderColor,"","").
				&Tr("","",$HeaderBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$HeaderTextSize,$HeaderTextColor).
							"<b>REPLY TO TOPIC</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor);
	if ($Group eq "Guest") {
		$HTML.=	"<b>Nick Name</b>";
	}else{
		$HTML.=	"<b>From</b>";
	}
	$HTML.=				"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","2","","","","","","");
	if ($Group eq "Guest") {
		$HTML.=	&TextBox("NickName","",$TextBoxSize,"20","width:$IETextBoxSize");
	}else{
		$HTML.=	&Font($FontFace,$TextSize,$TextColor).
					"<b>$MemberData[1] ($MemberData[0])</b>".
				"</font>";
	}
	$HTML.=			"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>To</b>".
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
    if ($UBCodes) {
        $MMessage="you can use ultraboard code in your message."
    }else{
        $MMessage="you cannot use ultraboard code in your message."
    }
	$HTML.=					"$BoardInfo[1] / $Topic</b>".
						"</font>".
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
						&TextBox("Subject","RE:$PostInfo[0]",$TextBoxSize,$MaxSubjectLen,"width:$IETextBoxSize").
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Message</b><br>".
                            &Font("",$CategoryDesTextSize,$CategoryTextColor).
								$MMessage.
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","2","","","","","","").
						&TextArea("Message","",$TextBoxSize,"10","$TextAreaType","width:$IETextBoxSize").
					"</td>".
				"</tr>";
	if ($Group ne "Guest") {
		$HTML.=	&Tr("","",$CategoryBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Option</b> ".
						"</font>".
					"</td>".
				"</tr>";
		if ($NotifyMembers=~/Reply/) {
			$HTML.=	&Tr("","",$RowOddBGColor).
						&Td("20","","","","","","",$ColumnOddBGColor,"").
							&Checkbox("Nodify","on","","").
						"</td>".
						&Td("100%","","","","","","",$ColumnEvenBGColor,"").
							&Font($FontFace,$TextSize,$TextColor).
								"<b>Notify you by email when someone reply this topic?</b>".
							"</font>".
						"</td>".
					"</tr>";
		}
		if ($UseSignatures) {
			$HTML.=	&Tr("","",$RowEvenBGColor).
						&Td("20","","","","","","",$ColumnOddBGColor,"").
							&Checkbox("UseSignature","on","","").
						"</td>".
						&Td("100%","","","","","","",$ColumnEvenBGColor,"").
							&Font($FontFace,$TextSize,$TextColor).
								"<b>Use your signature in this message?</b>".
							"</font>".
						"</td>".
					"</tr>";
		}
	}
	$HTML.=		&Tr("","",$CategoryBGColor).
					&Td("","","2","","","","","","").
						&Table("100%","CENTER","0","0","","").
							&Tr("","","").
								&Td("50%","","2","","","","","","").
									"<center>".&Submit("Submit","PREVIEW FIRST","width:$IETextBoxSize")."</center>".
								"</td>".
								&Td("50%","","2","","","","","","").
									"<center>".&Submit("Submit","REPLY THIS TOPIC","width:$IETextBoxSize")."</center>".
								"</td>".
							"</tr>".
						"</table>".
					"</td>".
				"</tr>".
				&Tr("","",$MenuBGColor).
					&Td("","","2","","","","","","").
						&PrintVersion().
					"</td>".
				"</tr>".
			"</table></td></tr></table>".
			"</form>";
###############################################################################	
	if ($PostInfo[2]) {
		@MemberInfo=&GetMemberData($PostInfo[2]);
	}
	$HTML.=	&BTable($TableWidth,$TableAlign,"0","0",$TableCellSpacing,$TableCellPadding,$TableBorderColor,"","").
				&Tr("","",$HeaderBGColor).
					&Td("","","","","","","","","").
						&Table("100%","CENTER","0","0","","").
							&Tr("","","").
								&Td("50%","","","","","","","","").
									&Font($FontFace,$HeaderTextSize,$HeaderTextColor).
										"<b>".$PostInfo[0]."</b>".
									"</font>".
								"</td>".
								&Td("50%","","","","RIGHT","","","","").
									&Font($FontFace,$HeaderTextSize,$HeaderTextColor);
	if ($PostInfo[2]) {
		$HTML.=	"<b>".$MemberInfo[1]."</b>";
	}else{
		$HTML.=	"<b>".$PostInfo[1]."</b>";
	}
	$HTML.=							"</font>".
								"</td>".
							"</tr>".
						"</table>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","","","","","","","").
						&Table("100%","CENTER","5","5","","").
							&Tr("","","").
								&Td("","","","","","MIDDLE","","","").
									&Font($FontFace,$TextSize,$TextColor).
										$PostInfo[7];
	if ($UseSignatures and $PostInfo[4] and $MemberInfo[15]) {
		$HTML.=	"<hr>".
				$MemberInfo[15];
	}
	$HTML.=							"</font>".
								"</td>".
							"</tr>".
						"</table>".
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
	if (($ShowIP eq "YES")||(($ShowIP eq "YESAdmin")&&(($Group eq "administrator")||($Group eq $BoardInfo[4])))) {
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
		@MemberInfo=();
		@PostInfo=&DecodeDBOutput($POST_DATA[$i]);
		if ($PostInfo[2]) {
			@MemberInfo=&GetMemberData($PostInfo[2]);
		}
		$HTML.=		"<p>".
					&BTable($TableWidth,$TableAlign,"0","0",$TableCellSpacing,$TableCellPadding,$TableBorderColor,"","").
						&Tr("","",$HeaderBGColor).
							&Td("","","","","","","","","").
								&Table("100%","CENTER","0","0","","").
									&Tr("","","").
										&Td("50%","","","","","","","","").
											&Font($FontFace,$HeaderTextSize,$HeaderTextColor).
												"<b>".$PostInfo[0]."</b>".
											"</font>".
										"</td>".
										&Td("50%","","","","RIGHT","","","","").
											&Font($FontFace,$HeaderTextSize,$HeaderTextColor);
		if ($PostInfo[2]) {
			$HTML.=								"<b>".$MemberInfo[1]."</b>";
		}else{
			$HTML.=								"<b>".$PostInfo[1]."</b>";
		}
		$HTML.=							"</font>".
										"</td>".
									"</tr>".
								"</table>".
							"</td>".
						"</tr>".
						&Tr("","",$RowOddBGColor).
							&Td("","","","","","","","","").
								&Table("100%","CENTER","5","5","","").
									&Tr("","","").
										&Td("","","","","","MIDDLE","","","").
											&Font($FontFace,$TextSize,$TextColor).
												$PostInfo[7];
		if ($UseSignatures and $PostInfo[4] and $MemberInfo[15]) {
			$HTML.=		"<hr>".
						$MemberInfo[15];
		}
		$HTML.=								"</font>".
										"</td>".
									"</tr>".
								"</table>".
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
										&Td("","","","","RIGHT","","","","").
											&Font($FontFace,$MenuTextSize,$MenuTextColor).
												"HOST/IP: ".$PostInfo[6].
											"</font>".
										"</td>".
									"</tr>".
								"</table>".
							"</td>".
						"</tr>".
					&CBTable();			
	}
	&PrintTheme("$UBName - Reply to Topic",$HTML);
	exit;
}
###############################################################################
1;# End of NewReply Function
###############################################################################