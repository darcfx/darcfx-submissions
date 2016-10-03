#!/usr/bin/perl
###############################################################################
# Upgrade.pl                                                                  #
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

# 1.62 ########################################################################
# Variables                                                                   #
###############################################################################

$Spliter="\|\^\|";

$Ext="pl";

# if your server support flock() function, then put on
#$FLock="on";

# The database path of your UltraBoard 1.50
#$InportPath="";

# The database path of your UltraBoard 1.62
#$ExportPath="";

# The members path of your UltraBoard 1.62
#$ExportMembersPath="";

# The library path of your UltraBoard 1.62
$LibPath="./Sources/Libraries";

require "$LibPath/Crypt.pm";

&ParseForm;

if ($in{'Action'} eq "") {
    &Setting();
}elsif ($in{'Action'} eq "Upgrade") {
    &Upgrade();
}

###############################################################################
# Setting                                                                     #
###############################################################################
sub Setting {
    # Printing Absolute Paths Setup page...
    &Header();
    print "<form action=\"Upgrade.$Ext\" method=\"POST\">\n";
    print "<input type=\"Hidden\" name=\"Action\" value=\"Upgrade\">\n";
    &ToolBar();
    print<<HTML;
<table width="100%" border="0" cellspacing="0" cellpadding="5">
	<tr>
		<td width="100%" valign="top">
			<font face="Verdana" size="4" color="#0033CC"><b>Setting</b></font>
		</td>
	</tr>
</table>
<center><img src="http://www.ultrascripts.com/UltraBoard/Remote/Black.gif" width=100% height=1 border=0 alt=""></center>
<table width="100%" border="0" cellspacing="0" cellpadding="5">
	<tr>
		<td width="100%" bgcolor="white" valign="top">
			<font face="Verdana" size="2" color="#0033CC"><b>Database Path of UltraBoard 1.50b (required)</b></font><br>
			<font face="Verdana" size="1" color="Black">the absolute path of the directory where all the ultraboard 1.50b data files will be located. (e.g. "/home/yourdomain/cgi-bin/UltraBoard/UBData")</font><br>
			<input type="Text" name="InportPath" value="" size="60" style="width=100%" class="TextBox">
			<p>
			
			<font face="Verdana" size="2" color="#0033CC"><b>Database Path of UltraBoard 1.62b (required)</b></font><br>
			<font face="Verdana" size="1" color="Black">the absolute path of the directory where all the ultraboard 1.62b data files will be located. (e.g. "/home/yourdomain/cgi-bin/UltraBoard1.62/UBData")<br>DON'T USE THE SAME AS 1.50B</font><br>
			<input type="Text" name="ExportPath" value="" size="60" style="width=100%" class="TextBox">
			<p>
			
			<font face="Verdana" size="2" color="#0033CC"><b>Members Path of UltraBoard 1.62b (required)</b></font><br>
			<font face="Verdana" size="1" color="Black">the absolute path of the directory where all the ultraboard 1.62b members data files will be located. (e.g. "/home/yourdomain/cgi-bin/UltraBoard1.62/UBData/Members")<br>DON'T USE THE SAME AS 1.50B</font><br>
			<input type="Text" name="ExportMembersPath" value="" size="60" style="width=100%" class="TextBox">
			<p>
			
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="20"><input type="Checkbox" name="FLock" value="on" checked></td>
					<td width="100%">
						<font face="Verdana" size="2" color="#0033CC"><b>Use File Lock Function</b></font><br>
						<font face="Verdana" size="1" color="Black">if your server supports the flock() function, I suggest you to use this. otherwise the board can become corrupted when some people post an the same time.</font><br>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<center><img src="http://www.ultrascripts.com/UltraBoard/Remote/Black.gif" width=100% height=1 border=0 alt=""></center>
<table width="100%" border="0" cellspacing="0" cellpadding="5">
	<tr>
		<td width="100%" valign="top" align="right">
			<input type="Reset" value="Starting Over" style="background-color : 0033CC; color : FFFFFF; font-weight : bold; font-family : Verdana; font-size : 9pt;">
			<input type="Submit" value="Upgrade Now >" style="background-color : 0033CC; color : FFFFFF; font-weight : bold; font-family : Verdana; font-size : 9pt;">
		</td>
	</tr>
</table>
HTML
    &Footer();
    exit;
}

###############################################################################
# Upgrade                                                                     #
###############################################################################
sub Upgrade {
    # if your server support flock() function, then put on
    $FLock=$in{'Flock'};

    # The database path of your UltraBoard 1.50
    $InportPath=$in{'InportPath'};

    # The database path of your UltraBoard 1.62
    $ExportPath=$in{'ExportPath'};

    # The members path of your UltraBoard 1.62
    $ExportMembersPath=$in{'ExportMembersPath'};

    print "Content-type: text/html\n\n";
    #print "> Started Convert 1.50 Data to 1.6 Data<br>\n";
    #print "> Started to Convert Categories & Boards Data...<br>\n";
    # Convert Categories Data
    #print "> Getting 1.50 categories data...<br>\n";
    dbmopen (%DATA,"$InportPath/categories",0644) || print "! Couldn't open the $InportPath/categories database, Reason: $!<br>\n";
        flock (%DATA, 1) if ($FLock);
        @CATEGORIES = split (/\&\&/, $DATA{'_CATEGORIES'});
        foreach $Category (@CATEGORIES) {
            
            # Converting Categories Data... 
            $CategoryID=$Category;
            $CategoryID=~s/\s//g;
            $CategoryID=~s/\W//g;
           
            $CategoryName=&UnChangeChars($Category);

            # to 1.62 Data
            #print "> Printing 1.50 category ($CategoryID) data to 1.62 categories data file...<br>\n";
            open(CATEGORIES,">>$ExportPath/Categories.db") || print "! Couldn't write $ExportPath/Categories.db file, Reason: $!<br>\n";
                flock(CATEGORIES,2) if ($FLock);
                    print CATEGORIES &EncodeDBInput($CategoryID,$CategoryName,"");
                flock(CATEGORIES,8) if ($FLock);
            close(CATEGORIES);

            #print "> Printing 1.50 category ($CategoryID) data to 1.62 category ($CategoryID) data file...<br>\n";
            open(CATEGORY,">$ExportPath/$CategoryID.cat") || print "! Couldn't create/write $ExportPath/Categories.db file, Reason: $!<br>\n";
                flock(CATEGORY,2) if ($FLock);
                    print CATEGORY &EncodeDBInput($CategoryID,$CategoryName,"");
                flock(CATEGORY,8) if ($FLock);
            close(CATEGORY);

            @BOARDS = split (/\&\&/, $DATA{$Category});
            # Converting Board Data...
            #print "> Getting 1.50 boards data...<br>\n";
            dbmopen (%DATA2,"$InportPath/boards",0644) || print "! Couldn't open the $InportPath/boards database, Reason: $!<br>\n";
                foreach $BOARD (@BOARDS) {
                    @BOARDINFO = split(/\&\&/, $DATA2{$BOARD});
                    @BOARDINFO[0]=&UnChangeChars(@BOARDINFO[0]);
                    @BOARDINFO[1]=&UnChangeChars(@BOARDINFO[1]);

                    # to 1.62 Data
                    $InputLine=&EncodeDBInput($BOARD,@BOARDINFO[0],@BOARDINFO[1],$CategoryID,"","Active","Protected");
                    #print "> Printing 1.50 board ($BOARD) data to 1.62 boards data file...<br>\n";
                    open(BOARDS,">>$ExportPath/Boards.db") || print "! Couldn't write $ExportPath/Boards.db file, Reason: $!<br>\n";
                        flock(BOARDS,2) if ($FLock);
                        print BOARDS $InputLine;
                        flock(BOARDS,8) if ($FLock);
                    close(BOARDS);

                    #print "> Printing 1.50 board ($BOARD) data to 1.62 category ($CategoryID) data file...<br>\n";
                    open(CATEGORY,">>$ExportPath/$CategoryID.cat") || print "! Couldn't write $ExportPath/$CategoryID.cat, Reason: $!<br>\n";
                        flock(CATEGORY,2) if ($FLock);
                        print CATEGORY $InputLine;
                        flock(CATEGORY,8) if ($FLock);
                    close(CATEGORY);

                    # from 1.50 Data
                    
                    $InputDataToNewVersion="";
                    #$TotalTopicToNewVersion=0;
                    #$TotalPostToNewVersion=0;
                    #print "> Creating the $BOARD directory in 1.62...<br>\n";
                    mkdir("$ExportPath/$BOARD",0777);
                    dbmopen(%INFO, "$InportPath/info_$BOARD",0644) || print "! Couldn't open the $InportPath/info_$BOARD database, Reason: $!<br>\n";
                        for ($PostNum=0;$PostNum<$INFO{'_POSTS'};$PostNum++) {
                            #$TotalPostToNewVersion++ if ($INFO{$PostNum});
                            if ($INFO{$PostNum}=~/^MAIN/) {
                                
                                @POSTINFO=split(/\&\&/, $INFO{$PostNum});
                                @RepliesNum=split(/\|,\|/, @POSTINFO[2]);
                                $TotalReples=scalar(@RepliesNum);
                                @POSTINFO[11] = "" if (@POSTINFO[11] eq "0");
                                @POSTINFO[3]=&UnChangeChars(@POSTINFO[3]);
                                $InputDataToNewVersion.=&EncodeDBInput(
                                                            @POSTINFO[7],
                                                            $TotalTopicToNewVersion,
                                                            $TotalReples,							#How many replies
                                                            @POSTINFO[3],		                    #Subject
                                                            "",			                            #NickName
                                                            @POSTINFO[4],							#UserName
                                                            @POSTINFO[11],      					#Closed ?
                                                            "",                                     #Description of the message
                                                            ""                                      #Topic Icon
                                                        );
                                open(MESSAGE,"$InportPath/$BOARD/$PostNum.txt") || print "! Couldn't open/read $InportPath/$BOARD/$PostNum.txt file, Reason: $!<br>\n";
                                    flock(MESSAGE,1) if ($FLock);
                                    $Message=<MESSAGE>;
                                    $Message=~s/\<br\>/\n/g;
                                    $Message=&UnChangeChars($Message);
                                    $Message=&UnUBCode($Message);
                                close(MESSAGE);
                                open(POST,">$ExportPath/$BOARD/$TotalTopicToNewVersion.post") || print "! Couldn't create/write $ExportPath/$BOARD/$TotalTopicToNewVersion.post file, Reason: $!<br>\n";
                                    flock(POST,2) if ($FLock);
                                        $InLine=	&EncodeDBInput(
                                                        @POSTINFO[3],	                    					#Subject
                                                        "",		        										#NickName
                                                        @POSTINFO[4],											#UserName
                                                        @POSTINFO[8],											#Nodify member when someone reply their message
                                                        "on",			                						#Use Signarture in their message or not
                                                        @POSTINFO[6],											#Post Time
                                                        @POSTINFO[5]											#Host/IP Address
                                                    );
                                        chomp $InLine;		
                                        print POST	$InLine.$Spliter;
                                        print POST	&EncodeUBCodes($Message).$Spliter;                          #Message
                                        print POST	&EncodeDBInput(                            
                                                        @POSTINFO[11],      									#Closed ?
                                                        "",                                                     #Description of the message
                                                        @POSTINFO[10],                                          #Edited how many times
                                                        ""                                                      #Topic Icon
                                                    );                                                    
                                        print POST	&EncodeDBInput(
                                                        $TotalReples,"0",@POSTINFO[7]
                                                    );
                                        for ($n=0;$n<$TotalReples;$n++) {
                                            @REPLYINFO=split(/\&\&/, $INFO{@RepliesNum[$n]});
                                            open(MESSAGE,"$InportPath/$BOARD/".@RepliesNum[$n].".txt") || print "! Couldn't open/read $InportPath/$BOARD/".@RepliesNum[$n].".txt file, Reason: $!<br>\n";
                                                flock(MESSAGE,1) if ($FLock);
                                                $Message=<MESSAGE>;
                                                $Message=~s/\<br\>/\n/g;
                                                $Message=&UnChangeChars($Message);
                                                $Message=&UnUBCode($Message);
                                            close(MESSAGE);
                                            $Message=&UnChangeChars($Message);
                                            @REPLYINFO[3]=&UnChangeChars(@REPLYINFO[3]);
                                            $InLine=	&EncodeDBInput(
                                                            @REPLYINFO[3],   #Subject
                                                            "",              #NickName
                                                            @REPLYINFO[4],   #UserName
                                                            @REPLYINFO[8],   #Nodify member when someone reply their message
                                                            "on",            #Use Signarture in their message or not
                                                            @REPLYINFO[6],   #Post Time
                                                            @REPLYINFO[5]    #IP Address
                                                        );
                                            chomp $InLine;
                                            $InLine.=$Spliter.&EncodeUBCodes($Message).$Spliter.@REPLYINFO[10]."\n";
                                            print POST $InLine;
                                        }         
                                        
                                    flock(POST,8) if ($FLock);
                                close(POST);
                                $TotalTopicToNewVersion++;
                            }
                        }
                        open(BOARD,">$ExportPath/$BOARD/board.list") || print "! Couldn't create/write $ExportPath/$BOARD/board.list file, Reason: $!<br>\n";
                            flock(BOARD,2) if ($FLock);
                            print BOARD $InputLine;
                            print BOARD $InputDataToNewVersion;
                            flock(BOARD,8) if ($FLock);
                        close(BOARD);
                        open(COUNT,">$ExportPath/$BOARD/board.count") || print "! Couldn't create/write $ExportPath/$BOARD/board.count file, Reason: $!<br>\n";
                            #Post Number, Total Topics Number, Total Posts Number, Last Update Time
                            flock(COUNT,2) if ($FLock);
                            print COUNT $INFO{'_TOTALMAIN'}.$Spliter.$INFO{'_TOTALMAIN'}.$Spliter.$INFO{'_TOTAL'}.$Spliter.$INFO{'_LASTDATE'};
                            flock(COUNT,8) if ($FLock);
                        close(COUNT);
					dbmclose(%INFO);
                }
            dbmclose (%DATA2);
        }
    dbmclose (%DATA);

    #print "> Convering 1.50 Members Data to 1.62 Members Data<br>\n";

    dbmopen(%DATA,"$InportPath/users",0666) || print "! Couldn't open the $InportPath/users database, Reason: $!<br>\n";
        foreach $USERNAME (sort(keys(%DATA))){
            if (($USERNAME ne "\_TOTAL")&&(!($USERNAME=~/\_TOTAL$/))&&(!($USERNAME=~/\_REGDATE$/))&&(!($USERNAME=~/\_POSTDATE$/))&&(!($USERNAME=~/\_GROUP$/))&&(!($USERNAME=~/\_ACT$/))) {
                # from 1.50
                &GetUserInfo("$InportPath/members/$USERNAME.txt");
                $USERINFO{'Email'}=&UnChangeChars($USERINFO{'Email'});
                $USERINFO{'HomePage'}=&UnChangeChars($USERINFO{'HomePage'});
                $USERINFO{'Location'}=&UnChangeChars($USERINFO{'Location'});
                $USERINFO{'Occupation'}=&UnChangeChars($USERINFO{'Occupation'});
                $USERINFO{'Interests'}=&UnChangeChars($USERINFO{'Interests'});
                $USERINFO{'Signature'}=&UnChangeChars($USERINFO{'Signature'});
                $USERINFO{'Signature'}=&UnUBCode($USERINFO{'Signature'});
                $USERINFO{'Signature'}=~s/\<br\>/\n/g;

                # to 1.62
                $NewUserName=lc($USERNAME);
                $NewPassword=Crypt::crypt($DATA{$USERNAME},substr($NewUserName, 0, 2));
                if ($DATA{$USERNAME."_ACT"} eq "YES") {
                    $NewStatus="Activate";
                }else{
                    $NewStatus="Disactivate";
                }
                
                &SaveMemberData($NewUserName,
					$NewUserName,
					$USERNAME,
					$NewPassword,
					"members",
					$USERINFO{'Email'},
					$DATA{$USERNAME."_TOTAL"},
                    
					$NewStatus,
					$DATA{$USERNAME."_POSTDATE"},
					$USERINFO{'HomePage'},
					$USERINFO{'Location'},
					"",
					$USERINFO{'Occupation'},
					$USERINFO{'Interests'},
					$USERINFO{'ICQ'},
					"",
					$USERINFO{'Signature'},
					$DATA{$USERNAME."_REGDATE"},
					"on"
                );
                open(DB,">>$ExportMembersPath/members.grp") || print "! Couldn't write the $ExportMembersPath/members.grp database, Reason: $!<br>\n";
                    flock(DB,2) if ($FLock);
                    print DB $NewUserName."\n";
                    flock(DB,8) if ($FLock);
                close(DB);
            }
        }
        open(DB,">$ExportMembersPath/Members.total") || print "! Couldn't create/write the $ExportMembersPath/Members.total database, Reason: $!<br>\n";
            flock(DB,2) if ($FLock);
            print DB $DATA{"_TOTAL"};
            flock(DB,8) if ($FLock);
        close(DB);

    dbmclose (%DATA);
    &Conclusion;    
    exit;
}

###############################################################################
# Conclusion                                                                  #
###############################################################################
sub Conclusion {
    # Printing conclusion page...
    &Header("Setup.$Ext");
    &ToolBar();
    print<<HTML;
<table width="100%" border="0" cellspacing="0" cellpadding="5">
	<tr>
		<td width="100%" valign="top">
			<font face="Verdana" size="4" color="#0033CC"><b>Conclusion</b></font>
		</td>
	</tr>
</table>
<center><img src="http://www.ultrascripts.com/UltraBoard/Remote/Black.gif" width=100% height=1 border=0 alt=""></center>
<table width="100%" border="0" cellspacing="0" cellpadding="5">
	<tr>
		<td width="100%" bgcolor="white" valign="top">
            <font face="Verdana" size="2">
                <font face="Verdana" size="2" color="#0033CC"><b>Congratulations!</b></font><br>
                All the 1.50 data have been converted to 1.62 data directory, and are ready to run your <a href=\"Setup.$Ext\" target="_blank">UltraBoard 1.62 Setup</a>
                <p>
                
                <font face="Verdana" size="2" color="#0033CC"><b>Copyright Notice & Usage Disclaimer</b></font><br>
                <font face="Verdana" size="2">
                <font color="#0033CC"><b>Copyright Notice</b></font><br>
                This program is free software; you can change or modify it as you see fit. However, modified versions cannot be sold or distributed. You cannot alter the copyright and "powered by" notices throughout the scripts. These notices must be clearly visible to the end users.
                <p>
                <font color="#0033CC"><b>Usage Disclaimer</b></font><br>
                THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.
                </font>
            </font>
		</td>
	</tr>
</table>
<center><img src="http://www.ultrascripts.com/UltraBoard/Remote/Black.gif" width=100% height=1 border=0 alt=""></center>
<table width="100%" border="0" cellspacing="0" cellpadding="1" algin="right">
	<tr>
		<td width="100%" align="right">
            <font face="Verdana" size="1" color="#0033CC">
                copyright &copy; 1999 jacky yung. all rights reserved.
            </font>
        </td>
	</tr>
</table>
HTML
    &Footer();
    exit;
}

###############################################################################
# UltraBoard 1.62 Library Function ########################################## #
###############################################################################

# 1.62 ########################################################################
# SaveMemberData                                                              #
###############################################################################
sub SaveMemberData {
	my ($ID,@Input)=@_;
	$ID=lc($ID);
	my ($Temp, $Return);
	@Input=&DecodeHTML(@Input);
	$Input[15]=&DecodeUBCodes($Input[15]);
	$tmp=&EncodeUBCodes($Input[15]);
	@Input=&EncodeHTML(@Input);
	$Input[15]=$tmp;
	for (my ($i)=0;$i<=$#Input;$i++) {
		$Input[$i] =~ s/\r//g;
	}
	$Return = join ("\n",@Input);
	open(INFO,">$ExportMembersPath/$ID.info") || print "! Couldn't create/write the $ExportMembersPath/$ID.info database, Reason: $!<br>\n";
		flock(INFO,2) if ($FLock);
			print INFO $Return;
		flock(INFO,8) if ($FLock);
	close(INFO);
}

# 1.62 ########################################################################
# EncodeHTML                                                                  #
###############################################################################
sub EncodeHTML {
	my (@Encode) = @_;
	for (my($i)=0;$i<=$#Encode;$i++){
		$Encode[$i] =~ s/\</\&lt\;/g;
		$Encode[$i] =~ s/\>/\&gt\;/g;
		$Encode[$i] =~ s/\"/\&quot\;/g;
		$Encode[$i] =~ s/\'/\|APO\|/g;
		$Encode[$i] =~ s/\+/\|PLS\|/g;
		$Encode[$i] =~ s/\=/\|EQU\|/g;
		$Encode[$i] =~ s/\n\n/\<p\>\\n\\n/g;
		$Encode[$i] =~ s/\n/\<br\>\\n/g;
		$Encode[$i] =~ s/\s/\+/g;
		$Encode[$i] =~ s/\&/\&amp\;/g;
	}
	return wantarray ? @Encode : $Encode[0];
}

# 1.62 ########################################################################
# DecodeHTML                                                                  #
###############################################################################
sub DecodeHTML {
	my (@Decode) = @_;
	for (my($i)=0;$i<=$#Decode;$i++){
		$Decode[$i] =~ s/\&amp\;/\&/g;
		$Decode[$i] =~ s/\+/ /g;
		$Decode[$i] =~ s/\|EQU\|/\=/g;
		$Decode[$i] =~ s/\|PLS\|/\+/g;
		$Decode[$i] =~ s/\|APO\|/\'/g;
		$Decode[$i] =~ s/\&quot\;/\"/g;
		$Decode[$i]=~s/\\n/\n/g;
	}
	return wantarray ? @Decode : $Decode[0];
}

# 1.62 ########################################################################
# EncodeUBCodes                                                               #
###############################################################################
sub EncodeUBCodes {
	$_ = shift;
	
	$_ =~ s/\</\&lt\;/g;
	$_ =~ s/\>/\&gt\;/g;
	
	if ($UBCodes eq "on") {
		$_ =~ s/\\\\/\\<!--no-->/isg;
		$_ =~ s/\\\[/\[<!--no-->/isg;
		$_ =~ s/\\\]/<!--no-->\]/isg;
		$_ =~ s/\\\:/\:<!--no-->/isg;
		$_ =~ s/\\\;/\;<!--no-->/isg;
        $_ =~ s/\\\^/\;<!--no-->/isg;

		$_ =~ s/\\http:\/\/(\S+)/<a href=\"http:\/\/$1\"\ target=\"_blank\"><!--auto-->http:\/\/$1<\/a><!--auto-->/isg;

		$_ =~ s/\\(www.\S+)/<a href=\"http:\/\/$1\"\ target=\"_blank\"><!--autohttp-->http:\/\/$1<\/a><!--autohttp-->/isg;

		$_ =~ s/\\ftp:\/\/(\S+)/<a href=\"ftp:\/\/$1\"\ target=\"_blank\"><!--auto-->ftp:\/\/$1<\/a><!--auto-->/isg;

		$_ =~ s/\\(ftp.\S+)/<a href=\"ftp:\/\/$1\"\ target=\"_blank\"><!--autoftp-->ftp:\/\/$1<\/a><!--autoftp-->/isg;

		$_ =~ s/\\(\S+?)\@(\S+)/<a href=\"mailto:$1\@$2\"\><!--autoemail-->$1\@$2<\/a><!--autoemail-->/ig;

		$_ =~ s/\[img=(\S+?)\]/<img src=\"$1\" border=\"0\">/isg;

		$_ =~ s/\[url=http:\/\/(\S+?)\]/<!--http--><a href=\"http:\/\/$1\"\ target=\"_blank\">/isg;
		$_ =~ s/\[url=(\S+?)\]/<!--nohttp--><a href=\"http:\/\/$1\"\ target=\"_blank\">/isg;
		$_ =~ s/\[\/url\]/<\/a><!--url-->/isg;

		$_ =~ s/\[email=(\S+?)\]/<a href=\"mailto:$1\">/isg;
		$_ =~ s/\[\/email\]/<\/a><!--email-->/isg;

		$_ =~ s/\[b\]/<b>/isg;
		$_ =~ s/\[\/b\]/<\/b>/isg;

		$_ =~ s/\[i\]/<i>/isg;
		$_ =~ s/\[\/i\]/<\/i>/isg;

		$_ =~ s/\[u\]/<u>/isg;
		$_ =~ s/\[\/u\]/<\/u>/isg;

		$_ =~ s/\[1\]/<font size=\"1\">/isg;
		$_ =~ s/\[\/1\]/<\/font><!--1-->/isg;

		$_ =~ s/\[2\]/<font size=\"2\">/isg;
		$_ =~ s/\[\/2\]/<\/font><!--2-->/isg;

		$_ =~ s/\[3\]/<font size=\"3\">/isg;
		$_ =~ s/\[\/3\]/<\/font><!--3-->/isg;

		$_ =~ s/\[4\]/<font size=\"4\">/isg;
		$_ =~ s/\[\/4\]/<\/font><!--4-->/isg;

		$_ =~ s/\[fixed\]/<font face=\"Courier New\">/isg;
		$_ =~ s/\[\/fixed\]/<\/font><!--fixed-->/isg;

		$_ =~ s/\[sup\]/<sup>/isg;
		$_ =~ s/\[\/sup\]/<\/sup>/isg;

		$_ =~ s/\[sub\]/<sub>/isg;
		$_ =~ s/\[\/sub\]/<\/sub>/isg;

		$_ =~ s/\[center\]/<center>/isg;
		$_ =~ s/\[\/center\]/<\/center>/isg;

		$_ =~ s/\[color=(\S+?)\]/<font color=\"$1\">/isg;
		$_ =~ s/\[\/color\]/<\/font><!--color-->/isg;

		$_ =~ s/\[list\]/<li>/isg;

		$_ =~ s/\[pre\]/<pre>/isg;
		$_ =~ s/\[\/pre\]/<\/pre>/isg;

		#$_ =~ s/\[code\](.+?)\[\/code\]/<blockquote><font size=\"1\" face=\"$FontFace\">code:<\/font><hr><font face=\"Courier New\"><pre>$1<\/pre><\/font><hr><\/blockquote>/isg;
		
		#$_ =~ s/\[quote\]<br>(.+?)<br>\[\/quote\]/<blockquote><hr>$1<hr><\/blockquote>/isg;
		#$_ =~ s/\[quote\](.+?)\[\/quote\]/<blockquote><hr>$1<hr><\/blockquote>/isg;

		$_ =~ s/\:\-\)/<img src=\"$URLImages\/Happy.gif\" border=\"0\" align=\"middle\">/isg;
		$_ =~ s/\;\-\)/<img src=\"$URLImages\/Wilk.gif\" border=\"0\" align=\"middle\">/isg;
		$_ =~ s/\:\-\(/<img src=\"$URLImages\/Sad.gif\" border=\"0\" align=\"middle\">/isg;
		$_ =~ s/\:\-\D/<img src=\"$URLImages\/TooHappy.gif\" border=\"0\" align=\"middle\">/isg;

        $_ =~ s/\:\)/$imgEmotion_1<!--e1-->/isg if ($imgEmotion_1);
        $_ =~ s/\:\(/$imgEmotion_2<!--e2-->/isg if ($imgEmotion_2);
        $_ =~ s/\;\)/$imgEmotion_3<!--e3-->/isg if ($imgEmotion_3);
        $_ =~ s/\:\P/$imgEmotion_4<!--e4-->/isg if ($imgEmotion_4);
        $_ =~ s/\;\P/$imgEmotion_5<!--e5-->/isg if ($imgEmotion_5);
        $_ =~ s/\:\o\)/$imgEmotion_7<!--e7-->/isg if ($imgEmotion_7);
        $_ =~ s/\:\o/$imgEmotion_6<!--e6-->/isg if ($imgEmotion_6);
        $_ =~ s/\^\_\^/$imgEmotion_8<!--e8-->/isg if ($imgEmotion_8);
        $_ =~ s/\^\^\;/$imgEmotion_9<!--e9-->/isg if ($imgEmotion_9);
        $_ =~ s/\^\^/$imgEmotion_10<!--e10-->/isg if ($imgEmotion_10);

		$_ =~ s/\\c/\&copy\;<!--char-->/g;
		$_ =~ s/\\r/\&reg\;<!--char-->/g;
		$_ =~ s/\\tm/\&\#153\;<!--char-->/g;
	}
	$_ =~ s/\n\n/\<p\>\\n\\n/g;
	$_ =~ s/\n/\<br\>\\n/g;
	if ($UBCodes eq "on") {
		$_ =~ s/\[quote\]<br>(.+?)<br>\[\/quote\]/<blockquote><hr>$1<hr><\/blockquote>/isg;
		$_ =~ s/\[quote\]<br>(.+?)\[\/quote\]/<blockquote><hr>$1<hr><\/blockquote>/isg;
		$_ =~ s/\[quote\](.+?)<br>\[\/quote\]/<blockquote><hr>$1<hr><\/blockquote>/isg;
		$_ =~ s/\[quote\](.+?)\[\/quote\]/<blockquote><hr>$1<hr><\/blockquote>/isg;

		if ($_=~/\[code\](.+?)\[\/code\]/) {
			$tmp=$1;
			$tmp=~s/\<br\>//isg;
			$tmp=~s/\<p\>//isg;
		}
		$_=~s/\[code\](.+?)\[\/code\]/<blockquote><pre><font size=\"1\" face=\"$FontFace\">code:<\/font><hr><font face=\"Courier New\" size=\"$TextSize\">$tmp<\/font><hr><\/pre><\/blockquote>/isg;

		if ($_=~/\[pre\](.+?)\[\/pre\]/) {
			$tmp=$1;
			$tmp=~s/\<br\>//isg;
			$tmp=~s/\<p\>//isg;
		}
		#$_=~s/\[pre\](.+?)\[\/pre\]/<pre>$tmp<\/pre>/isg;
	}
	$_ =~ s/\"/\&quot\;/g;
	$_ =~ s/\'/\|APO\|/g;
	$_ =~ s/\+/\|PLS\|/g;
	$_ =~ s/\=/\|EQU\|/g;
	$_ =~ s/\s/\+/g;
	$_ =~ s/\&/\&amp\;/g;
	return $_;
}

# 1.62 ########################################################################
# DecodeUBCodes                                                               #
###############################################################################
sub DecodeUBCodes {
	$_ = shift;

	$_ =~ s/\&copy\;<!--char-->/\\c/g;
	$_ =~ s/\&reg\;<!--char-->/\\r/g;
	$_ =~ s/\&\#153\;<!--char-->/\\tm/g;
    
    $_ =~ s/$imgEmotion_10<!--e10-->/\^\^/isg if ($imgEmotion_10);
    $_ =~ s/$imgEmotion_9<!--e9-->/\^\^\;/isg if ($imgEmotion_9);
    $_ =~ s/$imgEmotion_8<!--e8-->/\^\_\^/isg if ($imgEmotion_8);
    $_ =~ s/$imgEmotion_6<!--e6-->/\:\o/isg if ($imgEmotion_6);
    $_ =~ s/$imgEmotion_7<!--e7-->/\:\o\)/isg if ($imgEmotion_7);
    $_ =~ s/$imgEmotion_5<!--e5-->/\;\P/isg if ($imgEmotion_5);
    $_ =~ s/$imgEmotion_4<!--e4-->/\:\P/isg if ($imgEmotion_4);
    $_ =~ s/$imgEmotion_3<!--e3-->/\;\)/isg if ($imgEmotion_3);
    $_ =~ s/$imgEmotion_2<!--e2-->/\:\(/isg if ($imgEmotion_2);
    $_ =~ s/$imgEmotion_1<!--e1-->/\:\)/isg if ($imgEmotion_1);

	$_ =~ s/<img src=\"$URLImages\/TooHappy.gif\" border=\"0\" align=\"middle\">/\:\-\D/isg;
	$_ =~ s/<img src=\"$URLImages\/Sad.gif\" border=\"0\" align=\"middle\">/\:\-\(/isg;
	$_ =~ s/<img src=\"$URLImages\/Wilk.gif\" border=\"0\" align=\"middle\">/\;\-\)/isg;
	$_ =~ s/<img src=\"$URLImages\/Happy.gif\" border=\"0\" align=\"middle\">/\:\-\)/isg;

	$_ =~ s/<blockquote><hr>(.+?)<hr><\/blockquote>/\[quote\]$1\[\/quote\]/isg;

	$_ =~ s/<blockquote><pre><font size=\"1\" face=\"$FontFace\">code:<\/font><hr><font face=\"Courier New\" size=\"\S+\">(.+?)<\/font><hr><\/pre><\/blockquote>/\[code\]$1\[\/code\]/isg;
	
	$_ =~ s/<\/pre>/\[\/pre\]/isg;
	$_ =~ s/<pre>/\[pre\]/isg;

	$_ =~ s/<li>/\[list\]/isg;

	$_ =~ s/<\/font><!--color-->/\[\/color\]/isg;
	$_ =~ s/<font color=\"(\S+?)\">/\[color=$1\]/isg;

	$_ =~ s/<\/center>/\[\/center\]/isg;
	$_ =~ s/<center>/\[center\]/isg;
	
	$_ =~ s/<\/sub>/\[\/sub\]/isg;
	$_ =~ s/<sub>/\[sub\]/isg;

	$_ =~ s/<\/sup>/\[\/sup\]/isg;
	$_ =~ s/<sup>/\[sup\]/isg;

	$_ =~ s/<\/font><!--fixed-->/\[\/fixed\]/isg;
	$_ =~ s/<font face=\"Courier New\">/\[fixed\]/isg;

	$_ =~ s/<\/font><!--4-->/\[\/4\]/isg;
	$_ =~ s/<font size=\"4\">/\[4\]/isg;

	$_ =~ s/<\/font><!--3-->/\[\/3\]/isg;
	$_ =~ s/<font size=\"3\">/\[3\]/isg;

	$_ =~ s/<\/font><!--2-->/\[\/2\]/isg;
	$_ =~ s/<font size=\"2\">/\[2\]/isg;

	$_ =~ s/<\/font><!--1-->/\[\/1\]/isg;
	$_ =~ s/<font size=\"1\">/\[1\]/isg;

	$_ =~ s/<\/u>/\[\/u\]/isg;
	$_ =~ s/<u>/\[u\]/isg;

	$_ =~ s/<\/i>/\[\/i\]/isg;
	$_ =~ s/<i>/\[i\]/isg;

	$_ =~ s/<\/b>/\[\/b\]/isg;
	$_ =~ s/<b>/\[b\]/isg;

	$_ =~ s/<a href=\"mailto:(\S+?)\"><!--autoemail-->\S+<\/a><!--autoemail-->/\\$1/isg;
		
	$_ =~ s/<a href=\"ftp:\/\/(\S+?)\" target=\"_blank\"><!--autoftp-->\S+<\/a><!--autoftp-->/\\$1/isg;

	$_ =~ s/<a href=\"(ftp:\/\/\S+?)\" target=\"_blank\"><!--auto-->\S+<\/a><!--auto-->/\\$1/isg;	
	
	$_ =~ s/<a href=\"http:\/\/(\S+?)\" target=\"_blank\"><!--autohttp-->\S+<\/a><!--autohttp-->/\\$1/isg;

	$_ =~ s/<a href=\"(http:\/\/\S+?)\" target=\"_blank\"><!--auto-->\S+<\/a><!--auto-->/\\$1/isg;
	
	$_ =~ s/<\/a><!--email-->/\[\/email\]/isg;
	$_ =~ s/<a href=\"mailto:(\S+?)\">/\[email=$1\]/isg;

	$_ =~ s/<\/a><!--url-->/\[\/url\]/isg;
	$_ =~ s/<!--nohttp--><a href=\"http:\/\/(\S+?)\" target=\"_blank\">/\[url=$1\]/isg;
	$_ =~ s/<!--http--><a href=\"(http:\/\/\S+?)\" target=\"_blank\">/\[url=$1\]/isg;

	$_ =~ s/<img src=\"(\S+?)\" border=\"0\">/\[img=$1\]/isg;

    $_ =~ s/\;<!--no-->/\\\^/isg;
	$_ =~ s/\;<!--no-->/\\\;/isg;
	$_ =~ s/\:<!--no-->/\\\:/isg;
	$_ =~ s/<!--no-->\]/\\\]/isg;
	$_ =~ s/\[<!--no-->/\\\[/isg;
	$_ =~ s/\\<!--no-->/\\\\/isg;
	
	$_ =~ s/\<p\>//isg;
	$_ =~ s/\<br\>//isg;
	$_ =~ s/\&lt\;/\</isg;
	$_ =~ s/\&gt\;/\>/isg;

	return $_;
}

# 1.62 ########################################################################
# EncodeDBInput                                                               #
###############################################################################
sub EncodeDBInput {
	my (@Input) = @_;
	my ($Temp, $Return);
	@Input=&EncodeHTML(@Input);
	for (@Input) {
		$Temp = $_;
		$Temp =~ s/\Q$Spliter\E/\|\&\^\&\|/g;
		$Temp =~ s/\r//g;
		$Return .= $Temp.$Spliter;
	}
	$Return =~ s/\Q$Spliter\E$//g;
	$Return .= "\n";
	return $Return;
}

# 1.62 ########################################################################
# DecodeDBOutput                                                              #
###############################################################################
sub DecodeDBOutput {
	my ($Output) = @_;
	my (@Outputs);
	chomp ($Output);
	@Outputs=split(/\Q$Spliter\E/, $Output);
	for (my($i)=0;$i<=$#Outputs;$i++){
		$Outputs[$i]=~s/\|\&\^\&\|/$Spliter/g;
	}
	@Outputs=&DecodeHTML(@Outputs);
	return wantarray ? @Outputs : $Outputs[0];
}

###############################################################################
# UltraBoard 1.50 Library Function ########################################## #
###############################################################################

# 1.50 ########################################################################
# ChangeChars                                                                 #
###############################################################################
sub ChangeChars {
	$_ = shift;
	$_ =~ s/\</\&lt\;/g;
	$_ =~ s/\>/\&gt\;/g;
	$_ =~ s/ /\|SPC\|/g;
	$_ =~ s/&/\|AMP\|/g;
	return $_;
}

# 1.50 ########################################################################
# UnChangeChars                                                               #
###############################################################################
sub UnChangeChars {
	$_ = shift;
	$_ =~ s/\|SPC\|/ /g;
	$_ =~ s/\|AMP\|/&/g;
	$_ =~ s/\|EQU\|/\=/g;
    #$_ =~ s/\&lt\;/\</g;
	#$_ =~ s/\&gt\;/\>/g;
	return $_;
}

# 1.50 ########################################################################
# GetUserInfo                                                                 #
###############################################################################
sub GetUserInfo {
	$_ = shift;
	local (@VALUE, $name, $value);
	open (FILE, $_);
		@VALUE = <FILE>;
		foreach $VALUE (@VALUE) {
			($name, $value) = split(/=/, $VALUE);
            chomp $value;
			$USERINFO{$name} = $value;
		}
	close (FILE);
}

# 1.50 ########################################################################
# UBCode                                                                      #
###############################################################################
sub UBCode {
	$_ = shift;
	$_ =~ s/\|AMP\|lt\;br\|AMP\|gt\;/\<br\>/g;
	if ($UBCodes eq "on") {
		if ($IsSignature ne "TRUE") {
			$_ =~ s/\[img=\"http\:\/\/(\S+?)\"\]/\<img src\=\"http:\/\/$1\"\>/g;
		}
		$_ =~ s/\[url=\"http:\/\/(\S+?)\"\]/<a href\=\"http:\/\/$1\"\ target=\"_blank\">/isg;
		$_ =~ s/\[url=\"mailto:(\S+?)\"\]/<a href\=\"mailto:$1\"\>/isg;
		$_ =~ s/\[b\]/\<b\>/isg;
		$_ =~ s/\[i\]/\<i\>/isg;
		$_ =~ s/\[sub\]/\<sub\>/isg;
		$_ =~ s/\[sup\]/\<sup\>/isg;
		$_ =~ s/\[h1\]/\<h1\>/isg;
		$_ =~ s/\[h2\]/\<h2\>/isg;
		$_ =~ s/\[h3\]/\<h3\>/isg;
		$_ =~ s/\[h4\]/\<h4\>/isg;
		$_ =~ s/\[h5\]/\<h5\>/isg;
		$_ =~ s/\[h6\]/\<h6\>/isg;
		$_ =~ s/\[color=\"(\S+?)\"\]/\<font color=\"$1\"\>/isg;
		$_ =~ s/\[right]/\<p align=\"right\"\>/isg;
		$_ =~ s/\[center\]/\<center>/isg;

		$_ =~ s/\[\/url\]/<\/a\>/isg;
		$_ =~ s/\[\/b\]/\<\/b\>/isg;
		$_ =~ s/\[\/i\]/\<\/i\>/isg;
		$_ =~ s/\[\/sub\]/\<\/sub\>/isg;
		$_ =~ s/\[\/sup\]/\<\/sup\>/isg;
		$_ =~ s/\[\/h1\]/\<\/h1\>/isg;
		$_ =~ s/\[\/h2\]/\<\/h2\>/isg;
		$_ =~ s/\[\/h3\]/\<\/h3\>/isg;
		$_ =~ s/\[\/h4\]/\<\/h4\>/isg;
		$_ =~ s/\[\/h5\]/\<\/h5\>/isg;
		$_ =~ s/\[\/h6\]/\<\/h6\>/isg;
		$_ =~ s/\[\/color\]/\<\/font\>/isg;
		$_ =~ s/\[\/right\]/\<\/p\>/isg;
		$_ =~ s/\[\/center\]/\<\/center\>/isg;
	}
	$_ =~ s/\=/\|EQU\|/g;
	return $_;
}

# 1.50 ########################################################################
# UnUBCode                                                                    #
###############################################################################
sub UnUBCode {
	$_ = shift;
	$_ =~ s/\<img src\=\"(\S+?)\"\>/\[img=$1\]/isg;
	$_ =~ s/\<a href\=\"http:\/\/(\S+?)\"\ target=\"_blank\">/\[url=http:\/\/$1\]/isg;
	$_ =~ s/\<a href\=\"mailto:(\S+?)\"\>/\[url=mailto:$1\]/isg;
	$_ =~ s/\<b\>/\[b\]/isg;
	$_ =~ s/\<i\>/\[i\]/isg;
	$_ =~ s/\<sub\>/\[sub\]/isg;
	$_ =~ s/\<sup\>/\[sup\]/isg;
	$_ =~ s/\<h1\>/\[4\]/isg;
	$_ =~ s/\<h2\>/\[4\]/isg;
	$_ =~ s/\<h3\>/\[4\]/isg;
	$_ =~ s/\<h4\>/\[3\]/isg;
	$_ =~ s/\<h5\>/\[2\]/isg;
	$_ =~ s/\<h6\>/\[1\]/isg;
	$_ =~ s/\<font color\=\"(\S+?)\"\>/\[color=$1\]/isg;
	$_ =~ s/\<p align=\"right\"\>/\[right]/isg;
	$_ =~ s/\<center>/\[center\]/isg;

	$_ =~ s/\<\/a\>/\[\/url\]/isg;
	$_ =~ s/\<\/b\>/\[\/b\]/isg;
	$_ =~ s/\<\/i\>/\[\/i\]/isg;
	$_ =~ s/\<\/sub\>/\[\/sub\]/isg;
	$_ =~ s/\<\/sup\>/\[\/sup\]/isg;
	$_ =~ s/\<\/h1\>/\[\/4\]/isg;
	$_ =~ s/\<\/h2\>/\[\/4\]/isg;
	$_ =~ s/\<\/h3\>/\[\/4\]/isg;
	$_ =~ s/\<\/h4\>/\[\/3\]/isg;
	$_ =~ s/\<\/h5\>/\[\/2\]/isg;
	$_ =~ s/\<\/h6\>/\[\/1\]/isg;
	$_ =~ s/\<\/font\>/\[\/color\]/isg;
	$_ =~ s/\<\/p\>/\[\/right\]/isg;
	$_ =~ s/\<\/center\>/\[\/center\]/isg;
	return $_;
}

###############################################################################
# Upgrade Script Library Function ########################################### #
###############################################################################

###############################################################################
# ToolBar                                                                     #
###############################################################################
sub ToolBar {
    print<<HTML;
<table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="Black">
	<tr><td>
		<table width="100%" border="0" cellspacing="1" cellpadding="0">
			<tr bgcolor="#0033CC"><td>
				<table width="100%" border="0" cellspacing="0" cellpadding="5">
					<tr><td>
						<font face="Verdana" size="1" color="#FFFFFF"><b>
							<a href="http://www.ultrascripts.com" class="Menu">Home</a> |
							<a href="http://www.ultrascripts.com/features.shtml" class="Menu">features</a> |
							<a href="http://www.ultrascripts.com/download.shtml" class="Menu">download</a> |
							<a href="http://www.ultrascripts.com/demos.shtml" class="Menu">demos</a> |
							<a href="http://www.ultrascripts.com/support.shtml" class="Menu">support</a> |
							<a href="http://www.ultrascripts.com/links.shtml" class="Menu">links</a> |
							<a href="http://www.ultrascripts.com/credits.shtml" class="Menu">credits</a> |
							<a href="http://www.ultrascripts.com/contactus.shtml" class="Menu">contact us</a>
						</b></font>
					</td></tr>
				</table>
			</td></tr>
			<tr bgcolor="#FFFFCC" ><td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td><img src="http://www.ultrascripts.com/UltraBoard/Remote/Index.gif" width=477 height=50 border=0 alt="UltraBoard Setup"></td>
						<td align="right"><img src="http://www.ultrascripts.com/UltraBoard/Remote/Speed.gif" width=93 height=50 border=0 alt="UltraBoard Setup"></td>
					</tr>
				</table>
			</td></tr>
		</table>
	</td></tr>
</table>
HTML
}

###############################################################################
# Header                                                                      #
###############################################################################
sub Header {
    $Redirect = $_[0];
    print "Content-type: text/html\n\n";
    if ($Redirect) {
        $Redirect="<meta http-equiv=\"REFRESH\" content=\"10; url=$Redirect\">";
    }	
    print<<HTML;
<html>
<head>
	<title>UltraBoard Setup</title>
    $Redirect
	<STYLE type="text/css">
	<!--
		A.Menu:Link {
			font-family : Verdana;
			font-size : xx-small;
			font-weight : bold;
			color : White;
			text-decoration : none;
		}
		A.Menu:Visited {
			font-family : Verdana;
			font-size : xx-small;
			font-weight : bold;
			color : White;
			text-decoration : none;
		}
		A.Menu:active {
			font-family : Verdana;
			font-size : xx-small;
			font-weight : bold;
			color : White;
			text-decoration : none;
		}
		A.Menu:hover {
			font-family : Verdana;
			font-size : xx-small;
			font-weight : bold;
			color : Yellow;
			text-decoration : none;
		}
        Input {
            font-family : Courier New;
		}
        TextArea {
            font-family : Courier New;
		}
	-->
	</STYLE>
</head>

<body bgcolor="White" text="Black" link="#0033CC" vlink="#FF3300" alink="#FF3300" leftmargin=8 topmargin=8>
HTML
}

###############################################################################
# Footer                                                                      #
###############################################################################
sub Footer {
    print<<HTML;
</form>
</body>
</html>
HTML
}

###############################################################################
# ParseForm                                                                   #
###############################################################################
sub ParseForm{
	my ($Buffer, @Pairs, $Pair, $Name, $Value);
	if($ENV{'REQUEST_METHOD'} eq "POST"){
    	read(STDIN, $Buffer, $ENV{'CONTENT_LENGTH'});
	}elsif($ENV{'REQUEST_METHOD'} eq "GET"){
		$Buffer=$ENV{'QUERY_STRING'};
	}
	@Pairs = split(/&/, $Buffer);
	foreach $Pair (@Pairs) {
		($Name, $Value) = split(/=/, $Pair);
		$Value =~ tr/+/ /;
		$Value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
		$Value =~ s/\r//g;
		$Value =~ s/^\s+//g;
		$Value =~ s/\s+$//g;
		$in{$Name} = $Value;
	}
}