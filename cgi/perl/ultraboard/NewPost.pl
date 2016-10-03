###############################################################################
# NewPost.pl                                                                  #
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
# NewPost                                                                     #
###############################################################################
sub NewPost {
	my ($HTML);
	unless (-e "$DBPath/$in{'Board'}/board.list") {
		&ShowError("ACCESS DENIED","The board you want to post topic is not found.<br>Please contact the webmaster (".&Link("mailto:$EmailAddress","","").$EmailAddress."</a>".") for more information.");
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
			print "Location: UltraBoard.$Ext?Action=SignIn&Ref=NewPost&Board=$in{'Board'}&Idle=$in{'Idle'}&Sort=$in{'Sort'}&Order=$in{'Order'}&Page=$in{'Page'}\n\n";
		}elsif ($BoardInfo[6] eq "Private") {
			require "$DBPath/$in{'Board'}/Access.db";
			if ($Access{$MemberData[3]} ne "FullAccess") {
				print "Location: UltraBoard.$Ext?Action=SignIn&Ref=NewPost&Board=$in{'Board'}&Idle=$in{'Idle'}&Sort=$in{'Sort'}&Order=$in{'Order'}&Page=$in{'Page'}\n\n";
			}
		}
	}	
###############################################################################
	$HTML.=	"<p>".&Form("UltraBoard.$Ext","POST","","").
			&HiddenBox("Action","DoNewPost").
			&HiddenBox("Board",$in{'Board'}).
            &HiddenBox("Idle",$in{'Idle'}).
            &HiddenBox("Sort",$in{'Sort'}).
            &HiddenBox("Order",$in{'Order'}).
            &HiddenBox("Page",$in{'Page'}).
			&HiddenBox("Session",$SessionID).
			&BTable($TableWidth,$TableAlign,"0","0",$TableCellSpacing,$TableCellPadding,$TableBorderColor,"","").
				&Tr("","",$HeaderBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$HeaderTextSize,$HeaderTextColor).
							"<b>POST A NEW MESSAGE</b>".
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
	$HTML.=					"$BoardInfo[1]</b>".
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
						&TextBox("Subject","",$TextBoxSize,$MaxSubjectLen,"width:$IETextBoxSize").
					"</td>".
				"</tr>".
                &Tr("","",$CategoryBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Topic Description</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","2","","","","","","").
						&TextBox("Description","",$TextBoxSize,$TopicDesLen,"width:$IETextBoxSize").
					"</td>".
				"</tr>";
    if ($UBMessageIcon) {
        open(ICON,"$VarsPath/mIcons.txt");
            flock(ICON,2) if ($FLock);
            my (@Icons)=<ICON>;
        close(ICON);
        if ($#Icons>=0) {
            push (@IconList, "Normal","");
            $Selected="";
            for ($c=0;$c<=$#Icons;$c++) {
                @IconData=split (/\|\^\|/, $Icons[$c]);
                $Selected = $IconData[0] if ($IconData[3] ne "");
                push (@IconList, $IconData[1], $IconData[0]);
            }
            $HTML.= &Tr("","",$CategoryBGColor).
                        &Td("","","2","","","","","","").
                            &Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
                                "<b>Topic Icon</b>".
                            "</font>".
                        "</td>".
                    "</tr>".
                    &Tr("","",$RowOddBGColor).
                        &Td("","","2","","","","","","").
                            &Select("TopicIcon","","width:$IETextBoxSize","",$Selected,
                                @IconList
                            ).
                        "</td>".
                    "</tr>";
        }
    }
    $HTML.=     &Tr("","",$CategoryBGColor).
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
		if ($NotifyMembers=~/Post/) {
			$HTML.=	&Tr("","",$RowOddBGColor).
						&Td("20","","","","","","",$ColumnOddBGColor,"").
							&Checkbox("Nodify","on","","").
						"</td>".
						&Td("","","","","","","",$ColumnEvenBGColor,"").
							&Font($FontFace,$TextSize,$TextColor).
								"<b>Notify your by email when someone reply this topic?</b>".
							"</font>".
						"</td>".
					"</tr>";
		}
		if ($UseSignatures) {
			$HTML.=	&Tr("","",$RowEvenBGColor).
						&Td("20","","","","","","",$ColumnOddBGColor,"").
							&Checkbox("UseSignature","on","","").
						"</td>".
						&Td("","","","","","","",$ColumnEvenBGColor,"").
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
									"<center>".&Submit("Submit","POST THIS TOPIC","width:$IETextBoxSize")."</center>".
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
	&PrintTheme("$UBName - Post a New Message",$HTML);
	exit;
}
###############################################################################
1;# End of NewPost Function
###############################################################################