###############################################################################
# AdminDoNewPost.pl                                                           #
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
    $NoError=0;
    for ($i=0;$i<=$in{'Count'};$i++) {
		if ($in{"BoardID_".$i}) {
			$NoError=1;
		}
	}
    &ShowError("POSTING PROBLEM","You forgot to select a board to post.") if ($NoError==0);
	&ShowError("POSTING PROBLEM","You forgot to fill the \"Subject\" field.") if (!$in{'Subject'});
	&ShowError("POSTING PROBLEM","You forgot to fill the \"Message\" field.") if (!$in{'Message'});
	&ShowError("POSTING PROBLEM","The \"Subject\" must less than $MaxSubjectLen characters.") if (length($in{'Subject'}) > $MaxSubjectLen);
	
###############################################################################
	$PostTime = time;
	if (($ENV{'REMOTE_HOST'})&&($TrackIP=~/Host/)) {
		$IP=$ENV{'REMOTE_HOST'};
	}elsif ($TrackIP=~/IP/){
		$IP=$ENV{'REMOTE_ADDR'};
	}
	$InLine=	&EncodeDBInput(
					&RemoveCensorWords($in{'Subject'}),						#Subject
					"",														#NickName
					$UserName,												#UserName
					$in{'Nodify'},											#Nodify member when someone reply their message
					$in{'UseSignature'},									#Use Signarture in their message or not
					$PostTime,												#Post Time
					$IP														#Host/IP Address
				);
	chomp $InLine;
	$InputLine=	$InLine.$Spliter.
				&EncodeUBCodes(&RemoveCensorWords($in{'Message'})).$Spliter.
				&EncodeDBInput(
					"",      								                #Closed ?
					&RemoveCensorWords($in{'Description'}),                 #Description of the message
					"0",                                                    #Edited how many times
                    $in{'TopicIcon'}                                        #Topic Icon
				).
				&EncodeDBInput(
					"0","0","$PostTime"
				);
###############################################################################
	for ($i=0;$i<=$in{'Count'};$i++) {
		if ($in{"BoardID_".$i}) {
			$BoardID=$in{"BoardID_".$i};
			open(COUNT,"$DBPath/$BoardID/board.count")||&CGIError("Couldn't open/read the board.count file<br>\nPath: $DBPath/$BoardID<br>\nReason : $!");
				flock(COUNT,1) if ($FLock);
				@COUNT_DATA=&DecodeDBOutput(<COUNT>);
			close(COUNT);
			$COUNT_DATA[0]++;
			$COUNT_DATA[1]++;
			$COUNT_DATA[2]++;
			$COUNT_DATA[3]=$PostTime;
			open(COUNT,">$DBPath/$BoardID/board.count")||&CGIError("Couldn't create/write the board.count file<br>\nPath: $DBPath/$BoardID<br>\nReason : $!");
				flock(COUNT,2) if ($FLock);
					print COUNT &EncodeDBInput(@COUNT_DATA);
				flock(COUNT,8) if ($FLock);
			close(COUNT);

			open(BOARD,">>$DBPath/$BoardID/board.list")||&CGIError("Couldn't write the board.list file<br>\nPath: $DBPath/$BoardID<br>\nReason : $!");
				flock(BOARD,2) if ($FLock);
					print BOARD &EncodeDBInput(
									$PostTime,								#Post Time
									$COUNT_DATA[0],							#Post Number
									"0",									#How many replies
									&RemoveCensorWords($in{'Subject'}),		#Subject
									"",										#NickName
									$UserName,								#UserName
									"",      								#Closed ?
									&RemoveCensorWords($in{'Description'}), #Description of the message
                                    $in{'TopicIcon'}                        #Topic Icon
								);
				flock(BOARD,8) if ($FLock);
			close(BOARD);

			open(POST,">$DBPath/$BoardID/$COUNT_DATA[0].post")||&CGIError("Couldn't create/write the $COUNT_DATA[0].post file<br>\nPath: $DBPath/$BoardID<br>\nReason : $!");
				flock(POST,2) if ($FLock);
					print POST $InputLine;
				flock(POST,8) if ($FLock);
			close(POST);

			$MemberData[5]++;
		}
	}
###############################################################################
	$MemberData[7]=$PostTime;
	&SaveMemberData($UserName,@MemberData);
###############################################################################
	&ShowThank(	"POSTED THE TOPIC",
				"Your topic has been posted to those boards.\n",
				"3",
				"UBAdmin.$Ext?Session=$SessionID"	
	);
	exit;
}
###############################################################################
1;# End of DoNewPost Function
###############################################################################