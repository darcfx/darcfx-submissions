###############################################################################
# ShowBoard.pl                                                                #
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
# ShowBoard                                                                   #
###############################################################################
sub ShowBoard {
    #use POSIX qw(&ceil);
	if ($DisplayFront eq "") {
		print "Location: $URLSite\n\n";
		exit;
	}
	my ($HTML, $Menu, $List);
	$ColSpan=4;

	unless (-e "$DBPath/$in{'Board'}/board.list") {
		&ShowError("ACCESS DENIED","The board that you want access is not found.<br>Please contact the webmaster (".&Link("mailto:$EmailAddress","","").$EmailAddress."</a>".") for more information.");
	}

	open(BOARD,"$DBPath/$in{'Board'}/board.list")||&CGIError("Couldn't open/read the board.list file<br>\nPath: $DBPath/$in{'Board'}<br>\nReason : $!");
		flock(BOARD,1) if ($FLock);
		@BOARD_DATA=<BOARD>;
	close(BOARD);
	@BoardInfo=&DecodeDBOutput($BOARD_DATA[0]);
	if ($Group ne "administrator") {
		if ($BoardInfo[5] ne "Active") {
			&ShowError("ACCESS DENIED","The \"$BoardInfo[1]\" board is currently inactive.<br>Please contact the webmaster (".&Link("mailto:$EmailAddress","","").$EmailAddress."</a>".") for more information.");
		}
		if (($BoardInfo[6] eq "Private")&&($Group eq "Guest")) {
			print "Location: UltraBoard.$Ext?Action=SignIn&Ref=ShowBoard&Board=$in{'Board'}&Idle=$in{'Idle'}&Sort=$in{'Sort'}&Order=$in{'Order'}&Page=$in{'Page'}\n\n";
		}elsif ($BoardInfo[6] eq "Private") {
			require "$DBPath/$in{'Board'}/Access.db";
			if (!exists ($Access{$MemberData[3]})) {
				print "Location: UltraBoard.$Ext?Action=SignIn&Ref=ShowBoard&Board=$in{'Board'}&Idle=$in{'Idle'}&Sort=$in{'Sort'}&Order=$in{'Order'}&Page=$in{'Page'}\n\n";
			}else{
                $MemberStatus=$Access{$MemberData[3]};
            }
		}
	}
###############################################################################
# sort messages
    &GetCookies();
    $NowTime=time;
    if ($in{'Idle'} eq "") {
        if ($Cookies{'Idle'} ne "") {
            $in{'Idle'}=$Cookies{'Idle'};
        } else {
            $in{'Idle'}=$ShowTopics;
        }
    }
    if ($in{'Sort'} eq "") {
        if ($Cookies{'Sort'} ne "") {
            $in{'Sort'}=$Cookies{'Sort'};
        } else {
            $in{'Sort'}=$SortTopics;
        }
    }
    if ($in{'Order'} eq "") {
        if ($Cookies{'Order'} ne "") {
            $in{'Order'}=$Cookies{'Order'};
        } else {
            $in{'Order'}=$SortOrder;
        }
    }
    %PostID={};
    if ($in{'Idle'} eq "0") {
        for (my ($db)=1;$db<=$#BOARD_DATA;$db++) {
            @PostInfo=&DecodeDBOutput($BOARD_DATA[$db]);
			if (($PostInfo[5]) && (!$PostInfo[4])) {
				$PostInfo[4]=(&GetMemberData($PostInfo[5]))[1];
			}
			$PostID{$PostInfo[1]}=join($Spliter,@PostInfo);
			$SortField{$PostInfo[1]}=lc($PostInfo[$in{'Sort'}]);
            #$PostID{$PostInfo[1]}=$BOARD_DATA[$db];
        }
    }else{
        $IdleTime=86400*$in{'Idle'};
        for (my ($db)=1;$db<=$#BOARD_DATA;$db++) {
            @PostInfo=&DecodeDBOutput($BOARD_DATA[$db]);
            if (($PostInfo[0]+$IdleTime)>$NowTime) {
				if (($PostInfo[5]) && (!$PostInfo[4])) {
					$PostInfo[4]=(&GetMemberData($PostInfo[5]))[1];
				}
                $PostID{$PostInfo[1]}=join($Spliter,@PostInfo);
                $SortField{$PostInfo[1]}=lc($PostInfo[$in{'Sort'}]);
            }
        }
    }
	if ($in{'Order'} eq "Ascend") {
		$Sort{$in{'Sort'}}=&Image("$URLImages/SortAscend.gif","","","","","0","");
		if (($in{'Sort'} eq "2")||($in{'Sort'} eq "0")) {
			@SortedList=sort{$SortField{$a} <=> $SortField{$b}} keys %SortField;
		}else{
			@SortedList=sort{$SortField{$a} cmp $SortField{$b}} keys %SortField;
		}
    }else{
		$Sort{$in{'Sort'}}=&Image("$URLImages/SortDescend.gif","","","","","0","");
		if (($in{'Sort'} eq "2")||($in{'Sort'} eq "0")) {
			@SortedList=sort{$SortField{$b} <=> $SortField{$a}} keys %SortField;
		}else{
			@SortedList=sort{$SortField{$b} cmp $SortField{$a}} keys %SortField;
		}
    }
###############################################################################
	$Title.=&Td("","","","","","","","","").&Font($FontFace,$HeaderTextSize,$HeaderTextColor)."<b>TOPIC</b>$Sort{'1'}"."</font>"."</td>".
			&Td("","","","","","","","","").&Font($FontFace,$HeaderTextSize,$HeaderTextColor)."<b>ORIGINATOR</b>$Sort{'5'}"."</font>"."</td>".
			&Td("","","","","","","","","").&Font($FontFace,$HeaderTextSize,$HeaderTextColor)."<center><b>REPLIES</b>$Sort{'2'}</center>"."</font>"."</td>".
			&Td("","","","","","","","","").&Font($FontFace,$HeaderTextSize,$HeaderTextColor)."<b>LAST MODIFIED</b>$Sort{'0'}"."</font>"."</td>";
###############################################################################
# list messages
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
    if (!$in{'Page'}) {
        $in{'Page'}=0;
    }
	$RowColor=$RowOddBGColor;
    $FirstPost=$NumPage*$in{'Page'};
    $LastPost=$NumPage*$in{'Page'}+$NumPage;
    if ($LastPost > ($#SortedList+1)) {
        $LastPost=$#SortedList+1;
    }
    for (my ($i)=$FirstPost;$i<$LastPost;$i++) {
        @PostInfo=&DecodeDBOutput($PostID{$SortedList[$i]});
        if ($Cookies{"B_".$in{'Board'}."_TIME"}<$PostInfo[0]) {
            $NewIcon=&Image("$URLImages/New.gif","","","","","0","");
			$MessageStatus="This topic is new since you last visited.";
        }else{
            $NewIcon="";
			$MessageStatus="You have read this topic.";
        }

        $MessageIcon=&Image("$URLImages/Message.gif","","","","","0",$PostInfo[7]);   
        if ($PostInfo[6] ne ""){
            $MessageIcon=&Image("$URLImages/LockedMessage.gif","","","","","0",$PostInfo[7]);
			$MessageStatus="This topic has been closed!";
        }elsif ($PostInfo[8]) {
            $MessageIcon=&Image($TopicIcon{$PostInfo[8]},"","","","","0",$PostInfo[7]);  
        }
		$List.=	&Tr("","",$RowColor).
					&Td("40%","","","","","","",$ColumnOddBGColor,"").
                        &Table("100%","CENTER","0","0","","").
                            &Tr("","","").
                                &Td("20","","","","","","","","").
                                    &Link("UltraBoard.$Ext?Action=ShowPost&Board=$in{'Board'}&Post=$PostInfo[1]&Idle=$in{'Idle'}&Sort=$in{'Sort'}&Order=$in{'Order'}&Page=$in{'Page'}&Session=$SessionID",
										"",$PostInfo[7],
										"$MessageStatus").
                                        $MessageIcon.
                                    "</a>".
                                "</td>".
                                &Td("100%","","","","","","","","").
                                    &Font($FontFace,$TextSize,$TextColor)." ".
                                    &Link("UltraBoard.$Ext?Action=ShowPost&Board=$in{'Board'}&Post=$PostInfo[1]&Idle=$in{'Idle'}&Sort=$in{'Sort'}&Order=$in{'Order'}&Page=$in{'Page'}&Session=$SessionID",
										"",$PostInfo[7],
										"Read this ($PostInfo[3]) topic.").
                                        "<b>$PostInfo[3]</b>".
                                    "</a>".
                                    " ".$NewIcon.
                                    "</font>".
                                "</td>".
                            "</tr>".
                        "</table>".
					"</td>".
					&Td("25%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor);
		if ($PostInfo[5]) {
			$List.=	&Link("UltraBoard.$Ext?Action=ShowProfile&ID=$PostInfo[5]&Board=$in{'Board'}&Idle=$in{'Idle'}&Sort=$in{'Sort'}&Order=$in{'Order'}&Page=$in{'Page'}&Session=$SessionID","Profile","",
						"View $PostInfo[4] ($PostInfo[5]) Profile.").
						$PostInfo[4].
					"</a>";
		}else{
			$List.=	$PostInfo[4];
		}
		$List.=			"</font>".
					"</td>".
					&Td("5%","","","","","","",$ColumnOddBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"<center>".$PostInfo[2]."</center>".
						"</font>".
					"</td>".
					&Td("30%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							&GetDate($PostInfo[0],$DateTextColor,$TimeTextColor,$DateTextSize,$TimeTextSize).
						"</font>".
					"</td>".
				"</tr>";
        if ($RowColor eq $RowEvenBGColor) {
            $RowColor=$RowOddBGColor;
        }else{
            $RowColor=$RowEvenBGColor;
        }
    }
###############################################################################
# check is it more page.
    $NumOfPage=&ceil(($#SortedList+1)/$NumPage);
    $Position.= &Tr("","",$MenuBGColor).
					&Td("","",$ColSpan,"","","","","","").
                        &Table("100%","CENTER","0","0","","").
                            &Tr("","","").
                                &Td("20%","","","","","","","","");
    if ($in{'Page'}+1>1) {
        $Position.=                 &Link("UltraBoard.$Ext?Action=ShowBoard&Board=$in{'Board'}&Idle=$in{'Idle'}&Sort=$in{'Sort'}&Order=$in{'Order'}&Page=".($in{'Page'}-1)."&Session=$SessionID","","").
                                        $imgPrevious.
                                    "</a>";
        $MorePage=1;
    }
    $Position.=                 "</td>".&Td("60%","","","","CENTER","","","","").&Font($FontFace,$MenuTextSize,$MenuTextColor);
    $FirstNumPage=int($in{'Page'}/10)*10;
    $LastNumPage=$FirstNumPage+10;
    if ($LastNumPage>$NumOfPage) {
        $LastNumPage=$NumOfPage;
    }
    if ($FirstNumPage>=10) {
        $Position.= &Link("UltraBoard.$Ext?Action=ShowBoard&Board=$in{'Board'}&Idle=$in{'Idle'}&Sort=$in{'Sort'}&Order=$in{'Order'}&Page=".($FirstNumPage-1)."&Session=$SessionID","","").
                        "..".
                    "</a>"." ";
    }
    for (my ($p)=$FirstNumPage;$p<$LastNumPage;$p++) {
        if ($p != $in{'Page'}) {
            $Position.= &Link("UltraBoard.$Ext?Action=ShowBoard&Board=$in{'Board'}&Idle=$in{'Idle'}&Sort=$in{'Sort'}&Order=$in{'Order'}&Page=".$p."&Session=$SessionID","","").
                            ($p+1).
                        "</a>"." ";
        }else{
            $Position.= "<b>".($p+1)."</b> ";
        }
    }
    if ($LastNumPage<$NumOfPage) {
        $Position.= &Link("UltraBoard.$Ext?Action=ShowBoard&Board=$in{'Board'}&Idle=$in{'Idle'}&Sort=$in{'Sort'}&Order=$in{'Order'}&Page=".$LastNumPage."&Session=$SessionID","","").
                        "..".
                    "</a>";
    }
    $Position.=                 "</font>"."</td>".&Td("20%","","","","RIGHT","","","","");
    if ($in{'Page'}+1<$NumOfPage) {
        $Position.=                 &Link("UltraBoard.$Ext?Action=ShowBoard&Board=$in{'Board'}&Idle=$in{'Idle'}&Sort=$in{'Sort'}&Order=$in{'Order'}&Page=".($in{'Page'}+1)."&Session=$SessionID","","").
                                        $imgNext.
                                    "</a>";
        $MorePage=1;
    }
    $Position.=                 "</td>".
                            "</tr>".
                        "</table>".
                 	"</td>".
				"</tr>";
###############################################################################
    if ($Group ne "Guest") {
        $Greeting="Hi ".$MemberData[1]."! ";
    }
    if ($Cookies{"B_".$in{'Board'}."_TIME"} ne "") {
        $LastVisited="You last visited on ".&GetDate($Cookies{"B_".$in{'Board'}."_TIME"},"","","","");
    }
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
								"<b>Home</b>".
							"</a>";
	if ($UseCategory) {
		$HTML.=				" <b>/ </b>".
							&Link("UltraBoard.$Ext?Action=ShowCategory&Category=$CategoryInfo[0]&Idle=$in{'Idle'}&Sort=$in{'Sort'}&Order=$in{'Order'}&Page=$in{'Page'}&Session=$SessionID","","",
								"View this ($CategoryInfo[1]) category.").
								"<b>$CategoryInfo[1]</b>".
							"</a>";
	}			
	$HTML.=					" <b>/ </b>".
							"<b>".$BoardInfo[1]."</b>".
						"</font>".
					"</td>".
				"</tr>";
    if ($Greeting or $LastVisited) {
        $HTML.=     &Tr("","",$MenuBGColor).
                        &Td("","","","","","","","","").
                            &Font($FontFace,$MenuTextSize,$MenuTextColor).
                                $Greeting.$LastVisited.
                            "</font>".
                        "</td>".
                    "</tr>";
    }
    $HTML.=     &Tr("","",$RowOddBGColor).
			        &Td("","","","","","","","","");
    if ($BoardInfo[2] ne "") {
        $HTML.=         &Font($FontFace,$BoardDesTextSize,$TextColor).
					    	$BoardInfo[2].
					    "</font>";
    }
	$HTML.= 		    "<p>".
                        &Table("100%","CENTER","0","0","","").
                            &Tr("","","").
                                &Td("","","","","","","","","").
                                    &Font($FontFace,$BoardDesTextSize,$TextColor).
                                        $BoardInfo[6]." Board".
                                    "</font>".
                                "</td>".
                                &Td("","","","","RIGHT","","","","").
                                    &Font($FontFace,$BoardDesTextSize,$TextColor);
    if ($Group eq "administrator") {
        $HTML.="Full Access";
    }elsif ($Group eq "Guest") {
        if ($BoardInfo[6] ne "Public") {
            $HTML.="Read Only";
        }else{
            $HTML.="Full Access";
        }
    }else{
        if (($BoardInfo[6] eq "Protected")||($BoardInfo[6] eq "Public")) {
            $HTML.="Full Access";
        }else{
            if ($Access{$MemberData[3]}) {
                if ($Access{$MemberData[3]} eq "FullAccess") {
                    $HTML.="Full Access";
                }else{
                    $HTML.="Read Only";
                }
            }
        }
    }
    $HTML.=	     					"</font>".
                                "</td>".
                            "</tr>".
                        "</table>".
                      "</td>".
                "</tr>".
	    	"</table></td></tr></table>".
            &Table($TableWidth,$TableAlign,"","6","","").
                &Tr("","","").
					&Td("","","","","","","nowrap","","").
						&Form("UltraBoard.$Ext","GET","","").
                        &HiddenBox("Action","ShowBoard").
                        &HiddenBox("Board",$in{'Board'}).
                        &HiddenBox("Page",$in{'Page'}).
                        &HiddenBox("Session",$SessionID).
			       "</td>".
				"</tr>".
				&Tr("","","").
					&Td("","","","","","","","","").
						"<center>".
                        &Select("Idle","","","",$in{'Idle'},
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
                        &Select("Order","","","",$in{'Order'},
                                "sorted in ascending order","Ascend",
                                "sorted in descending order","Descend",
                               ).
                        &Select("Sort","","","",$in{'Sort'},
                                "topic","3",
                                "originator","5",
                                "replies","2",
                                "last modified","0",
                               ).
                        &Submit("","LIST","","").
                        "</center>".
					"</td>".
				"</tr>".
                &Tr("","","").
					&Td("","","","","","","nowrap","","").
						"</form>".
					"</td>".
				"</tr>".
			"</table>".
			&BTable($TableWidth,$TableAlign,"0","0",$TableCellSpacing,$TableCellPadding,$TableBorderColor,"","").
				&Tr("","",$HeaderBGColor).
					$Title.
				"</tr>".
				$List.
                $Position.
				&Tr("","",$MenuBGColor).
					&Td("","",$ColSpan,"","","","","","").
						&PrintVersion("YES").
					"</td>".
				"</tr>".
			"</table></td></tr></table>".
            &GetBoardList();
###############################################################################
    if ($Cookies{"B_".$in{'Board'}."_TIME"}+3600<$NowTime) {
        open(COUNT,"$DBPath/$in{'Board'}/board.count")||&CGIError("Couldn't open/read the board.count file<br>\nPath: $DBPath/$in{'Board'}<br>\nReason : $!");
            flock(COUNT,1) if ($FLock);
            @COUNT_DATA=&DecodeDBOutput(<COUNT>);
        close(COUNT);
        print &CookiesHeader($NowTime+31536000,"B_".$in{'Board'}."_TIME",$NowTime,"B_".$in{'Board'}."_POST",$COUNT_DATA[2]);
    }
###############################################################################
	&PrintTheme("$UBName",$HTML);
	exit;
}
###############################################################################
1;# End of ShowBoard Function
###############################################################################