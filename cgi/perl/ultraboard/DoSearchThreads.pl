###############################################################################
# DoSearchThreads.pl                                                          #
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
# DoSearchThreads                                                             #
###############################################################################
sub DoSearchThreads {
	require "$LibPath/SearchMessages.lib";
	&SearchMessages();
	$HTML.=	"<p>".&BTable($TableWidth,$TableAlign,"0","0",$TableCellSpacing,$TableCellPadding,$TableBorderColor,"","").
				&Tr("","",$HeaderBGColor).
					&Td("","","5","","","","","","").
						&Font($FontFace,$HeaderTextSize,$HeaderTextColor).
							"<b>SEARCH THREADS (FOUND ".scalar(@SortedList)." THREADS)</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Topic</b>".
						"</font>".
					"</td>".
					&Td("","","","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Originator</b>".
						"</font>".
					"</td>".
					&Td("","","","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Board</b>".
						"</font>".
					"</td>".
					&Td("","","","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Last Modified</b>".
						"</font>".
					"</td>".
				"</tr>";
    $RowColor=$RowOddBGColor;
	for ($i=0;$i<=$#SortedList;$i++) {
        @PostInfo=&DecodeDBOutput($PostID[$SortedList[$i]]);
		if ($PostInfo[9] ne ""){
            $MessageIcon=&Image("$URLImages/LockedMessage.gif","","","","","0",$PostInfo[9]);
			$MessageStatus="This topic has been closed!";
        }elsif ($Cookies{"B_".$PostInfo[7]."_TIME"}<$PostInfo[0]) {
            $MessageIcon=&Image("$URLImages/NewMessage.gif","","","","","0",$PostInfo[9]);
			$MessageStatus="This topic is new since you last visited.";
        }else{
            $MessageIcon=&Image("$URLImages/OldMessage.gif","","","","","0",$PostInfo[9]);
			$MessageStatus="You have read this topic.";
        }
		$HTML.=	&Tr("","",$RowColor).
						&Td("36%","","","","","","",$ColumnOddBGColor,"").
							&Table("100%","CENTER","0","0","","").
                                &Tr("","","").
                                    &Td("20","","","","","","","","").
                                        &Link("UltraBoard.$Ext?Action=ShowPost&Board=$PostInfo[6]&Post=$PostInfo[8]&Idle=$in{'Idle'}&Sort=$in{'Sort'}&Order=$in{'Order'}&Page=$in{'Page'}&Session=$SessionID",
                                            "",$PostInfo[7],
                                            "$MessageStatus").
                                            $MessageIcon.
                                        "</a>".
                                    "</td>".
                                    &Td("100%","","","","","","","","").
                                        &Font($FontFace,$TextSize,$TextColor)." ".
                                        &Link("UltraBoard.$Ext?Action=ShowPost&Board=$PostInfo[6]&Post=$PostInfo[8]&Idle=$in{'Idle'}&Sort=$in{'Sort'}&Order=$in{'Order'}&Page=$in{'Page'}&Session=$SessionID",
                                            "",$PostInfo[7],
                                            "Read this ($PostInfo[0]) topic.").
                                            "<b>$PostInfo[0]</b>".
                                        "</a>".
                                        "</font>".
                                    "</td>".
                                "</tr>".
                            "</table>".
						"</td>".
						&Td("15%","","","","","","",$ColumnEvenBGColor,"").
							&Font($FontFace,$TextSize,$TextColor);
		if ($PostInfo[2]) {
			$HTML.=				&Link("UltraBoard.$Ext?Action=ShowProfile&ID=$PostInfo[2]&Board=$PostInfo[6]&Idle=$in{'Idle'}&Sort=$in{'Sort'}&Order=$in{'Order'}&Page=$in{'Page'}&Session=$SessionID","Profile","",
									"View $PostInfo[1] ($PostInfo[2]) Profile.").
									$PostInfo[1].
								"</a>";
		}else{
			$HTML.=				$PostInfo[1];
		}
		$HTML.=				"</font>".
						"</td>".
						&Td("25%","","","","","","",$ColumnOddBGColor,"").
							&Font($FontFace,$TextSize,$TextColor).
								&Link("UltraBoard.$Ext?Action=ShowBoard&Board=$PostInfo[6]&Idle=$in{'Idle'}&Sort=$in{'Sort'}&Order=$in{'Order'}&Session=$SessionID","","",
									"Visit this ($PostInfo[7]) board.").
									$PostInfo[7].
								"</a>".
							"</font>".
						"</td>".
						&Td("24%","","","","","","",$ColumnEvenBGColor,"").
							&Font($FontFace,$TextSize,$TextColor).
								&GetDate($PostInfo[5],$DateTextColor,$TimeTextColor,$DateTextSize,$TimeTextSize).
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
					&Td("","","5","","","","","","").
						&PrintVersion("YES").
					"</td>".
				"</tr>".
			"</table></td></tr></table>".
			&GetBoardList();
	&PrintTheme("$UBName - Search Threads (Found ".scalar(@SortedList)." Threads)",$HTML);
	exit;
}
###############################################################################
1;# End of DoSearchThreads Function
###############################################################################