###############################################################################
# ShowPost.pl                                                                 #
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
# ShowPost                                                                    #
###############################################################################
sub ShowPost {
	my ($HTML);
	unless (-e "$DBPath/$in{'Board'}/board.list") {
		&ShowError("ACCESS DENIED","The board that you want is not found.<br>Please contact the webmaster (".&Link("mailto:$EmailAddress","","").$EmailAddress."</a>".") for more information.");
	}
	unless (-e "$DBPath/$in{'Board'}/$in{'Post'}.post") {
		&ShowError("ACCESS DENIED","The topic that you want to read is not found.<br>Please contact the webmaster (".&Link("mailto:$EmailAddress","","").$EmailAddress."</a>".") for more information.");
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
		if (($BoardInfo[6] eq "Private")&&($Group eq "Guest")) {
			print "Location: UltraBoard.$Ext?Action=SignIn&Ref=ShowPost&Board=$in{'Board'}&Post=$in{'Post'}&Idle=$in{'Idle'}&Sort=$in{'Sort'}&Order=$in{'Order'}&Page=$in{'Page'}\n\n";
		}elsif ($BoardInfo[6] eq "Private") {
			require "$DBPath/$in{'Board'}/Access.db";
			if (!exists ($Access{$MemberData[3]})) {
				print "Location: UltraBoard.$Ext?Action=SignIn&Ref=ShowPost&Board=$in{'Board'}&Post=$in{'Post'}&Idle=$in{'Idle'}&Sort=$in{'Sort'}&Order=$in{'Order'}&Page=$in{'Page'}\n\n";
			}else{
                $MemberStatus=$Access{$MemberData[3]};
            }
		}
	}
###############################################################################
	open(POST,"$DBPath/$in{'Board'}/$in{'Post'}.post")||&CGIError("Couldn't open/read the $in{'Post'}.post file<br>\nPath: $DBPath/$in{'Board'}<br>\nReason : $!");
		flock(POST,1) if ($FLock);
		@POST_DATA=<POST>;
	close(POST);
	@PostInfo=&DecodeDBOutput($POST_DATA[0]);
	$Topic=$PostInfo[0];
	$Closed=$PostInfo[8];
    $TopicDes=$PostInfo[9];
	if (($PostInfo[2])&&(-e "$MembersPath/$PostInfo[2].info")) {
		@MemberInfo=&GetMemberData($PostInfo[2]);
	}
    @PostStat=&DecodeDBOutput($POST_DATA[1]);
	$PostStat[1]++;
	$POST_DATA[1]=&EncodeDBInput(@PostStat);
	open(POST,">$DBPath/$in{'Board'}/$in{'Post'}.post")||&CGIError("Couldn't create/write the $in{'Post'}.post file<br>\nPath: $DBPath/$in{'Board'}<br>\nReason : $!");
		flock(POST,2) if ($FLock);
		print POST @POST_DATA;
		flock(POST,8) if ($FLock);
	close(POST);

    if ($UBMessageIcon) {
        open(ICON,"$VarsPath/mIcons.txt");
            flock(ICON,2) if ($FLock);
            my (@Icons)=<ICON>;
        close(ICON);
        if ($#Icons>=0) {
            %TopicIcon=();            
            for ($c=0;$c<=$#Icons;$c++) {
                @IconData=split (/\|\^\|/, $Icons[$c]);
                $TopicIcon{$IconData[0]}=$IconData[2];
            }
        }
    }

    if ($Cookies{"B_".$in{'Board'}."_TIME"}<$PostStat[2]) {
        $NewIcon=&Image("$URLImages/New.gif","","","","","0","");
    }else{
        $NewIcon="";
    }

    $MessageIcon=&Image("$URLImages/Message.gif","","","","","0",$PostInfo[8]);   
    if ($Closed ne ""){
        $MessageIcon=&Image("$URLImages/LockedMessage.gif","","","","","0",$PostInfo[8]);
    }elsif ($PostInfo[11]) {
        $MessageIcon=&Image($TopicIcon{$PostInfo[11]},"","","","","0",$PostInfo[8]);  
    }
###############################################################################
    if ($Cookies{"B_".$in{'Board'}."_TIME"}<$PostInfo[5]) {
        $MNewIcon=&Image("$URLImages/SmallNew.gif","","","","","0","New Message");
    }else{
        $MNewIcon=&Image("$URLImages/SmallMessage.gif","","","","","0",$PostInfo[0]);
    }
	$Post.=	&BTable($TableWidth,$TableAlign,"0","0",$TableCellSpacing,$TableCellPadding,$TableBorderColor,"","").
				&Tr("","",$HeaderBGColor).
					&Td("","","","","","","","","").
						&Table("100%","CENTER","0","0","","").
							&Tr("","","").
								&Td("10","","","","","","","","").
									$MNewIcon.
								"</td>".
								&Td("50%","","","","","","","","").
									&Font($FontFace,$HeaderTextSize,$HeaderTextColor).
										"<b>".$PostInfo[0]." (modified ".$PostInfo[10]." times)</b> ".
									"</font>".
								"</td>".
								&Td("50%","","","","RIGHT","","","","").
									&Font($FontFace,$HeaderTextSize,$HeaderTextColor);
	#$Post.=	"<b>".$PostInfo[1]."</b>";
	if (($PostInfo[2]) && (!$PostInfo[1])) {
		$Post.=	"<b>".$MemberInfo[1]."</b>";
	}else{
		$Post.=	"<b>".$PostInfo[1]."</b>";
	}
	$Post.=							"</font>".
								"</td>".
							"</tr>".
						"</table>".
					"</td>".
				"</tr>";
	if (($PostInfo[2])||($Group eq "administrator")||($Group eq $BoardInfo[4])) {
		$Post.=	&Tr("","",$MenuBGColor).
					&Td("","","","","","","","","").
						&Table("100%","CENTER","0","0","","").
							&Tr("","","").
								&Td("","","","","","","","","");
		if ($PostInfo[2]) {
				$Post.=				&Link("UltraBoard.$Ext?Action=ShowProfile&ID=$PostInfo[2]&Board=$in{'Board'}&Idle=$in{'Idle'}&Sort=$in{'Sort'}&Order=$in{'Order'}&Page=$in{'Page'}&Session=$SessionID","Profile","",
										"View $MemberInfo[1] ($MemberInfo[0]) Profile.").
										$imgProfile.
									"</a>";
		}
		if ($MemberInfo[17] ne "") {
			$Post.=					$imgSperater.&Link("mailto:$MemberInfo[4]","","",
										"Send email to $MemberInfo[1].").
                                        $imgEmail.
                                    "</a>";
		}
										

		if ((($Group ne "administrator")&&($Group ne $BoardInfo[4]))&&($UserName eq $PostInfo[2])&&($PostInfo[2] ne "")&&(!$Closed)) {
			$Post.=					$imgSperater.&Link("UltraBoard.$Ext?Action=ModifyPost&Post=$in{'Post'}&Board=$in{'Board'}&ID=0&Idle=$in{'Idle'}&Sort=$in{'Sort'}&Order=$in{'Order'}&Page=$in{'Page'}&Session=$SessionID","","",
										"Modify this ($PostInfo[0]) topic.").
										$imgModify.
									"</a>";
		}
		$Post.=					"</td>".
								&Td("","","","","RIGHT","","","","");
		if (($Group eq "administrator")||($Group eq $BoardInfo[4])) {
			$Post.=					&Link("UltraBoard.$Ext?Action=ModifyPost&Post=$in{'Post'}&Board=$in{'Board'}&ID=0&Idle=$in{'Idle'}&Sort=$in{'Sort'}&Order=$in{'Order'}&Page=$in{'Page'}&Session=$SessionID","","",
										"Modify this ($PostInfo[0]) topic.").
										$imgModify.
									"</a>".$imgSperater;
		}
		if (($Group eq "administrator")||($Group eq $BoardInfo[4])) {
			$Post.=					&Link("UltraBoard.$Ext?Action=DoRemoveMessages&Post=$in{'Post'}&Board=$in{'Board'}&Idle=$in{'Idle'}&Sort=$in{'Sort'}&Order=$in{'Order'}&Page=$in{'Page'}&Session=$SessionID","","",
										"Remove this ($PostInfo[0]) Thread.").
										$imgRemoveThread.
									"</a>";
		}
		$Post.=					"</td>".
							"</tr>".
						"</table>".
					"</td>".
				"</tr>";
	}
	$Post.=		&Tr("","",$RowOddBGColor).
					&Td("","","","","","","","","").
						&Table("100%","CENTER","5","5","","").
							&Tr("","","").
								&Td("","","","","","MIDDLE","","","").
									&Font($FontFace,$TextSize,$TextColor).
										$PostInfo[7];
	if ($UseSignatures and $PostInfo[4] and $MemberInfo[15]) {
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
										&GetDate($PostInfo[5],$MenuTextColor,$MenuTextColor,$MenuTextSize,$MenuTextSize).
									"</font>".
								"</td>".
								&Td("","","","","RIGHT","","","","");
	if (($ShowIP eq "YES")||(($ShowIP eq "YESAdmin")&&(($Group eq "administrator")||($Group eq $BoardInfo[4])))) {
		$Post.=	&Font($FontFace,$MenuTextSize,$MenuTextColor).
					"HOST/IP: ".$PostInfo[6].
				"</font>";
	}
	$Post.=						"</td>".
							"</tr>".
						"</table>".
					"</td>".
				"</tr>".
			&CBTable();
	
###############################################################################
	for (my ($i)=2;$i<=$#POST_DATA;$i++) {
		@MemberInfo=();
		@PostInfo=&DecodeDBOutput($POST_DATA[$i]);
		if (($PostInfo[2])&&(-e "$MembersPath/$PostInfo[2].info")) {
			@MemberInfo=&GetMemberData($PostInfo[2]);
		}
        if ($Cookies{"B_".$in{'Board'}."_TIME"}<$PostInfo[5]) {
            $MNewIcon=&Image("$URLImages/SmallNew.gif","","","","","0","New Message");
        }else{
            $MNewIcon=&Image("$URLImages/SmallMessage.gif","","","","","0",$PostInfo[0]);
        }
		$Replies.=	"<p>".
					&BTable($TableWidth,$TableAlign,"0","0",$TableCellSpacing,$TableCellPadding,$TableBorderColor,"","").
						&Tr("","",$HeaderBGColor).
							&Td("","","","","","","","","").
								&Table("100%","CENTER","0","0","","").
									&Tr("","","").
										&Td("10","","","","","","","","").
											$MNewIcon.
										"</td>".
										&Td("50%","","","","","","","","").
											&Font($FontFace,$HeaderTextSize,$HeaderTextColor).
												"<b>".$PostInfo[0]." (modified ".$PostInfo[8]." times)</b> ".
											"</font>".
										"</td>".
										&Td("50%","","","","RIGHT","","","","").
											&Font($FontFace,$HeaderTextSize,$HeaderTextColor);
		#$Replies.=	"<b>".$PostInfo[1]."</b>";
		if (($PostInfo[2]) && (!$PostInfo[1])) {
			$Replies.=	"<b>".$MemberInfo[1]."</b>";
		}else{
			$Replies.=	"<b>".$PostInfo[1]."</b>";
		}
		$Replies.=							"</font>".
										"</td>".
									"</tr>".
								"</table>".
							"</td>".
						"</tr>";
		if (($PostInfo[2])||($Group eq "administrator")||($Group eq $BoardInfo[4])) {
			$Replies.=	&Tr("","",$MenuBGColor).
							&Td("","","","","","","","","").
								&Table("100%","CENTER","0","0","","").
									&Tr("","","").
										&Td("","","","","","","","","");
			if ($PostInfo[2]) {
				$Replies.=					&Link("UltraBoard.$Ext?Action=ShowProfile&ID=$PostInfo[2]&Board=$in{'Board'}&Idle=$in{'Idle'}&Sort=$in{'Sort'}&Order=$in{'Order'}&Page=$in{'Page'}&Session=$SessionID","Profile","",
												"View $MemberInfo[1] ($MemberInfo[0]) Profile.").
												$imgProfile.
											"</a>";
			}
			if (($MemberInfo[17] ne "")&&($PostInfo[2])) {
				$Replies.=					$imgSperater.&Link("mailto:$MemberInfo[4]","","",
                                                "Send email to $MemberInfo[1].").
                                                $imgEmail.
                                            "</a>";
			}									
			if ((($Group ne "administrator")&&($Group ne $BoardInfo[4]))&&($UserName eq $PostInfo[2])&&($PostInfo[2])&&(!$Closed)) {
				$Replies.=					$imgSperater.&Link("UltraBoard.$Ext?Action=ModifyReply&Post=$in{'Post'}&Board=$in{'Board'}&ID=".($i-1)."&Idle=$in{'Idle'}&Sort=$in{'Sort'}&Order=$in{'Order'}&Page=$in{'Page'}&Session=$SessionID","","",
												"Modify this ($PostInfo[0]) message.").
												$imgModify.
											"</a>";
			}
			$Replies.=					"</td>".
										&Td("","","","","RIGHT","","","","");
			if (($Group eq "administrator")||($Group eq $BoardInfo[4])) {
				$Replies.=					&Link("UltraBoard.$Ext?Action=ModifyReply&Post=$in{'Post'}&Board=$in{'Board'}&ID=".($i-1)."&Idle=$in{'Idle'}&Sort=$in{'Sort'}&Order=$in{'Order'}&Page=$in{'Page'}&Session=$SessionID","","",
												"Modify this ($PostInfo[0]) message.").
												$imgModify.
											"</a>".$imgSperater;
			}
			if (($Group eq "administrator")||($Group eq $BoardInfo[4])) {
				$Replies.=					&Link("UltraBoard.$Ext?Action=DoRemoveMessages&Post=$in{'Post'}&ID=".($i-1)."&Board=$in{'Board'}&Idle=$in{'Idle'}&Sort=$in{'Sort'}&Order=$in{'Order'}&Page=$in{'Page'}&Session=$SessionID","","",
												"Remove this ($PostInfo[0]) Message.").
												$imgRemove.
											"</a>";
			}
			$Replies.=					"</td>".
									"</tr>".
								"</table>".
							"</td>".
						"</tr>";
		}
		$Replies.=		&Tr("","",$RowOddBGColor).
							&Td("","","","","","","","","").
								&Table("100%","CENTER","5","5","","").
									&Tr("","","").
										&Td("","","","","","MIDDLE","","","").
											&Font($FontFace,$TextSize,$TextColor).
												$PostInfo[7];
		if ($UseSignatures and $PostInfo[4] and $MemberInfo[15]) {
			$Replies.=	"<hr>".
						$MemberInfo[15];
		}
		$Replies.=							"</font>".
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
        $Replies.=	                        &Font($FontFace,$MenuTextSize,$MenuTextColor).
                                                "HOST/IP: ".$PostInfo[6].
                                            "</font>";
	}
	$Replies.=                          "</td>".
									"</tr>".
								"</table>".
							"</td>".
						"</tr>".
					&CBTable();			
	}
###############################################################################
    open(CATEGORY,"$DBPath/$BoardInfo[3].cat")||&CGIError("Couldn't open/read the $BoardInfo[3].cat file<br>\nPath: $DBPath<br>\nReason : $!");
		flock(CATEGORY,1) if ($FLock);
		$CATEGORY_DATA=<CATEGORY>;
		@CategoryInfo=&DecodeDBOutput($CATEGORY_DATA);
	close(CATEGORY);
    
	$HTML.=	"<p>".&BTable($TableWidth,$TableAlign,"0","0",$TableCellSpacing,$TableCellPadding,$TableBorderColor,"","").
				&Tr("","",$CategoryBGColor).
					&Td("","","","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							&Link("UltraBoard.$Ext?Session=$SessionID","","",
								"Back to $UBName.").
								"<b>Home".
							"</a>";
    if ($UseCategory) {
		$HTML.=				" / ".
							&Link("UltraBoard.$Ext?Action=ShowCategory&Category=$CategoryInfo[0]&Idle=$in{'Idle'}&Sort=$in{'Sort'}&Order=$in{'Order'}&Page=$in{'Page'}&Session=$SessionID","","",
								"View this ($CategoryInfo[1]) category.").
								"<b>$CategoryInfo[1]</b>".
							"</a>";
	}		
	$HTML.=					" / ".
                            &Link("UltraBoard.$Ext?Action=ShowBoard&Board=$in{'Board'}&Idle=$in{'Idle'}&Sort=$in{'Sort'}&Order=$in{'Order'}&Page=$in{'Page'}&Session=$SessionID","","",
								"Back to $BoardInfo[1] board.").
								"$BoardInfo[1]</b>".
							"</a>".
						"</font>".
					"</td>".
				"</tr>".
                &Tr("","",$MenuBGColor).
					&Td("","","","","","","","","").
                        &Table("100%","CENTER","0","0","","").
                            &Tr("","","").
                                &Td("10","","","","","","","","").
                                    $MessageIcon.
                                "</td>".
                                &Td("100%","","","","","","","","").
                                    &Font($FontFace,$TextSize,$TextColor)." ".
                                        "<b>".$Topic."</b> ".$NewIcon.
                                    "</font>".
                                "</td>".
                            "</tr>".
                        "</table>".
					"</td>".
				"</tr>";
	if ($TopicDes ne "") {
		$HTML.= &Tr("","",$RowOddBGColor).
			        &Td("","","","","","","","","").
                        &Font($FontFace,$CategoryDesTextSize,$CategoryTextColor).
							$TopicDes.
						"</font>".
                    "</td>".
                "</tr>";
	}
    $HTML.= "</table></td></tr></table>".
            "<p>".
			$Post.
			$Replies.
			"<p>".
			&BTable($TableWidth,$TableAlign,"0","0",$TableCellSpacing,$TableCellPadding,$TableBorderColor,"","").
				&Tr("","",$MenuBGColor).
                    &Td("","","","","RIGHT","","","","").
                        &Table("100%","CENTER","0","0","","").
                            &Tr("","","");
	if (($Group eq "administrator")||($Group eq $BoardInfo[4])) {
		$HTML.=					&Td("","","","","","","","","").
									&Link("UltraBoard.$Ext?Action=DoRemoveMessages&Post=$in{'Post'}&Board=$in{'Board'}&Idle=$in{'Idle'}&Sort=$in{'Sort'}&Order=$in{'Order'}&Page=$in{'Page'}&Session=$SessionID","","",
										"Remove this ($Topic) Thread.").
										$imgRemoveThread.
									"</a>".$imgSperater;
		if ($Closed) {
			$HTML.=					&Link("UltraBoard.$Ext?Action=DoCloseThread&Type=Open&Post=$in{'Post'}&Board=$in{'Board'}&Idle=$in{'Idle'}&Sort=$in{'Sort'}&Order=$in{'Order'}&Page=$in{'Page'}&Session=$SessionID","","",
										"Open this ($Topic) Thread.").
										$imgOpenThread.
									"</a>";
		}else{
			$HTML.=					&Link("UltraBoard.$Ext?Action=DoCloseThread&Type=Close&Post=$in{'Post'}&Board=$in{'Board'}&Idle=$in{'Idle'}&Sort=$in{'Sort'}&Order=$in{'Order'}&Page=$in{'Page'}&Session=$SessionID","","",
										"Close this ($Topic) Thread.").
										$imgCloseThread.
									"</a>";
		}					
		$HTML.=					"</td>";
	}
    $HTML.=                     &Td("","","","","RIGHT","","","","");
    if ((!defined ($MemberStatus))||($MemberStatus ne "ReadOnly")) {
        $HTML.=                     &Link("UltraBoard.$Ext?Action=NewPost&Board=$in{'Board'}&Idle=$in{'Idle'}&Sort=$in{'Sort'}&Order=$in{'Order'}&Page=$in{'Page'}&Session=$SessionID","","","Post new Topic").$imgPost."</a>";
        $HTML.=                     $imgSperater.&Link("UltraBoard.$Ext?Action=NewReply&Post=$in{'Post'}&Board=$in{'Board'}&Idle=$in{'Idle'}&Sort=$in{'Sort'}&Order=$in{'Order'}&Page=$in{'Page'}&Session=$SessionID","","","Reply this Topic").$imgReply."</a>".$imgSperater if (!$Closed);
    }
    $HTML.= $imgSperater if ($Closed);
	$HTML.=                         &Link("UltraBoard.$Ext?Action=PrintableTopic&Post=$in{'Post'}&Board=$in{'Board'}&Idle=$in{'Idle'}&Sort=$in{'Sort'}&Order=$in{'Order'}&Page=$in{'Page'}&Session=$SessionID","","","View Printable Version of this Topic").$imgPrint."</a>";
	$HTML.=							$imgSperater.&Link("UltraBoard.$Ext?Action=ForwardTopic&Post=$in{'Post'}&Board=$in{'Board'}&Idle=$in{'Idle'}&Sort=$in{'Sort'}&Order=$in{'Order'}&Page=$in{'Page'}&Session=$SessionID","","","Forward this Topic to Friend").$imgForward."</a>" if ($EmailFunction);
    $HTML.=                     "</td>".
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
			&GetBoardList();
	&PrintTheme("$UBName - $Topic",$HTML);
	exit;
}
###############################################################################
1;# End of ShowPost Function
###############################################################################