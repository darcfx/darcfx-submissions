###############################################################################
# AdminDoActivateAccounts.pl                                                  #
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
# DoActivateAccounts                                                          #
###############################################################################
sub DoActivateAccounts {
	for (my ($i)=0;$i<$in{'Count'};$i++) {
		if ($in{"MemberID_".$i}) {
			@MemberInfo=&GetMemberData($in{"MemberID_".$i});
			if ($MemberInfo[6] eq "Disactivate") {
				$MemberInfo[6] = "Activate";
			}else{
				$MemberInfo[6] = "Disactivate";
			}
			&SaveMemberData($in{"MemberID_".$i}, @MemberInfo);
		}
	}
###############################################################################
	&ShowThank(	"ACTIVATED/DISACTIVATED THOSE MEMBERS ACCOUNT",
				"Those members account have been activated/disactivated.\n",
				"3",
				"UBAdmin.$Ext?Action=ManageAccounts&Session=$SessionID"				
	);	
	exit;
}
###############################################################################
1;# End of DoActivateAccounts Function
###############################################################################