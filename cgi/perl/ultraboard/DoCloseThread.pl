###############################################################################
# DoCloseThread.pl                                                            #
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
# DoCloseThread                                                               #
###############################################################################
sub DoCloseThread {
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
        print "Location: UltraBoard.$Ext?Action=SignIn&Ref=DoRemoveMessages&Type$in{'Type'}&Board=$in{'Board'}&Post=$in{'Post'}&ID=$in{'ID'}&Idle=$in{'Idle'}&Sort=$in{'Sort'}&Order=$in{'Order'}&Page=$in{'Page'}\n\n";
	}
###############################################################################
	require "$LibPath/SearchPostID.lib";
	$TotalPosts=@BOARD_DATA;
	$PostPos = &SearchPostID($in{'Post'});
	if ($PostPos > 0) {
		if ($in{'Type'} eq "Close") {
			$PostInfo[6]="1";
		}else{
			$PostInfo[6]="";
		}
		$BOARD_DATA[$PostPos]=&EncodeDBInput(@PostInfo);
		@PostInfo=&DecodeDBOutput($POST_DATA[0]);
		if ($in{'Type'} eq "Close") {
			$PostInfo[8]="1";
		}else{
			$PostInfo[8]="";
		}
        $POST_DATA[0]=join ($Spliter,@PostInfo);
        $POST_DATA[0]=~s/\n/\\n/g;
        $POST_DATA[0].="\n";
		open(POST,">$DBPath/$in{'Board'}/$in{'Post'}.post")||&CGIError("Couldn't create/write the $in{'Post'}.post file<br>\nPath: $DBPath/$in{'Board'}<br>\nReason : $!");
			flock(POST,2) if ($FLock);
				print POST @POST_DATA;
			flock(POST,8) if ($FLock);
		close(POST);
		open(BOARD,">$DBPath/$in{'Board'}/board.list")||&CGIError("Couldn't create/write the board.list file<br>\nPath: $DBPath/$in{'Board'}<br>\nReason : $!");
			flock(BOARD,2) if ($FLock);
				print BOARD @BOARD_DATA;
			flock(BOARD,8) if ($FLock);
		close(BOARD);
	}
###############################################################################
	if ($in{'Type'} eq "Close") {
		&ShowThank(	"CLOSED THE THREAD",
					"The thread has been closed.\n",
					"3",
					"UltraBoard.$Ext?Action=ShowPost&Board=$in{'Board'}&Post=$in{'Post'}&Idle=$in{'Idle'}&Sort=$in{'Sort'}&Order=$in{'Order'}&Page=$in{'Page'}&Session=$SessionID"				
		);
	}else{
		&ShowThank(	"OPEDED THE THREAD",
					"The thread has been opened.\n",
					"3",
					"UltraBoard.$Ext?Action=ShowPost&Board=$in{'Board'}&Post=$in{'Post'}&Idle=$in{'Idle'}&Sort=$in{'Sort'}&Order=$in{'Order'}&Page=$in{'Page'}&Session=$SessionID"				
		);
	}
	exit;
}
###############################################################################
1;# End of DoCloseThread Function
###############################################################################