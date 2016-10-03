###############################################################################
# AdminDoCfgGeneral.pl                                                        #
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
# DoCfgGeneral                                                                #
###############################################################################
sub DoCfgGeneral {
    &ShowError("SAVING PROBLEM","You forgot to fill the name of your home page.")   if (!$in{'SiteName'});
	&ShowError("SAVING PROBLEM","You forgot to fill the name of your forum.")       if (!$in{'UBName'});
    &ShowError("SAVING PROBLEM","You forgot to fill the rule of your sign up page.") if (($in{'UseRule'})&&(!$in{'Rule'}));


    $in{'CommentLength'}    =10     if ($in{'CommentLength'}<10);
    $in{'SignaturesLength'} =10     if ($in{'SignaturesLength'}<10);
    $in{'ModifyTime'}       =0      if (!$in{'ModifyTime'});
    $in{'MaxSubjectLen'}    =10     if ($in{'MaxSubjectLen'}<10);
    $in{'TopicDesLen'}      =10     if ($in{'TopicDesLen'}<10);
    if ($EmailFunction eq "") {
        $in{'ViewRegister'}     ="";
        $in{'VerifyReg'}        ="";
        $in{'NotifyRegister'}   ="";
        $in{'NotifyPost'}       ="";
        $in{'NotifyMembers'}    ="";
    }
###############################################################################
    $in{'SiteName'} =&ChangesChars($in{'SiteName'});
    $in{'UBName'}   =&ChangesChars($in{'UBName'});
    $in{'UBDes'}    =&ChangesChars($in{'UBDes'});
    @CensorWords    =split(/\s/,$in{'CensorWords'});
    @CensorWords    =&ChangesChars(@CensorWords);
	open(GENERAL,">$VarsPath/General.cfg")||&CGIError("Couldn't create/write the General.cfg file<br>\nPath: $VarsPath<br>\nReason : $!");
		flock(GENERAL,2) if ($FLock);
		print GENERAL<<FILE;
\$SiteName              =\"$in{'SiteName'}\";
\$UBName                =\"$in{'UBName'}\";
\$UBDes                 =\"$in{'UBDes'}\";

\$ShowTopics            =\"$in{'ShowTopics'}\";
\$SortTopics            =\"$in{'SortTopics'}\";
\$SortOrder             =\"$in{'SortOrder'}\";
\$NumPage               =\"$in{'NumPage'}\";
\$ShowTotal             =\"$in{'ShowTotal'}\";

\$DisplayFront          =\"$in{'DisplayFront'}\";
\$UseCategory           =\"$in{'UseCategory'}\";
\$DisplayCategoryDes    =\"$in{'DisplayCategoryDes'}\";
\$DisplayBoardDes       =\"$in{'DisplayBoardDes'}\";
\$ShowNumberMembers     =\"$in{'ShowNumberMembers'}\";
\$OnlyCategory          =\"$in{'OnlyCategory'}\";

\$AllowRegister         =\"$in{'AllowRegister'}\";
\$UseRule               =\"$in{'UseRule'}\";
\$DefaultGroup          =\"$in{'DefaultGroup'}\";
\$ViewRegister          =\"$in{'ViewRegister'}\";
\$VerifyReg             =\"$in{'VerifyReg'}\";
\$CheckEmail            =\"$in{'CheckEmail'}\";
\$NotifyRegister        =\"$in{'NotifyRegister'}\";
\$ShowEmail             =\"$in{'ShowEmail'}\";
\$UseSignatures         =\"$in{'UseSignatures'}\";
\$CommentLength         =\"$in{'CommentLength'}\";
\$SignaturesLength      =\"$in{'SignaturesLength'}\";

\$TrackIP               =\"$in{'TrackIP'}\";
\$ShowIP                =\"$in{'ShowIP'}\";

\$NotifyPost            =\"$in{'NotifyPost'}\";
\$NotifyMembers         =\"$in{'NotifyMembers'}\";
\$EditMessage           =\"$in{'EditMessage'}\";
\$ModifyTime            =\"$in{'ModifyTime'}\";
\$MaxSubjectLen         =\"$in{'MaxSubjectLen'}\";
\$TopicDesLen           =\"$in{'TopicDesLen'}\";
\$UBCodes               =\"$in{'UBCodes'}\";
\$UBMessageIcon         =\"$in{'UBMessageIcon'}\";
\$TextAreaType          =\"$in{'TextAreaType'}\";

\$CensorWords           =\"$in{'CensorWords'}\";

1;
FILE
		flock(GENERAL,8) if ($FLock);
	close(GENERAL);
    if ($in{'UseRule'}) {
        $in{'Rule'}=~s/\n\n/<p>\\n\\n/isg;
        $in{'Rule'}=~s/\n/<br>\\n/isg;
        open(RULE,">$VarsPath/Rule.txt")||&CGIError("Couldn't create/write the Rule.txt file<br>\nPath: $VarsPath<br>\nReason : $!");
            flock(RULE,2) if ($FLock);
                print RULE $in{'Rule'};
            flock(RULE,8) if ($FLock);
        close(RULE);
    }
###############################################################################
	&ShowThank(	"SAVED GENERAL CONFIGURATION",
				"Saved all the general configurations.\n",
				"3",
				"UBAdmin.$Ext?Session=$SessionID"
	);
	exit;
}
###############################################################################
1;# End of DoCfgGeneral Function
###############################################################################