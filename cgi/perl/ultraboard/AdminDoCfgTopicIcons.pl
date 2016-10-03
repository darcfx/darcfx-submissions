###############################################################################
# AdminDoCfgStyle.pl                                                          #
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
# DoCfgTopicIcons                                                             #
###############################################################################
sub DoCfgTopicIcons {
    open(ICON,">$VarsPath/mIcons.txt")||&CGIError("Couldn't create/write the mIcons.txt file<br>\nPath: $VarsPath<br>\nReason : $!");
        flock(ICON,2) if ($FLock);
        for ($i=0;$i<=$in{'COUNT'};$i++) {
            if ($in{"ICON_ID_$i"} ne "") {
                $in{"ICON_ID_$i"}=~s/\s/_/isg;
                $in{"ICON_ID_$i"}=~s/\|\^\|/_/isg;
                $in{"ICON_ID_$i"}=~s/\W/_/isg;
                if ($in{'ICON_DEF'} eq $i) {
                    $Def=$in{'ICON_DEF'};
                }else{
                    $Def="";
                }
                print ICON $in{"ICON_ID_$i"}."|^|".$in{"ICON_DES_$i"}."|^|".$in{"ICON_URL_$i"}."|^|".$Def."\n";
            }
        }
        flock(ICON,8) if ($FLock);
    close(ICON);
###############################################################################
	&ShowThank(	"SAVED TOPIC ICONS CONFIGURATION",
				"Saved all the topic icons configurations.\n",
				"3",
				"UBAdmin.$Ext?Session=$SessionID"
	);
	exit;
}
###############################################################################
1;# End of DoCfgStyle Function
###############################################################################