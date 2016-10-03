#!/usr/bin/perl
package iB;

#
# Updates the tables for the RC.
#


#+------------------------------------------------------------------------------------------------------
#| Ikonboard by Matthew Mecham [ v3.0 ]
#| 
#| Script author: Nurlan Mukhanov (Infection)
#|
#| No parts of this script can be used outside Ikonboard without prior consent.
#| You must keep this header intact and all copyright links visable.
#| (c)2001 Ikonboard.com <http://www.ikonboard.com>
#|
#| Please Read the licence for more information.
#+------------------------------------------------------------------------------------------------------

use strict;

BEGIN {

    $iB::PTH = '.';
    
    #### Getting errors? Enter your path below!
    # Remeber to remove the comment first (# is a comment)
    
    
    #$iB::PTH = 'E:\inent\wwww\htdocs\ikonboard';
    
    
    unshift (@INC, "$iB::PTH");
    unshift (@INC, "$iB::PTH/Data");
    unshift (@INC, "$iB::PTH/Sources");
    unshift (@INC, "$iB::PTH/Skin");
    unshift (@INC, "$iB::PTH/Languages");
    unshift (@INC, "$iB::PTH/Sources/Lib");
    
}
#+------------------------------------------------------------------------------------------------------
use CGI;
use CGI::Carp "fatalsToBrowser";
$iB::Q = new CGI;
use DBI;
use Boardinfo;
$iB::INFO = Boardinfo->new();

### What are we doing?

if ($iB::Q->param('act') eq 'run') {
    iB::run();
} else {
    iB::show();
}




sub show {
    print $iB::Q->header();
    print $iB::Q->start_html();

    print qq~<b><font size=4>Alter Tables</font></b>
             <br><br><font size='3'>This convertor will update your PostgreSQL tables to the new format.</font>
             <a href='alter_table.cgi?act=run'>Run the upgrader</a>
            ~;
    print $iB::Q->end_html();
}


sub run {
    # Get the board info file.
    my $info = Boardinfo->new();
    
    # Get a DB connection
    
    $ENV{PGHOST} = $info->{'IP'} if($info->{'DB_IP'});
    $ENV{PGPORT} = $info->{'PORT'} if($info->{'DB_PORT'});

    my $dsn  = "dbi:Pg:dbname=$info->{'DB_NAME'}";

    my $dbh = DBI->connect($dsn, $info->{'DB_USER'}, $info->{'DB_PASS'},{});



    if ($DBI::errstr) {
        &errors("PostgreSQL connection error: $DBI::errstr");
    }
    
    my $pre = $info->{DB_PREFIX};
    
    print $iB::Q->header();
    print $iB::Q->start_html("Alter Table Output");

#    $dbh->{AutoCommit}=0;
#    $dbh->commit;


#---------------------------------------------------------------
#
# Altering table active_sessions
#
#---------------------------------------------------------------
            
    print "<b>Altering Table: ".$pre."active_sessions...</b><br><br>";

    $dbh->do("create table active_sessions_temp (
                                                    id               character varying(32) not null default '0',
                                                    member_name      character varying(32),
                                                    member_password  character varying(32),
                                                    member_id        character varying(32),
                                                    this_ip          character varying(16),
                                                    last_log_in      integer,
                                                    user_agent       character varying(64),
                                                    running_time     integer,
                                                    member_logstate  integer,
                                                    location         character varying(64),
                                                    log_in_type      integer,
                                                    member_group     integer)"
                                                 );

    $dbh->do("insert into active_sessions_temp select * from ".$pre."active_sessions");
    $dbh->do("drop table ".$pre."active_sessions");
    $dbh->do("alter table active_sessions_temp rename to ".$pre."active_sessions");
    $dbh->do("create index ".$pre."active_sessions_pkey on ".$pre."active_sessions(id)");

    &errors("PostgreSQL error: $DBI::errstr") if $DBI::errstr;
    print "Removed NOT NULL attribute from THIS_IP column<br>Removed NOT NULL attribute from USER_AGENT column";


#---------------------------------------------------------------
#
# Altering table address_books
#
#---------------------------------------------------------------
    
    print "<br><br><b>Altering Table: ".$pre."address_books...</b><br><br>";

    $dbh->do("create table address_books_temp (
                                            id               integer not null default '0',
                                            in_member_id     character varying(24) not null,
                                            member_id        character varying(24) not null,
                                            in_member_name   character varying(32) not null,
                                            receive_msg      integer,
                                            in_member_desc   character varying(48) default '')"
                                         );


    $dbh->do("insert into address_books_temp select * from ".$pre."address_books");
    $dbh->do("drop table ".$pre."address_books");
    $dbh->do("alter table address_books_temp rename to ".$pre."address_books");
    $dbh->do("create index ".$pre."address_books_pkey on ".$pre."address_books(id)");

    &errors("PostgreSQL error: $DBI::errstr") if $DBI::errstr;
    print "Removed NOT NULL attribute from IN_MEMBER_DESC column<br>";

#---------------------------------------------------------------
#
# Altering table authorisation
#
#--------------------------------------------------------------- 

    print "<br><b>Altering Table: ".$pre."authorisation...</b><br><br>";

    $dbh->do("create table authorisation_temp (
                                                  id             integer not null default '0',
                                                  unique_code    character varying(32) not null,
                                                  date_entered   integer not null default '0',
                                                  member_id      character varying(32) not null,
                                                  member_name    character varying(32) not null,
                                                  this_ip        character varying(16) default '',
                                                  member_email   character varying(128) not null,
                                                  _where         character varying(32) default '',
                                                  member_group   integer)"
                                              );

    $dbh->do("insert into authorisation_temp select * from ".$pre."authorisation");
    $dbh->do("drop table ".$pre."authorisation");
    $dbh->do("alter table authorisation_temp rename to ".$pre."authorisation");
    $dbh->do("create index ".$pre."authorisation_pkey on ".$pre."authorisation(id)");

    &errors("PostgreSQL error: $DBI::errstr") if $DBI::errstr;

    print "Removed NOT NULL attribute from THIS_IP column<br>";
    print "Removed NOT NULL attribute from _WHERE column, changed to varchar from char<br>";
    
#---------------------------------------------------------------
#
# Altering table categories
#
#---------------------------------------------------------------
  
    print "<br><b>Altering Table: ".$pre."categories...</b><br><br>";
    
    $dbh->do("create table categories_temp (
                                               cat_id       integer not null default '0',
                                               cat_pos      integer,
                                               cat_state    character varying(16),
                                               cat_name     character varying(128) not null,
                                               cat_desc     character varying(128) default '',
                                               sub_cat_id   character varying(16) default '',
                                               view         character varying(16),
                                               image        character varying(256),
                                               url          character varying(256))"
                                           );

    $dbh->do("insert into categories_temp select * from ".$pre."categories");
    $dbh->do("drop table ".$pre."categories");
    $dbh->do("alter table categories_temp rename to ".$pre."categories");
    $dbh->do("create index ".$pre."categories_pkey on ".$pre."categories(cat_id)");

    &errors("PostgreSQL error: $DBI::errstr") if $DBI::errstr;
    print "SUB_CAT_ID column changed to int(10)<br>";
    print "Added new column IMAGE<br>";
    print "Added new column URL<br>"; 


#---------------------------------------------------------------
#
# Altering table forum_moderators
#
#--------------------------------------------------------------- 
    
    print "<br><b>Altering Table: ".$pre."forum_moderators...</b><br><br>";
      
    $dbh->do("create table forum_moderators_temp (
                                                     moderator_id   integer not null default '0',
                                                     forum_id       integer not null default '0',
                                                     member_name    character varying(32) not null,
                                                     member_id      character varying(32) not null default '0',
                                                     edit_post      integer,
                                                     edit_topic     integer,
                                                     delete_post    integer,
                                                     delete_topic   integer,
                                                     view_ip        integer,
                                                     open_topic     integer,
                                                     close_topic    integer,
                                                     mass_move      integer,
                                                     mass_prune     integer,
                                                     move_topic     integer,
                                                     pin_topic      integer,
                                                     unpin_topic    integer,
                                                     post_q         integer,
                                                     topic_q        integer,
                                                     allow_warn     integer)"

                                                 );

    $dbh->do("insert into forum_moderators_temp select * from ".$pre."forum_moderators");
    $dbh->do("drop table ".$pre."forum_moderators");
    $dbh->do("alter table forum_moderators_temp rename to ".$pre."forum_moderators");
    $dbh->do("create index ".$pre."forum_moderators_pkey on ".$pre."forum_moderators(moderator_id)");

    &errors("PostgreSQL error: $DBI::errstr") if $DBI::errstr;

    print "Column's data type changed from smallint to integer<br>";
    
    
#---------------------------------------------------------------
#
# Altering table forum_rules
#
#---------------------------------------------------------------  
    
    print "<br><b>Altering Table: ".$pre."forum_rules...</b><br><br>";

    $dbh->do("create table forum_rules_temp (
                                                id            integer not null default '0',
                                                rules_title   character varying(128) not null,
                                                rules_text    text,
                                                last_update   integer,
                                                show_all      integer default '')"
                                             );

    $dbh->do("insert into forum_rules_temp select * from ".$pre."forum_rules");
    $dbh->do("drop table ".$pre."forum_rules");
    $dbh->do("alter table forum_rules_temp rename to ".$pre."forum_rules");
    $dbh->do("create index ".$pre."forum_rules_pkey on ".$pre."forum_rules(id)");

    &errors("PostgreSQL error: $DBI::errstr") if $DBI::errstr;
    print "SHOW_ALL column added to table<br>";
    

#---------------------------------------------------------------
#
# Altering table message_data
#
#--------------------------------------------------------------- 
      
    
    print "<br><b>Altering Table: ".$pre."message_data...</b><br><br>";


    $dbh->do("create table message_data_temp (
                                               message_id       integer not null default '0',
                                               date             integer,
                                               read_state       integer,
                                               title            character varying(128),
                                               message          text,
                                               message_icon     integer,
                                               from_id          character varying(32),
                                               from_name        character varying(32),
                                               reply            integer,
                                               reply_date       integer,
                                               virtual_dir      character varying(32),
                                               member_id        character varying(32),
                                               recipient_id     character varying(32) default '',
                                               recipient_name   character varying(32) default '')"
                                             );

    $dbh->do("insert into message_data_temp select * from ".$pre."message_data");
    $dbh->do("drop table ".$pre."message_data");
    $dbh->do("alter table message_data_temp rename to ".$pre."message_data");
    $dbh->do("create index ".$pre."message_data_pkey on ".$pre."message_data(message_id)");

    &errors("PostgreSQL error: $DBI::errstr") if $DBI::errstr;
    print "RECIPIENT_ID column added to table<br>";
    print "RECIPIENT_NAME column added to table<br>"; 
        
#---------------------------------------------------------------
#
# Altering table mem_groups
#
#--------------------------------------------------------------- 

    print "<br><b>Altering Table: ".$pre."mem_groups...</b><br><br>";

    $dbh->do("create table mem_groups_temp (
                                               id                   integer not null default '0',
                                               view_board           integer,
                                               mem_info             integer,
                                               other_topics         integer,
                                               use_search           integer,
                                               email_friend         integer,
                                               invite_friend        integer,
                                               edit_profile         integer,
                                               post_new_topics      integer,
                                               reply_own_topics     integer,
                                               reply_other_topics   integer,
                                               edit_own_posts       integer,
                                               delete_own_posts     integer,
                                               open_close_topics    integer,
                                               delete_own_topics    integer,
                                               post_polls           integer,
                                               vote_polls           integer,
                                               use_pm               integer,
                                               is_supmod            integer,
                                               access_cp            integer,
                                               title                character varying(32) not null,
                                               can_remove           integer,
                                               read_ad_logs         integer,
                                               delete_ad_logs       integer,
                                               edit_groups          integer,
                                               append_edit          integer,
                                               access_offline       integer,
                                               avoid_q              integer,
                                               avoid_flood          integer,
                                               team_icon            character varying(64) default '',
                                               attach_max           integer not null default '0')"
                                            );

    $dbh->do("insert into mem_groups_temp select * from ".$pre."mem_groups");
    $dbh->do("drop table ".$pre."mem_groups");
    $dbh->do("alter table mem_groups_temp rename to ".$pre."mem_groups");
    $dbh->do("create index ".$pre."mem_groups_pkey on ".$pre."mem_groups(id)");

    &errors("PostgreSQL error: $DBI::errstr") if $DBI::errstr;
    print "Removed NOT NULL attribute from TEAM_ICON column<br>";
    print "Removed NOT NULL attribute from ATTACH_MAX column<br>";


#---------------------------------------------------------------
#
# Altering table mem_groups
#
#--------------------------------------------------------------- 
    
    print "<br><b>Altering Table: ".$pre."mod_posts...</b><br><br>";

    $dbh->do("create table mod_posts_temp ( 
                                             id           integer not null default '0',
                                             author       character varying(128),
                                             ip_addr      character varying(32),
                                             post_date    integer,
                                             post         text,
                                             author_type  integer,
                                             topic_id     integer default '0',
                                             forum_id     integer default '0',
                                             type         character varying(16),
                                             post_id      integer,
                                             attach_id    integer default '')"
                                           );

    $dbh->do("insert into mod_posts_temp select * from ".$pre."mod_posts");
    $dbh->do("drop table ".$pre."mod_posts");
    $dbh->do("alter table mod_posts_temp rename to ".$pre."mod_posts");
    $dbh->do("create index ".$pre."mod_posts_pkey on ".$pre."mod_posts(id)");
  

    &errors("PostgreSQL error: $DBI::errstr") if $DBI::errstr;
    print "Removed NOT NULL attribute from ATTACH_ID column<br>";

#---------------------------------------------------------------
#
# Altering table forum_posts
#
#---------------------------------------------------------------

    print "<br><b>Altering Table: ".$pre."forum_posts...</b><br><br>";

    $dbh->do("create table forum_posts_temp ( 
                                             post_id       integer not null default '0',
                                             author        character varying(32),
                                             enable_sig    character varying(8),
                                             enable_emo    integer,
                                             ip_addr       character varying(16),
                                             post_date     integer,
                                             post_icon     integer,
                                             post          text,
                                             author_type   integer,
                                             queued        integer,
                                             topic_id      integer,
                                             forum_id      integer,
                                             attach_id     character varying(64),
                                             attach_hits   integer,
                                             attach_type   character varying(128))"
                                          );

    $dbh->do("insert into forum_posts_temp select * from ".$pre."forum_posts");
    $dbh->do("drop table ".$pre."forum_posts");
    $dbh->do("alter table forum_posts_temp rename to ".$pre."forum_posts");
    $dbh->do("create index ".$pre."forum_posts_pkey on ".$pre."forum_posts(post_id)");

    &errors("PostgreSQL error: $DBI::errstr") if $DBI::errstr;
    print "Numeric types changed to integer<br>";


#---------------------------------------------------------------
#
# Altering table member_titles
#
#---------------------------------------------------------------

    print "<br><b>Altering Table: ".$pre."member_titles...</b><br><br>";

    $dbh->do("create table member_titles_temp (
                                                id                integer not null,
                                                posts             integer,
                                                title             character varying(128),
                                                advance_group     integer,
                                                pips              character varying(64))"
                                              );

    $dbh->do("insert into member_titles_temp select * from ".$pre."member_titles");
    $dbh->do("drop table ".$pre."member_titles");
    $dbh->do("alter table member_titles_temp rename to ".$pre."member_titles");
    $dbh->do("create index ".$pre."member_titles_pkey on ".$pre."member_titles(id)");

    &errors("PostgreSQL error: $DBI::errstr") if $DBI::errstr;
    print "Integer type of PIPS changed to character varying(64)<br>";



#---------------------------------------------------------------
#
# Creating table calendar
#
#---------------------------------------------------------------

    print "<br><b>Creating Table: ".$pre."calendar...</b><br><br>";

    $dbh->do("create table ".$pre."calendar ( 
                                              member_id       character varying(32) not null,
                                              member_name     character varying(32) not null,
                                              day             integer not null,
                                              month           integer not null,
                                              year            integer not null,
                                              time_adjust     character varying(4),
                                              primary key     (member_id))"
                                          );
    &errors("PostgreSQL error: $DBI::errstr") if $DBI::errstr;
    print "Table ".$pre."calendar created<br>";

#    $dbh->{AutoCommit}=0;
    $dbh->disconnect;
    
    print "<br><b>All done, you may now remove this script</b>";   
                
    print $iB::Q->end_html();
    exit;
}



sub errors {
    my $error = shift;
    print $iB::Q->header();
    print $iB::Q->start_html("Fatal Errors");
    print "ERROR: $error";
    print $iB::Q->end_html();
    exit;
}



