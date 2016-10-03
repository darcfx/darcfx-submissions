###############################################################################
# Help.pl                                                                     #
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
# Help                                                                        #
###############################################################################
sub Help {
    $HTML.=	"<p>".&BTable($TableWidth,$TableAlign,"0","0",$TableCellSpacing,$TableCellPadding,$TableBorderColor,"","").
				&Tr("","",$HeaderBGColor).
					&Td("","","","","","","","","").
                        &Font($FontFace,$HeaderTextSize,$HeaderTextColor).
							"<b>What's UB Code?</b>".
						"</font>".
					"</td>".
				"</tr>".
	        	&Tr("","",$RowOddBGColor).
					&Td("","","","","","","","","").
						&Table("100%","CENTER","5","5","","").
							&Tr("","","").
								&Td("","","","","","MIDDLE","","","").
									&Font($FontFace,$TextSize,$TextColor).
                                        "It's an alternative to HTML, so you can stylize and add images to your code.".
									"</font>".
								"</td>".
							"</tr>".
						"</table>".
					"</td>".
				"</tr>".
			&CBTable();
    $HTML.=	"<p>".
            &BTable($TableWidth,$TableAlign,"0","0",$TableCellSpacing,$TableCellPadding,$TableBorderColor,"","").
				&Tr("","",$HeaderBGColor).
					&Td("","","","","","","","","").
                        &Font($FontFace,$HeaderTextSize,$HeaderTextColor).
							"<b>How do I use UB Code?</b>".
						"</font>".
					"</td>".
				"</tr>".
	        	&Tr("","",$RowOddBGColor).
					&Td("","","","","","","","","").
						&Table("100%","CENTER","5","5","","").
							&Tr("","","").
								&Td("","","","","","MIDDLE","","","").
									&Font($FontFace,$TextSize,$TextColor);
    $HTML.=                             "Below are examples of the use and how to use UB Code. You basically just type in what it says! For example, if you want bold text: [b]Bold Text[/b] -> <b>Bold Text</b><p>";                                      
    $HTML.=                             &BTable($TableWidth,$TableAlign,"0","0","1",$TableCellPadding,$TableBorderColor,"","").
                                            &Tr("","",$RowOddBGColor).
                                                &Td("","","","","","","",$ColumnOddBGColor,"").
                                                    &Font($FontFace,$TextSize,$TextColor).
                                                        "<b>Code</b>".
                                                    "</font>".
                                                "</td>".
                                                &Td("","","","","","","","","").
                                                    &Font($FontFace,$TextSize,$TextColor).
                                                        "<b>Description</b>".
                                                    "</font>".
                                                "</td>".
                                                &Td("","","","","","","","","").
                                                    &Font($FontFace,$TextSize,$TextColor).
                                                        "<b>Example</b>".
                                                    "</font>".
                                                "</td>".
                                            "</tr>".
                                            &Tr("","",$RowOddBGColor).
                                                &Td("","","","","","","",$ColumnOddBGColor,"").
                                                    &Font($FontFace,$TextSize,$TextColor).
                                                        "<b>\\</b>http\:\/\/www.ultrascripts.com".
                                                    "</font>".
                                                "</td>".
                                                &Td("","","","","","","","","").
                                                    &Font($FontFace,$TextSize,$TextColor).
                                                        "Simple Linking (work for url/email address)".
                                                    "</font>".
                                                "</td>".
                                                &Td("","","","","","","","","").
                                                    &Font($FontFace,$TextSize,$TextColor).
                                                        "<a href=\"http://www.ultrascripts.com\" target=\"_blank\">http://www.ultrascripts.com</a>".
                                                    "</font>".
                                                "</td>".
                                            "</tr>".
                                            &Tr("","",$RowOddBGColor).
                                                &Td("","","","","","","",$ColumnOddBGColor,"").
                                                    &Font($FontFace,$TextSize,$TextColor).
                                                        "<b>[url=</b>http://www.ultrascripts.com<b>]</b>UltraScripts.com<b>[/url]</b>".
                                                    "</font>".
                                                "</td>".
                                                &Td("","","","","","","","","").
                                                    &Font($FontFace,$TextSize,$TextColor).
                                                        "Adv. Linking".
                                                    "</font>".
                                                "</td>".
                                                &Td("","","","","","","","","").
                                                    &Font($FontFace,$TextSize,$TextColor).
                                                        "<a href=\"http://www.ultrascripts.com\" target=\"_blank\">UltraScripts.com</a>".
                                                    "</font>".
                                                "</td>".
                                            "</tr>".
                                            &Tr("","",$RowOddBGColor).
                                                &Td("","","","","","","",$ColumnOddBGColor,"").
                                                    &Font($FontFace,$TextSize,$TextColor).
                                                        "<b>[email=</b>support\@ultrascripts.com<b>]</b>Support Email<b>[/url]</b>".
                                                    "</font>".
                                                "</td>".
                                                &Td("","","","","","","","","").
                                                    &Font($FontFace,$TextSize,$TextColor).
                                                        "Email Address".
                                                    "</font>".
                                                "</td>".
                                                &Td("","","","","","","","","").
                                                    &Font($FontFace,$TextSize,$TextColor).
                                                        "<a href=\"mailto:support\@ultrascripts.com\" target=\"_blank\">Support Email</a>".
                                                    "</font>".
                                                "</td>".
                                            "</tr>".
                                            "</tr>".
                                            &Tr("","",$RowOddBGColor).
                                                &Td("","","","","","","",$ColumnOddBGColor,"").
                                                    &Font($FontFace,$TextSize,$TextColor).
                                                        "<b>[img=</b>Your image address<b>]</b>".
                                                    "</font>".
                                                "</td>".
                                                &Td("","","","","","","","","").
                                                    &Font($FontFace,$TextSize,$TextColor).
                                                        "Show Image".
                                                    "</font>".
                                                "</td>".
                                                &Td("","","","","","","","","").
                                                    &Font($FontFace,$TextSize,$TextColor).
                                                        "[image]".
                                                    "</font>".
                                                "</td>".
                                            "</tr>".
                                            &Tr("","",$RowOddBGColor).
                                                &Td("","","","","","","",$ColumnOddBGColor,"").
                                                    &Font($FontFace,$TextSize,$TextColor).
                                                        "<b>[b]</b>Bold Text<b>[/b]</b>".
                                                    "</font>".
                                                "</td>".
                                                &Td("","","","","","","","","").
                                                    &Font($FontFace,$TextSize,$TextColor).
                                                        "Bold Text".
                                                    "</font>".
                                                "</td>".
                                                &Td("","","","","","","","","").
                                                    &Font($FontFace,$TextSize,$TextColor).
                                                        "<b>Bold Text</b>".
                                                    "</font>".
                                                "</td>".
                                            "</tr>".
                                            &Tr("","",$RowOddBGColor).
                                                &Td("","","","","","","",$ColumnOddBGColor,"").
                                                    &Font($FontFace,$TextSize,$TextColor).
                                                        "<b>[i]</b>Italics Text<b>[/i]</b>".
                                                    "</font>".
                                                "</td>".
                                                &Td("","","","","","","","","").
                                                    &Font($FontFace,$TextSize,$TextColor).
                                                        "Italics Text".
                                                    "</font>".
                                                "</td>".
                                                &Td("","","","","","","","","").
                                                    &Font($FontFace,$TextSize,$TextColor).
                                                        "<i>Italics Text</i>".
                                                    "</font>".
                                                "</td>".
                                            "</tr>".
                                            &Tr("","",$RowOddBGColor).
                                                &Td("","","","","","","",$ColumnOddBGColor,"").
                                                    &Font($FontFace,$TextSize,$TextColor).
                                                        "<b>[u]</b>Underline Text<b>[/u]</b>".
                                                    "</font>".
                                                "</td>".
                                                &Td("","","","","","","","","").
                                                    &Font($FontFace,$TextSize,$TextColor).
                                                        "Underline Text".
                                                    "</font>".
                                                "</td>".
                                                &Td("","","","","","","","","").
                                                    &Font($FontFace,$TextSize,$TextColor).
                                                        "<u>Underline Text</u>".
                                                    "</font>".
                                                "</td>".
                                            "</tr>".
                                            &Tr("","",$RowOddBGColor).
                                                &Td("","","","","","","",$ColumnOddBGColor,"").
                                                    &Font($FontFace,$TextSize,$TextColor).
                                                        "<b>[1]</b>Size 1 Text<b>[/1]</b>".
                                                    "</font>".
                                                "</td>".
                                                &Td("","","","","","","","","").
                                                    &Font($FontFace,$TextSize,$TextColor).
                                                        "Size 1 Text".
                                                    "</font>".
                                                "</td>".
                                                &Td("","","","","","","","","").
                                                    &Font($FontFace,$TextSize,$TextColor).
                                                        "<font size=\"1\">Size 1 Text</font>".
                                                    "</font>".
                                                "</td>".
                                            "</tr>".
                                            &Tr("","",$RowOddBGColor).
                                                &Td("","","","","","","",$ColumnOddBGColor,"").
                                                    &Font($FontFace,$TextSize,$TextColor).
                                                        "<b>[2]</b>Size 2 Text<b>[/2]</b>".
                                                    "</font>".
                                                "</td>".
                                                &Td("","","","","","","","","").
                                                    &Font($FontFace,$TextSize,$TextColor).
                                                        "Size 2 Text".
                                                    "</font>".
                                                "</td>".
                                                &Td("","","","","","","","","").
                                                    &Font($FontFace,$TextSize,$TextColor).
                                                        "<font size=\"2\">Size 2 Text</font>".
                                                    "</font>".
                                                "</td>".
                                            "</tr>".
                                            &Tr("","",$RowOddBGColor).
                                                &Td("","","","","","","",$ColumnOddBGColor,"").
                                                    &Font($FontFace,$TextSize,$TextColor).
                                                        "<b>[3]</b>Size 3 Text<b>[/3]</b>".
                                                    "</font>".
                                                "</td>".
                                                &Td("","","","","","","","","").
                                                    &Font($FontFace,$TextSize,$TextColor).
                                                        "Size 3 Text".
                                                    "</font>".
                                                "</td>".
                                                &Td("","","","","","","","","").
                                                    &Font($FontFace,$TextSize,$TextColor).
                                                        "<font size=\"3\">Size 3 Text</font>".
                                                    "</font>".
                                                "</td>".
                                            "</tr>".
                                            &Tr("","",$RowOddBGColor).
                                                &Td("","","","","","","",$ColumnOddBGColor,"").
                                                    &Font($FontFace,$TextSize,$TextColor).
                                                        "<b>[4]</b>Size 4 Text<b>[/4]</b>".
                                                    "</font>".
                                                "</td>".
                                                &Td("","","","","","","","","").
                                                    &Font($FontFace,$TextSize,$TextColor).
                                                        "Size 4 Text".
                                                    "</font>".
                                                "</td>".
                                                &Td("","","","","","","","","").
                                                    &Font($FontFace,$TextSize,$TextColor).
                                                        "<font size=\"4\">Size 4 Text</font>".
                                                    "</font>".
                                                "</td>".
                                            "</tr>".
                                            &Tr("","",$RowOddBGColor).
                                                &Td("","","","","","","",$ColumnOddBGColor,"").
                                                    &Font($FontFace,$TextSize,$TextColor).
                                                        "<b>[fixed]</b>Fixed Text<b>[/fixed]</b>".
                                                    "</font>".
                                                "</td>".
                                                &Td("","","","","","","","","").
                                                    &Font($FontFace,$TextSize,$TextColor).
                                                        "Fixed Text".
                                                    "</font>".
                                                "</td>".
                                                &Td("","","","","","","","","").
                                                    &Font($FontFace,$TextSize,$TextColor).
                                                        "<font face=\"Courier New\">Fixed Text</font>".
                                                    "</font>".
                                                "</td>".
                                            "</tr>".
                                            &Tr("","",$RowOddBGColor).
                                                &Td("","","","","","","",$ColumnOddBGColor,"").
                                                    &Font($FontFace,$TextSize,$TextColor).
                                                        "<b>[sup]</b>Superscript Text<b>[/sup]</b>".
                                                    "</font>".
                                                "</td>".
                                                &Td("","","","","","","","","").
                                                    &Font($FontFace,$TextSize,$TextColor).
                                                        "Superscript Text".
                                                    "</font>".
                                                "</td>".
                                                &Td("","","","","","","","","").
                                                    &Font($FontFace,$TextSize,$TextColor).
                                                        "text<sup>Superscript Text</sup>".
                                                    "</font>".
                                                "</td>".
                                            "</tr>".
                                            &Tr("","",$RowOddBGColor).
                                                &Td("","","","","","","",$ColumnOddBGColor,"").
                                                    &Font($FontFace,$TextSize,$TextColor).
                                                        "<b>[sub]</b>Subscript Text<b>[/sub]</b>".
                                                    "</font>".
                                                "</td>".
                                                &Td("","","","","","","","","").
                                                    &Font($FontFace,$TextSize,$TextColor).
                                                        "Subscript Text".
                                                    "</font>".
                                                "</td>".
                                                &Td("","","","","","","","","").
                                                    &Font($FontFace,$TextSize,$TextColor).
                                                        "text<sub>Subscript Text</sub>".
                                                    "</font>".
                                                "</td>".
                                            "</tr>".
                                            &Tr("","",$RowOddBGColor).
                                                &Td("","","","","","","",$ColumnOddBGColor,"").
                                                    &Font($FontFace,$TextSize,$TextColor).
                                                        "<b>[center]</b>Center Text<b>[/center]</b>".
                                                    "</font>".
                                                "</td>".
                                                &Td("","","","","","","","","").
                                                    &Font($FontFace,$TextSize,$TextColor).
                                                        "Center Text".
                                                    "</font>".
                                                "</td>".
                                                &Td("","","","","","","","","").
                                                    &Font($FontFace,$TextSize,$TextColor).
                                                        "<center>Center Text</center>".
                                                    "</font>".
                                                "</td>".
                                            "</tr>".
                                            &Tr("","",$RowOddBGColor).
                                                &Td("","","","","","","",$ColumnOddBGColor,"").
                                                    &Font($FontFace,$TextSize,$TextColor).
                                                        "<b>[color=</b>0000FF<b>]</b>Color Text<b>[/color]</b>".
                                                    "</font>".
                                                "</td>".
                                                &Td("","","","","","","","","").
                                                    &Font($FontFace,$TextSize,$TextColor).
                                                        "Color Text".
                                                    "</font>".
                                                "</td>".
                                                &Td("","","","","","","","","").
                                                    &Font($FontFace,$TextSize,$TextColor).
                                                        "<font color=\"0000FF\">Color Text</font>".
                                                    "</font>".
                                                "</td>".
                                            "</tr>".
                                            &Tr("","",$RowOddBGColor).
                                                &Td("","","","","","","",$ColumnOddBGColor,"").
                                                    &Font($FontFace,$TextSize,$TextColor).
                                                        "<b>[list]</b>List Items".
                                                    "</font>".
                                                "</td>".
                                                &Td("","","","","","","","","").
                                                    &Font($FontFace,$TextSize,$TextColor).
                                                        "List Items".
                                                    "</font>".
                                                "</td>".
                                                &Td("","","","","","","","","").
                                                    &Font($FontFace,$TextSize,$TextColor).
                                                        "<li>List Items".
                                                    "</font>".
                                                "</td>".
                                            "</tr>".
                                            &Tr("","",$RowOddBGColor).
                                                &Td("","","","","","","",$ColumnOddBGColor,"").
                                                    &Font($FontFace,$TextSize,$TextColor).
                                                        "<b>[pre]</b>Preformatted Text<b>[/pre]</b>".
                                                    "</font>".
                                                "</td>".
                                                &Td("","","","","","","","","").
                                                    &Font($FontFace,$TextSize,$TextColor).
                                                        "Preformatted Text".
                                                    "</font>".
                                                "</td>".
                                                &Td("","","","","","","","","").
                                                    &Font($FontFace,$TextSize,$TextColor).
                                                        "<pre>  Preformatted Text</pre>".
                                                    "</font>".
                                                "</td>".
                                            "</tr>".
                                            &Tr("","",$RowOddBGColor).
                                                &Td("","","","","","","",$ColumnOddBGColor,"").
                                                    &Font($FontFace,$TextSize,$TextColor).
                                                        "<b>[quote]</b>Quoted Text<b>[/quote]</b>".
                                                    "</font>".
                                                "</td>".
                                                &Td("","","","","","","","","").
                                                    &Font($FontFace,$TextSize,$TextColor).
                                                        "Quoted Text".
                                                    "</font>".
                                                "</td>".
                                                &Td("","","","","","","","","").
                                                    &Font($FontFace,$TextSize,$TextColor).
                                                        "<blockquote><hr>Quoted Text<hr><\/blockquote>".
                                                    "</font>".
                                                "</td>".
                                            "</tr>".
                                            &Tr("","",$RowOddBGColor).
                                                &Td("","","","","","","",$ColumnOddBGColor,"").
                                                    &Font($FontFace,$TextSize,$TextColor).
                                                        "<b>[code]</b>Coded Text<b>[/code]</b>".
                                                    "</font>".
                                                "</td>".
                                                &Td("","","","","","","","","").
                                                    &Font($FontFace,$TextSize,$TextColor).
                                                        "Coded Text".
                                                    "</font>".
                                                "</td>".
                                                &Td("","","","","","","","","").
                                                    &Font($FontFace,$TextSize,$TextColor).
                                                        "<blockquote><pre><font size=\"1\" face=\"$FontFace\">code:</font><hr><font face=\"Courier New\" size=\"$TextSize\">Coded Text</font><hr> </pre></blockquote>".
                                                    "</font>".
                                                "</td>".
                                            "</tr>".
                                        &CBTable();
	$HTML.= 						"</font>".
								"</td>".
							"</tr>".
						"</table>".
					"</td>".
				"</tr>".
                &Tr("","",$MenuBGColor).
					&Td("","","","","","","","","").
						&PrintVersion().
					"</td>".
				"</tr>".
			&CBTable();
    &PrintTheme("$UBName - Help",$HTML);
	exit;
}
###############################################################################
1;# End of Help Function
###############################################################################