#!/usr/bin/perl

###############################################################################
# UBAdmin.pl                                                                  #
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
$VarsPath="./Variables";
$LibPath="./Sources/Libraries";
$SrcPath="./Sources/UBAdmin";

###############################################################################
# Linking Library                                                             #
###############################################################################
eval {
    require "$VarsPath/System.cfg";
    require "$VarsPath/General.cfg";
    require "$VarsPath/Style.cfg";
    require "$LibPath/HTML.lib";
    require "$LibPath/Common.lib";
    require "$LibPath/Crypt.pm";
    require "$LibPath/UBAdmin.lib";
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
	&CheckPermission;
	&WriteLog();
	&CheckBanned();

	if ($in{'Action'} eq "") {
		require "$SrcPath/AdminMain.pl";
		&Main();
	}

	elsif ($in{'Action'} eq "ShowStats") {
		require "$SrcPath/AdminShowStats.pl";
		&ShowStats();
	}

	elsif ($in{'Action'} eq "CfgSystem") {
		require "$SrcPath/AdminCfgSystem.pl";
		&CfgSystem();
	}elsif ($in{'Action'} eq "DoCfgSystem") {
		require "$SrcPath/AdminDoCfgSystem.pl";
		&DoCfgSystem();
	}elsif ($in{'Action'} eq "CfgGeneral") {
		require "$SrcPath/AdminCfgGeneral.pl";
		&CfgGeneral();
	}elsif ($in{'Action'} eq "DoCfgGeneral") {
		require "$SrcPath/AdminDoCfgGeneral.pl";
		&DoCfgGeneral();
	}elsif ($in{'Action'} eq "CfgStyle") {
		require "$SrcPath/AdminCfgStyle.pl";
		&CfgStyle();
	}elsif ($in{'Action'} eq "DoCfgStyle") {
		require "$SrcPath/AdminDoCfgStyle.pl";
		&DoCfgStyle();
	}elsif ($in{'Action'} eq "CfgTopicIcons") {
		require "$SrcPath/AdminCfgTopicIcons.pl";
		&CfgTopicIcons();
	}elsif ($in{'Action'} eq "DoCfgTopicIcons") {
		require "$SrcPath/AdminDoCfgTopicIcons.pl";
		&DoCfgTopicIcons();
	}

	elsif ($in{'Action'} eq "ModifyProfile") {
		require "$SrcPath/AdminModifyProfile.pl";
		&ModifyProfile();
	}elsif ($in{'Action'} eq "DoModifyProfile") {
		require "$SrcPath/AdminDoModifyProfile.pl";
		&DoModifyProfile();
	}elsif ($in{'Action'} eq "DoApproveAccounts") {
		require "$SrcPath/AdminDoApproveAccounts.pl";
		&DoApproveAccounts();
	}

	elsif ($in{'Action'} eq "CreateGroup") {
		require "$SrcPath/AdminCreateGroup.pl";
		&CreateGroup();
	}elsif ($in{'Action'} eq "DoCreateGroup") {
		require "$SrcPath/AdminDoCreateGroup.pl";
		&DoCreateGroup();
	}elsif ($in{'Action'} eq "ModifyGroup") {
		require "$SrcPath/AdminModifyGroup.pl";
		&ModifyGroup();
	}elsif ($in{'Action'} eq "DoModifyGroup") {
		require "$SrcPath/AdminDoModifyGroup.pl";
		&DoModifyGroup();
	}elsif ($in{'Action'} eq "DoModifyGroup2") {
		require "$SrcPath/AdminDoModifyGroup2.pl";
		&DoModifyGroup2();
	}elsif ($in{'Action'} eq "RemoveGroups") {
		require "$SrcPath/AdminRemoveGroups.pl";
		&RemoveGroups();
	}elsif ($in{'Action'} eq "DoRemoveGroups") {
		require "$SrcPath/AdminDoRemoveGroups.pl";
		&DoRemoveGroups();
	}

	elsif ($in{'Action'} eq "CreateAccount") {
		require "$SrcPath/AdminCreateAccount.pl";
		&CreateAccount();
	}elsif ($in{'Action'} eq "DoCreateAccount") {
		require "$SrcPath/AdminDoCreateAccount.pl";
		&DoCreateAccount();
	}elsif ($in{'Action'} eq "ManageAccounts") {
		require "$SrcPath/AdminManageAccounts.pl";
		&ManageAccounts();
	}elsif ($in{'Action'} eq "ActivateAccounts") {
		require "$SrcPath/AdminActivateAccounts.pl";
		&ActivateAccounts();
	}elsif ($in{'Action'} eq "DoActivateAccounts") {
		require "$SrcPath/AdminDoActivateAccounts.pl";
		&DoActivateAccounts();
	}elsif ($in{'Action'} eq "EmailMembers") {
		require "$SrcPath/AdminEmailMembers.pl";
		&EmailMembers();
	}elsif ($in{'Action'} eq "DoEmailMembers") {
		require "$SrcPath/AdminDoEmailMembers.pl";
		&DoEmailMembers();
	}elsif ($in{'Action'} eq "ModifyAccount") {
		require "$SrcPath/AdminModifyAccount.pl";
		&ModifyAccount();
	}elsif ($in{'Action'} eq "DoModifyAccount") {
		require "$SrcPath/AdminDoModifyAccount.pl";
		&DoModifyAccount();
	}elsif ($in{'Action'} eq "DoModifyAccount2") {
		require "$SrcPath/AdminDoModifyAccount2.pl";
		&DoModifyAccount2();
	}elsif ($in{'Action'} eq "MoveAccounts") {
		require "$SrcPath/AdminMoveAccounts.pl";
		&MoveAccounts();
	}elsif ($in{'Action'} eq "DoMoveAccounts") {
		require "$SrcPath/AdminDoMoveAccounts.pl";
		&DoMoveAccounts();
	}elsif ($in{'Action'} eq "RemoveAccounts") {
		require "$SrcPath/AdminRemoveAccounts.pl";
		&RemoveAccounts();
	}elsif ($in{'Action'} eq "DoRemoveAccounts") {
		require "$SrcPath/AdminDoRemoveAccounts.pl";
		&DoRemoveAccounts();
	}

	elsif ($in{'Action'} eq "CreateCategory") {
		require "$SrcPath/AdminCreateCategory.pl";
		&CreateCategory();
	}elsif ($in{'Action'} eq "DoCreateCategory") {
		require "$SrcPath/AdminDoCreateCategory.pl";
		&DoCreateCategory();
	}elsif ($in{'Action'} eq "ModifyCategory") {
		require "$SrcPath/AdminModifyCategory.pl";
		&ModifyCategory();
	}elsif ($in{'Action'} eq "DoModifyCategory") {
		require "$SrcPath/AdminDoModifyCategory.pl";
		&DoModifyCategory();
	}elsif ($in{'Action'} eq "DoModifyCategory2") {
		require "$SrcPath/AdminDoModifyCategory2.pl";
		&DoModifyCategory2();
	}elsif ($in{'Action'} eq "ReOrderCategories") {
		require "$SrcPath/AdminReOrderCategories.pl";
		&ReOrderCategories();
	}elsif ($in{'Action'} eq "DoReOrderCategories") {
		require "$SrcPath/AdminDoReOrderCategories.pl";
		&DoReOrderCategories();
	}elsif ($in{'Action'} eq "RemoveCategories") {
		require "$SrcPath/AdminRemoveCategories.pl";
		&RemoveCategories();
	}elsif ($in{'Action'} eq "DoRemoveCategories") {
		require "$SrcPath/AdminDoRemoveCategories.pl";
		&DoRemoveCategories();
	}

	elsif ($in{'Action'} eq "CreateBoard") {
		require "$SrcPath/AdminCreateBoard.pl";
		&CreateBoard();
	}elsif ($in{'Action'} eq "DoCreateBoard") {
		require "$SrcPath/AdminDoCreateBoard.pl";
		&DoCreateBoard();
	}elsif ($in{'Action'} eq "ModifyBoard") {
		require "$SrcPath/AdminModifyBoard.pl";
		&ModifyBoard();
	}elsif ($in{'Action'} eq "DoModifyBoard") {
		require "$SrcPath/AdminDoModifyBoard.pl";
		&DoModifyBoard();
	}elsif ($in{'Action'} eq "DoModifyBoard2") {
		require "$SrcPath/AdminDoModifyBoard2.pl";
		&DoModifyBoard2();
	}elsif ($in{'Action'} eq "ReOrderBoards") {
		require "$SrcPath/AdminReOrderBoards.pl";
		&ReOrderBoards();
	}elsif ($in{'Action'} eq "DoReOrderBoards") {
		require "$SrcPath/AdminDoReOrderBoards.pl";
		&DoReOrderBoards();
	}elsif ($in{'Action'} eq "RemoveBoards") {
		require "$SrcPath/AdminRemoveBoards.pl";
		&RemoveBoards();
	}elsif ($in{'Action'} eq "DoRemoveBoards") {
		require "$SrcPath/AdminDoRemoveBoards.pl";
		&DoRemoveBoards();
	}

	elsif ($in{'Action'} eq "NewPost") {
		require "$SrcPath/AdminNewPost.pl";
		&NewPost();
	}elsif ($in{'Action'} eq "DoNewPost") {
		require "$SrcPath/AdminDoNewPost.pl";
		&DoNewPost();
	}elsif ($in{'Action'} eq "ManageMessages") {
		require "$SrcPath/AdminManageMessages.pl";
		&ManageMessages();
	}elsif ($in{'Action'} eq "CloseThreads") {
		require "$SrcPath/AdminCloseThreads.pl";
		&CloseThreads();
	}elsif ($in{'Action'} eq "DoCloseThreads") {
		require "$SrcPath/AdminDoCloseThreads.pl";
		&DoCloseThreads();
	}elsif ($in{'Action'} eq "ModifyThread") {
		require "$SrcPath/AdminModifyThread.pl";
		&ModifyThread();
	}elsif ($in{'Action'} eq "DoModifyThread") {
		require "$SrcPath/AdminDoModifyThread.pl";
		&DoModifyThread();
	}elsif ($in{'Action'} eq "DoModifyThread2") {
		require "$SrcPath/AdminDoModifyThread2.pl";
		&DoModifyThread2();
	}elsif ($in{'Action'} eq "MoveThreads") {
		require "$SrcPath/AdminMoveThreads.pl";
		&MoveThreads();
	}elsif ($in{'Action'} eq "DoMoveThreads") {
		require "$SrcPath/AdminDoMoveThreads.pl";
		&DoMoveThreads();
	}elsif ($in{'Action'} eq "RemoveThreads") {
		require "$SrcPath/AdminRemoveThreads.pl";
		&RemoveThreads();
	}elsif ($in{'Action'} eq "DoRemoveThreads") {
		require "$SrcPath/AdminDoRemoveThreads.pl";
		&DoRemoveThreads();
	}else{
		require "$SrcPath/AdminMain.pl";
		&Main();
	}
}

###############################################################################
# SignIn                                                                      #
###############################################################################
sub SignIn {
    $Group="Guest";
	&GetCookies();
	if (($Cookies{'UserName'})&&($Cookies{'Password'})) {
		$Remember="on";
	}
	$HTML.=	"<p>".&Form("UBAdmin.$Ext","POST","","").
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
					"</td>".
				"</tr>".
				&Tr("","",$RowOddBGColor).
					&Td("","","2","","","","","","").
						&PasswordBox("Password",$Cookies{'Password'},$TextBoxSize,"","width:$IETextBoxSize").
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
						"<center>".&Submit("","LOGIN","width:$IETextBoxSize")."</center>".
					"</td>".
				"</tr>".
				&Tr("","",$MenuBGColor).
					&Td("","","2","","","","","","").
						&PrintVersion().
					"</td>".
				"</tr>".
			"</table></td></tr></table>".
			"</form>";
	&PrintTheme("$UBName Administrative Center - Login",$HTML);
	exit;
}

###############################################################################
# WriteLog                                                                    #
###############################################################################
sub WriteLog {
	my ($IP,$RemoteHost,$Agent,$Referer,$Time,%Hits,$Value);

	$IP = $ENV{'REMOTE_ADDR'};				# Get IP address
	$RemoteHost = $ENV{'REMOTE_HOST'};		# Get remote host address
	$Referer = $ENV{'HTTP_REFERER'};		# Get referer address
	if (!$Referer) {
		$Referer="Unknown";
	}
	$Agent = $ENV{'HTTP_USER_AGENT'};		# Get user agent
	$Referer =~ s/\?(.|\n)*//ig;
	$Time=time;								# Get time

# Process Action Log
	open(LOG,"$StatsPath/Admin.log");
		flock(LOG,2) if ($FLock);
		my (@Actions)=<LOG>;
	close(LOG);
	if (scalar(@Actions) >= $MaxActionLog) {
		open(LOG,">$StatsPath/Admin.log");
			flock(LOG,2) if ($FLock);
			for ($i=scalar(@Actions)-$MaxActionLog+1;$i<scalar(@Actions);$i++) {
				print LOG $Actions[$i];
			}
			print LOG localtime($Time)."|^|".$IP."|^|".$RemoteHost."|^|".$Agent."|^|".$in{'Action'}."|^|".$UserName."\n";
			flock(LOG,8) if ($FLock);
		close(LOG);
	}else{
		open(LOG,">>$StatsPath/Admin.log");
			flock(LOG,2) if ($FLock);
			print LOG localtime($Time)."|^|".$IP."|^|".$RemoteHost."|^|".$Agent."|^|".$in{'Action'}."|^|".$UserName."\n";
			flock(LOG,8) if ($FLock);
		close(LOG);
	}
}
###############################################################################
# End of UBAdmin.pl file
###############################################################################