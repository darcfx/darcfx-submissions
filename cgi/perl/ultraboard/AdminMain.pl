###############################################################################
# AdminMain.pl                                                                #
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
# Main                                                                        #
###############################################################################
sub Main {
	#use POSIX qw(&ceil);
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
						"</form>";
						
	open(MEMBERS,"$MembersPath/Members.rev")||&CGIError("Couldn't open/read the Members.rev file<br>\nPath: $MembersPath<br>\nReason : $!");
		flock(MEMBERS,1) if ($FLock);
		@MEMBERS_DATA=<MEMBERS>;
	close(MEMBERS);

	if (scalar(@MEMBERS_DATA)>0) {
		chomp (@MEMBERS_DATA);
		$HTML.=				&Form("UBAdmin.$Ext","GET","","","name=\"form\"").
							&HiddenBox("Action","DoApproveAccounts").
							&HiddenBox("Count",scalar(@MEMBERS_DATA)).
							&HiddenBox("Session",$SessionID).
						"</td>".
					"</tr>".
				"</table>".
				&BTable($TableWidth,$TableAlign,"0","0",$TableCellSpacing,$TableCellPadding,$TableBorderColor,"","").
					&Tr("","",$HeaderBGColor).
						&Td("","","7","","","","","","").
							&Font($FontFace,$HeaderTextSize,$HeaderTextColor).
								"<b>APPROVE/DISAPPROVE MEMBERS ACCOUNT</b>".
							"</font>".
						"</td>".
					"</tr>".
					&Tr("","",$CategoryBGColor).
						&Td("20","","","","CENTER","","","","").
							&Link("#","","","","onClick=\"CheckAll();return false;\"").
								&Image("$URLImages/CheckAll.gif","","","","","0","Reverse Selection").
							"</a>".
						"</td>".
						&Td("","","","","","","","","").
							&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
								"<b>Nick Name</b>".
							"</font>".
						"</td>".
						&Td("","","","","","","","","").
							&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
								"<b>Email</b>".
							"</font>".
						"</td>".
                        &Td("","","","","","","","","").
							&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
								"<b>Host/IP</b>".
							"</font>".
						"</td>".
						&Td("","","","","","","","","").
							&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
								"<b>Registered Date</b>".
							"</font>".
						"</td>".
					"</tr>";
		for ($i=$#MEMBERS_DATA;$i>=0;$i--) {
			@MemberInfo=&GetMemberData($MEMBERS_DATA[$i]);
			$HTML.=	&Tr("","",$RowColor).
						&Td("20","","","","CENTER","","",$ColumnOddBGColor,"").
							&Checkbox("MemberID_$i",$MemberInfo[0],"","").
						"</td>".
						&Td("30%","","","","","","",$ColumnEvenBGColor,"").
							&Font($FontFace,$TextSize,$TextColor)." ".
								&Link("UltraBoard.$Ext?Action=ShowProfile&ID=$MemberInfo[0]&Session=$SessionID","Profile",$MemberInfo[1]).
									"$MemberInfo[1]".
								"</a>".
							"</font>".
						"</td>".
                        &Td("30%","","","","","","",$ColumnOddBGColor,"").
							&Font($FontFace,$TextSize,$TextColor).
                                &Link("mailto:$MemberInfo[4]","","").
									"$MemberInfo[4]".
								"</a>".
							"</font>".
						"</td>".
						&Td("20%","","","","","","",$ColumnEvenBGColor,"").
							&Font($FontFace,"1",$TextColor).
								"$MemberInfo[18]".
							"</font>".
						"</td>".
						&Td("20%","","","","","","",$ColumnOddBGColor,"").
							&Font($FontFace,$TextSize,$TextColor).
								&GetDate($MemberInfo[16],$DateTextColor,$TimeTextColor,$DateTextSize,$TimeTextSize).
							"</font>".
						"</td>".
					"</tr>";
			if ($RowColor eq $RowEvenBGColor) {
				$RowColor=$RowOddBGColor;
			}else{
				$RowColor=$RowEvenBGColor;
			}
		}
		$HTML.=		&Tr("","",$CategoryBGColor).
						&Td("","","6","","","","","","").
							&Table("100%","CENTER","0","0","","").
								&Tr("","","").
									&Td("50%","","","","","","","","").
										"<center>".&Submit("Submit","APPROVE","width:$IETextBoxSize")."</center>".
									"</td>".
									&Td("50%","","","","","","","","").
										"<center>".&Submit("Submit","DISPROVE","width:$IETextBoxSize")."</center>".
									"</td>".
								"</tr>".
							"</table>".
						"</td>".
					"</tr>".
					&Tr("","",$MenuBGColor).
						&Td("","","6","","","","","","").
							&PrintVersion("YES").
						"</td>".
					"</tr>".
				"</table></td></tr></table>".
				"</form>";
		($HTML.=<<'				HTML')=~s/^\s+//gm;
				
				<SCRIPT LANGUAGE="JavaScript">
				<!--
					function CheckAll () {
						var Num=document.form.Count.value;
						for (var i=0;i<Num;i++) {
							eval ("document.form.MemberID_"+i+".checked = 1-document.form.MemberID_"+i+".checked");
						}
					}
				//-->
				</SCRIPT>
				HTML
	}else{
		$HTML.=			"</td>".
					"</tr>".
				"</table>";
	}
	if ($UseStats) {
		###############################################################################
		# Process Vistors Log
			###########################################################################
			# Print Last 20 Vistors
			$HTML.=		&BTable($TableWidth,$TableAlign,"0","0",$TableCellSpacing,$TableCellPadding,$TableBorderColor,"","").
							&Tr("","",$HeaderBGColor).
								&Td("","","2","","","","","","").
									&Font($FontFace,$HeaderTextSize,$HeaderTextColor).
										"<b>GENERAL INFORMATION</b>".
									"</font>".
								"</td>".
							"</tr>";
            open(MEMBERS,"$MembersPath/Members.total");
				flock(MEMBERS,2) if ($FLock);
				$Members=<MEMBERS>;
			close(MEMBERS);
            $Members=0 unless ($Members);
			$HTML.=			&Tr("","",$RowOddBGColor).
								&Td("20%","","","","","","",$ColumnOddBGColor,"").
									&Font($FontFace,$TextSize,$TextColor).
										"Total Members".
									"</font>".
								"</td>".
								&Td("80%","","","","","","",$ColumnEvenBGColor,"").
									&Font($FontFace,$TextSize,$TextColor).
										$Members." members".
									"</font>".
								"</td>".
							"</tr>";
            open(BOARDS,"$DBPath/Boards.db");
				flock(BOARDS,2) if ($FLock);
				@Boards=<BOARDS>;
			close(BOARDS);
			$HTML.=			&Tr("","",$RowEvenBGColor).
								&Td("20%","","","","","","",$ColumnOddBGColor,"").
									&Font($FontFace,$TextSize,$TextColor).
										"Total Boards".
									"</font>".
								"</td>".
								&Td("80%","","","","","","",$ColumnEvenBGColor,"").
									&Font($FontFace,$TextSize,$TextColor).
										scalar(@Boards)." boards".
									"</font>".
								"</td>".
							"</tr>";
            open(HITS,"$StatsPath/Total.hits");
				flock(HITS,2) if ($FLock);
				$TotalHits=<HITS>;
			close(HITS);
            $TotalHits=0 unless ($TotalHits);
			$HTML.=			&Tr("","",$RowOddBGColor).
								&Td("20%","","","","","","",$ColumnOddBGColor,"").
									&Font($FontFace,$TextSize,$TextColor).
										"Total Hits".
									"</font>".
								"</td>".
								&Td("80%","","","","","","",$ColumnEvenBGColor,"").
									&Font($FontFace,$TextSize,$TextColor).
										$TotalHits." hits".
									"</font>".
								"</td>".
							"</tr>";
			open(CDATE,"$StatsPath/CDate.dat");
				flock(CDATE,2) if ($FLock);
				$CurrentDate=<CDATE>;
			close(CDATE);
			open(HITS,"$StatsPath/Today.hits");
				flock(HITS,2) if ($FLock);
				$TodayHits=<HITS>;
			close(HITS);
			$HTML.=			&Tr("","",$RowEvenBGColor).
								&Td("20%","","","","","","",$ColumnOddBGColor,"").
									&Font($FontFace,$TextSize,$TextColor).
										"Current Date Hits".
									"</font>".
								"</td>".
								&Td("80%","","","","","","",$ColumnEvenBGColor,"").
									&Font($FontFace,$TextSize,$TextColor).
										$CurrentDate." (".$TodayHits." hits)".
									"</font>".
								"</td>".
							"</tr>";
			my (@Days) = ("Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday");
			open(POP,"$StatsPath/Week.pop");
				flock(POP,2) if ($FLock);
				@MaxDay=split(/\|\^\|/,<POP>);
			close(POP);
			$HTML.=			&Tr("","",$RowOddBGColor).
								&Td("20%","","","","","","",$ColumnOddBGColor,"").
									&Font($FontFace,$TextSize,$TextColor).
										"Highest Day of the Week".
									"</font>".
								"</td>".
								&Td("80%","","","","","","",$ColumnEvenBGColor,"").
									&Font($FontFace,$TextSize,$TextColor).
										$Days[$MaxDay[0]]." (".$MaxDay[1]." hits)".
									"</font>".
								"</td>".
							"</tr>";
			open(POP,"$StatsPath/Day.pop");
				flock(POP,2) if ($FLock);
				@MaxHour=split(/\|\^\|/,<POP>);
			close(POP);
			$HTML.=			&Tr("","",$RowEvenBGColor).
								&Td("20%","","","","","","",$ColumnOddBGColor,"").
									&Font($FontFace,$TextSize,$TextColor).
										"Highest Hour of the Day".
									"</font>".
								"</td>".
								&Td("80%","","","","","","",$ColumnEvenBGColor,"").
									&Font($FontFace,$TextSize,$TextColor).
										$MaxHour[0].":00 - ".$MaxHour[0].":59 (".$MaxHour[1]." hits)".
									"</font>".
								"</td>".
							"</tr>";
			open(POP,"$StatsPath/Browsers.pop");
				flock(POP,2) if ($FLock);
				@MaxBrowser=split(/\|\^\|/,<POP>);
			close(POP);
			$MaxBrowser[0]=~s/_/ /g;
			$HTML.=			&Tr("","",$RowOddBGColor).
								&Td("20%","","","","","","",$ColumnOddBGColor,"").
									&Font($FontFace,$TextSize,$TextColor).
										"Most Accessed Browser".
									"</font>".
								"</td>".
								&Td("80%","","","","","","",$ColumnEvenBGColor,"").
									&Font($FontFace,$TextSize,$TextColor).
										$MaxBrowser[0]." (".$MaxBrowser[1]." hits)".
									"</font>".
								"</td>".
							"</tr>".
							&Tr("","",$MenuBGColor).
								&Td("","","2","","RIGHT","","","","").
									&Font($FontFace,$MenuTextSize,$MenuTextColor).
										&Link("UBAdmin.$Ext?Action=ShowStats&Session=$SessionID","","").
											"more...".
										"</a>".
									"</font>".
								"</td>".
							"</tr>".
						"</table></td></tr></table>".
						"<p>";
		###############################################################################
		# Process Vistors Log
			open(LOG,"$StatsPath/Visitors.log");
				flock(LOG,2) if ($FLock);
				@Visitors=<LOG>;
			close(LOG);
			###########################################################################
			# Print Last 20 Vistors
			$HTML.=		&BTable($TableWidth,$TableAlign,"0","0",$TableCellSpacing,$TableCellPadding,$TableBorderColor,"","").
							&Tr("","",$HeaderBGColor).
								&Td("","","3","","","","","","").
									&Font($FontFace,$HeaderTextSize,$HeaderTextColor).
										"<b>LAST 20 VISITORS</b>".
									"</font>".
								"</td>".
							"</tr>";
			$EndLog=scalar(@Visitors);
			if ($EndLog>20) {
				$EndLog-=20;
			}else{
				$EndLog=0;
			}
            $RowColor=$RowOddBGColor;
			for ($n=$#Visitors;$n>=$EndLog;$n--) {
				@LogInfo=split(/\|\^\|/,$Visitors[$n]);
				$LogInfo[4]=~s/\_/ /g;
				if (!$LogInfo[2]) {
					$Host=$LogInfo[1];
				}else{
					$Host=$LogInfo[2];
				}
				$HTML.=		&Tr("","",$RowColor).
								&Td("35%","","","","","","",$ColumnOddBGColor,"").
									&Font($FontFace,$TextSize,$TextColor).
										$LogInfo[0].
									"</font>".
								"</td>".
								&Td("40%","","","","","","",$ColumnEvenBGColor,"").
									&Font($FontFace,$TextSize,$TextColor).
										$Host.
									"</font>".
								"</td>".
								&Td("25%","","","","","","",$ColumnOddBGColor,"").
									&Font($FontFace,$TextSize,$TextColor).
										$LogInfo[4].
									"</font>".
								"</td>".
							"</tr>";
				if ($RowColor eq $RowEvenBGColor) {
					$RowColor=$RowOddBGColor;
				}else{
					$RowColor=$RowEvenBGColor;
				}
			}
			$HTML.=		&Tr("","",$MenuBGColor).
							&Td("","","3","","RIGHT","","","","").
								&Font($FontFace,$MenuTextSize,$MenuTextColor).
									&Link("UBAdmin.$Ext?Action=ShowStats&Type=LastVisitors&Session=$SessionID","","").
										"more...".
									"</a>".
								"</font>".
							"</td>".
						"</tr>".
					"</table></td></tr></table>".
					"<p>";
			###########################################################################
			# Print Last 20 Referers URL
			$HTML.=		&BTable($TableWidth,$TableAlign,"0","0",$TableCellSpacing,$TableCellPadding,$TableBorderColor,"","").
							&Tr("","",$HeaderBGColor).
								&Td("","","2","","","","","","").
									&Font($FontFace,$HeaderTextSize,$HeaderTextColor).
										"<b>LAST 20 REFFERING URLS</b>".
									"</font>".
								"</td>".
							"</tr>";
			$EndLog=scalar(@Visitors);
			if ($EndLog>20) {
				$EndLog-=20;
			}else{
				$EndLog=0;
			}
            $RowColor=$RowOddBGColor;
			for ($n=$#Visitors;$n>=$EndLog;$n--) {
				@LogInfo=split(/\|\^\|/,$Visitors[$n]);
				$LengthURL=length($LogInfo[3]);
				$ReferURL=$LogInfo[3];
				if ($LengthURL >= 80) {
					$ReferURL=substr ($LogInfo[3],0,37)."...".substr ($LogInfo[3],$LengthURL-37,37);
				}
				$HTML.=		&Tr("","",$RowColor).
								&Td("35%","","","","","","",$ColumnOddBGColor,"").
									&Font($FontFace,$TextSize,$TextColor).
										$LogInfo[0].
									"</font>".
								"</td>".
								&Td("65%","","","","","","",$ColumnEvenBGColor,"").
									&Font($FontFace,$TextSize,$TextColor).
										&Link($LogInfo[3],"_blank",$LogInfo[3]).
											$ReferURL.
										"</a>".
									"</font>".
								"</td>".
							"</tr>";
				if ($RowColor eq $RowEvenBGColor) {
					$RowColor=$RowOddBGColor;
				}else{
					$RowColor=$RowEvenBGColor;
				}
			}
			$HTML.=		&Tr("","",$MenuBGColor).
							&Td("","","2","","RIGHT","","","","").
								&Font($FontFace,$MenuTextSize,$MenuTextColor).
									&Link("UBAdmin.$Ext?Action=ShowStats&Type=LastReferURL&Session=$SessionID","","").
										"more...".
									"</a>".
								"</font>".
							"</td>".
						"</tr>".
					"</table></td></tr></table>".
					"<p>";
	}
	if ($UseLog) {
		###############################################################################
		# Process Vistors Log
			open(LOG,"$StatsPath/Action.log");
				flock(LOG,2) if ($FLock);
				my (@Actions)=<LOG>;
			close(LOG);
			###########################################################################
			# Print Last 20 Vistors
			$HTML.=		&BTable($TableWidth,$TableAlign,"0","0",$TableCellSpacing,$TableCellPadding,$TableBorderColor,"","").
							&Tr("","",$HeaderBGColor).
								&Td("","","3","","","","","","").
									&Font($FontFace,$HeaderTextSize,$HeaderTextColor).
										"<b>LAST 20 ACTIONS</b>".
									"</font>".
								"</td>".
							"</tr>";
			$EndLog=scalar(@Actions);
			if ($EndLog>20) {
				$EndLog-=20;
			}else{
				$EndLog=0;
			}
            $RowColor=$RowOddBGColor;
			for ($n=$#Actions;$n>=$EndLog;$n--) {
				@LogInfo=split(/\|\^\|/,$Actions[$n]);
				if (!$LogInfo[2]) {
					$Host=$LogInfo[1];
				}else{
					$Host=$LogInfo[2];
				}
				if ($LogInfo[4] eq "") {
					$Info = "$LogInfo[9] at the first page";
				}elsif ($LogInfo[4] eq "SignIn") {
					$Info = "$LogInfo[9] at the sign in page";
				}elsif ($LogInfo[4] eq "LostPassword") {
					$Info = "$LogInfo[9] at the lost password page";
				}elsif ($LogInfo[4] eq "DoLostPassword") {
					$Info = "ub) sending password";
				}elsif ($LogInfo[4] eq "SignOut") {
					$Info = "$LogInfo[9] sign out";
				}elsif ($LogInfo[4] eq "SignUp") {
					$Info = "at sign up page";
				}elsif ($LogInfo[4] eq "DoSignUp") {
					$Info = "ub) creating account";
				}elsif ($LogInfo[4] eq "ModifyAccount") {
					$Info = "$LogInfo[9] at modify acount page";
				}elsif ($LogInfo[4] eq "DoModifyAccount") {
					$Info = "ub) modifing $LogInfo[9] account";
				}elsif ($LogInfo[4] eq "ShowCategory") {
					$Info = "$LogInfo[9] view $LogInfo[5] category";
				}elsif ($LogInfo[4] eq "ShowBoard") {
					$Info = "$LogInfo[9] view $LogInfo[6] board";
				}elsif ($LogInfo[4] eq "ShowPost") {
					$Info = "$LogInfo[9] view $LogInfo[7] ($LogInfo[6]) topic";
				}elsif ($LogInfo[4] eq "PrintableTopic") {
					$Info = "$LogInfo[9] view $LogInfo[7] ($LogInfo[6]) printable version topic";
				}elsif ($LogInfo[4] eq "ForwardTopic") {
					$Info = "$LogInfo[9] send $LogInfo[7] ($LogInfo[6]) topic to friend ";
				}elsif ($LogInfo[4] eq "DoForwardTopic") {
					$Info = "ub) sending $LogInfo[7] ($LogInfo[6]) topic";
				}elsif ($LogInfo[4] eq "NewPost") {
					$Info = "$LogInfo[9] write a new topic at $LogInfo[6] board";
				}elsif ($LogInfo[4] eq "DoNewPost") {
					$Info = "ub) posting a new topic at $LogInfo[6] board";
				}elsif ($LogInfo[4] eq "NewReply") {
					$Info = "$LogInfo[9] reply the $LogInfo[7] ($LogInfo[6]) topic";
				}elsif ($LogInfo[4] eq "DoNewReply") {
					$Info = "ub) posting the reply on $LogInfo[7] ($LogInfo[6])";
				}elsif ($LogInfo[4] eq "ModifyPost") {
					$Info = "$LogInfo[9] modify topic($LogInfo[7]) at $LogInfo[6]";
				}elsif ($LogInfo[4] eq "DoModifyPost") {
					$Info = "ub) modifing topic($LogInfo[7]) at $LogInfo[6]";
				}elsif ($LogInfo[4] eq "ModifyReply") {
					$Info = "$LogInfo[9] modify reply($LogInfo[8]) at $LogInfo[7] ($LogInfo[6])";
				}elsif ($LogInfo[4] eq "DoModifyReply") {
					$Info = "ub) modifing reply($LogInfo[8]) at $LogInfo[7] ($LogInfo[6])";
				}elsif ($LogInfo[4] eq "ShowProfile") {
					$Info = "$LogInfo[9] view $LogInfo[8] profile";
				}elsif ($LogInfo[4] eq "SearchThreads") {
					$Info = "$LogInfo[9] search thread";
				}elsif ($LogInfo[4] eq "DoSearchThreads") {
					$Info = "ub) searching thread";
				}elsif ($LogInfo[4] eq "DoRemoveMessages") {
					$Info = "$LogInfo[9] remove thread($LogInfo[7]) at $LogInfo[6]";
				}elsif ($LogInfo[4] eq "DoCloseThread") {
					$Info = "$LogInfo[9] close/open thread($LogInfo[7]) at $LogInfo[6]";
				}else{
					$Info = "$LogInfo[9] do \"$LogInfo[4]\" Action";
				}
				$HTML.=		&Tr("","",$RowColor).
								&Td("30%","","","","","","",$ColumnOddBGColor,"").
									&Font($FontFace,"1",$TextColor).
										$LogInfo[0].
									"</font>".
								"</td>".
								&Td("28%","","","","","","",$ColumnEvenBGColor,"").
									&Font($FontFace,"1",$TextColor).
										$Host.
									"</font>".
								"</td>".
								&Td("42%","","","","","","",$ColumnOddBGColor,"").
									&Font($FontFace,"1",$TextColor).
										$Info.
									"</font>".
								"</td>".
							"</tr>";
				if ($RowColor eq $RowEvenBGColor) {
					$RowColor=$RowOddBGColor;
				}else{
					$RowColor=$RowEvenBGColor;
				}
			}
			$HTML.=		&Tr("","",$MenuBGColor).
							&Td("","","3","","RIGHT","","","","").
								&Font($FontFace,$MenuTextSize,$MenuTextColor).
									&Link("UBAdmin.$Ext?Action=ShowStats&Type=ActionLog&Session=$SessionID","","").
										"more...".
									"</a>".
								"</font>".
							"</td>".
						"</tr>".
					"</table></td></tr></table>".
					"<p>";
	}
    ###############################################################################
    # Process Vistors Log
        open(LOG,"$StatsPath/Admin.log");
            flock(LOG,2) if ($FLock);
            @Actions=<LOG>;
        close(LOG);
        ###########################################################################
        # Print Last 20 Vistors
        $HTML.=		&BTable($TableWidth,$TableAlign,"0","0",$TableCellSpacing,$TableCellPadding,$TableBorderColor,"","").
                        &Tr("","",$HeaderBGColor).
                            &Td("","","3","","","","","","").
                                &Font($FontFace,$HeaderTextSize,$HeaderTextColor).
                                    "<b>LAST 20 ADMINISTRATOR ACTIONS</b>".
                                "</font>".
                            "</td>".
                        "</tr>";
        $EndLog=scalar(@Actions);
        if ($EndLog>20) {
            $EndLog-=20;
        }else{
            $EndLog=0;
        }
        $RowColor=$RowOddBGColor;
        for ($n=$#Actions;$n>=$EndLog;$n--) {
            @LogInfo=split(/\|\^\|/,$Actions[$n]);
            if (!$LogInfo[2]) {
                $Host=$LogInfo[1];
            }else{
                $Host=$LogInfo[2];
            }
            $Info = "$LogInfo[5] do \"$LogInfo[4]\" Action";
			$HTML.=		    &Tr("","",$RowColor).
								&Td("30%","","","","","","",$ColumnOddBGColor,"").
									&Font($FontFace,"1",$TextColor).
										$LogInfo[0].
									"</font>".
								"</td>".
								&Td("28%","","","","","","",$ColumnEvenBGColor,"").
									&Font($FontFace,"1",$TextColor).
										$Host.
									"</font>".
								"</td>".
								&Td("42%","","","","","","",$ColumnOddBGColor,"").
									&Font($FontFace,"1",$TextColor).
										$Info.
									"</font>".
								"</td>".
							"</tr>";
            if ($RowColor eq $RowEvenBGColor) {
                $RowColor=$RowOddBGColor;
            }else{
                $RowColor=$RowEvenBGColor;
            }
        }
		$HTML.= 		&Tr("","",$MenuBGColor).
							&Td("","","3","","RIGHT","","","","").
								&Font($FontFace,$MenuTextSize,$MenuTextColor).
									&Link("UBAdmin.$Ext?Action=ShowStats&Type=AdminLog&Session=$SessionID","","").
										"more...".
									"</a>".
								"</font>".
							"</td>".
						"</tr>".
					"</table></td></tr></table>".
					"<p>";
	&PrintTheme("$UBName Administrative Center",$HTML);
	exit;    
}
###############################################################################
1;# End of Main Function
###############################################################################