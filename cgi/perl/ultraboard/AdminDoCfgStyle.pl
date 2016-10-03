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
# DoCfgStyle                                                                  #
###############################################################################
sub DoCfgStyle {
    $in{'imgSite'}          =&ChangesChars($in{'imgSite'});
    $in{'imgHome'}          =&ChangesChars($in{'imgHome'});
    $in{'imgSignIn'}        =&ChangesChars($in{'imgSignIn'});
    $in{'imgSignOut'}       =&ChangesChars($in{'imgSignOut'});
    $in{'imgSignUp'}        =&ChangesChars($in{'imgSignUp'});
    $in{'imgModifyAccount'} =&ChangesChars($in{'imgModifyAccount'});
    $in{'imgHelp'}          =&ChangesChars($in{'imgHelp'});
    $in{'imgSearch'}        =&ChangesChars($in{'imgSearch'});
    $in{'imgAdmin'}         =&ChangesChars($in{'imgAdmin'});
    $in{'imgProfile'}       =&ChangesChars($in{'imgProfile'});
    $in{'imgEmail'}         =&ChangesChars($in{'imgEmail'});
    $in{'imgPost'}          =&ChangesChars($in{'imgPost'});
    $in{'imgReply'}         =&ChangesChars($in{'imgReply'});
    $in{'imgForward'}       =&ChangesChars($in{'imgForward'});
    $in{'imgPrint'}         =&ChangesChars($in{'imgPrint'});
    $in{'imgModify'}        =&ChangesChars($in{'imgModify'});
    $in{'imgRemove'}        =&ChangesChars($in{'imgRemove'});
    $in{'imgRemoveThread'}  =&ChangesChars($in{'imgRemoveThread'});
    $in{'imgCloseThread'}   =&ChangesChars($in{'imgCloseThread'});
    $in{'imgOpenThread'}    =&ChangesChars($in{'imgOpenThread'});
    $in{'imgPrevious'}      =&ChangesChars($in{'imgPrevious'});
    $in{'imgNext'}          =&ChangesChars($in{'imgNext'});
    $in{'imgSperater'}      =&ChangesChars($in{'imgSperater'});
    
    $in{'imgEmotion_1'}     =&ChangesChars($in{'imgEmotion_1'});
    $in{'imgEmotion_2'}     =&ChangesChars($in{'imgEmotion_2'});
    $in{'imgEmotion_3'}     =&ChangesChars($in{'imgEmotion_3'});
    $in{'imgEmotion_4'}     =&ChangesChars($in{'imgEmotion_4'});
    $in{'imgEmotion_5'}     =&ChangesChars($in{'imgEmotion_5'});
    $in{'imgEmotion_6'}     =&ChangesChars($in{'imgEmotion_6'});
    $in{'imgEmotion_7'}     =&ChangesChars($in{'imgEmotion_7'});
    $in{'imgEmotion_8'}     =&ChangesChars($in{'imgEmotion_8'});
    $in{'imgEmotion_9'}     =&ChangesChars($in{'imgEmotion_9'});
    $in{'imgEmotion_10'}    =&ChangesChars($in{'imgEmotion_10'});
    $in{'imgEmotion_11'}    =&ChangesChars($in{'imgEmotion_11'});
    $in{'imgEmotion_12'}    =&ChangesChars($in{'imgEmotion_12'});
    $in{'imgEmotion_13'}    =&ChangesChars($in{'imgEmotion_13'});
    $in{'imgEmotion_14'}    =&ChangesChars($in{'imgEmotion_14'});
    $in{'imgEmotion_15'}    =&ChangesChars($in{'imgEmotion_15'});
    
###############################################################################
	open(STYLE,">$VarsPath/Style.cfg")||&CGIError("Couldn't create/write the Style.cfg file<br>\nPath: $VarsPath<br>\nReason : $!");
		flock(STYLE,2) if ($FLock);
		print STYLE<<FILE;
\$TableWidth            =\"$in{'TableWidth'}\";
\$TableAlign            =\"CENTER\";
\$TableCellPadding      =\"$in{'TableCellPadding'}\";
\$TableCellSpacing      =\"$in{'TableCellSpacing'}\";
\$TableBorderColor      =\"$in{'TableBorderColor'}\";

\$RowOddBGColor         =\"$in{'RowOddBGColor'}\";
\$RowEvenBGColor        =\"$in{'RowEvenBGColor'}\";
\$ColumnOddBGColor      =\"$in{'ColumnOddBGColor'}\";
\$ColumnEvenBGColor     =\"$in{'ColumnEvenBGColor'}\";

\$FontFace              =\"$in{'FontFace'}\";
\$TextColor             =\"$in{'TextColor'}\";
\$TextSize              =\"$in{'TextSize'}\";

\$DateTextColor         =\"$in{'DateTextColor'}\";
\$TimeTextColor         =\"$in{'TimeTextColor'}\";
\$DateTextSize          =\"$in{'DateTextSize'}\";
\$TimeTextSize          =\"$in{'TimeTextSize'}\";

\$HeaderBGColor         =\"$in{'HeaderBGColor'}\";
\$HeaderTextColor       =\"$in{'HeaderTextColor'}\";
\$HeaderTextSize        =\"$in{'HeaderTextSize'}\";

\$CategoryBGColor       =\"$in{'CategoryBGColor'}\";
\$CategoryTextColor     =\"$in{'CategoryTextColor'}\";
\$CategoryNameTextSize  =\"$in{'CategoryNameTextSize'}\";
\$CategoryDesTextSize   =\"$in{'CategoryDesTextSize'}\";

\$BoardNameTextSize     =\"$in{'BoardNameTextSize'}\";
\$BoardDesTextSize      =\"$in{'BoardDesTextSize'}\";

\$MenuBGColor           =\"$in{'MenuBGColor'}\";
\$MenuTextColor         =\"$in{'MenuTextColor'}\";
\$MenuTextSize          =\"$in{'MenuTextSize'}\";

\$TextBoxSize           =\"$in{'TextBoxSize'}\";
\$IETextBoxSize         =\"$in{'IETextBoxSize'}\";

\$imgSite               =\"$in{'imgSite'}\";
\$imgHome               =\"$in{'imgHome'}\";
\$imgSignIn             =\"$in{'imgSignIn'}\";
\$imgSignOut            =\"$in{'imgSignOut'}\";
\$imgSignUp             =\"$in{'imgSignUp'}\";
\$imgModifyAccount      =\"$in{'imgModifyAccount'}\";
\$imgHelp               =\"$in{'imgHelp'}\";
\$imgSearch             =\"$in{'imgSearch'}\";
\$imgAdmin              =\"$in{'imgAdmin'}\";

\$imgProfile            =\"$in{'imgProfile'}\";
\$imgEmail              =\"$in{'imgEmail'}\";

\$imgPost               =\"$in{'imgPost'}\";
\$imgReply              =\"$in{'imgReply'}\";
\$imgForward            =\"$in{'imgForward'}\";
\$imgPrint              =\"$in{'imgPrint'}\";

\$imgModify             =\"$in{'imgModify'}\";
\$imgRemove             =\"$in{'imgRemove'}\";
\$imgRemoveThread       =\"$in{'imgRemoveThread'}\";
\$imgCloseThread        =\"$in{'imgCloseThread'}\";
\$imgOpenThread         =\"$in{'imgOpenThread'}\";

\$imgPrevious           =\"$in{'imgPrevious'}\";
\$imgNext               =\"$in{'imgNext'}\";

\$imgSperater           =\"$in{'imgSperater'}\";

\$imgEmotion_1          =\"$in{'imgEmotion_1'}\";
\$imgEmotion_2          =\"$in{'imgEmotion_2'}\";
\$imgEmotion_3          =\"$in{'imgEmotion_3'}\";
\$imgEmotion_4          =\"$in{'imgEmotion_4'}\";
\$imgEmotion_5          =\"$in{'imgEmotion_5'}\";
\$imgEmotion_6          =\"$in{'imgEmotion_6'}\";
\$imgEmotion_7          =\"$in{'imgEmotion_7'}\";
\$imgEmotion_8          =\"$in{'imgEmotion_8'}\";
\$imgEmotion_9          =\"$in{'imgEmotion_9'}\";
\$imgEmotion_10         =\"$in{'imgEmotion_10'}\";
\$imgEmotion_11         =\"$in{'imgEmotion_11'}\";
\$imgEmotion_12         =\"$in{'imgEmotion_12'}\";
\$imgEmotion_13         =\"$in{'imgEmotion_13'}\";
\$imgEmotion_14         =\"$in{'imgEmotion_14'}\";
\$imgEmotion_15         =\"$in{'imgEmotion_15'}\";
1;
FILE
		flock(STYLE,8) if ($FLock);
	close(STYLE);
###############################################################################
	&ShowThank(	"SAVED STYLE CONFIGURATION",
				"Saved all the style configurations.\n",
				"3",
				"UBAdmin.$Ext?Session=$SessionID"
	);
	exit;
}
###############################################################################
1;# End of DoCfgStyle Function
###############################################################################