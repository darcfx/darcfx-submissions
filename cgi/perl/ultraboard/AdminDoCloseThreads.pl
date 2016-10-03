###############################################################################
# AdminDoCloseThreads.pl                                                      #
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
# DoCloseThreads                                                              #
###############################################################################
sub DoCloseThreads {
	require "$LibPath/SearchPostID.lib";
	for (my ($i)=0;$i<$in{'Count'};$i++) {
		if ($in{"PostID_".$i}) {
			($PostID, $BoardID)=split(/\Q$Spliter\E/,$in{"PostID_".$i});
			push (@{$Posts{$BoardID}},$PostID);
		}
	}
	foreach $BoardID (keys %Posts) {
		open(BOARD,"$DBPath/$BoardID/board.list")||&CGIError("Couldn't open/read the board.list file<br>\nPath: $DBPath/$BoardID<br>\nReason : $!");
			flock(BOARD,1) if ($FLock);
			@BOARD_DATA=<BOARD>;
		close(BOARD);
		$TotalPosts=@BOARD_DATA;
		foreach $PostID (@{$Posts{$BoardID}}) {
			$PostPos = &SearchPostID($PostID);
			if ($PostPos > 0) {
				if ($PostInfo[6] ne "") {
					$PostInfo[6]="";
				}else{
					$PostInfo[6]="1";
				}
				$BOARD_DATA[$PostPos]=&EncodeDBInput(@PostInfo);
				open(POST,"$DBPath/$BoardID/$PostID.post")||&CGIError("Couldn't open/read the $PostID.post file<br>\nPath: $DBPath/$BoardID<br>\nReason : $!");
					flock(POST,1) if ($FLock);
					@POST_DATA=<POST>;
				close(POST);
				@PostInfo=&DecodeDBOutput($POST_DATA[0]);
				if ($PostInfo[8] ne "") {
					$PostInfo[8]="";
				}else{
					$PostInfo[8]="1";
				}
                $POST_DATA[0]=join ($Spliter,@PostInfo);
                $POST_DATA[0]=~s/\n/\\n/g;
                $POST_DATA[0].="\n";
				open(POST,">$DBPath/$BoardID/$PostID.post")||&CGIError("Couldn't create/write the $PostID.post file<br>\nPath: $DBPath/$BoardID<br>\nReason : $!");
					flock(POST,2) if ($FLock);
						print POST @POST_DATA;
					flock(POST,8) if ($FLock);
				close(POST);
			}
		}
		open(BOARD,">$DBPath/$BoardID/board.list")||&CGIError("Couldn't create/write the board.list file<br>\nPath: $DBPath/$BoardID<br>\nReason : $!");
			flock(BOARD,2) if ($FLock);
				print BOARD @BOARD_DATA;
			flock(BOARD,8) if ($FLock);
		close(BOARD);
	}
###############################################################################
	&ShowThank(	"CLOSED/OPENED THOSE THREADS",
				"Those threads have been closed/opened.\n",
				"3",
				"UBAdmin.$Ext?Action=ManageMessages&Session=$SessionID"				
	);	
	exit;
}
###############################################################################
1;# End of DoCloseThreads Function
###############################################################################