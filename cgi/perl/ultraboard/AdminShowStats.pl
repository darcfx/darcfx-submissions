###############################################################################
# AdminShowStats.pl                                                           #
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
# ShowStats                                                                   #
###############################################################################
sub ShowStats {
	#use POSIX qw(&ceil);
	$HTML.=&Table($TableWidth,$TableAlign,"","6","","").
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
						&Form("UBAdmin.$Ext","POST","","","name=\"form\"").
						&HiddenBox("Action","DoCreateBoard").
						&HiddenBox("Count",(scalar(@GROUPS_DATA)-1)).
						&HiddenBox("Session",$SessionID).
					"</td>".
				"</tr>".
			"</table>";
	if ($in{'Type'} eq "LastVisitors") {
		$ColSpan=3;
		open(LOG,"$StatsPath/Visitors.log");
			flock(LOG,2) if ($FLock);
			@Visitors=<LOG>;
		close(LOG);
		$HTML.=		&BTable($TableWidth,$TableAlign,"0","0",$TableCellSpacing,$TableCellPadding,$TableBorderColor,"","").
						&Tr("","",$HeaderBGColor).
							&Td("","","3","","","","","","").
								&Font($FontFace,$HeaderTextSize,$HeaderTextColor).
									"<b>LAST $MaxVisitorLog VISITORS</b>".
								"</font>".
							"</td>".
						"</tr>";
        $RowColor=$RowOddBGColor;
		for ($n=$#Visitors;$n>=0;$n--) {
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
        $HTML.=		    &Tr("","",$MenuBGColor).
							&Td("","",$ColSpan,"","RIGHT","","","","").
								&PrintVersion().
							"</td>".
						"</tr>".
					"</table></td></tr></table>".
					"<p>";
	}elsif ($in{'Type'} eq "LastReferURL") {
		$ColSpan=3;
		open(LOG,"$StatsPath/Visitors.log");
			flock(LOG,2) if ($FLock);
			@Visitors=<LOG>;
		close(LOG);
		$HTML.=		&BTable($TableWidth,$TableAlign,"0","0",$TableCellSpacing,$TableCellPadding,$TableBorderColor,"","").
						&Tr("","",$HeaderBGColor).
							&Td("","","2","","","","","","").
								&Font($FontFace,$HeaderTextSize,$HeaderTextColor).
									"<b>LAST $MaxVisitorLog REFERERS URL</b>".
								"</font>".
							"</td>".
						"</tr>";
        $RowColor=$RowOddBGColor;
		for ($n=$#Visitors;$n>=0;$n--) {
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
									&Link($LogInfo[3],"_blank","$LogInfo[3]").
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
        $HTML.=		    &Tr("","",$MenuBGColor).
							&Td("","",$ColSpan,"","RIGHT","","","","").
								&PrintVersion().
							"</td>".
						"</tr>".
					"</table></td></tr></table>".
					"<p>";
	}elsif ($in{'Type'} eq "TopReferURL") {
		$ColSpan=3;
		open(REFERER,"$StatsPath/Referers.log");
			flock(REFERER,2) if ($FLock);
			my (@RefURLs)=<REFERER>;
		close(REFERER);
		$TotalHits=0;
		for ($n=0;$n<=$#RefURLs;$n++) {
			($RefURL,$Value)=split(/\|\^\|/,$RefURLs[$n]);
			$Sort{$n}=$Value;
			$ReferURL[$n]=$RefURL;
			$ReferValue[$n]=$Value;
			$TotalHits+=$Value;
		}
		@SortedList = reverse sort{$Sort{$a} <=> $Sort{$b}} keys %Sort;
		$HTML.=		&BTable($TableWidth,$TableAlign,"0","0",$TableCellSpacing,$TableCellPadding,$TableBorderColor,"","").
						&Tr("","",$HeaderBGColor).
							&Td("","","3","","","","","","").
								&Font($FontFace,$HeaderTextSize,$HeaderTextColor).
									"<b>TOP REFERERS URL</b>".
								"</font>".
							"</td>".
						"</tr>";
		$RowColor=$RowOddBGColor;
		for ($n=0;$n<scalar(@SortedList);$n++) {
			$TotalPercent=&ceil(($ReferValue[$n]/$TotalHits)*10000)/100;
			$LengthURL=length($ReferURL[$n]);
			$ReferURL=$ReferURL[$n];
			if ($LengthURL >= 70) {
				$ReferURL=substr ($ReferURL[$n],0,35)."...".substr ($ReferURL[$n],$LengthURL-35,35);
			}
			$HTML.=		&Tr("","",$RowColor).
							&Td("10%","","","","CENTER","","",$ColumnOddBGColor,"").
								&Font($FontFace,$TextSize,$TextColor).
									$ReferValue[$n].
								"</font>".
							"</td>".
							&Td("10%","","","","CENTER","","",$ColumnEvenBGColor,"").
								&Font($FontFace,$TextSize,$TextColor).
									$TotalPercent."%".
								"</font>".
							"</td>".
							&Td("80%","","","","","","",$ColumnOddBGColor,"").
								&Font($FontFace,$TextSize,$TextColor).
									&Link($ReferURL[$n],"_blank",$ReferURL[$n]).
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
        $HTML.=		    &Tr("","",$MenuBGColor).
							&Td("","",$ColSpan,"","RIGHT","","","","").
								&PrintVersion().
							"</td>".
						"</tr>".
					"</table></td></tr></table>".
					"<p>";
	}elsif ($in{'Type'} eq "Days") {
		$ColSpan=4;
		open(HITS,"$StatsPath/Days.hits");
			flock(HITS,2) if ($FLock);
			my (@Hits)=<HITS>;
		close(HITS);
		open(CDATE,"$StatsPath/CDate.dat");
			flock(CDATE,2) if ($FLock);
			my ($CurrentDate)=<CDATE>;
		close(CDATE);
		open(HITS,"$StatsPath/Today.hits");
			flock(HITS,2) if ($FLock);
			my ($TodayHits)=<HITS>;
		close(HITS);
		$Max=0;
		$TotalHits=0;
		@Day=();
		@DayHit=();
		if ($CurrentDate) {
			push (@Day, $CurrentDate);
			push (@DayHit, $TodayHits);
			$Max=$TodayHits if ($Max<$TodayHits);
			$TotalHits+=$TodayHits;
		}
		for ($n=$#Hits;$n>=0;$n--) {
			@DayInfo=split(/\|\^\|/,$Hits[$n]);
			push (@Day, $DayInfo[0]);
			push (@DayHit, $DayInfo[1]);
			$Max=$DayInfo[1] if ($Max<$DayInfo[1]);
			$TotalHits+=$DayInfo[1];
		}
		$HTML.=		&BTable($TableWidth,$TableAlign,"0","0",$TableCellSpacing,$TableCellPadding,$TableBorderColor,"","").
						&Tr("","",$HeaderBGColor).
							&Td("","","4","","","","","","").
								&Font($FontFace,$HeaderTextSize,$HeaderTextColor).
									"<b>DAYS HITS</b>".
								"</font>".
							"</td>".
						"</tr>";
		$RowColor=$RowOddBGColor;
		for ($n=0;$n<scalar(@Day);$n++) {
			$Percentage=&ceil(($DayHit[$n]/$Max)*100);
			$TotalPercent=&ceil(($DayHit[$n]/$TotalHits)*10000)/100;
			$HTML.=		&Tr("","",$RowColor).
							&Td("20%","","","","","","",$ColumnOddBGColor,"").
								&Font($FontFace,$TextSize,$TextColor).
									$Day[$n].
								"</font>".
							"</td>".
							&Td("10%","","","","CENTER","","",$ColumnEvenBGColor,"").
								&Font($FontFace,$TextSize,$TextColor).
									$DayHit[$n].
								"</font>".
							"</td>".
							&Td("10%","","","","CENTER","","",$ColumnOddBGColor,"").
								&Font($FontFace,$TextSize,$TextColor).
									$TotalPercent."%".
								"</font>".
							"</td>".
							&Td("60%","","","","","","",$ColumnEvenBGColor,"").
								&Font($FontFace,$TextSize,$TextColor).
									&Image("$URLImages/Bar.gif","$Percentage%","16","","","0","$DayHit[$n] ($TotalPercent%)").
								"</font>".
							"</td>".
						"</tr>";
			if ($RowColor eq $RowEvenBGColor) {
				$RowColor=$RowOddBGColor;
			}else{
				$RowColor=$RowEvenBGColor;
			}
		}
        $HTML.=		    &Tr("","",$MenuBGColor).
							&Td("","",$ColSpan,"","RIGHT","","","","").
								&PrintVersion().
							"</td>".
						"</tr>".
					"</table></td></tr></table>".
					"<p>";
	}elsif ($in{'Type'} eq "ActionLog") {
		$ColSpan=9;
		open(LOG,"$StatsPath/Action.log");
			flock(LOG,2) if ($FLock);
			my (@Actions)=<LOG>;
		close(LOG);
		$HTML.=		&BTable($TableWidth,$TableAlign,"0","0",$TableCellSpacing,$TableCellPadding,$TableBorderColor,"","").
						&Tr("","",$HeaderBGColor).
							&Td("","","9","","","","","","").
								&Font($FontFace,$HeaderTextSize,$HeaderTextColor).
									"<b>LAST $MaxActionLog ACTIONS</b>".
								"</font>".
							"</td>".
						"</tr>".
						&Tr("","",$HeaderBGColor).
							&Td("","","","","","","","","").
								&Font($FontFace,$HeaderTextSize,$HeaderTextColor).
									"<b>Date</b>".
								"</font>".
							"</td>".
							&Td("","","","","","","","","").
								&Font($FontFace,$HeaderTextSize,$HeaderTextColor).
									"<b>HOST</b>".
								"</font>".
							"</td>".
                            &Td("","","","","","","","","").
								&Font($FontFace,$HeaderTextSize,$HeaderTextColor).
									"<b>IP</b>".
								"</font>".
							"</td>".
							&Td("","","","","","","","","").
								&Font($FontFace,$HeaderTextSize,$HeaderTextColor).
									"<b>ACTION</b>".
								"</font>".
							"</td>".
							&Td("","","","","","","","","").
								&Font($FontFace,$HeaderTextSize,$HeaderTextColor).
									"<b>CATEGORY</b>".
								"</font>".
							"</td>".
							&Td("","","","","","","","","").
								&Font($FontFace,$HeaderTextSize,$HeaderTextColor).
									"<b>BOARD</b>".
								"</font>".
							"</td>".
							&Td("","","","","","","","","").
								&Font($FontFace,$HeaderTextSize,$HeaderTextColor).
									"<b>POST ID</b>".
								"</font>".
							"</td>".
							&Td("","","","","","","","","").
								&Font($FontFace,$HeaderTextSize,$HeaderTextColor).
									"<b>ID</b>".
								"</font>".
							"</td>".
							&Td("","","","","","","","","").
								&Font($FontFace,$HeaderTextSize,$HeaderTextColor).
									"<b>USERNAME</b>".
								"</font>".
							"</td>".
						"</tr>";
        $RowColor=$RowOddBGColor;
		for ($n=$#Actions;$n>=0;$n--) {
			@LogInfo=split(/\|\^\|/,$Actions[$n]);
			$HTML.=		&Tr("","",$RowColor).
							&Td("","","","","","","",$ColumnOddBGColor,"").
								&Font($FontFace,"1",$TextColor).
									$LogInfo[0].
								"</font>".
							"</td>".
							&Td("","","","","","","",$ColumnEvenBGColor,"").
								&Font($FontFace,"1",$TextColor).
									$LogInfo[2].
								"</font>".
							"</td>".
                            &Td("","","","","","","",$ColumnOddBGColor,"").
								&Font($FontFace,"1",$TextColor).
									$LogInfo[1].
								"</font>".
							"</td>".
							&Td("","","","","","","",$ColumnEvenBGColor,"").
								&Font($FontFace,"1",$TextColor).
									$LogInfo[4].
								"</font>".
							"</td>".
							&Td("","","","","","","",$ColumnOddBGColor,"").
								&Font($FontFace,"1",$TextColor).
									$LogInfo[5].
								"</font>".
							"</td>".
							&Td("","","","","","","",$ColumnEvenBGColor,"").
								&Font($FontFace,"1",$TextColor).
									$LogInfo[6].
								"</font>".
							"</td>".
							&Td("","","","","","","",$ColumnOddBGColor,"").
								&Font($FontFace,"1",$TextColor).
									$LogInfo[7].
								"</font>".
							"</td>".
							&Td("","","","","","","",$ColumnEvenBGColor,"").
								&Font($FontFace,"1",$TextColor).
									$LogInfo[8].
								"</font>".
							"</td>".
							&Td("","","","","","","",$ColumnOddBGColor,"").
								&Font($FontFace,"1",$TextColor).
									$LogInfo[9].
								"</font>".
							"</td>".
						"</tr>";
			if ($RowColor eq $RowEvenBGColor) {
				$RowColor=$RowOddBGColor;
			}else{
				$RowColor=$RowEvenBGColor;
			}
		}
        $HTML.=		    &Tr("","",$MenuBGColor).
							&Td("","",$ColSpan,"","RIGHT","","","","").
								&PrintVersion().
							"</td>".
						"</tr>".
					"</table></td></tr></table>".
					"<p>";
	}elsif ($in{'Type'} eq "AdminLog") {
		$ColSpan=6;
		open(LOG,"$StatsPath/Admin.log");
			flock(LOG,2) if ($FLock);
			my (@Actions)=<LOG>;
		close(LOG);
		$HTML.=		&BTable($TableWidth,$TableAlign,"0","0",$TableCellSpacing,$TableCellPadding,$TableBorderColor,"","").
						&Tr("","",$HeaderBGColor).
							&Td("","","8","","","","","","").
								&Font($FontFace,$HeaderTextSize,$HeaderTextColor).
									"<b>LAST $MaxActionLog ADMINISTRATOR ACTIONS</b>".
								"</font>".
							"</td>".
						"</tr>".
						&Tr("","",$HeaderBGColor).
							&Td("","","","","","","","","").
								&Font($FontFace,$HeaderTextSize,$HeaderTextColor).
									"<b>DATE</b>".
								"</font>".
							"</td>".
							&Td("","","","","","","","","").
								&Font($FontFace,$HeaderTextSize,$HeaderTextColor).
									"<b>HOST</b>".
								"</font>".
							"</td>".
                            &Td("","","","","","","","","").
								&Font($FontFace,$HeaderTextSize,$HeaderTextColor).
									"<b>IP</b>".
								"</font>".
							"</td>".
							&Td("","","","","","","","","").
								&Font($FontFace,$HeaderTextSize,$HeaderTextColor).
									"<b>ACTION</b>".
								"</font>".
							"</td>".
							&Td("","","","","","","","","").
								&Font($FontFace,$HeaderTextSize,$HeaderTextColor).
									"<b>USERNAME</b>".
								"</font>".
							"</td>".
						"</tr>";
        $RowColor=$RowOddBGColor;
		for ($n=$#Actions;$n>=0;$n--) {
			@LogInfo=split(/\|\^\|/,$Actions[$n]);
			$HTML.=		&Tr("","",$RowColor).
							&Td("","","","","","","",$ColumnOddBGColor,"").
								&Font($FontFace,"1",$TextColor).
									$LogInfo[0].
								"</font>".
							"</td>".
							&Td("","","","","","","",$ColumnEvenBGColor,"").
								&Font($FontFace,"1",$TextColor).
									$LogInfo[2].
								"</font>".
							"</td>".
                            &Td("","","","","","","",$ColumnOddBGColor,"").
								&Font($FontFace,"1",$TextColor).
									$LogInfo[1].
								"</font>".
							"</td>".
							&Td("","","","","","","",$ColumnEvenBGColor,"").
								&Font($FontFace,"1",$TextColor).
									$LogInfo[4].
								"</font>".
							"</td>".
							&Td("","","","","","","",$ColumnOddBGColor,"").
								&Font($FontFace,"1",$TextColor).
									$LogInfo[5].
								"</font>".
							"</td>".
						"</tr>";
			if ($RowColor eq $RowEvenBGColor) {
				$RowColor=$RowOddBGColor;
			}else{
				$RowColor=$RowEvenBGColor;
			}
		}
        $HTML.=		    &Tr("","",$MenuBGColor).
							&Td("","",$ColSpan,"","RIGHT","","","","").
								&PrintVersion().
							"</td>".
						"</tr>".
					"</table></td></tr></table>".
					"<p>";
	}else{
		$ColSpan=4;
		###############################################################################
		# Process Referers
			open(REFERER,"$StatsPath/Referers.log");
				flock(REFERER,2) if ($FLock);
				my (@RefURLs)=<REFERER>;
			close(REFERER);
			$TotalHits=0;
			for ($n=0;$n<=$#RefURLs;$n++) {
				($RefURL,$Value)=split(/\|\^\|/,$RefURLs[$n]);
				$Sort{$n}=$Value;
				$ReferURL[$n]=$RefURL;
				$ReferValue[$n]=$Value;
				$TotalHits+=$Value;
			}
			@SortedList = reverse sort{$Sort{$a} <=> $Sort{$b}} keys %Sort;
			###########################################################################
			# Print Top 20 Referers URL
			$HTML.=		&BTable($TableWidth,$TableAlign,"0","0",$TableCellSpacing,$TableCellPadding,$TableBorderColor,"","").
							&Tr("","",$HeaderBGColor).
								&Td("","","3","","","","","","").
									&Font($FontFace,$HeaderTextSize,$HeaderTextColor).
										"<b>TOP 20 REFFERING URLS</b>".
									"</font>".
								"</td>".
							"</tr>";
			$EndRef=scalar(@SortedList);
			$EndRef=20 if ($EndRef>20);
			$RowColor=$RowOddBGColor;
			for ($n=0;$n<$EndRef;$n++) {
				$TotalPercent=&ceil(($ReferValue[$SortedList[$n]]/$TotalHits)*10000)/100;
				$LengthURL=length($ReferURL[$SortedList[$n]]);
				$ReferURL=$ReferURL[$SortedList[$n]];
				if ($LengthURL >= 70) {
					$ReferURL=substr ($ReferURL[$SortedList[$n]],0,35)."...".substr ($ReferURL[$SortedList[$n]],$LengthURL-35,35);
				}
				$HTML.=		&Tr("","",$RowColor).
								&Td("10%","","","","CENTER","","",$ColumnOddBGColor,"").
									&Font($FontFace,$TextSize,$TextColor).
										$ReferValue[$SortedList[$n]].
									"</font>".
								"</td>".
								&Td("10%","","","","CENTER","","",$ColumnEvenBGColor,"").
									&Font($FontFace,$TextSize,$TextColor).
										$TotalPercent."%".
									"</font>".
								"</td>".
								&Td("80%","","","","","","",$ColumnOddBGColor,"").
									&Font($FontFace,$TextSize,$TextColor).
										&Link($ReferURL[$SortedList[$n]],"_blank",$ReferURL[$n]).
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
							&Td("","","3","","RIGHT","","","","").
								&Font($FontFace,$MenuTextSize,$MenuTextColor).
									&Link("UBAdmin.$Ext?Action=ShowStats&Type=TopReferURL&Session=$SessionID","","").
										"more...".
									"</a>".
								"</font>".
							"</td>".
						"</tr>".
					"</table></td></tr></table>".
					"<p>";
		###############################################################################
		# Process Days Hits	
			open(HITS,"$StatsPath/Days.hits");
				flock(HITS,2) if ($FLock);
				my (@Hits)=<HITS>;
			close(HITS);
			open(CDATE,"$StatsPath/CDate.dat");
				flock(CDATE,2) if ($FLock);
				my ($CurrentDate)=<CDATE>;
			close(CDATE);
			open(HITS,"$StatsPath/Today.hits");
				flock(HITS,2) if ($FLock);
				my ($TodayHits)=<HITS>;
			close(HITS);
			$LastDay=scalar(@Hits);
			if ($LastDay>19) {
				$LastDay-=19;
			}else{
				$LastDay=0;
			}
			$Max=0;
			$TotalHits=0;
			@Day=();
			@DayHit=();
			if ($CurrentDate) {
				push (@Day, $CurrentDate);
				push (@DayHit, $TodayHits);
				$Max=$TodayHits if ($Max<$TodayHits);
				$TotalHits+=$TodayHits;
			}
			for ($n=$#Hits;$n>=$LastDay;$n--) {
				@DayInfo=split(/\|\^\|/,$Hits[$n]);
				push (@Day, $DayInfo[0]);
				push (@DayHit, $DayInfo[1]);
				$Max=$DayInfo[1] if ($Max<$DayInfo[1]);
				$TotalHits+=$DayInfo[1];
			}
			###########################################################################
			# Print Last 20 Days Hits
			$HTML.=		&BTable($TableWidth,$TableAlign,"0","0",$TableCellSpacing,$TableCellPadding,$TableBorderColor,"","").
							&Tr("","",$HeaderBGColor).
								&Td("","","4","","","","","","").
									&Font($FontFace,$HeaderTextSize,$HeaderTextColor).
										"<b>HITS FROM THE LAST 20 DAYS</b>".
									"</font>".
								"</td>".
							"</tr>";
			$RowColor=$RowOddBGColor;
			for ($n=0;$n<scalar(@Day);$n++) {
				$Percentage=&ceil(($DayHit[$n]/$Max)*100);
				$TotalPercent=&ceil(($DayHit[$n]/$TotalHits)*10000)/100;
				$HTML.=		&Tr("","",$RowColor).
								&Td("20%","","","","","","",$ColumnOddBGColor,"").
									&Font($FontFace,$TextSize,$TextColor).
										$Day[$n].
									"</font>".
								"</td>".
								&Td("10%","","","","CENTER","","",$ColumnEvenBGColor,"").
									&Font($FontFace,$TextSize,$TextColor).
										$DayHit[$n].
									"</font>".
								"</td>".
								&Td("10%","","","","CENTER","","",$ColumnOddBGColor,"").
									&Font($FontFace,$TextSize,$TextColor).
										$TotalPercent."%".
									"</font>".
								"</td>".
								&Td("60%","","","","","","",$ColumnEvenBGColor,"").
									&Font($FontFace,$TextSize,$TextColor).
										&Image("$URLImages/Bar.gif","$Percentage%","16","","","0","$DayHit[$n] ($TotalPercent%)").
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
							&Td("","","4","","RIGHT","","","","").
								&Font($FontFace,$MenuTextSize,$MenuTextColor).
									&Link("UBAdmin.$Ext?Action=ShowStats&Type=Days&Sort=Date&Session=$SessionID","","").
										"more...".
									"</a>".
								"</font>".
							"</td>".
						"</tr>".
					"</table></td></tr></table>".
					"<p>";
		###############################################################################
		# Process Hours Hits	
			open(HITS,"$StatsPath/Day.hits");
				flock(HITS,2) if ($FLock);
				my (@Hits)=<HITS>;
			close(HITS);
			chomp(@Day);
			$Max=1;
			$TotalHits=0;
			for (0..23) {
				if ($Hits[$_]) {
					($Hour,$Value)=split(/\|\^\|/, $Hits[$_]);
					$Day{$Hour}=$Value;
					$Max=$Value if ($Max<$Value);
					$TotalHits+=$Value;
				}else{
					$Day{$_}=0;
				}
			}
			$TotalHits=1 if ($TotalHits==0);
			###########################################################################
			# Print Hours Hits
			$HTML.=		&BTable($TableWidth,$TableAlign,"0","0",$TableCellSpacing,$TableCellPadding,$TableBorderColor,"","").
							&Tr("","",$HeaderBGColor).
								&Td("","","4","","","","","","").
									&Font($FontFace,$HeaderTextSize,$HeaderTextColor).
										"<b>HITS BY THE HOUR</b>".
									"</font>".
								"</td>".
							"</tr>";
            $RowColor=$RowOddBGColor;
			for (0..23) {
				$Percentage=&ceil(($Day{$_}/$Max)*100);
				$TotalPercent=&ceil(($Day{$_}/$TotalHits)*10000)/100;
				if ($_<10) {
					$Hour="0".$_.":00 - 0".$_.":59";
				}else{
					$Hour=$_.":00 - ".$_.":59";
				}
				$HTML.=		&Tr("","",$RowColor).
								&Td("20%","","","","","","",$ColumnOddBGColor,"").
									&Font($FontFace,$TextSize,$TextColor).
										$Hour.
									"</font>".
								"</td>".
								&Td("10%","","","","CENTER","","",$ColumnEvenBGColor,"").
									&Font($FontFace,$TextSize,$TextColor).
										$Day{$_}.
									"</font>".
								"</td>".
								&Td("10%","","","","CENTER","","",$ColumnOddBGColor,"").
									&Font($FontFace,$TextSize,$TextColor).
										$TotalPercent."%".
									"</font>".
								"</td>".
								&Td("60%","","","","","","",$ColumnEvenBGColor,"").
									&Font($FontFace,$TextSize,$TextColor).
										&Image("$URLImages/Bar.gif","$Percentage%","16","","","0","$Hour -".$Day{$_}." ($TotalPercent%)").
									"</font>".
								"</td>".
							"</tr>";
				if ($RowColor eq $RowEvenBGColor) {
					$RowColor=$RowOddBGColor;
				}else{
					$RowColor=$RowEvenBGColor;
				}
			}
			$HTML.=	"</table></td></tr></table>".
					"<p>";
		###############################################################################
		# Process Days Hits	
			my (@Days) = ("Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday");
			open(HITS,"$StatsPath/Week.hits");
				flock(HITS,2) if ($FLock);
				my (@Hits)=<HITS>;
			close(HITS);
			chomp(@Hits);
			$Max=1;
			$TotalHits=0;
			for (0..6) {
				if ($Hits[$_]) {
					($Day,$Value)=split(/\|\^\|/, $Hits[$_]);
					$Week{$Day}=$Value;
					$Max=$Value if ($Max<$Value);
					$TotalHits+=$Value;
				}else{
					$Week{$_}=0;
				}
			}
			$TotalHits=1 if ($TotalHits==0);
			###########################################################################
			# Print Days Hits
			$HTML.=		&BTable($TableWidth,$TableAlign,"0","0",$TableCellSpacing,$TableCellPadding,$TableBorderColor,"","").
							&Tr("","",$HeaderBGColor).
								&Td("","","4","","","","","","").
									&Font($FontFace,$HeaderTextSize,$HeaderTextColor).
										"<b>HITS BY DAY OF THE WEEK</b>".
									"</font>".
								"</td>".
							"</tr>";
            $RowColor=$RowOddBGColor;
			for (0..6) {
				$Percentage=&ceil(($Week{$_}/$Max)*100);
				$TotalPercent=&ceil(($Week{$_}/$TotalHits)*10000)/100;
				$HTML.=		&Tr("","",$RowColor).
								&Td("20%","","","","","","",$ColumnOddBGColor,"").
									&Font($FontFace,$TextSize,$TextColor).
										$Days[$_].
									"</font>".
								"</td>".
								&Td("10%","","","","CENTER","","",$ColumnEvenBGColor,"").
									&Font($FontFace,$TextSize,$TextColor).
										$Week{$_}.
									"</font>".
								"</td>".
								&Td("10%","","","","CENTER","","",$ColumnOddBGColor,"").
									&Font($FontFace,$TextSize,$TextColor).
										$TotalPercent."%".
									"</font>".
								"</td>".
								&Td("60%","","","","","","",$ColumnEvenBGColor,"").
									&Font($FontFace,$TextSize,$TextColor).
										&Image("$URLImages/Bar.gif","$Percentage%","16","","","0",$Days[$_]." - ".$Week{$_}."  ($TotalPercent%)").
									"</font>".
								"</td>".
							"</tr>";
				if ($RowColor eq $RowEvenBGColor) {
					$RowColor=$RowOddBGColor;
				}else{
					$RowColor=$RowEvenBGColor;
				}
			}
			$HTML.=	"</table></td></tr></table>".
					"<p>";
		###############################################################################
		# Process Browsers
			%Sort=();
			open(HITS,"$StatsPath/Browsers.hits");
				flock(HITS,2) if ($FLock);
				my (@Browsers)=<HITS>;
			close(HITS);
			$Max=0;
			$TotalHits=0;
			for ($n=0;$n<=$#Browsers;$n++) {
				($Browser,$Value)=split(/\|\^\|/,$Browsers[$n]);
				$Sort{$n}=$Value;
				$BrowserName[$n]=$Browser;
				$BrowserHits[$n]=$Value;
				$Max=$Value if ($Max<$Value);
				$TotalHits+=$Value;
			}
			@SortedList = reverse sort{$Sort{$a} <=> $Sort{$b}} keys %Sort;
			###########################################################################
			# Print Top Browsers
			$HTML.=		&BTable($TableWidth,$TableAlign,"0","0",$TableCellSpacing,$TableCellPadding,$TableBorderColor,"","").
							&Tr("","",$HeaderBGColor).
								&Td("","","4","","","","","","").
									&Font($FontFace,$HeaderTextSize,$HeaderTextColor).
										"<b>TOP BROWSERS</b>".
									"</font>".
								"</td>".
							"</tr>";
			$RowColor=$RowOddBGColor;
			for ($n=0;$n<scalar(@SortedList);$n++) {
				$BrowserName[$SortedList[$n]]=~s/\_/ /g;
				$Percentage=int(($BrowserHits[$SortedList[$n]]/$Max)*100);
				$TotalPercent=int(($BrowserHits[$SortedList[$n]]/$TotalHits)*10000)/100;
				$HTML.=		&Tr("","",$RowColor).
								&Td("20%","","","","","","",$ColumnOddBGColor,"").
									&Font($FontFace,$TextSize,$TextColor).
										$BrowserName[$SortedList[$n]].
									"</font>".
								"</td>".
								&Td("10%","","","","CENTER","","",$ColumnEvenBGColor,"").
									&Font($FontFace,$TextSize,$TextColor).
										$BrowserHits[$SortedList[$n]].
									"</font>".
								"</td>".
								&Td("10%","","","","CENTER","","",$ColumnOddBGColor,"").
									&Font($FontFace,$TextSize,$TextColor).
										$TotalPercent."%".
									"</font>".
								"</td>".
								&Td("60%","","","","","","",$ColumnEvenBGColor,"").
									&Font($FontFace,$TextSize,$TextColor).
										&Image("$URLImages/Bar.gif","$Percentage%","16","","","0",$BrowserName[$SortedList[$n]]." - ".$BrowserHits[$SortedList[$n]]." ($TotalPercent%)").
									"</font>".
								"</td>".
							"</tr>";
			}
			$HTML.=		&Tr("","",$MenuBGColor).
							&Td("","",$ColSpan,"","RIGHT","","","","").
								&PrintVersion().
							"</td>".
						"</tr>".
					"</table></td></tr></table>".
					"<p>";
	}
	&PrintTheme("$UBName Administrative Center - View Stats",$HTML);
	exit;
}
###############################################################################
1;# End of ShowStats Function
###############################################################################