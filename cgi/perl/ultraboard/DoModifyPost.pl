###############################################################################
# DoModifyPost.pl                                                             #
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
# DoModifyPost                                                                #
###############################################################################
sub DoModifyPost {
	my ($HTML);
    &ShowError("POSTING PROBLEM","You forgot to fill the \"Message\" field.") if (!$in{'Message'});
	unless (-e "$DBPath/$in{'Board'}/board.list") {
		&ShowError("ACCESS DENIED","The board you want is not found.<br>Please contact the webmaster (".&Link("mailto:$EmailAddress","","").$EmailAddress."</a>".") for more information.");
	}
	unless (-e "$DBPath/$in{'Board'}/$in{'Post'}.post") {
		&ShowError("ACCESS DENIED","The topic you want is not found.<br>Please contact the webmaster (".&Link("mailto:$EmailAddress","","").$EmailAddress."</a>".") for more information.");
	}
	open(BOARD,"$DBPath/$in{'Board'}/board.list")||&CGIError("Couldn't open/read the board.list file<br>\nPath: $DBPath/$in{'Board'}<br>\nReason : $!");
		flock(BOARD,1) if ($FLock);
		@BOARD_DATA=<BOARD>;
	close(BOARD);
	open(POST,"$DBPath/$in{'Board'}/$in{'Post'}.post")||&CGIError("Couldn't open/read the $in{'Post'}.post file<br>\nPath: $DBPath/$in{'Board'}<br>\nReason : $!");
		flock(POST,1) if ($FLock);
		@POST_DATA=<POST>;
	close(POST);
    @PostInfo=&DecodeDBOutput($POST_DATA[0]);
	@BoardInfo=&DecodeDBOutput($BOARD_DATA[0]);
	if (($Group ne "administrator")&&($Group ne $BoardInfo[4])) {
		if ($BoardInfo[5] ne "Active") {
			&ShowError("ACCESS DENIED","The \"$BoardInfo[1]\" board is currently inactive.<br>Please contact the webmaster (".&Link("mailto:$EmailAddress","","").$EmailAddress."</a>".") for more information.");
		}
        if ($Group eq "Guest") {
            print "Location: UltraBoard.$Ext?Action=SignIn&Ref=DoModifyPost&Board=$in{'Board'}&Post=$in{'Post'}&ID=$in{'ID'}&Idle=$in{'Idle'}&Sort=$in{'Sort'}&Order=$in{'Order'}&Page=$in{'Page'}\n\n";
        }elsif ($BoardInfo[6] eq "Private") {
			require "$DBPath/$in{'Board'}/Access.db";
			if ($Access{$MemberData[3]} ne "FullAccess") {
				print "Location: UltraBoard.$Ext?Action=SignIn&Ref=DoModifyPost&Board=$in{'Board'}&Post=$in{'Post'}&ID=$in{'ID'}&Idle=$in{'Idle'}&Sort=$in{'Sort'}&Order=$in{'Order'}&Page=$in{'Page'}\n\n";
			}
		}
		if ($PostInfo[8] ne "") {
			&ShowError("ACCESS DENIED","The message that you want to modify was closed.");
		}
		if ($MemberData[0] ne $PostInfo[2]) {
			&ShowError("ACCESS DENIED","Sorry, you can't modify this message. You are not the author of this message.");
		}
		if (($PostInfo[5]+$ModifyTime) < time) {
			&ShowError("ACCESS DENIED","Sorry, you can't modify this message. You haven't modify your message before ".&GetDate($PostInfo[5]).".");
		}
	}else{
		$PostInfo[10]--;
	}
	$ModifyTime = time;
###############################################################################
	if (($Group ne "administrator")&&($Group ne $BoardInfo[4])) {
		if (($ENV{'REMOTE_HOST'})&&($TrackIP=~/Host/)) {
			$IP=$ENV{'REMOTE_HOST'};
		}elsif ($TrackIP=~/IP/){
			$IP=$ENV{'REMOTE_ADDR'};
		}
	}else{
		$IP=$PostInfo[6];
	}
	@PostStat=&DecodeDBOutput($POST_DATA[1]);
	$PostStat[2]=$ModifyTime;
	$POST_DATA[1]=&EncodeDBInput(@PostStat);
	$InLine=	&EncodeDBInput(
					$PostInfo[0],											#Subject
					$PostInfo[1],											#NickName
					$PostInfo[2],											#UserName
					$in{'Nodify'},											#Nodify member when someone reply their message
					$in{'UseSignature'},									#Use Signarture in their message or not
					$PostInfo[5],											#Post Time
					$IP														#IP Address
				);
	chomp $InLine;		
	$POST_DATA[0]=	$InLine.$Spliter.
							&EncodeUBCodes(&RemoveCensorWords($in{'Message'})).$Spliter.	#Message
							&EncodeDBInput(                            
								$PostInfo[8],      								        #Closed ?
								$PostInfo[9],							                #Description of the message
								++$PostInfo[10]                                         #Edited how many times
							);
    
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
			$PostInfo[0]=$ModifyTime;
			$BOARD_DATA[$i]=&EncodeDBInput(@PostInfo);
		}
	}
	open(BOARD,">$DBPath/$in{'Board'}/board.list")||&CGIError("Couldn't create/write the board.list file<br>\nPath: $DBPath/$in{'Board'}<br>\nReason : $!");
		flock(BOARD,2) if ($FLock);
			print BOARD @BOARD_DATA;
		flock(BOARD,8) if ($FLock);
	close(BOARD);
###############################################################################
	&ShowThank(	"MODIFIED THE TOPIC",
				"Your topic has been modified.\n",
				"3",
				"UltraBoard.$Ext?Action=ShowPost&Board=$in{'Board'}&Post=$in{'Post'}&Idle=$in{'Idle'}&Sort=$in{'Sort'}&Order=$in{'Order'}&Page=$in{'Page'}&Session=$SessionID"				
	);
	exit;
}
###############################################################################
1;# End of DoModifyPost Function
###############################################################################