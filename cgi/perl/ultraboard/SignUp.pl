###############################################################################
# SignUp.pl                                                                   #
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
# SignUp                                                                      #
###############################################################################
sub SignUp {
	if (!$AllowRegister) {
		print "Location: UltraBoard.$Ext&Idle=$in{'Idle'}&Sort=$in{'Sort'}&Order=$in{'Order'}&Page=$in{'Page'}\n\n";
	}
    if (($UseRule ne "")&&(!defined $in{'Agreement'})) {
        open(RULE,"$VarsPath/Rule.txt");
            flock(RULE,2) if ($FLock);
            my (@Rule)=<RULE>;
            $Rule=join("",@Rule);
            $Rule=~s/\\n/\n/isg;
        close(RULE);
        $HTML.= "<p>".&Form("UltraBoard.$Ext","POST","","").
                &HiddenBox("Action","SignUp").
                &HiddenBox("Ref",$in{'Ref'}).
                &HiddenBox("Category",$in{'Category'}).
                &HiddenBox("Board",$in{'Board'}).
                &HiddenBox("Post",$in{'Post'}).
                &HiddenBox("Idle",$in{'Idle'}).
                &HiddenBox("Sort",$in{'Sort'}).
                &HiddenBox("Order",$in{'Order'}).
                &HiddenBox("Page",$in{'Page'}).
                &BTable($TableWidth,$TableAlign,"0","0",$TableCellSpacing,$TableCellPadding,$TableBorderColor,"","").
                    &Tr("","",$HeaderBGColor).
                        &Td("","","2","","","","","","").
                            &Font($FontFace,$HeaderTextSize,$HeaderTextColor).
                                "<b>RULES AND TERMS OF AGREEMENT</b>".
                            "</font>".
                        "</td>".
                    "</tr>".
                    &Tr("","",$RowOddBGColor).
                        &Td("","","2","","","","","","").
                            &Table("100%","CENTER","5","10","","").
                                &Tr("","","").
                                    &Td("","","","","","MIDDLE","","","").
                                        &Font($FontFace,$TextSize,$TextColor).
                                            $Rule.
                                        "</font>".
                                    "</td>".
                                "</tr>".
                            "</table>".
                        "</td>".
                    "</tr>".
                    &Tr("","",$CategoryBGColor).
                        &Td("50%","","","","","","","","").
                            "<center>".&Submit("Agreement","AGREE","width:$IETextBoxSize")."</center>".
                        "</td>".
                        &Td("50%","","","","","","","","").
                            "<center>".&Submit("Agreement","DISAGREE","width:$IETextBoxSize")."</center>".
                        "</td>".
                    "</tr>".
                    &Tr("","",$MenuBGColor).
                        &Td("","","2","","","","","","").
                            &PrintVersion().
                        "</td>".
                    "</tr>".
                "</table></td></tr></table>".
                "</form>";
	    &PrintTheme("$UBName - Sign Up for a New Account",$HTML);
        exit;
    }elsif (($UseRule ne "")&&($in{'Agreement'} eq "DISAGREE")) {
        print "Location: UltraBoard.$Ext?Idle=$in{'Idle'}&Sort=$in{'Sort'}&Order=$in{'Order'}&Page=$in{'Page'}\n\n";
    }
	$HTML.=	"<p>".&Form("UltraBoard.$Ext","POST","","").
			&HiddenBox("Action","DoSignUp").
			&HiddenBox("Ref",$in{'Ref'}).
			&HiddenBox("Category",$in{'Category'}).
			&HiddenBox("Board",$in{'Board'}).
			&HiddenBox("Post",$in{'Post'}).
            &HiddenBox("Idle",$in{'Idle'}).
            &HiddenBox("Sort",$in{'Sort'}).
            &HiddenBox("Order",$in{'Order'}).
            &HiddenBox("Page",$in{'Page'}).
			&BTable($TableWidth,$TableAlign,"0","0",$TableCellSpacing,$TableCellPadding,$TableBorderColor,"","").
				&Tr("","",$HeaderBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$HeaderTextSize,$HeaderTextColor).
							"<b>SIGN UP A NEW ACCOUNT</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Username (required)</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"your username can be up to 26 characters with letters or numbers with no spaces, and it is not case-sensitive.".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","2","","","","","","").
						&TextBox("REG_UserName","",$TextBoxSize,"26","width:$IETextBoxSize").
					"</td>".
				"</tr>";
	if (!$VerifyReg) {
		$HTML.=	&Tr("","",$CategoryBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Password (required)</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"your password can be up to 26 characters with letters or numbers with no spaces, and it is case-sensitive.".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","2","","","","","","").
						&PasswordBox("REG_Password","",$TextBoxSize,"26","width:$IETextBoxSize").
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Verfiy Password (required)</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"please enter your password again..".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","2","","","","","","").
						&PasswordBox("REG_VerfiyPassword","",$TextBoxSize,"","width:$IETextBoxSize").
					"</td>".
				"</tr>";
	}else{
        $EmailMessage = "your password will be sent to you via the e-mail address you enter below.";
    }
	$HTML.=		&Tr("","",$CategoryBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Nick Name (required)</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"your nickname can be up to 20 characters with no spaces, it will used in every message you post.".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".

				&Tr("","",$RowOddBGColor).
					&Td("","","2","","","","","","").
						&TextBox("REG_NickName","",$TextBoxSize,"20","width:$IETextBoxSize").
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Email (required)</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"please use your real e-mail address. ".$EmailMessage.
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","2","","","","","","").
						&TextBox("REG_Email","",$TextBoxSize,"","width:$IETextBoxSize").
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Home Page</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","2","","","","","","").
						&TextBox("REG_HomePage","",$TextBoxSize,"","width:$IETextBoxSize").
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Location</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","2","","","","","","").
						&TextBox("REG_Location","",$TextBoxSize,"","width:$IETextBoxSize").
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>ICQ Number</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","2","","","","","","").
						&TextBox("REG_ICQ","",$TextBoxSize,"","width:$IETextBoxSize").
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Age</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","2","","","","","","").
						&TextBox("REG_Age","",$TextBoxSize,"2","width:$IETextBoxSize").
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Occupation</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","2","","","","","","").
						&TextBox("REG_Occupation","",$TextBoxSize,"","width:$IETextBoxSize").
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Interests</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","2","","","","","","").
						&TextBox("REG_Interests","",$TextBoxSize,"","width:$IETextBoxSize").
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Comments</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","2","","","","","","").
						&TextArea("REG_Comments","",$TextBoxSize,"3","VIRUAL","width:$IETextBoxSize").
					"</td>".
				"</tr>";
	if ($UseSignatures) {
		$HTML.=	&Tr("","",$CategoryBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Signature</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"your signature will appear at the bottom of every post you make.  You can use UltraBoard code in your signature.".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","2","","","","","","").
						&TextArea("REG_Signature","",$TextBoxSize,"5","$TextAreaType","width:$IETextBoxSize").
					"</td>".
				"</tr>";
	}
	if ($Cookies{'Idle'} ne "") {
		$in{'Idle'}=$Cookies{'Idle'};
	} else {
		$in{'Idle'}="default";
	}
	if ($Cookies{'Sort'} ne "") {
		$in{'Sort'}=$Cookies{'Sort'};
	} else {
		$in{'Sort'}=$SortTopics;
	}
	if ($Cookies{'Order'} ne "") {
		$in{'Order'}=$Cookies{'Order'};
	} else {
		$in{'Order'}=$SortOrder;
	}
	$HTML.=		&Tr("","",$CategoryBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Default Show Topics?</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","2","","","","","","").
						&Table("100%","CENTER","0","0","","").
                            &Tr("","","").
                                &Td("","","","","","","","","").
                                    &Select("REG_Idle","","","",$in{'Idle'},
											"Use default ($ShowTopics days)","default",
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
                                "</td>".
                                &Td("","","","","","","","","").
                                    &Select("REG_Order","","","",$in{'Order'},
											"sorted in ascending order","Ascend",
											"sorted in descending order","Descend",
										   ).
                                "</td>".
								&Td("100%","","","","","","","","").
                                    &Select("REG_Sort","","width: $IETextBoxSize","",$in{'Sort'},
											"topic","3",
											"originator","5",
											"replies","2",
											"last modified","0",
										   ).
                                "</td>".
                            "</tr>".
                        "</table>".
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("20","","","","","","","","").
						&Checkbox("REG_Remember","on","",$Remember).
					"</td>".
					&Td("100%","","","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							" <b>Remember Your Password?</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("20","","","","","","","","").
						&Checkbox("REG_ShowEmail","on","",$ShowEmail).
					"</td>".
					&Td("100%","","","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							" <b>Show Your Email Address?</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","2","","","","","","").
						"<center>".&Submit("","SIGN UP FOR A NEW ACCOUNT","width:$IETextBoxSize")."</center>".
					"</td>".
				"</tr>".
				&Tr("","",$MenuBGColor).
					&Td("","","2","","","","","","").
						&PrintVersion().
					"</td>".
				"</tr>".
			"</table></td></tr></table>".
			"</form>";
	&PrintTheme("$UBName - Sign Up for a New Account",$HTML);
	exit;
}
###############################################################################
1;# End of SignUp Function
###############################################################################