###############################################################################
# PreviewMessage.pl                                                           #
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
# PreviewMessage                                                              #
###############################################################################
sub PreviewMessage {
	&ShowError("POSTING PROBLEM","You forgot to fill the \"Subject\" field.") if (!$in{'Subject'});
	&ShowError("POSTING PROBLEM","You forgot to fill the \"Message\" field.") if (!$in{'Message'});
	&ShowError("POSTING PROBLEM","The \"Subject\" must less than $MaxSubjectLen characters.") if (length($in{'Subject'}) > $MaxSubjectLen);

	open(BOARD,"$DBPath/$in{'Board'}/board.list")||&CGIError("Couldn't open/read the board.list file<br>\nPath: $DBPath/$in{'Board'}<br>\nReason : $!");
		flock(BOARD,1) if ($FLock);
		$BOARD_DATA=<BOARD>;
	close(BOARD);
	@BoardInfo=&DecodeDBOutput($BOARD_DATA);
	if ($Group eq "Guest") {
		&ShowError("POSTING PROBLEM","You forgot to fill the \"Nick Name\" field.") if (!$in{'NickName'});
		&ShowError("POSTING PROBLEM","Your \"Nick Name\" must more than 4 characters.") if (length($in{'NickName'}) < 4);
		&ShowError("POSTING PROBLEM","Your \"Nick Name\" must less than 20 characters.") if (length($in{'NickName'}) > 20);
	}
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
	if ($UserName) {
		@MemberInfo=&GetMemberData($UserName);
	}
	$in{'NickName'}=&RemoveCensorWords($in{'NickName'});
	$in{'Subject'}=&RemoveCensorWords($in{'Subject'});
	$in{'Description'}=&RemoveCensorWords($in{'Description'});
	$in{'Message'}=&EncodeUBCodes(&RemoveCensorWords($in{'Message'}));
	if (($ENV{'REMOTE_HOST'})&&($TrackIP=~/Host/)) {
		$IP=$ENV{'REMOTE_HOST'};
	}elsif ($TrackIP=~/IP/){
		$IP=$ENV{'REMOTE_ADDR'};
	}
###############################################################################
	$Post.=	&Form("UltraBoard.$Ext","POST","","").
			&HiddenBox("Action",$in{'Action'}).
			&HiddenBox("Post",$in{'Post'}).
			&HiddenBox("Board",$in{'Board'}).
            &HiddenBox("Idle",$in{'Idle'}).
            &HiddenBox("Sort",$in{'Sort'}).
            &HiddenBox("Order",$in{'Order'}).
            &HiddenBox("Page",$in{'Page'}).
			&HiddenBox("Session",$SessionID).
			&HiddenBox("NickName",&EncodeHTML($in{'NickName'})).
			&HiddenBox("Subject",&EncodeHTML($in{'Subject'})).
			&HiddenBox("Description",&EncodeHTML($in{'Description'})).
            &HiddenBox("TopicIcon",$in{'TopicIcon'}).
			&HiddenBox("Message",$in{'Message'}).
			&HiddenBox("Nodify",$in{'Nodify'}).
			&HiddenBox("UseSignature",$in{'UseSignature'}).
			&HiddenBox("Method","Preview").
			&BTable($TableWidth,$TableAlign,"0","0",$TableCellSpacing,$TableCellPadding,$TableBorderColor,"","").
				&Tr("","",$HeaderBGColor).
					&Td("","","","","","","","","").
						&Table("100%","CENTER","0","0","","").
							&Tr("","","").
								&Td("10","","","","","","","","").
									&Image("$URLImages/SmallMessage.gif","","","","","0",$in{'Subject'}).
								"</td>".
								&Td("50%","","","","","","","","").
									&Font($FontFace,$HeaderTextSize,$HeaderTextColor).
										"<b>".$in{'Subject'}." (modified 0 times)</b>".
									"</font>".
								"</td>".
								&Td("50%","","","","RIGHT","","","","").
									&Font($FontFace,$HeaderTextSize,$HeaderTextColor);
	if ($UserName) {
		$Post.=	"<b>".$MemberInfo[1]."</b>";
	}else{
		$Post.=	"<b>".$in{'NickName'}."</b>";
	}
	$Post.=							"</font>".
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
									&DecodeDBOutput($in{'Message'});
	if ($UseSignatures and $in{'UseSignature'} and $MemberInfo[15]) {
		$Post.=	"<hr>".
				$MemberInfo[15];
	}
	$Post.=							"</font>".
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
										&GetDate(time,$MenuTextColor,$MenuTextColor,$MenuTextSize,$MenuTextSize).
									"</font>".
								"</td>".
								&Td("","","","","RIGHT","","","","");
	if (($ShowIP eq "YES")||(($ShowIP eq "YESAdmin")&&(($Group eq "administrator")||($Group eq $BoardInfo[4])))) {
		$Post.=	&Font($FontFace,$MenuTextSize,$MenuTextColor).
					"HOST/IP: ".$IP.
				"</font>";
	}
	$Post.=						"</td>".
							"</tr>".
						"</table>".
					"</td>".
				"</tr>".
			&CBTable();
###############################################################################
	if ($in{'Action'} eq "DoNewPost") {
		$Button="POST THIS TOPIC";
	}else{
		$Button="REPLY THIS TOPIC";
	}
	$HTML.=	"<p>".
			$Post.
			"<p>".
			&BTable($TableWidth,$TableAlign,"0","0",$TableCellSpacing,$TableCellPadding,$TableBorderColor,"","").
				&Tr("","",$CategoryBGColor).
					&Td("","","2","","","","","","").
						&Table("100%","CENTER","0","0","","").
							&Tr("","","").
								&Td("50%","","2","","","","","","").
									"<center>".&Button("","< BACK","width:$IETextBoxSize","onclick=\"history.go(-1)\"")."</center>".
								"</td>".
								&Td("50%","","2","","","","","","").
									"<center>".&Submit("Submit",$Button,"width:$IETextBoxSize")."</center>".
								"</td>".
							"</tr>".
						"</table>".
					"</td>".
				"</tr>".
				&Tr("","",$MenuBGColor).
					&Td("","","","","","","","","").
						&PrintVersion("YES").
					"</td>".
				"</tr>".
			"</table></td></tr></table>".
			"</form>";
	&PrintTheme("$UBName",$HTML);
	exit;
}
###############################################################################
1;# End of PreviewMessage Function
###############################################################################