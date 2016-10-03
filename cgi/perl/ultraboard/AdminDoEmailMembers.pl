###############################################################################
# AdminDoEmailMembers.pl                                                      #
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
# DoEmailMembers                                                              #
###############################################################################
sub DoEmailMembers {
	for ($i=0;$i<$in{'Count'};$i++) {
		if ($in{"MemberID_".$i}) {
			($MemberID, $MemberEmail)=split(/\Q$Spliter\E/,$in{"MemberID_".$i});
            &SendMail("$UBName Administrative Center <$EmailAddress>", $in{'Subject'}, $in{'Message'},$MemberEmail);
		}
	}
	&ShowThank(	"SENT TO THOSE MEMBERS",
				"Sent email to those members.",
				"3",
				"UBAdmin.$Ext?Action=ManageAccounts&Session=$SessionID"
	);
}
###############################################################################
1;# End of DoEmailMembers Function
###############################################################################