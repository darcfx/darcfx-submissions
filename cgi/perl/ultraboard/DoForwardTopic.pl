###############################################################################
# DoForwardTopic.pl                                                           #
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
# DoForwardTopic                                                              #
###############################################################################
sub DoForwardTopic {	
	my ($HTML);
	&ShowError("FORWARDING PROBLEM","You forgot to fill your name.") unless ($in{'FromName'});
	&ShowError("FORWARDING PROBLEM","You forgot to fill your email.") unless ($in{'FromEmail'});
	&ShowError("FORWARDING PROBLEM","You forgot to fill your friend name.") unless ($in{'ToName'});
	&ShowError("FORWARDING PROBLEM","You forgot to fill your friend email.") unless ($in{'ToEmail'});
	&ShowError("FORWARDING PROBLEM","You forgot to fill the subject.") unless ($in{'Subject'});

	unless (-e "$DBPath/$in{'Board'}/board.list") {
		&ShowError("ACCESS DENIED","The board you want is not found.<br>Please contact the webmaster (".&Link("mailto:$EmailAddress","","").$EmailAddress."</a>".") for more information.");
	}
	unless (-e "$DBPath/$in{'Board'}/$in{'Post'}.post") {
		&ShowError("ACCESS DENIED","The topic you want is not found.<br>Please contact the webmaster (".&Link("mailto:$EmailAddress","","").$EmailAddress."</a>".") for more information.");
	}
	open(BOARD,"$DBPath/$in{'Board'}/board.list")||&CGIError("Couldn't open/read the board.list file<br>\nPath: $DBPath/$in{'Board'}<br>\nReason : $!");
		flock(BOARD,1) if ($FLock);
		$BOARD_DATA=<BOARD>;
	close(BOARD);
	@BoardInfo=&DecodeDBOutput($BOARD_DATA);
	if (($Group ne "administrator")&&($Group ne $BoardInfo[4])) {
		if ($BoardInfo[5] ne "Active") {
			&ShowError("ACCESS DENIED","The \"$BoardInfo[1]\" board is currently inactive.<br>Please contact the webmaster (".&Link("mailto:$EmailAddress","","").$EmailAddress."</a>".") for more information.");
		}
		if (($BoardInfo[6] ne "Public")&&($BoardInfo[6] eq "Protected")&&($Group eq "Guest")) {
			print "Location: UltraBoard.$Ext?Action=SignIn&Ref=ShowPost&Board=$in{'Board'}&Post=$in{'Post'}&Idle=$in{'Idle'}&Sort=$in{'Sort'}&Order=$in{'Order'}&Page=$in{'Page'}\n\n";
		}elsif ($BoardInfo[6] eq "Private") {
			require "$DBPath/$in{'Board'}/Access.db";
			if (!exists ($Access{$MemberData[3]})) {
				print "Location: UltraBoard.$Ext?Action=SignIn&Ref=ShowPost&Board=$in{'Board'}&Post=$in{'Post'}&Idle=$in{'Idle'}&Sort=$in{'Sort'}&Order=$in{'Order'}&Page=$in{'Page'}\n\n";
			}
		}
	}
###############################################################################
	open(POST,"$DBPath/$in{'Board'}/$in{'Post'}.post")||&CGIError("Couldn't open/read the $in{'Post'}.post file<br>\nPath: $DBPath/$in{'Board'}<br>\nReason : $!");
		flock(POST,1) if ($FLock);
		@POST_DATA=<POST>;
	close(POST);
	@PostInfo=&DecodeDBOutput($POST_DATA[0]);
	$Topic=$PostInfo[0];
	if (($PostInfo[2])&&(-e "$MembersPath/$PostInfo[2].info")) {
		@MemberInfo=&GetMemberData($PostInfo[2]);
	}
###############################################################################
	$Post.=	"Original Topic:";
    $Post.= "\n==================================================\n";
    $Post.= "Subject: $PostInfo[0]\n";
    $Post.= "Posted by ";
    if ($PostInfo[2]) {
				if ((!$PostInfo[1])) {
					 $Post.=	$MemberInfo[1];
				}else{
					 $Post.=	$PostInfo[1];
				}
		if ($MemberInfo[17] ne "") {
			$Post	.=	" ($MemberInfo[4])";
		}
    }else{
        $Post.=	$PostInfo[1];
    }
    $Post.= "\non ".&GetDate($PostInfo[5]);
    if (($ShowIP eq "YES")||(($ShowIP eq "YESAdmin")&&(($Group eq "administrator")||($Group eq $BoardInfo[4])))) {
		$Post.= " from ".$PostInfo[6];
	}
	$Post.= "\n==================================================\n";
	$PostInfo[7]=~s/\<p\>//g;
	$PostInfo[7]=~s/\<br\>//g;
    $Post.= &RemoveUBCodes($PostInfo[7]);
    if ($UseSignatures and $PostInfo[4] and $MemberInfo[15]) {
		$Post.= "\n\n--------------------\n";
		$MemberInfo[15]=~s/\<p\>//g;
		$MemberInfo[15]=~s/\<br\>//g;
		$Post.= &RemoveUBCodes($MemberInfo[15]);
	}   
    $Post.= "\n\n";
###############################################################################
    $Replies.=	"Replied Message:";
	for (my ($i)=2;$i<=$#POST_DATA;$i++) {
		$Replies.= "\n==================================================\n";
		@PostInfo=&DecodeDBOutput($POST_DATA[$i]);
		if (($PostInfo[2])&&(-e "$MembersPath/$PostInfo[2].info")) {
			@MemberInfo=&GetMemberData($PostInfo[2]);
		}
        $Table.=" - $PostInfo[0], Posted by ";
        $Replies.= ($i-1).") Subject: $PostInfo[0]\n";
        $Replies.= "Posted by ";
        if ($PostInfo[2]) {
						if ((!$PostInfo[1])) {
							 $Table.=	$MemberInfo[1];
							 $Replies.=	$MemberInfo[1];
						}else{
							 $Table.=	$PostInfo[1];
							 $Replies.=	$PostInfo[1];
						}
            #$Table.=	$PostInfo[1];
            #$Replies.=	$PostInfo[1];
			if ($MemberInfo[17] ne "") {
                $Table	.=	" ($MemberInfo[4])";
                $Replies.=	" ($MemberInfo[4])";
            }
        }else{
            $Table.=	$PostInfo[1];
            $Replies.=	$PostInfo[1];
        }
        $Table.=    "on ".&GetDate($PostInfo[5])."\n";
        $Replies.=  "\non ".&GetDate($PostInfo[5]);
        if (($ShowIP eq "YES")||(($ShowIP eq "YESAdmin")&&(($Group eq "administrator")||($Group eq $BoardInfo[4])))) {
            $Replies.= " from ".$PostInfo[6];
        }
		$Replies.= "\n==================================================\n";
		$PostInfo[7]=~s/\<p\>//g;
		$PostInfo[7]=~s/\<br\>//g;
        $Replies.= &RemoveUBCodes($PostInfo[7]);
        if ($UseSignatures and $PostInfo[3] and $MemberInfo[15]) {
            $Replies.= "\n\n--------------------\n";
			$MemberInfo[15]=~s/\<p\>//g;
			$MemberInfo[15]=~s/\<br\>//g;
			$Replies.= &RemoveUBCodes($MemberInfo[15]);
        }
		$Replies.= "\n\n";
	}
###############################################################################
	$Subject = $in{'Subject'};
	$Message .= "Hello, $in{'ToName'}\n\n";
	$Message .= "$in{'Message'}\n\n";
	$Message .= "From $in{'FromName'} ($in{'FromEmail'})\n\n";
	$Message .= "Following is the topic:\n";
	$Message .= "##################################################\n";	    
	$Message .=	$Post;
	if ($#POST_DATA>=2) {
		$Message .= "##################################################\n";
		$Message .= "Table Contents:\n";
		$Message .= "==================================================\n";
		$Message .= $Table."\n";
		$Message .= "##################################################\n";
		$Message .= $Replies;
	}
	$Message .= "##################################################\n";
	$Message .= "$UBName forum,\n";
	$Message .= "$URLSite\n";
	$Message .= "==================================================\n";
	$Message .= "Powered by UltraBoard 1.62\n";
	&SendMail($in{'FromEmail'},$Subject,$Message,$in{'ToEmail'});
###############################################################################
	&ShowThank(	"FORWARDED THE TOPIC",
				"The Topic has been sent to your friend $in{'ToName'} ($in{'ToEmail'}).\n",
				"3",
				"UltraBoard.$Ext?Action=ShowPost&Board=$in{'Board'}&Post=$in{'Post'}&Idle=$in{'Idle'}&Sort=$in{'Sort'}&Order=$in{'Order'}&Page=$in{'Page'}&Session=$SessionID"				
	);
	exit;
}
###############################################################################
1;# End of DoForwardTopic Function
###############################################################################