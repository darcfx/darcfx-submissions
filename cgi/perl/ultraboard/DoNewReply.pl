###############################################################################
# DoNewReply.pl                                                               #
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
# DoNewReply                                                                  #
###############################################################################
sub DoNewReply {
	&ShowError("POSTING PROBLEM","You forgot to fill the \"Subject\" field.") if (!$in{'Subject'});
	&ShowError("POSTING PROBLEM","You forgot to fill the \"Message\" field.") if (!$in{'Message'});
	&ShowError("POSTING PROBLEM","The \"Subject\" must less than $MaxSubjectLen characters.") if (length($in{'Subject'}) > $MaxSubjectLen);

	unless (-e "$DBPath/$in{'Board'}/board.list") {
		&ShowError("POSTING PROBLEM","The board that you want to reply topic is not found.<br>Please contact the webmaster (".&Link("mailto:$EmailAddress","","").$EmailAddress."</a>".") for more information.");
	}
	unless (-e "$DBPath/$in{'Board'}/$in{'Post'}.post") {
		&ShowError("POSTING PROBLEM","The topic that you want to reply is not found.<br>Please contact the webmaster (".&Link("mailto:$EmailAddress","","").$EmailAddress."</a>".") for more information.");
	}
	open(BOARD,"$DBPath/$in{'Board'}/board.list")||&CGIError("Couldn't open/read the board.list file<br>\nPath: $DBPath/$in{'Board'}<br>\nReason : $!");
		flock(BOARD,1) if ($FLock);
		$BOARD_DATA=<BOARD>;
	close(BOARD);
	@BoardInfo=&DecodeDBOutput($BOARD_DATA);
	if ($Group eq "Guest") {
		&ShowError("POSTING PROBLEM","You forgot to fill the \"Nick Name\" field.") if (!$in{'NickName'});
		&ShowError("POSTING PROBLEM","Your \"Nick Name\" must more than 4 characters.") if (length($in{'NickName'}) < 4);
		&ShowError("POSTING PROBLEM","Your \"Nick Name\" must less than 20 characters.") if (length($in{'NickName'}) > 20);
	}
	if ($Group ne "administrator") {
		if ($BoardInfo[5] ne "Active") {
			&ShowError("ACCESS DENIED","The \"$BoardInfo[1]\" board is currently inactive.<br>Please contact the webmaster (".&Link("mailto:$EmailAddress","","").$EmailAddress."</a>".") for more information.");
		}
		if (($BoardInfo[6] ne "Public")&&($Group eq "Guest")) {
			print "Location: UltraBoard.$Ext?Action=SignIn&Ref=NewReply&Post=$in{'Post'}&Board=$in{'Board'}&Idle=$in{'Idle'}&Sort=$in{'Sort'}&Order=$in{'Order'}&Page=$in{'Page'}\n\n";
		}elsif ($BoardInfo[6] eq "Private") {
			require "$DBPath/$in{'Board'}/Access.db";
			if ($Access{$MemberData[3]} ne "FullAccess") {
				print "Location: UltraBoard.$Ext?Action=SignIn&Ref=NewReply&Post=$in{'Post'}&Board=$in{'Board'}&Idle=$in{'Idle'}&Sort=$in{'Sort'}&Order=$in{'Order'}&Page=$in{'Page'}\n\n";
			}
		}
	}
###############################################################################
    open(POST,"$DBPath/$in{'Board'}/$in{'Post'}.post")||&CGIError("Couldn't open/read the $in{'Post'}.post file<br>\nPath: $DBPath/$in{'Board'}<br>\nReason : $!");
		flock(POST,1) if ($FLock);
		@POST_DATA=<POST>;
	close(POST);
    @TopicInfo=&DecodeDBOutput($POST_DATA[0]);
    if ($TopicInfo[8] ne "") {
        &ShowError("POSTING PROBLEM","The topic that you want to reply was closed.");
    }
	$PostTime = time;
	if ($in{'Method'} eq "Preview") {
		$NickName=&RemoveCensorWords(&DecodeHTML($NickName));
		$in{'Subject'}=&RemoveCensorWords(&DecodeHTML($in{'Subject'}));
		$in{'Description'}=&RemoveCensorWords(&DecodeHTML($in{'Description'}));
		$in{'Message'}=&RemoveCensorWords(&DecodeUBCodes(&DecodeHTML($in{'Message'})));
	}
	# new in 1.62
	$NickName=$in{'NickName'};
	unless ($NickName) {
		$NickName=$MemberData[1];
	}
###############################################################################
	open(COUNT,"$DBPath/$in{'Board'}/board.count")||&CGIError("Couldn't open/read the board.count file<br>\nPath: $DBPath/$in{'Board'}<br>\nReason : $!");
		flock(COUNT,1) if ($FLock);
		@COUNT_DATA=&DecodeDBOutput(<COUNT>);
	close(COUNT);
	$COUNT_DATA[2]++;
	$COUNT_DATA[3]=$PostTime;
	open(COUNT,">$DBPath/$in{'Board'}/board.count")||&CGIError("Couldn't create/write the board.count file<br>\nPath: $DBPath/$in{'Board'}<br>\nReason : $!");
		flock(COUNT,2) if ($FLock);
			print COUNT &EncodeDBInput(@COUNT_DATA);
		flock(COUNT,8) if ($FLock);
	close(COUNT);
###############################################################################
	if (($ENV{'REMOTE_HOST'})&&($TrackIP=~/Host/)) {
		$IP=$ENV{'REMOTE_HOST'};
	}elsif ($TrackIP=~/IP/){
		$IP=$ENV{'REMOTE_ADDR'};
	}
	@PostStat=&DecodeDBOutput($POST_DATA[1]);
	$PostStat[0]++;
	$PostStat[2]=$PostTime;
	$POST_DATA[1]=&EncodeDBInput(@PostStat);
	$InLine=	&EncodeDBInput(
					#$PostStat[0],                                           #Reply ID
					&RemoveCensorWords($in{'Subject'}),						#Subject
					$NickName,												#NickName
					$UserName,												#UserName
					$in{'Nodify'},											#Nodify member when someone reply their message
					$in{'UseSignature'},									#Use Signarture in their message or not
					$PostTime,												#Post Time
					$IP														#IP Address
				);
	chomp $InLine;
	push	(@POST_DATA,	$InLine.$Spliter.&EncodeUBCodes(&RemoveCensorWords($in{'Message'})).$Spliter."0\n");
	open(POST,">$DBPath/$in{'Board'}/$in{'Post'}.post")||&CGIError("Couldn't create/write the $in{'Post'}.post file<br>\nPath: $DBPath/$in{'Board'}<br>\nReason : $!");
		flock(POST,2) if ($FLock);
			print POST @POST_DATA;
		flock(POST,8) if ($FLock);
	close(POST);
###############################################################################
	open(BOARD,"$DBPath/$in{'Board'}/board.list")||&CGIError("Couldn't open/read the board.list file<br>\nPath: $DBPath/$in{'Board'}<br>\nReason : $!");
		flock(BOARD,1) if ($FLock);
		@BOARD_DATA=<BOARD>;
	close(BOARD);
	for (my ($i)=1;$i<=$#BOARD_DATA;$i++) {
		@PostInfo=&DecodeDBOutput($BOARD_DATA[$i]);
		if ($PostInfo[1] eq $in{'Post'}) {
			$PostInfo[0]=$PostTime;
			$PostInfo[2]++;
			$BOARD_DATA[$i]=&EncodeDBInput(@PostInfo);
		}
	}
	open(BOARD,">$DBPath/$in{'Board'}/board.list")||&CGIError("Couldn't create/write the board.list file<br>\nPath: $DBPath/$in{'Board'}<br>\nReason : $!");
		flock(BOARD,2) if ($FLock);
			print BOARD @BOARD_DATA;
		flock(BOARD,8) if ($FLock);
	close(BOARD);
###############################################################################
	if ($UserName) {
		$MemberData[5]++;
		$MemberData[7]=$PostTime;
		&SaveMemberData($UserName,@MemberData);
	}
###############################################################################
	@BoardInfo=&DecodeDBOutput($BOARD_DATA[0]);
	open(CATEGORY,"$DBPath/$BoardInfo[3].cat")||&CGIError("Couldn't open/read the $BoardInfo[3].cat file<br>\nPath: $DBPath<br>\nReason : $!");
		flock(CATEGORY,1) if ($FLock);
		$CATEGORY_DATA=<CATEGORY>;
		@CategoryInfo=&DecodeDBOutput($CATEGORY_DATA);
	close(CATEGORY);
	my ($Subject, $Message);
	if ($Group eq "Guest") {
        $From = "$NickName (Guest)";
	}else{
		$From= "$MemberData[1] ($MemberData[0])";
	}
	# Send Email
	if ($NodifyPost) {
		$Subject = "A topic has been replied at $UBName";
		$Message = "Hello,\n";
		$Message .= "$From has been replied a topic at ".&GetDate($PostTime)."\n\n";
		$Message .= "Following is the reply message information:\n";
		$Message .= "----------------------------------------\n";
		$Message .= "From: $From\n";
		$Message .= "To: $CategoryInfo[1] / $BoardInfo[1] / $TopicInfo[0]\n";
		$Message .= "Host/IP: $IP\n";
		$Message .= "Email: $MemberData[4]\n\n";
		$Message .= "Subject: $in{'Subject'}\n";
		$Message .= "Message:\n$in{'Message'}\n";
		$Message .= "----------------------------------------\n";
		$Message .= "UltraBoard Administrative Center\n";
		$Message .= "Powered by UltraScripts.com\n";
		&SendMail("$UBName Administrative Center <$EmailAddress>",$Subject,$Message,$EmailAddress);
	}
	if (($TopicInfo[3])&&($TopicInfo[2])&&($NotifyMembers=~/Post/)) {
		if (($TopicInfo[1] ne "")||($MemberData[0] ne $TopicInfo[2])) {
			$Subject = "Your topic ($TopicInfo[0]) has been replied at $UBName";
			$Message = "Hello,\n";
			$Message .= "$From has been replied your topic at ".&GetDate($PostTime)."\n\n";
			$Message .= "Following is the reply message information:\n";
			$Message .= "----------------------------------------\n";
			$Message .= "From: $From\n";
			$Message .= "To: $CategoryInfo[1] / $BoardInfo[1] / $TopicInfo[0]\n";
			$Message .= "Subject: $in{'Subject'}\n";
			$Message .= "Message:\n$in{'Message'}\n";
			$Message .= "----------------------------------------\n";
			$Message .= "Thank you for posted message in our $UBName forum,\n";
			$Message .= "WebMaster, $UBName\n";
			$Message .= "$EmailAddress\n";
			$Message .= "$URLSite\n";
			$Message .= "----------------------------------------\n";
			$Message .= "Powered by UltraScripts.com\n";

			$OriginatorEmail=(&GetMemberData($TopicInfo[2]))[4];
			&SendMail("$UBName Administrative Center <$EmailAddress>",$Subject,$Message,$OriginatorEmail);
		}
	}
	if ($NotifyMembers=~/Reply/) {
        $Subject = "The topic ($TopicInfo[0]) has been replied at $UBName";
        $Message = "Hello,\n";
        $Message .= "$From has been replied the topic at ".&GetDate($PostTime)."\n\n";
        $Message .= "Following is the reply message information:\n";
        $Message .= "----------------------------------------\n";
        $Message .= "From: $From\n";
        $Message .= "To: $CategoryInfo[1] / $BoardInfo[1] / $TopicInfo[0]\n";
        $Message .= "Subject: $in{'Subject'}\n";
        $Message .= "Message:\n$in{'Message'}\n";
        $Message .= "----------------------------------------\n";
        $Message .= "Thank you for posted message in our $UBName forum,\n";
        $Message .= "WebMaster, $UBName\n";
        $Message .= "$EmailAddress\n";
        $Message .= "$URLSite\n";
        $Message .= "----------------------------------------\n";
        $Message .= "Powered by UltraScripts.com\n";
		for ($i=2;$i<=$#POST_DATA;$i++) {
			@ReplyInfo=&DecodeDBOutput($POST_DATA[$i]);
			if (($ReplyInfo[3])&&($ReplyInfo[2])) {
				if (($ReplyInfo[1] ne "")||($MemberData[0] ne $ReplyInfo[2])) {
					$ReplierEmail = (&GetMemberData($ReplyInfo[2]))[4];
                    &SendMail("$UBName Administrative Center <$EmailAddress>",$Subject,$Message,$ReplierEmail);
				}
			}
		}
	}
###############################################################################
	&ShowThank(	"REPLIED THE TOPIC",
				"Your message has been replied in $BoardInfo[1].\n",
				"3",
				"UltraBoard.$Ext?Action=ShowPost&Board=$in{'Board'}&Post=$in{'Post'}&Idle=$in{'Idle'}&Sort=$in{'Sort'}&Order=$in{'Order'}&Page=$in{'Page'}&Session=$SessionID"				
	);
	exit;
}
###############################################################################
1;# End of DoNewReply Function
###############################################################################