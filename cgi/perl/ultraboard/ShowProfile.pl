###############################################################################
# ShowProfile.pl                                                              #
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
# ShowProfile                                                                 #
###############################################################################
sub ShowProfile {
    $in{'ID'}=lc($in{'ID'});
    unless (-e "$MembersPath/$in{'ID'}.info") {
        &ShowError("FILE PROBLEM","The \"$in{'ID'}\" Profile is not found.<br>Please contact the webmaster (".&Link("mailto:$EmailAddress","","").$EmailAddress."</a>".") for more information.");
    }
    @MemberInfo=&GetMemberData($in{'ID'});
    $AccountName=uc($MemberInfo[0]);
    $NickName=uc($MemberInfo[1]);
    open(GROUP,"$MembersPath/Groups.db")||&CGIError("Couldn't open/read the Groups.db file<br>\nPath: $MembersPath<br>\nReason : $!");
		flock(GROUP,1) if ($FLock);
		while (<GROUP>) {
            @Group=&DecodeDBOutput($_);
            if ($MemberInfo[3] eq $Group[0]) {
                $Status=$Group[1];
                last;
            }
		}
	close(GROUP);
###############################################################################
	$HTML.=	"<p>".&BTable($TableWidth,$TableAlign,"0","0",$TableCellSpacing,$TableCellPadding,$TableBorderColor,"","").
				&Tr("","",$HeaderBGColor).
					&Td("","","","","","","","","").
						&Font($FontFace,$HeaderTextSize,$HeaderTextColor).
							"<b>$NickName ($AccountName) PROFILE</b>".
						"</font>".
					"</td>".
				"</tr>".
	            &Tr("","",$CategoryBGColor).
					&Td("","","","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Nick Name</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","","","","","","","").
						&Font($FontFace,$TextSize,$TextColor).
							$MemberInfo[1]."&nbsp;".
						"</font>".
					"</td>".
				"</tr>".
                &Tr("","",$CategoryBGColor).
					&Td("","","","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Status</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","","","","","","","").
						&Font($FontFace,$TextSize,$TextColor).
							$Status." (".$MemberInfo[6].")".
						"</font>".
					"</td>".
				"</tr>".
                &Tr("","",$CategoryBGColor).
					&Td("","","","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Member Since</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","","","","","","","").
						&Font($FontFace,$TextSize,$TextColor).
                            &GetDate($MemberInfo[16],$TextColor,$TextColor,$TextSize,$TextSize)."&nbsp;".
						"</font>".
					"</td>".
				"</tr>".
                &Tr("","",$CategoryBGColor).
					&Td("","","","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Total Posts</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","","","","","","","").
						&Font($FontFace,$TextSize,$TextColor).
							$MemberInfo[5]."&nbsp;".
						"</font>".
					"</td>".
				"</tr>".
                &Tr("","",$CategoryBGColor).
					&Td("","","","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Last Post</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","","","","","","","").
						&Font($FontFace,$TextSize,$TextColor).
							 &GetDate($MemberInfo[7],$TextColor,$TextColor,$TextSize,$TextSize)."&nbsp;".
						"</font>".
					"</td>".
				"</tr>";
	if ($MemberInfo[17] ne "") {
		$HTML.= &Tr("","",$CategoryBGColor).
					&Td("","","","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Email</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","","","","","","","").
						&Font($FontFace,$TextSize,$TextColor).
                            &Link("mailto:$MemberInfo[4]","","").
                                $MemberInfo[4].
                            "</a>"."&nbsp;".
                        "</font>".
					"</td>".
				"</tr>";
	}
	$HTML.=     &Tr("","",$CategoryBGColor).
					&Td("","","","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Home Page</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","","","","","","","").
						&Font($FontFace,$TextSize,$TextColor).
							&Link($MemberInfo[8],"","").
                                $MemberInfo[8].
                            "</a>"."&nbsp;".
						"</font>".
					"</td>".
				"</tr>".
                &Tr("","",$CategoryBGColor).
					&Td("","","","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Location</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","","","","","","","").
						&Font($FontFace,$TextSize,$TextColor).
                            $MemberInfo[9]."&nbsp;".
						"</font>".
					"</td>".
				"</tr>".
                &Tr("","",$CategoryBGColor).
					&Td("","","","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>ICQ Number</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","","","","","","","");
    if (length($MemberInfo[13]) > 0) {
        $HTML.=	        &Table("100%","CENTER","0","0","","").
                            &Tr("","","").
                                &Td("10","","","","","","","","").
                                    &Image("http://online.mirabilis.com/scripts/online.dll?icq=$MemberInfo[13]&img=5","","","","","","$MemberInfo[13]").
                                "</td>".
                                &Td("100%","","","","","","","","").
                                    &Font($FontFace,$TextSize,$TextColor).
                                        $MemberInfo[13].
                                    "</font>".
                                "</td>".
                            "</tr>".
                        "</table>";
    }else{
		$HTML.= "&nbsp;";
	}
		$HTML.=		"</td>".
				"</tr>".
                &Tr("","",$CategoryBGColor).
					&Td("","","","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Age</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","","","","","","","").
						&Font($FontFace,$TextSize,$TextColor).
                            $MemberInfo[10]."&nbsp;".
						"</font>".
					"</td>".
				"</tr>".
                &Tr("","",$CategoryBGColor).
					&Td("","","","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Occupation</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","","","","","","","").
						&Font($FontFace,$TextSize,$TextColor).
                            $MemberInfo[11]."&nbsp;".
    					"</font>".
					"</td>".
				"</tr>".
                &Tr("","",$CategoryBGColor).
					&Td("","","","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Interests</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","","","","","","","").
						&Font($FontFace,$TextSize,$TextColor).
                            $MemberInfo[12]."&nbsp;".
						"</font>".
					"</td>".
				"</tr>".
                &Tr("","",$CategoryBGColor).
					&Td("","","","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Comments</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","","","","","","","").
						&Font($FontFace,$TextSize,$TextColor).
                            $MemberInfo[14]."&nbsp;".
						"</font>".
					"</td>".
				"</tr>";
    if ($UseSignatures) {
        $HTML.= &Tr("","",$CategoryBGColor).
					&Td("","","","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Signature</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","","","","","","","").
						&Font($FontFace,$TextSize,$TextColor).
                            $MemberInfo[15]."&nbsp;";
						"</font>".
					"</td>".
				"</tr>";
    }
    $HTML.=     &Tr("","",$MenuBGColor).
					&Td("","","","","","","","","").
						&PrintVersion("YES").
					"</td>".
				"</tr>";
	$HTML.=		&CBTable();
    &PrintTheme("$UBName",$HTML);
	exit;
}
###############################################################################
1;# End of ShowProfile Function
###############################################################################