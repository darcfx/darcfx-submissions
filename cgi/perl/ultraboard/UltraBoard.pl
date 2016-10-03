#!/usr/bin/perl

###############################################################################
# UltraBoard.pl                                                               #
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
# Variables                                                                   #
###############################################################################
# sometime server don't understand the path with . in front, so change it to  #
# full path when you have error on creating admin profile data.               #
###############################################################################
$LibPath="./Sources/Libraries";
$VarsPath="./Variables";
$SrcPath="./Sources/UltraBoard";

###############################################################################
# Linking Library                                                             #
###############################################################################
eval {
    require "$VarsPath/System.cfg";
    require "$VarsPath/General.cfg";
    require "$VarsPath/Style.cfg";
    require "$LibPath/HTML.lib";
    require "$LibPath/Common.lib";
    require "$LibPath/UltraBoard.lib";
    require "$LibPath/Stats.lib";
    require "$LibPath/Crypt.pm";
};

if ($@) {
    print<<HTML;
Content-type: text/html

<html>
<head>
<title>CGI Script Error</title>
</head>
<body>
<h1>Script Error</h1>
<p>Couldn't load required libraries.<br>\nCheck that they exist, permissions are set correctly and that they compile.<br>\nReason: $@</p>
</body>
</html>
HTML
}

eval {
	&main;
};

if ($@) {
	&CGIError("Couldn't run your request<br>\nReason : $@");
}

###############################################################################
# Main                                                                        #
###############################################################################
sub main {
	&ParseForm;
	&CheckPermission();
	&WriteStats if ($UseStats);
	&WriteLog if ($UseLog);
	&ShowError(uc($UBName)." WAS CLOSED",$ClosedMessage) if ($CloseUB);
	&CheckBanned();


	if ($in{'Action'} eq "") {
		require "$SrcPath/Main.pl";
		&Main();
	}elsif ($in{'Action'} eq "SignIn") {
		&SignIn();
	}elsif ($in{'Action'} eq "LostPassword") {
		require "$SrcPath/LostPassword.pl";
		&LostPassword();
	}elsif ($in{'Action'} eq "DoLostPassword") {
		require "$SrcPath/DoLostPassword.pl";
		&DoLostPassword();
	}elsif ($in{'Action'} eq "SignOut") {
		&SignOut();
	}elsif ($in{'Action'} eq "SignUp") {
		require "$SrcPath/SignUp.pl";
		&SignUp();
	}elsif ($in{'Action'} eq "DoSignUp") {
		require "$SrcPath/DoSignUp.pl";
		&DoSignUp();
	}elsif ($in{'Action'} eq "ModifyAccount") {
			require "$SrcPath/ModifyAccount.pl";
		&ModifyAccount();
	}elsif ($in{'Action'} eq "DoModifyAccount") {
			require "$SrcPath/DoModifyAccount.pl";
		&DoModifyAccount();
	}elsif (($in{'Action'} eq "ShowCategory")&&($in{'Category'})) {
		require "$SrcPath/ShowCategory.pl";
		&ShowCategory();
	}elsif (($in{'Action'} eq "ShowBoard")&&($in{'Board'})) {
		require "$SrcPath/ShowBoard.pl";
		&ShowBoard();
	}elsif (($in{'Action'} eq "ShowPost")&&($in{'Board'})&&($in{'Post'})) {
		require "$SrcPath/ShowPost.pl";
		&ShowPost();
	}elsif (($in{'Action'} eq "PrintableTopic")&&($in{'Board'})&&($in{'Post'})) {
		require "$SrcPath/PrintableTopic.pl";
		&PrintableTopic();
	}elsif (($in{'Action'} eq "ForwardTopic")&&($in{'Board'})&&($in{'Post'})) {
		require "$SrcPath/ForwardTopic.pl";
		&ForwardTopic();
	}elsif (($in{'Action'} eq "DoForwardTopic")&&($in{'Board'})&&($in{'Post'})) {
		require "$SrcPath/DoForwardTopic.pl";
		&DoForwardTopic();
	}elsif (($in{'Action'} eq "NewPost")&&($in{'Board'})) {
		require "$SrcPath/NewPost.pl";
		&NewPost();
	}elsif (($in{'Action'} eq "DoNewPost")&&($in{'Board'})) {
		if ($in{'Submit'} eq "PREVIEW FIRST") {
			require "$SrcPath/PreviewMessage.pl";
			&PreviewMessage();
		}else{
			require "$SrcPath/DoNewPost.pl";
			&DoNewPost();
		}
	}elsif (($in{'Action'} eq "NewReply")&&($in{'Board'})&&($in{'Post'})) {
		require "$SrcPath/NewReply.pl";
		&NewReply();
	}elsif (($in{'Action'} eq "DoNewReply")&&($in{'Board'})&&($in{'Post'})) {
		if ($in{'Submit'} eq "PREVIEW FIRST") {
			require "$SrcPath/PreviewMessage.pl";
			&PreviewMessage();
		}else{
			require "$SrcPath/DoNewReply.pl";
			&DoNewReply();
		}
	}elsif (($in{'Action'} eq "ModifyPost")&&($in{'Board'})&&($in{'Post'})&&(length($in{'ID'})>0)) {
		require "$SrcPath/ModifyPost.pl";
		&ModifyPost();
	}elsif (($in{'Action'} eq "DoModifyPost")&&($in{'Board'})&&($in{'Post'})) {
		require "$SrcPath/DoModifyPost.pl";
		&DoModifyPost();
	}elsif (($in{'Action'} eq "ModifyReply")&&($in{'Board'})&&($in{'Post'})&&(length($in{'ID'})>0)) {
		require "$SrcPath/ModifyReply.pl";
		&ModifyReply();
	}elsif (($in{'Action'} eq "DoModifyReply")&&($in{'Board'})&&($in{'Post'})&&(length($in{'ID'})>0)) {
		require "$SrcPath/DoModifyReply.pl";
		&DoModifyReply();
	}elsif (($in{'Action'} eq "ShowProfile")&&($in{'ID'})) {
			require "$SrcPath/ShowProfile.pl";
		&ShowProfile();
	}elsif ($in{'Action'} eq "SearchThreads") {
			require "$SrcPath/SearchThreads.pl";
		&SearchThreads();
	}elsif ($in{'Action'} eq "DoSearchThreads") {
			require "$SrcPath/DoSearchThreads.pl";
		&DoSearchThreads();
	}elsif (($in{'Action'} eq "DoRemoveMessages")&&($in{'Board'})&&($in{'Post'})) {
			require "$SrcPath/DoRemoveMessages.pl";
		&DoRemoveMessages();
	}elsif (($in{'Action'} eq "DoCloseThread")&&($in{'Board'})&&($in{'Post'})) {
			require "$SrcPath/DoCloseThread.pl";
		&DoCloseThread();
	}elsif ($in{'Action'} eq "Help") {
			require "$SrcPath/Help.pl";
		&Help();
	}elsif ($in{'Action'} eq "Redirect") {
			if ($in{'Link'}=~/^C_/) {
					$in{'Category'}=$in{'Link'};
					$in{'Category'}=~s/^C_//g;
					print "Location: $URLCGI/UltraBoard.$Ext?Action=ShowCategory&Category=$in{'Category'}&Idle=$in{'Idle'}&Order=$in{'Order'}&Sort=$in{'Sort'}&Session=$SessionID\n\n";
			}else{
					$in{'Board'}=$in{'Link'};
					$in{'Board'}=~s/^B_//g;
					print "Location: $URLCGI/UltraBoard.$Ext?Action=ShowBoard&Board=$in{'Board'}&Idle=$in{'Idle'}&Order=$in{'Order'}&Sort=$in{'Sort'}&Session=$SessionID\n\n";
			}
	}else{
		require "$SrcPath/Main.pl";
		&Main();
	}
}
###############################################################################
# SignIn                                                                      #
###############################################################################
sub SignIn {
    $Group="Guest";
	$HTML.=	"<p>".&Form("UltraBoard.$Ext","POST","","").
			&HiddenBox("Action",$in{'Ref'}).
			&HiddenBox("Type",$in{'Type'}).
			&HiddenBox("Category",$in{'Category'}).
			&HiddenBox("Board",$in{'Board'}).
			&HiddenBox("Post",$in{'Post'}).
            &HiddenBox("ID",$in{'ID'}).
            &HiddenBox("Idle",$in{'Idle'}).
            &HiddenBox("Sort",$in{'Sort'}).
            &HiddenBox("Order",$in{'Order'}).
            &HiddenBox("Page",$in{'Page'}).
			&BTable($TableWidth,$TableAlign,"0","0",$TableCellSpacing,$TableCellPadding,$TableBorderColor,"","").
				&Tr("","",$HeaderBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$HeaderTextSize,$HeaderTextColor).
							"<b>LOGIN</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>UserName</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","2","","","","","","").
						&TextBox("UserName",$Cookies{'UserName'},$TextBoxSize,"","width:$IETextBoxSize").
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","2","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Password</b> ".
						"</font>".
						&Font($FontFace,$CategoryDesTextSize,$CategoryTextColor).
							&Link("UltraBoard.$Ext?Action=LostPassword&Type=$in{'Type'}&Category=$in{'Category'}&Board=$in{'Board'}&Post=$in{'Post'}&ID=$in{'ID'}&Idle=$in{'Idle'}&Sort=$in{'Sort'}&Order=$in{'Order'}&Page=$in{'Page'}","","").
								"Lost your password?".
							"</a>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","2","","","","","","").
						&PasswordBox("Password","",$TextBoxSize,"","width:$IETextBoxSize").
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("20","","","","","","","","").
						&Checkbox("Remember","on","",$Remember).
					"</td>".
					&Td("100%","","","","","","","","").
						&Font($FontFace,$CategoryNameTextSize,$CategoryTextColor).
							"<b>Remember Your Password?</b>".
						"</font>".
					"</td>".
				"</tr>".
				&Tr("","",$CategoryBGColor).
					&Td("","","2","","","","","","").
						"<center>".&Submit("","SIGN IN","width:$IETextBoxSize")."</center>".
					"</td>".
				"</tr>".
				&Tr("","",$MenuBGColor).
					&Td("","","2","","","","","","").
						&PrintVersion().
					"</td>".
				"</tr>".
			"</table></td></tr></table>".
			"</form>";
	&PrintTheme("$UBName - Sign In",$HTML);
	exit;
}

###############################################################################
# CGIError                                                                    #
###############################################################################
sub CGIError {
	my ($Message)=$_[0];
    print<<HTML;
Content-type: text/html

<html>
<head>
<title>CGI Script Error</title>
</head>
<body>
<h1>Script Error</h1>
<p>$Message</p>
</body>
</html>
HTML
	exit;
	#die @Message;
}

###############################################################################
# SignOut                                                                     #
###############################################################################
sub SignOut {
	my (@Cookies);
	push (@Cookies,"UserName","","Password","");
	my ($Header);
	my ($Cookie,$Value,$Char);
	my (@Days) = ("Sun","Mon","Tue","Wed","Thu","Fri","Sat");
	my (@Months) = ("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec");
	my ($Sec,$Min,$Hour,$MDay,$Mon,$Year,$WDay) = gmtime(time+31536000);
	if ($Year>50) {
		$Year+=1900;
	}else{
		$Year+=2000;
	}
	
	$Header="Location: $URLCGI/UltraBoard.$Ext?Action=$in{'Ref'}&Category=$in{'Category'}&Board=$in{'Board'}&Post=$in{'Post'}&ID=$in{'ID'}&Idle=$in{'Idle'}&Sort=$in{'Sort'}&Order=$in{'Order'}&Page=$in{'Page'}\n";
	
	while(($Cookie,$Value)=@Cookies) {
		foreach $Char (@Cookie_Encode_Chars) {
			$Cookie =~ s/$Char/$Cookie_Encode_Chars{$Char}/g;
			$Value  =~ s/$Char/$Cookie_Encode_Chars{$Char}/g;
		}
		$Header.="Set-Cookie: ".$Cookie."=". $Value."; ";
		$Header.="expires=$Days[$WDay], $MDay-$Months[$Mon]-$Year $Hour:$Min:$Sec GMT;";
		$Header.="\n";
		shift(@Cookies);
		shift(@Cookies);
	}
	$Header.="Content-type: text/html\n";
	$Header.="\n";
	
	print $Header;
}
###############################################################################
# End of UltraBoard.pl file
###############################################################################