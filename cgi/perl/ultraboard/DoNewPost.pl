###############################################################################
# DoNewPost.pl                                                                #
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
# DoNewPost                                                                   #
###############################################################################
sub DoNewPost {
	&ShowError("POSTING PROBLEM","You forgot to fill the \"Subject\" field.") if (!$in{'Subject'});
	&ShowError("POSTING PROBLEM","You forgot to fill the \"Message\" field.") if (!$in{'Message'});
	&ShowError("POSTING PROBLEM","The \"Subject\" must less than $MaxSubjectLen characters.") if (length($in{'Subject'}) > $MaxSubjectLen);
	
	unless (-e "$DBPath/$in{'Board'}/board.list") {
		&ShowError("ACCESS DENIED","The board you want to post topic is not found.<br>Please contact the webmaster (".&Link("mailto:$EmailAddress","","").$EmailAddress."</a>".") for more information.");
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
			print "Location: UltraBoard.$Ext?Action=SignIn&Ref=NewPost&Board=$in{'Board'}&Idle=$in{'Idle'}&Sort=$in{'Sort'}&Order=$in{'Order'}&Page=$in{'Page'}\n\n";
		}elsif ($BoardInfo[6] eq "Private") {
			require "$DBPath/$in{'Board'}/Access.db";
			if ($Access{$MemberData[3]} ne "FullAccess") {
				print "Location: UltraBoard.$Ext?Action=SignIn&Ref=NewPost&Board=$in{'Board'}&Idle=$in{'Idle'}&Sort=$in{'Sort'}&Order=$in{'Order'}&Page=$in{'Page'}\n\n";
			}
		}
	}
###############################################################################
	$PostTime = time;
	if ($in{'Method'} eq "Preview") {
		$in{'NickName'}=&RemoveCensorWords(&DecodeHTML($in{'NickName'}));
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
	$COUNT_DATA[0]++;
	$COUNT_DATA[1]++;
	$COUNT_DATA[2]++;
	$COUNT_DATA[3]=$PostTime;
	open(COUNT,">$DBPath/$in{'Board'}/board.count")||&CGIError("Couldn't create/write the board.count file<br>\nPath: $DBPath/$in{'Board'}<br>\nReason : $!");
		flock(COUNT,2) if ($FLock);
			print COUNT &EncodeDBInput(@COUNT_DATA);
		flock(COUNT,8) if ($FLock);
	close(COUNT);
###############################################################################
 	open(BOARD,">>$DBPath/$in{'Board'}/board.list")||&CGIError("Couldn't write the board.list file<br>\nPath: $DBPath/$in{'Board'}<br>\nReason : $!");
		flock(BOARD,2) if ($FLock);
			print BOARD &EncodeDBInput(
							$PostTime,								#Post Time
							$COUNT_DATA[0],							#Post Number
							"0",									#How many replies
							&RemoveCensorWords($in{'Subject'}),		#Subject
							&RemoveCensorWords($NickName),			#NickName
							$UserName,								#UserName
                            "",      								#Closed ?
                            &RemoveCensorWords($in{'Description'}), #Description of the message
                            $in{'TopicIcon'}                        #Topic Icon
						);
		flock(BOARD,8) if ($FLock);
	close(BOARD);
###############################################################################
	if (($ENV{'REMOTE_HOST'})&&($TrackIP=~/Host/)) {
		$IP=$ENV{'REMOTE_HOST'};
	}elsif ($TrackIP=~/IP/){
		$IP=$ENV{'REMOTE_ADDR'};
	}
	open(POST,">$DBPath/$in{'Board'}/$COUNT_DATA[0].post")||&CGIError("Couldn't create/write the $COUNT_DATA[0].post file<br>\nPath: $DBPath/$in{'Board'}<br>\nReason : $!");
		flock(POST,2) if ($FLock);
			$InLine=	&EncodeDBInput(
							&RemoveCensorWords($in{'Subject'}),						#Subject
							$NickName,												#NickName
							$UserName,												#UserName
							$in{'Nodify'},											#Nodify member when someone reply their message
							$in{'UseSignature'},									#Use Signarture in their message or not
							$PostTime,												#Post Time
							$IP														#Host/IP Address
						);
			chomp $InLine;		
			print POST	$InLine.$Spliter;

			print POST	&EncodeUBCodes(&RemoveCensorWords($in{'Message'})).$Spliter;#Message
			print POST	&EncodeDBInput(                            
							"",      												#Closed ?
                            &RemoveCensorWords($in{'Description'}),                 #Description of the message
                            "0",                                                    #Edited how many times
                            $in{'TopicIcon'}                                        #Topic Icon
						);
						
			print POST	&EncodeDBInput(
							"0","0","$PostTime"
						);
		flock(POST,8) if ($FLock);
	close(POST);
###############################################################################
	if ($UserName) {
		$MemberData[5]++;
		$MemberData[7]=$PostTime;
		&SaveMemberData($UserName,@MemberData);
	}
###############################################################################
	if ($NotifyPost) {
		if ($Group eq "Guest") {
			$From = "$NickName (Guest)";
		}else{
			$From = "$MemberData[1] ($MemberData[0])";
		}
		open(BOARD,"$DBPath/$in{'Board'}/board.list")||&CGIError("Couldn't open/read the board.list file<br>\nPath: $DBPath/$in{'Board'}<br>\nReason : $!");
			flock(BOARD,1) if ($FLock);
			$BOARD_DATA=<BOARD>;
		close(BOARD);
		@BoardInfo=&DecodeDBOutput($BOARD_DATA);
		open(CATEGORY,"$DBPath/$BoardInfo[3].cat")||&CGIError("Couldn't open/read the $BoardInfo[3].cat file<br>\nPath: $DBPath<br>\nReason : $!");
			flock(CATEGORY,1) if ($FLock);
			$CATEGORY_DATA=<CATEGORY>;
			@CategoryInfo=&DecodeDBOutput($CATEGORY_DATA);
		close(CATEGORY);
		my ($Subject) = "New topic has been posted at $UBName";
		my ($Message) = "Hello,\n";
			$Message .= "$From has been posted a new topic at ".gmtime($PostTime+($GMTOffset*3600))."\n\n";
			$Message .= "Following is the topic information:\n";
			$Message .= "----------------------------------------\n";
			$Message .= "From: $From\n";
			$Message .= "To: $CategoryInfo[1] / @BoardInfo[1]\n";
			$Message .= "Host/IP: $IP\n";
			$Message .= "Email: $MemberData[4]\n\n";
			$Message .= "Subject: $in{'Subject'}\n";
			$Message .= "Message:\n$in{'Message'}\n";
			$Message .= "----------------------------------------\n";
			$Message .= "UltraBoard Administrative Center\n";
			$Message .= "Powered by UltraScripts.com\n";
		&SendMail($EmailAddress,$Subject,$Message,$EmailAddress);
	}
###############################################################################
	&ShowThank(	"POSTED THE TOPIC",
				"Your topic has been posted in $BoardInfo[1].\n",
				"3",
				"UltraBoard.$Ext?Action=ShowPost&Board=$in{'Board'}&Post=$COUNT_DATA[0]&Idle=$in{'Idle'}&Sort=$in{'Sort'}&Order=$in{'Order'}&Page=$in{'Page'}&Session=$SessionID"				
	);
	exit;
}
###############################################################################
1;# End of DoNewPost Function
###############################################################################