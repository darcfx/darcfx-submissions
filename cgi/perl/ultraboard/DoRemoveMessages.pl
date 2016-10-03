###############################################################################
# DoRemoveMessages.pl                                                         #
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
# DoRemoveMessages                                                            #
###############################################################################
sub DoRemoveMessages {
	my ($HTML);
	unless (-e "$DBPath/$in{'Board'}/board.list") {
		&ShowError("ACCESS DENIED","The board that you want is not found.<br>Please contact the webmaster (".&Link("mailto:$EmailAddress","","").$EmailAddress."</a>".") for more information.");
	}
	unless (-e "$DBPath/$in{'Board'}/$in{'Post'}.post") {
		&ShowError("ACCESS DENIED","The topic that you want is not found.<br>Please contact the webmaster (".&Link("mailto:$EmailAddress","","").$EmailAddress."</a>".") for more information.");
	}
	open(BOARD,"$DBPath/$in{'Board'}/board.list")||&CGIError("Couldn't open/read the board.list file<br>\nPath: $DBPath/$in{'Board'}<br>\nReason : $!");
		flock(BOARD,1) if ($FLock);
		@BOARD_DATA=<BOARD>;
	close(BOARD);
	open(POST,"$DBPath/$in{'Board'}/$in{'Post'}.post")||&CGIError("Couldn't open/read the $in{'Post'}.post file<br>\nPath: $DBPath/$in{'Board'}<br>\nReason : $!");
		flock(POST,1) if ($FLock);
		@POST_DATA=<POST>;
	close(POST);
    
	@BoardInfo=&DecodeDBOutput($BOARD_DATA[0]);

	if (($Group ne "administrator")&&($Group ne $BoardInfo[4])) {
        print "Location: UltraBoard.$Ext?Action=SignIn&Ref=DoRemoveMessages&Board=$in{'Board'}&Post=$in{'Post'}&ID=$in{'ID'}&Idle=$in{'Idle'}&Sort=$in{'Sort'}&Order=$in{'Order'}&Page=$in{'Page'}\n\n";
	}
###############################################################################
	require "$LibPath/SearchPostID.lib";
	$TotalPosts=@BOARD_DATA;
	$PostPos = &SearchPostID($in{'Post'});
	open(BOARD,"$DBPath/$in{'Board'}/board.list")||&CGIError("Couldn't open/read the board.list file<br>\nPath: $DBPath/$in{'Board'}<br>\nReason : $!");
		flock(BOARD,1) if ($FLock);
		@BOARD_DATA=<BOARD>;
	close(BOARD);
	open(COUNT,"$DBPath/$in{'Board'}/board.count")||&CGIError("Couldn't open/read the board.count file<br>\nPath: $DBPath/$in{'Board'}<br>\nReason : $!");
		flock(COUNT,1) if ($FLock);
		@COUNT_DATA=&DecodeDBOutput(<COUNT>);
	close(COUNT);
	if ($in{'ID'} > 0) {
		# Board Counter
		$COUNT_DATA[2]--;
		@PostInfo=&DecodeDBOutput($BOARD_DATA[$PostPos]);
		$PostInfo[2]--;
		$BOARD_DATA[$PostPos]=&EncodeDBInput(@PostInfo);

		@PostStat=&DecodeDBOutput($POST_DATA[1]);
		$PostStat[0]--;
		$POST_DATA[1]=&EncodeDBInput(@PostStat);
		$POST_DATA[$in{'ID'}+1]="";
		open(POST,">$DBPath/$in{'Board'}/$in{'Post'}.post")||&CGIError("Couldn't create/write the $in{'Post'}.post file<br>\nPath: $DBPath/$in{'Board'}<br>\nReason : $!");
			flock(POST,2) if ($FLock);
				print POST @POST_DATA;
			flock(POST,8) if ($FLock);
		close(POST);
	}else{
        @PostInfo=&DecodeDBOutput($BOARD_DATA[$PostPos]);
		#@PostInfo=&DecodeDBOutput($POST_DATA[0]);
		# Board Counter
		$COUNT_DATA[1]--;
		$COUNT_DATA[2]--;
		$COUNT_DATA[2]-=$PostInfo[2];
		# Delete Post in Posts List
		$BOARD_DATA[$PostPos]="";
		# Delete Post
		unlink("$DBPath/$in{'Board'}/$in{'Post'}.post");
	}
	open(COUNT,">$DBPath/$in{'Board'}/board.count")||&CGIError("Couldn't create/write the board.count file<br>\nPath: $DBPath/$in{'Board'}<br>\nReason : $!");
		flock(COUNT,2) if ($FLock);
			print COUNT &EncodeDBInput(@COUNT_DATA);
		flock(COUNT,8) if ($FLock);
	close(COUNT);
	open(BOARD,">$DBPath/$in{'Board'}/board.list")||&CGIError("Couldn't create/write the board.list file<br>\nPath: $DBPath/$in{'Board'}<br>\nReason : $!");
		flock(BOARD,2) if ($FLock);
			print BOARD @BOARD_DATA;
		flock(BOARD,8) if ($FLock);
	close(BOARD);
###############################################################################
	if ($in{'ID'} > 0) {
		&ShowThank(	"REMOVED MESSAGE",
					"The message has been removed.\n",
					"3",
					"UltraBoard.$Ext?Action=ShowPost&Board=$in{'Board'}&Post=$in{'Post'}&Idle=$in{'Idle'}&Sort=$in{'Sort'}&Order=$in{'Order'}&Page=$in{'Page'}&Session=$SessionID"				
		);
	}else{
		&ShowThank(	"REMOVED TOPIC",
					"The topic has been removed.\n",
					"3",
					"UltraBoard.$Ext?Action=ShowBoard&Board=$in{'Board'}&Idle=$in{'Idle'}&Sort=$in{'Sort'}&Order=$in{'Order'}&Page=$in{'Page'}&Session=$SessionID"				
		);
	}
	exit;
}
###############################################################################
1;# End of DoRemoveMessages Function
###############################################################################