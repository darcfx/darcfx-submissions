###############################################################################
# AdminDoModifyThread2.pl                                                     #
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
# DoModifyThread2                                                             #
###############################################################################
sub DoModifyThread2 {
	open(POST,"$DBPath/$in{'Board'}/$in{'Post'}.post")||&CGIError("Couldn't open/read the $in{'Post'}.post file<br>\nPath: $DBPath/$in{'Board'}<br>\nReason : $!");
		flock(POST,1) if ($FLock);
		@POST_DATA=<POST>;
	close(POST);
###############################################################################
	@PostInfo=&DecodeDBOutput($POST_DATA[0]);
	$InLine=	&EncodeDBInput(
					&RemoveCensorWords($in{'Subject_0'}),					#Subject
					$PostInfo[1],											#NickName
					$PostInfo[2],											#UserName
					$PostInfo[3],											#Nodify member when someone reply their message
					$PostInfo[4],											#Use Signarture in their message or not
					$PostInfo[5],											#Post Time
					$PostInfo[6]											#IP Address
				);
	chomp $InLine;
	$POST_DATA[0]=	$InLine.$Spliter.
					&EncodeUBCodes(&RemoveCensorWords($in{'Message_0'})).$Spliter.
					&EncodeDBInput(
						$PostInfo[8],      								        #Closed ?
						&RemoveCensorWords($in{'Description_0'}),               #Description of the message
						$PostInfo[10]			                                #Edited how many times
					);
	for ($i=1;$i<$in{'Count'};$i++) {
		@PostInfo=&DecodeDBOutput($POST_DATA[$i+1]);
		$InLine=	&EncodeDBInput(
						#$PostInfo[0],                                   #Reply ID
						&RemoveCensorWords($in{"Subject_".$i}),			#Subject
						$PostInfo[1],									#NickName
						$PostInfo[2],									#UserName
						$PostInfo[3],									#Nodify member when someone reply their message
						$PostInfo[4],									#Use Signarture in their message or not
						$PostInfo[5],									#Post Time
						$PostInfo[6]									#IP Address
					);
		chomp $InLine;
        $POST_DATA[$i+1]=  $InLine.$Spliter.&EncodeUBCodes(&RemoveCensorWords($in{"Message_".$i})).$Spliter.$PostInfo[8]."\n";
	}
	open(POST,">$DBPath/$in{'Board'}/$in{'Post'}.post")||&CGIError("Couldn't create/write the $in{'Post'}.post file<br>\nPath: $DBPath/$in{'Board'}<br>\nReason : $!");
		flock(POST,2) if ($FLock);
			print POST @POST_DATA;
		flock(POST,8) if ($FLock);
	close(POST);
###############################################################################
	&ShowThank(	"MODIFY THE THREAD",
				"Those threads have been modified.\n",
				"3",
				"UBAdmin.$Ext?Action=ManageMessages&Session=$SessionID"				
	);	
	exit;
}
###############################################################################
1;# End of DoModifyThread2 Function
###############################################################################