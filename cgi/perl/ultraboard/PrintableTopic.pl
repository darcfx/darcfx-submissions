###############################################################################
# PrintableTopic.pl                                                           #
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
# PrintableTopic                                                              #
###############################################################################
sub PrintableTopic {
	my ($HTML);
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
	if ($Group ne "administrator") {
		if ($BoardInfo[5] ne "Active") {
			&ShowError("ACCESS DENIED","The \"$BoardInfo[1]\" board is currently inactive.<br>Please contact the webmaster (".&Link("mailto:$EmailAddress","","").$EmailAddress."</a>".") for more information.");
		}
		if (($BoardInfo[6] ne "Public")&&($Group eq "Guest")) {
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
	$Post.=	"<b>$UBName</b><hr><b>Original Topic:</b><hr>";
            
    $Post.= &Font("","2","").
            "<b>$PostInfo[0]</b><br>".
            "Posted by ";
    if ($PostInfo[2]) {
        #$Post.=	$PostInfo[1];
				if ((!$PostInfo[1])) {
					$Post.=	$MemberInfo[1];
				}else{
					$Post.=	$PostInfo[1];
				}
        if ($MemberInfo[17] ne "") {
            $Post.=" ($MemberInfo[4])";
        }
    }else{
        $Post.=	$PostInfo[1];
    }
    $Post.= " on ".&GetDate($PostInfo[5]);
    if (($ShowIP eq "YES")||(($ShowIP eq "YESAdmin")&&(($Group eq "administrator")||($Group eq $BoardInfo[4])))) {
		$Post.= " from ".$PostInfo[6];
	}
	$Post.=		"<blockquote>".
				$PostInfo[7];
    if ($UseSignatures and $PostInfo[4] and $MemberInfo[15]) {
		$Post.=	"<hr>".
				$MemberInfo[15];
	}   
    $Post.=		"</blockquote>";
    $Post.= "</font>";
###############################################################################
	if (scalar(@POST_DATA)>2) {
		$Replies.=	"<b>Replied Message:</b><hr>";
		$Table.=	"<hr><b>Table Contents:</b><ul>";
	}
	for (my ($i)=2;$i<=$#POST_DATA;$i++) {
		@PostInfo=&DecodeDBOutput($POST_DATA[$i]);
		if (($PostInfo[2])&&(-e "$MembersPath/$PostInfo[2].info")) {
			@MemberInfo=&GetMemberData($PostInfo[2]);
		}
        $Table.="<li><b>$PostInfo[0]</b>, Posted by ";
        $Replies.=  &Font("","2","").
                    "<b>$PostInfo[0]</b><br>".
                    "Posted by ";

        if ($PostInfo[2]) {
						if ((!$PostInfo[1])) {
							$Table.=		$MemberInfo[1];
							$Replies.=	$MemberInfo[1];
						}else{
							$Table.=		$PostInfo[1];
							$Replies.=	$PostInfo[1];
						}
            #$Table.=	$PostInfo[1];
            #$Replies.=	$PostInfo[1];
            if ($MemberInfo[17] ne "") {
                $Table.=	" ($MemberInfo[4])";
                $Replies.=	" ($MemberInfo[4])";
            }
        }else{
            $Table.=	$PostInfo[1];
            $Replies.=	$PostInfo[1];
        }
        $Table.=    " on ".&GetDate($PostInfo[5]);
        $Replies.=  " on ".&GetDate($PostInfo[5]);
        if (($ShowIP eq "YES")||(($ShowIP eq "YESAdmin")&&(($Group eq "administrator")||($Group eq $BoardInfo[4])))) {
            $Replies.= " from ".$PostInfo[6];
        }
        $Replies.=  "<blockquote>".
                    $PostInfo[7];
        if ($UseSignatures and $PostInfo[3] and $MemberInfo[15]) {
            $Replies.=	"<hr>".
                    $MemberInfo[15];
        }   
        $Replies.=	"</blockquote>";
        $Replies.=  "</font>"."<hr>";
	}
###############################################################################
	$HTML.=	&Font("","2","").
			$Post.
            $Table.
            "</ul><hr>".
			$Replies.
                "Powered by UltraBoard 1.62".
            "</font>".
            "<hr>";
    print	&HTMLHeader().
			&Head("$UBName - $Topic (Printable Version)"). 
			&Body().
			$HTML.
			&CBody();
	exit;    
}
###############################################################################
1;# End of PrintableTopic Function
###############################################################################