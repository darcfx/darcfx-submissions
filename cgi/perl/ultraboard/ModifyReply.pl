###############################################################################
# ModifyReply.pl                                                              #
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
# ModifyReply                                                                 #
###############################################################################
sub ModifyReply {
	my ($HTML);
	unless (-e "$DBPath/$in{'Board'}/board.list") {
		&ShowError("ACCESS DENIED","The board you want is not found.<br>Please contact the webmaster (".&Link("mailto:$EmailAddress","","").$EmailAddress."</a>".") for more information.");
	}
	unless (-e "$DBPath/$in{'Board'}/$in{'Post'}.post") {
		&ShowError("ACCESS DENIED","The topic you want is not found.<br>Please contact the webmaster (".&Link("mailto:$EmailAddress","","").$EmailAddress."</a>".") for more information.");
	}
	open(BOARD,"$DBPath/$in{'Board'}/board.list")||&CGIError("Couldn't open/read the board.list file<br>\nPath: $DBPath/$in{'Board'}<br>\nReason : $!");
		flock(BOARD,1) if ($FLock);
		$BOARD_DATA=<BOARD>;
	close(BOARD);
    open(POST,"$DBPath/$in{'Board'}/$in{'Post'}.post")||&CGIError("Couldn't open/read the $in{'Post'}.post file<br>\nPath: $DBPath/$in{'Board'}<br>\nReason : $!");
		flock(POST,1) if ($FLock);
		@POST_DATA=<POST>;
	close(POST);
    @PostInfo=&DecodeDBOutput($POST_DATA[0]);
	$Closed=$PostInfo[8];
	$Topic=$PostInfo[0];
	@BoardInfo=&DecodeDBOutput($BOARD_DATA);
	@PostInfo=&DecodeDBOutput($POST_DATA[$in{'ID'}+1]);
	@MemberInfo=&GetMemberData($PostInfo[2]) if ($PostInfo[2]);
	if (($Group ne "administrator")&&($Group ne $BoardInfo[4])) {
		if ($BoardInfo[5] ne "Active") {
			&ShowError("ACCESS DENIED","The \"$BoardInfo[1]\" board is currently inactive.<br>Please contact the webmaster (".&Link("mailto:$EmailAddress","","").$EmailAddress."</a>".") for more information.");
		}
        if ($Group eq "Guest") {
            print "Location: UltraBoard.$Ext?Action=SignIn&Ref=ModifyReply&Board=$in{'Board'}&Post=$in{'Post'}&ID=$in{'ID'}&Idle=$in{'Idle'}&Sort=$in{'Sort'}&Order=$in{'Order'}&Page=$in{'Page'}\n\n";
        }elsif ($BoardInfo[6] eq "Private") {
			require "$DBPath/$in{'Board'}/Access.db";
			if ($Access{$MemberData[3]} ne "FullAccess") {
				print "Location: UltraBoard.$Ext?Action=SignIn&Ref=ModifyReply&Board=$in{'Board'}&Post=$in{'Post'}&ID=$in{'ID'}&Idle=$in{'Idle'}&Sort=$in{'Sort'}&Order=$in{'Order'}&Page=$in{'Page'}\n\n";
			}
		}
		if ($Closed ne "") {
			&ShowError("ACCESS DENIED","The message that you want to modify was closed.");
		}
		if ($MemberData[0] ne $PostInfo[2]) {
			&ShowError("ACCESS DENIED","Sorry, you can't modify this message. You are not the author of this message.");
		}
		if (($PostInfo[5]+$ModifyTime) < time) {
			&ShowError("ACCESS DENIED","Sorry, you can't modify this message. You haven't modify your message before ".&GetDate($PostInfo[5]+$ModifyTime).".");
		}
	}
	$ModifyTime = time;
###############################################################################
	$HTML.=	"<p>".&Form("UltraBoard.$Ext","POST","","").
			&HiddenBox("Action","DoModifyReply").
			&HiddenBox("Board",$in{'Board'}).
			&HiddenBox("Post",$in{'Post'}).
            &HiddenBox("ID",$in{'ID'}).
            &HiddenBox("Idle",$in{'Idle'}).
            &HiddenBox("Sort",$in{'Sort'}).
            &HiddenBox("Order",$in{'Order'}).
            &HiddenBox("Page",$in{'Page'}).
			&HiddenBox("Session",$SessionID).
			&BTable($TableWidth,$TableAlign,"0","0",$TableCellSpacing,$TableCellPadding,$TableBorderColor,"","").
				&Tr("","",$HeaderBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$HeaderTextSize,$HeaderTextColor).
							"<b>MODIFY MESSAGE</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
                    		"<b>Author</b>".
	                    "</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","2","","","","","","").
        		        &Font($FontFace,$TextSize,$TextColor);
	if ($PostInfo[2]) {
		$HTML.=	"<b>$MemberInfo[1] ($MemberInfo[0])</b>";
	}else{
		$HTML.=	"<b>$PostInfo[1]</b>";
	}
	$HTML.=		        "</font>".
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
						&Font($FontFace,$TextSize,$TextColor).
					        "<b>$PostInfo[0]</b>".
				        "</font>".
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
						&TextArea("Message",&DecodeUBCodes($PostInfo[7]),$TextBoxSize,"10","$TextAreaType","width:$IETextBoxSize").
					"</td>".
				"</tr>";
	if ($PostInfo[2]) {
		$HTML.=	&Tr("","",$CategoryBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Option</b> ".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("20","","","","","","",$ColumnOddBGColor,"").
						&Checkbox("Nodify","on","",$PostInfo[3]).
					"</td>".
					&Td("100%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"<b>Nodify him/her by email when someone reply this topic?</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowEvenBGColor).
					&Td("20","","","","","","",$ColumnOddBGColor,"").
						&Checkbox("UseSignature","on","",$PostInfo[4]).
					"</td>".
					&Td("100%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"<b>Use his/her signature in this message?</b>".
						"</font>".
					"</td>".
				"</tr>";
	}else{
		$HTML.=	&HiddenBox("Nodify","").
				&HiddenBox("UseSignature","");
	}
	$HTML.=		&Tr("","",$CategoryBGColor).
					&Td("","","2","","","","","","").
						"<center>".&Submit("","MODIFY THIS MESSAGE","width:$IETextBoxSize")."</center>".
					"</td>".
				"</tr>".
				&Tr("","",$MenuBGColor).
					&Td("","","2","","","","","","").
						&PrintVersion().
					"</td>".
				"</tr>".
			"</table></td></tr></table>".
			"</form>";
	&PrintTheme("$UBName - Modify Message \"$PostInfo[1]\"",$HTML);
	exit;
}
###############################################################################
1;# End of ModifyReply Function
###############################################################################