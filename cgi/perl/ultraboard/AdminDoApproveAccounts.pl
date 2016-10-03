###############################################################################
# AdminDoApproveAccounts.pl                                                   #
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
# DoApproveAccounts                                                           #
###############################################################################
sub DoApproveAccounts {
	if ($in{'Submit'} eq "APPROVE") {
		for (my ($i)=0;$i<$in{'Count'};$i++) {
			if ($in{"MemberID_".$i}) {
				@MemberInfo=&GetMemberData($in{"MemberID_".$i});
				$DisApproveAccounts.="\|".$in{"MemberID_".$i}."\|";
				if ($MemberInfo[2] eq "") {
					$NewPassword = &RandomPassword();
					$MemberInfo[2] = Crypt::crypt($NewPassword,substr($in{"MemberID_".$i}, 0, 2));
				}
				
				$MemberInfo[6] = "Activate";
				&SaveMemberData($in{"MemberID_".$i}, @MemberInfo);

				$Subject = "Registration information at $UBName ($URLSite)";
				$Message = "Hello, $MemberInfo[1]\n";
				$Message .= "Your have been approved!\n\n";
				if ($VerifyReg ne "") {
					$Message .= "Following is your login information:\n";
					$Message .= "------------------------------------\n";
					$Message .= "UserName: $MemberInfo[0]\n";
					$Message .= "Password: $NewPassword\n";	
					$Message .= "------------------------------------\n";
				}
				$Message .= "Thank you for registering our $UBName forum,\n";
				$Message .= "WebMaster, $UBName\n";
				$Message .= "$EmailAddress\n";
				$Message .= "$URLSite\n";
				$Message .= "------------------------------------\n";
				$Message .= "Powered by UltraScripts.com\n";
				&SendMail($EmailAddress,$Subject,$Message,$MemberInfo[4]);
			}
		}

		open(MEMBERS,"$MembersPath/Members.rev")||&CGIError("Couldn't open/read the Members.rev file<br>\nPath: $MembersPath<br>\nReason : $!");
			flock(MEMBERS,1) if ($FLock);
			@MEMBERS_DATA=<MEMBERS>;
		close(MEMBERS);
		for ($i=0;$i<=$#MEMBERS_DATA;$i++) {
			$MemberID=$MEMBERS_DATA[$i];
			chomp ($MemberID);
			if ($DisApproveAccounts=~/\|$MemberID\|/i) {
				$MEMBERS_DATA[$i]="";
			}
		}
		open(MEMBERS,">$MembersPath/Members.rev")||&CGIError("Couldn't create/write the Members.rev file<br>\nPath: $MembersPath<br>\nReason : $!");
			flock(MEMBERS,2) if ($FLock);
			print MEMBERS @MEMBERS_DATA;
			flock(MEMBERS,8) if ($FLock);
		close(MEMBERS);
		$Thank="APPROVED";
	}else{
		for (my ($i)=0;$i<$in{'Count'};$i++) {
			if ($in{"MemberID_".$i}) {
				@MemberInfo=&GetMemberData($in{"MemberID_".$i});
				$DisApproveAccounts.="\|".$in{"MemberID_".$i}."\|";
				open(DB,"$MembersPath/Members.total")||&CGIError("Couldn't open/read the Members.total file<br>\nPath: $MembersPath<br>\nReason : $!");
					flock(DB,1) if ($FLock);
					$TotalMembers=<DB>;
				close(DB);
				open(DB,">$MembersPath/Members.total")||&CGIError("Couldn't create/write the Members.total file<br>\nPath: $MembersPath<br>\nReason : $!");
					flock(DB,2) if ($FLock);
					print DB --$TotalMembers;
					flock(DB,8) if ($FLock);
				close(DB);

				open(GROUP,"$MembersPath/$MemberInfo[3].grp")||&CGIError("Couldn't read/open the $MemberInfo[3].grp file<br>\nPath: $MembersPath<br>\nReason : $!");
					flock(GROUP,1) if ($FLock);
					@GROUP_DATA=<GROUP>;
				close(GROUP);
				for ($i=1;$i<=$#GROUP_DATA;$i++) {
					$Group=$GROUP_DATA[$i];
					chomp($Group);
					if ($Group eq $MemberInfo[0]) {
						$GROUP_DATA[$i]="";
						last;
					}
				}
				open(GROUP,">$MembersPath/$MemberInfo[3].grp")||&CGIError("Couldn't create/write the $MemberInfo[3].grp file<br>\nPath: $MembersPath<br>\nReason : $!");
					flock(GROUP,2) if ($FLock);
					print GROUP @GROUP_DATA;
					flock(GROUP,8) if ($FLock);
				close(GROUP);

				unlink("$MembersPath/".$in{"MemberID_".$i}.".info");
			}
		}
		open(MEMBERS,"$MembersPath/Members.rev")||&CGIError("Couldn't open/read the Members.rev file<br>\nPath: $MembersPath<br>\nReason : $!");
			flock(MEMBERS,1) if ($FLock);
			@MEMBERS_DATA=<MEMBERS>;
		close(MEMBERS);
		for ($i=0;$i<=$#MEMBERS_DATA;$i++) {
			$MemberID=$MEMBERS_DATA[$i];
			chomp ($MemberID);
			if ($DisApproveAccounts=~/\|$MemberID\|/i) {
				$MEMBERS_DATA[$i]="";
			}
		}
		open(MEMBERS,">$MembersPath/Members.rev")||&CGIError("Couldn't create/write the Members.rev file<br>\nPath: $MembersPath<br>\nReason : $!");
			flock(MEMBERS,2) if ($FLock);
			print MEMBERS @MEMBERS_DATA;
			flock(MEMBERS,8) if ($FLock);
		close(MEMBERS);
		
		$Thank="DISAPPROVED";
	}
###############################################################################
	&ShowThank(	"$Thank THOSE MEMBERS ACCOUNT",
				"Those members account have been ".lc($Thank).".\n",
				"3",
				"UBAdmin.$Ext?Session=$SessionID"				
	);	
	exit;
}
###############################################################################
1;# End of DoApproveAccounts Function
###############################################################################