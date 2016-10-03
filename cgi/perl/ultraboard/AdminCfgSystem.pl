###############################################################################
# AdminCfgSystem.pl                                                           #
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
# CfgSystem                                                                   #
###############################################################################
sub CfgSystem {
	if ($EmailFunction eq "SendMail") {
		$SendMailPath=$SendMailLocation;
	}else{
		$SMTPAddress=$SendMailLocation;
	}
	open(BAN,"$VarsPath/IPs.ban");
		flock(BAN,2) if ($FLock);
		my (@IPs)=<BAN>;
	close(BAN);
	chomp (@IPs);
	$IPBanList=join(" ",@IPs);
	open(BAN,"$VarsPath/Hosts.ban");
		flock(BAN,2) if ($FLock);
		my (@Hosts)=<BAN>;
	close(BAN);
	chomp (@Hosts);
	$HostBanList=join(" ",@Hosts);
    $EmailFunction = "no" if (!$EmailFunction);
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
						"</form>".
						&Form("UBAdmin.$Ext","POST","","").
						&HiddenBox("Action","DoCfgSystem").
						&HiddenBox("Session",$SessionID).
					"</td>".
				"</tr>".
			"</table>".
			&BTable($TableWidth,$TableAlign,"0","0",$TableCellSpacing,$TableCellPadding,$TableBorderColor,"","").
				&Tr("","",$HeaderBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$HeaderTextSize,$HeaderTextColor).
							"<b>ABSOLUTE PATHS</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Datebase Path (required)</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"the absolute path of the directory where all the ultraboard data files will be located. (e.g. \"/home/yourdomain/cgi-bin/UltraBoard/UBData\")".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","2","","","","",$ColumnOddBGColor,"").
						&TextBox("DBPath",$DBPath,$TextBoxSize,"","width:$IETextBoxSize").
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Members Path (required)</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"the absolute path of the directory where all the ultraboard members data files will be located. (e.g. \"/home/yourdomain/cgi-bin/UltraBoard/UBData/Members\")".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","2","","","","",$ColumnOddBGColor,"").
						&TextBox("MembersPath",$MembersPath,$TextBoxSize,"","width:$IETextBoxSize").
					"</td>".
				"</tr>".
                &Tr("","",$CategoryBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Members Session Path (required)</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"the absolute path of the directory where all the ultraboard members session files will be located. (e.g. \"/home/yourdomain/cgi-bin/UltraBoard/UBData/Sessions\")".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","2","","","","",$ColumnOddBGColor,"").
						&TextBox("SessionPath",$SessionPath,$TextBoxSize,"","width:$IETextBoxSize").
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Stats Path (required)</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"the absolute path of directory that where all the ultraboard log and stats files will be located. (e.g. \"/home/yourdomain/cgi-bin/UltraBoard/UBData/Stats\")".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","2","","","","",$ColumnOddBGColor,"").
						&TextBox("StatsPath",$StatsPath,$TextBoxSize,"","width:$IETextBoxSize").
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>CGI Path (required)</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"the absolute path of directory where the UltraBoard.pl and UBAdmin.pl are located. (e.g. \"/home/yourdomain/cgi-bin/UltraBoard\")".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","2","","","","",$ColumnOddBGColor,"").
						&TextBox("CGIPath",$CGIPath,$TextBoxSize,"","width:$IETextBoxSize").
					"</td>".
				"</tr>".
				&Tr("","",$HeaderBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$HeaderTextSize,$HeaderTextColor).
							"<b>URL ADDRESSES</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>CGI URL (required)</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"the location where the UltraBoard.pl and UBAdmin.pl are located. (e.g. \"http://www.yourdomain.com/cgi-bin/UltraBoard\")".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","2","","","","",$ColumnOddBGColor,"").
						&TextBox("URLCGI",$URLCGI,$TextBoxSize,"","width:$IETextBoxSize").
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Images URL (required)</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"the location where the UltraBoard images (*.gif) are located. (e.g. \"http://yourdomain.com/cgi-bin/UltraBoard/Images\")".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","2","","","","",$ColumnOddBGColor,"").
						&TextBox("URLImages",$URLImages,$TextBoxSize,"","width:$IETextBoxSize").
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Site URL (required)</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"the url of your site. (e.g. \"http://www.yourdomain.com\")".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","2","","","","",$ColumnOddBGColor,"").
						&TextBox("URLSite",$URLSite,$TextBoxSize,"","width:$IETextBoxSize").
					"</td>".
				"</tr>".
				&Tr("","",$HeaderBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$HeaderTextSize,$HeaderTextColor).
							"<b>EMAIL OPERATIONS</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Email Address (required)</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"your e-mail address. (e.g. \"webmaster\@yourdomain.com\")".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","2","","","","",$ColumnOddBGColor,"").
						&TextBox("EmailAddress",$EmailAddress,$TextBoxSize,"","width:$IETextBoxSize").
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Mail Function</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"choose the type of method UltraBoard should send mail by. if you don't want to allow UltraBoard to send mail function just choose \"don't use.\".".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("20","","","","","","","","").
						&Radio("EmailFunction","no",$EmailFunction,"").
					"</td>".
					&Td("100%","","","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							" <b>Don't use.</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("20","","","","","","","","").
						&Radio("EmailFunction","SendMail",$EmailFunction,"").
					"</td>".
					&Td("100%","","","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							" <b>Use SendMail.</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("20","","","2","","","",$ColumnOddBGColor,"").
						"&nbsp;".
					"</td>".
					&Td("100%","","","","","","",$CategoryBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"<b>SendMail Location</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"if you choose to use the sendmail program, please fill in the location of the sendmail program on your server. (e.g. \"/usr/bin/sendmail\")".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("100%","","","","","","",$ColumnOddBGColor,"").
						&TextBox("SendMailPath",$SendMailPath,$TextBoxSize,"","width:$IETextBoxSize").
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("20","","","","","","","","").
						&Radio("EmailFunction","SMTP",$EmailFunction,"").
					"</td>".
					&Td("100%","","","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							" <b>Use SMTP.</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("20","","","2","","","",$ColumnOddBGColor,"").
						"&nbsp;".
					"</td>".
					&Td("100%","","","","","","",$CategoryBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"<b>SMTP Server Address</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"if you choose to use your smtp server, please fill in the address of your smtp server. (e.g. \"smtp.yourdomain.com\")".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("100%","","","","","","",$ColumnOddBGColor,"").
						&TextBox("SMTPAddress",$SMTPAddress,$TextBoxSize,"","width:$IETextBoxSize").
					"</td>".
				"</tr>".
				&Tr("","",$HeaderBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$HeaderTextSize,$HeaderTextColor).
							"<b>DATE/TIME OPERATIONS</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Time Zone Name</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"the time zone of your area. (e.g. \"GMT\")".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","2","","","","",$ColumnOddBGColor,"").
						&TextBox("TimeZoneName",$TimeZoneName,$TextBoxSize,"","width:$IETextBoxSize").
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>GMT Time Zone Offset</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"the time different between your area and greenwhich mean time. (e.g. \"-5\" if you live in new york.)".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","2","","","","",$ColumnOddBGColor,"").
						&TextBox("GMTOffset",$GMTOffset,$TextBoxSize,"","width:$IETextBoxSize").
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Date Format</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"select the date format you prefer.".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("20","","","","","","",$ColumnOddBGColor,"").
						&Radio("DateFormat","US",$DateFormat,"").
					"</td>".
					&Td("100%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"US Format (MM-DD-YYYY)".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowEvenBGColor).
					&Td("20","","","","","","",$ColumnOddBGColor,"").
						&Radio("DateFormat","USE",$DateFormat,"").
					"</td>".
					&Td("100%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"Expanded US Format (Month DD, YYYY)".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("20","","","","","","",$ColumnOddBGColor,"").
						&Radio("DateFormat","EU",$DateFormat,"").
					"</td>".
					&Td("100%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"European Format (DD-MM-YYYY)".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowEvenBGColor).
					&Td("20","","","","","","",$ColumnOddBGColor,"").
						&Radio("DateFormat","EUE",$DateFormat,"").
					"</td>".
					&Td("100%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"Expanded European Format (DD Month, YYYY)".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Time Format</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"select the time format you prefer.".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("20","","","","","","",$ColumnOddBGColor,"").
						&Radio("TimeFormat","12",$TimeFormat,"").
					"</td>".
					&Td("100%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"AM/PM Time Format".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowEvenBGColor).
					&Td("20","","","","","","",$ColumnOddBGColor,"").
						&Radio("TimeFormat","24",$TimeFormat,"").
					"</td>".
					&Td("100%","","","","","","",$ColumnEvenBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"24 Hour Time Format".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$HeaderBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$HeaderTextSize,$HeaderTextColor).
							"<b>MISCELLANEOUS OPERATIONS<b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("20","","","","","","","","").
						&Checkbox("CloseUB","on","",$CloseUB).
					"</td>".
					&Td("100%","","","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Close the UltraBoard a While</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"if you want to close your board a while for upgrade or...".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("20","","","2","","","",$ColumnOddBGColor,"").
						"&nbsp;".
					"</td>".
					&Td("100%","","","","","","",$CategoryBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"<b>Close UltraBoard Message</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"this message will appear while the board is closed.".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("100%","","","","","","",$ColumnOddBGColor,"").
						&TextArea("ClosedMessage",$ClosedMessage,$TextBoxSize,"3","$TextAreaType","width:$IETextBoxSize").
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("20","","","","","","","","").
						&Checkbox("FLock","on","",$FLock).
					"</td>".
					&Td("100%","","","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Use File Lock Function</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"if your server supports the flock() function, I suggest you to use this. otherwise the board can become corrupted when some people post an the same time.".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("20","","","","","","","","").
						&Checkbox("UseStats","on","",$UseStats).
					"</td>".
					&Td("100%","","","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Use Stats Feature</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"if you want to know how many people access your board hourly, daily and monthly, use this option.".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
                 &Tr("","",$RowOddBGColor).
					&Td("100%","","2","","","","",$CategoryBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"<b>Clean Up Time</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"every how many second clean up the members session files once?".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
                &Tr("","",$RowOddBGColor).
					&Td("100%","","2","","","","",$ColumnOddBGColor,"").
						&TextBox("CleanUpTime",$CleanUpTime,$TextBoxSize,"5","width:$IETextBoxSize").
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("20","","","","","","","","").
						&Checkbox("UseLog","on","",$UseLog).
					"</td>".
					&Td("100%","","","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Track all the Log Information</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"if you want to log all users who access your board, use this option.".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("20","","","4","","","",$ColumnOddBGColor,"").
						"&nbsp;".
					"</td>".
					&Td("100%","","","","","","",$CategoryBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"<b>Maximum Number of Action Log Informations</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"how many lines of action information do you want to keep track of?".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("100%","","","","","","",$ColumnOddBGColor,"").
						&TextBox("MaxActionLog",$MaxActionLog,$TextBoxSize,"5","width:$IETextBoxSize").
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("100%","","","","","","",$CategoryBGColor,"").
						&Font($FontFace,$TextSize,$TextColor).
							"<b>Maximum Number of Visitor Log Informations</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"how many visitors (if the number of visitors exceeds this number, older ones will be deleted) do you want to keep track of?".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("100%","","","","","","",$ColumnOddBGColor,"").
						&TextBox("MaxVisitorLog",$MaxVisitorLog,$TextBoxSize,"5","width:$IETextBoxSize").
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>IP Addresses Ban List</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"list all of the ip addresses that you want to ban from your board. use a space to seperate each ip address.  (also, to ban a specfic range, say 128.64, just type \"128.64\")".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","2","","","","",$ColumnOddBGColor,"").
						&TextArea("IPBanList",$IPBanList,$TextBoxSize,"3","VIRTUAL","width:$IETextBoxSize").
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Host Addresses Ban List</b><br>".
							&Font("",$CategoryDesTextSize,$CategoryTextColor).
								"list all of the host addresses that you want to ban from your board. use a space to seperate every host address (e.g. if you want to ban ban.net, just type \"ban.net\")".
							"</font>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","2","","","","",$ColumnOddBGColor,"").
						&TextArea("HostBanList",$HostBanList,$TextBoxSize,"3","VIRTUAL","width:$IETextBoxSize").
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","2","","","","","","").
						"<center>".&Submit("","SUBMIT AND SAVE CONFIGURATION","width:$IETextBoxSize")."</center>".
					"</td>".
				"</tr>".
				&Tr("","",$MenuBGColor).
					&Td("","","2","","","","","","").
						&PrintVersion().
					"</td>".
				"</tr>".
			"</table></td></tr></table>".
			"</form>";
	&PrintTheme("$UBName Administrative Center - Configure System Options",$HTML);
	exit;
}
###############################################################################
1;# End of CfgSystem Function
###############################################################################