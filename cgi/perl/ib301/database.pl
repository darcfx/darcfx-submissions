package database;
use strict;
#+-----------------------------------------------------------------+
#| Ikonboard v3 by Jarvis Entertainment Group, Inc.
#|
#| No parts of this script can be used outside Ikonboard without prior consent.
#|
#| More information available from <ib-license@jarvisgroup.net>
#| (c)2001 Jarvis Entertainment Group, Inc.
#| 
#| http://www.ikonboard.com
#|
#| Please Read the license for more information
#+-----------------------------------------------------------------+

BEGIN { 

        if (eval "require DBI") {
            $iB::EVAL->{DBI} = 'Yes';
            require DBI;
        }
       
        require 'functions.pm' or iB::install_error ( 'Could not load install_modules/functions.pm' );
 }


my $functions = functions->new();

sub new {
    my $pkg = shift;
    my $obj = { '_output' => undef, error => '' };
    bless $obj, $pkg;
    return $obj;
}


####################################################
# Print out the choices form
####################################################

sub form {
    my $obj = shift;

    my $select = "<select name='DB_DRIVER' class='forminput'><option value='DBM' selected>DBM Database</option><option value='mySQL'>mySQL Database</option><option value='pgSQL'>PostgreSQL Database</option>";

    # Lets print out the html
    return qq~
                  <form action='installer.$iB::EXT' method='post'>
                  <input type='hidden' name='act' value='database'>
                  <input type='hidden' name='DO'  value='1'>
                  <table cellspacing='0' cellpadding='4' width='100%' align='center' border='0'>
                  <tr>
                   <td class='ti' colspan='2'><span style='color:#CC0000'><u>Database set up</u></span></td>
                  </tr>
                  <tr>
                   <td class='t' colspan='2'>We now need to set up the database. Please select which database type you'd like to use. If selecting mySQL, you must have the required modules installed. The installer will check this.</td>
                  </tr>
                  <tr>
                   <td class='t'><b>Which database would you like to use?</b></td>
                   <td class='t' width='60%'>$select</select></td>
                  </tr>
                  <tr>
                    <td align='left' bgcolor='#8888AA'><input type='button' class='forminput' style='width:100' value=' << BACK ' onClick='window.location="installer.$iB::EXT?act=tar&DO=1&end=1"'></td>
                    <td align='right' bgcolor='#8888AA'><input type='submit' class='forminput' style='width:100' value=' PROCEED >> '></td>
                  </tr>
                  </table>
                  </form>
                ~;
}


####################################################
# SET UP DBM
####################################################

sub setup_dbm {
    my $obj = shift;

    # We don't have a lot to do at this stage, so lets just check to make
    # sure we can load the iDatabase/DBM.pm library without incident.

    require 'Sources/iDatabase/SQL.pm' or iB::install_error ( 'Could not load Sources/iDatabase/SQL.pm. Please make sure the module is there, use your browsers back button to try again' );

    # Add to the config file
    $iB::CONFIG->{DB_DRIVER}  = $iB::IN{'DB_DRIVER'};
    $iB::CONFIG->{DB_DIR}     = "$iB::CONFIG->{'IKON_DIR'}/Database";
    $functions->_write_config( $iB::CONFIG );

    return $obj->end_setup();
}

####################################################
# SET UP mySQL
####################################################

sub setup_mysql {
    my $obj = shift;

    # If we have submitted the form...

    if ($iB::IN{'create'}) {
        return $obj->_create_mysql();
    }

    $iB::CONFIG->{'DB_IP'}     ||= 'localhost';
    $iB::CONFIG->{'DB_PREFIX'} ||= 'ib_';

    # All we need do at this stage is produce a form
    # requesting more details

    return qq~
          <form action='installer.$iB::EXT' method='post'>
          <input type='hidden' name='act' value='database'>
          <input type='hidden' name='DB_DRIVER' value='mySQL'>
          <input type='hidden' name='DO'    value='1'>
          <input type='hidden' name='create'  value='1'>
          <table cellspacing='0' cellpadding='4' width='100%' align='center' border='0'>
          <tr>
           <td class='ti' colspan='2'><span style='color:#CC0000'><u>mySQL Set Up Information</u></span></td>
          </tr>
          <tr>
           <td class='t' colspan='2'>Before we can go any further, we need to know a few details about your mySQL set-up. You must have a mySQL user set up, and a mySQL database set up. If you are unsure of any of the requested information, please check with your web host.</td>
          </tr>
          <tr>
           <td class='t'><b>Your mySQL Username</b> [ Required ]</td>
           <td class='t'><input type='text' class='forminput' name='DB_USER' value='$iB::CONFIG->{'DB_USER'}'></td>
          </tr>
          <tr>
           <td class='t'><b>Your mySQL Password</b> [ Required ]</td>
           <td class='t'><input type='text' class='forminput' name='DB_PASS' value='$iB::CONFIG->{'DB_PASS'}'></td>
          </tr>
          <tr>
           <td class='t'><b>Your mySQL Database Name</b> [ Required ]</td>
           <td class='t'><input type='text' class='forminput' name='DB_NAME' value='$iB::CONFIG->{'DB_NAME'}'></td>
          </tr>
          <tr>
           <td class='t'><b>Your mySQL Database Server</b> [ Required ]</td>
           <td class='t'><input type='text' class='forminput' name='DB_IP' value='$iB::CONFIG->{'DB_IP'}'></td>
          </tr>
          <tr>
           <td class='t'><b>Port Number for DB Server</b> [ Optional ]<br>This can be left blank</td>
           <td class='t'><input type='text' class='forminput' name='DB_PORT' value='$iB::CONFIG->{'DB_PORT'}'></td>
          </tr>
          <tr>
           <td class='t'><b>Table Prefix (to allow multiple iB's in one database)</b> [ Optional ]<br>This can be left blank</td>
           <td class='t'><input type='text' class='forminput' name='DB_PREFIX' value='$iB::CONFIG->{'DB_PREFIX'}'></td>
          </tr>
          <tr>
           <td class='t'><b>Allow Ikonboard to create the needed tables?</b><br>You may choose 'No' and use phpMyAdmin to create the tables.<br>Use "/INSTALL_DATA/create_tables.txt" as your guide.</td>
           <td class='t'><select name='CREATE' class='forminput'><option value='y' selected>Yes</option><option value='n'>No, I have already created the iB tables</option></select></td>
          </tr>
          <tr>
            <td align='left' bgcolor='#8888AA'><input type='button' class='forminput' style='width:100' value=' << BACK ' onClick='window.location="installer.$iB::EXT?act=database&DO=0"'></td>
            <td align='right' bgcolor='#8888AA'><input type='submit' class='forminput' style='width:100' value=' PROCEED >> '></td>
          </tr>
          </table>
          </form>
        ~;
}


sub _create_mysql {
    my $obj = shift;

    my $errors  = 0;
    my $found   = 0;
    my @fatal_errors;
    my ($have_dbi, $have_dbd, $can_connect, $found_db);

    # Test for the DBI library

    if ($iB::EVAL->{DBI} eq 'no') {
        ++$errors;
        push @fatal_errors, "You must install the DBI suite of modules. Visit <a href='http://www.cpan.org' target='_blank'>CPAN</a> for more information.";
        $have_dbi = '<span style="color:red">NO</span>';
        goto 'ERRORS';
    } else {
        $have_dbi = 'Yes';
    }

    # Test for mySQL DBI::Driver
    $found = 0;
    my @drivers = DBI->available_drivers;
    for (my $d = 0; $d <= $#drivers; $d++) {
      $found = 1 if index($drivers[$d], "mysql") != -1;
    }
    unless ($found) {
        ++$errors;
        push @fatal_errors, "You must install the mySQL DBD driver.";
        $have_dbd = '<span style="color:red">NO</span>';
    } else {
        $have_dbd = 'Yes';
    }        

    # Test for connection
    $found = 0;
    my $dsn  = "DBI:mysql:$iB::IN{'DB_NAME'}:$iB::IN{'DB_IP'}";
    $dsn    .= ":$iB::IN{'DB_PORT'}" if $iB::IN{'DB_PORT'};

    my $dbh = DBI->connect($dsn, $iB::IN{'DB_USER'}, $iB::IN{'DB_PASS'});

    if ($DBI::errstr) {
        ++$errors;
        push @fatal_errors, "mySQL connection error: $DBI::errstr";
        goto 'ERRORS';
    } 

    my $sth = $dbh->prepare("show databases");
    $sth->execute;
    while (my @log = $sth->fetchrow_array) {
    	$found = 1 if $log[0] eq $iB::IN{'DB_NAME'};
    }
    unless ($found) {
        ++$errors;
        push @fatal_errors, "mySQL cannot locate the database called $iB::IN{'DB_NAME'}.";
        $found_db = '<span style="color:red">NO</span>';
        goto 'ERRORS';
    } else {
        $found_db = 'Yes';
    }

    # Grab the create_tables.txt file and set about
    # creating our tables.

    my @SQLS;
    if ($iB::IN{'CREATE'} eq 'y') {
        local $/ = undef;
        open (MYSQL, "$iB::CONFIG->{'IKON_DIR'}/INSTALL_DATA/mysql_schema.txt") || &iB::install_error( "Cannot locate the INSTALL_DATA/create_tables.txt file");
        @SQLS = split /\;\n/, <MYSQL>;
        close (MYSQL);
  
        for my $SQL (@SQLS) {
          next if $SQL =~ /^\s+$/;
          if ($iB::IN{'DB_PREFIX'} ne "ib_") {
            $SQL =~ s/CREATE TABLE ib_(\w+) \(/CREATE TABLE $iB::IN{'DB_PREFIX'}$1 (/ig;
          }
          $sth = $dbh->prepare($SQL);
          $sth->execute();
          if ($DBI::errstr) {
            ++$errors;
            push @fatal_errors, "mySQL create table error. $DBI::errstr ($SQL)";
          }
        }
    }
    $dbh->disconnect();

    $iB::CONFIG->{'DB_NAME'}   = $iB::IN{'DB_NAME'};
    $iB::CONFIG->{'DB_IP'}     = $iB::IN{'DB_IP'};
    $iB::CONFIG->{'DB_PORT'}   = $iB::IN{'DB_PORT'};
    $iB::CONFIG->{'DB_DRIVER'} = $iB::IN{'DB_DRIVER'};
    $iB::CONFIG->{'DB_DIR'}    = "$iB::CONFIG->{'IKON_DIR'}/Database";
    $iB::CONFIG->{'DB_USER'}   = $iB::IN{'DB_USER'};
    $iB::CONFIG->{'DB_PASS'}   = $iB::IN{'DB_PASS'};
    $iB::CONFIG->{'DB_PREFIX'} = $iB::IN{'DB_PREFIX'};

ERRORS:

    if ($errors) {
        my $htm = qq~
                  <table cellspacing='0' cellpadding='4' width='100%' align='center' border='0'>
                  <tr>
                   <td class='ti' colspan='2'><span style='color:#CC0000'><u>mySQL Database Creation Error</u></span></td>
                  </tr>
                  <tr>
                   <td class='t' colspan='2'>$errors error(s) were found trying to set up mySQL, please use go back to correct these errors</td>
                  </tr>
                  <tr>
                    <td class='t' colspan='2'><ul>
                  ~;

        for my $e (@fatal_errors) {
            $htm .= qq~<li>$e\n~;
        }

        $htm .= qq~
                    </ul>
                    </td>
                  <tr>
                    <td align='left' bgcolor='#8888AA' colspan='2'><input type='button' class='forminput' style='width:100' value=' << BACK ' onClick='history.go(-1)'></td>
                  </tr>
                  </table>
         ~;
        return $htm;
    }
    else {
        return $obj->end_setup();
    }
}

####################################################
# SET UP pgSQL By Infection
####################################################


sub setup_pgsql {
    my $obj = shift;

    # If we have submitted the form...

    if ($iB::IN{'create'}) {
        return $obj->_create_pgsql();
    }

    $iB::CONFIG->{'DB_IP'}     ||= 'localhost';
    $iB::CONFIG->{'DB_PREFIX'} ||= 'ib_';

    # All we need do at this stage is produce a form
    # requesting more details

    return qq~
          <form action='installer.$iB::EXT' method='post'>
          <input type='hidden' name='act' value='database'>
          <input type='hidden' name='DB_DRIVER' value='pgSQL'>
          <input type='hidden' name='DO'    value='1'>
          <input type='hidden' name='create'  value='1'>
          <table cellspacing='0' cellpadding='4' width='100%' align='center' border='0'>
          <tr>
           <td class='ti' colspan='2'><span style='color:#CC0000'><u>PostgreSQL Set Up Information</u></span></td>
          </tr>
          <tr>
           <td class='t' colspan='2'>Before we can go any further, we need to know a few details about your PostgeSQL set-up. You must have a PostgreSQL user set up, and a PostgreSQL database set up. If you are unsure of any of the requested information, please check with your web host.</td>
          </tr>
          <tr>
           <td class='t'><b>Your PostgreSQL Username</b> [ Required ]</td>
           <td class='t'><input type='text' class='forminput' name='DB_USER' value='$iB::CONFIG->{'DB_USER'}'></td>
          </tr>
          <tr>
           <td class='t'><b>Your PostgreSQL Password</b> [ Required ]</td>
           <td class='t'><input type='text' class='forminput' name='DB_PASS' value='$iB::CONFIG->{'DB_PASS'}'></td>
          </tr>
          <tr>
           <td class='t'><b>Your PostgreSQL Database Name</b> [ Required ]</td>
           <td class='t'><input type='text' class='forminput' name='DB_NAME' value='$iB::CONFIG->{'DB_NAME'}'></td>
          </tr>
          <tr>
           <td class='t'><b>Your PostgreSQL Database Server</b> [ Optional ]</td>
           <td class='t'><input type='text' class='forminput' name='DB_IP' value='$iB::CONFIG->{'DB_IP'}'></td>
          </tr>
          <tr>
           <td class='t'><b>Port Number for DB Server</b> [ Optional ]<br>This can be left blank</td>
           <td class='t'><input type='text' class='forminput' name='DB_PORT' value='$iB::CONFIG->{'DB_PORT'}'></td>
          </tr>
          <tr>
           <td class='t'><b>Table Prefix (to allow multiple iB's in one database)</b> [ Optional ]<br>This can be left blank</td>
           <td class='t'><input type='text' class='forminput' name='DB_PREFIX' value='$iB::CONFIG->{'DB_PREFIX'}'></td>
          </tr>
          <tr>
            <td align='left' bgcolor='#8888AA'><input type='button' class='forminput' style='width:100' value=' << BACK ' onClick='window.location="installer.$iB::EXT?act=database&DO=0"'></td>
            <td align='right' bgcolor='#8888AA'><input type='submit' class='forminput' style='width:100' value=' PROCEED >> '></td>
          </tr>
          </table>
          </form>
        ~;
}


sub _create_pgsql {
    my $obj = shift;

    my $errors  = 0;
    my $found   = 0;
    my @fatal_errors;
    my ($have_dbi, $have_dbd, $can_connect, $found_db, $sth);

    # Test for the DBI library
    eval "use DBI";
    if ($@) {
        ++$errors;
        push @fatal_errors, "You must install the DBI suite of modules. Visit <a href='www.cpan.org' target='_blank'>CPAN</a> for more information.";
        $have_dbi = '<span style="color:red">NO</span>';
    } else {
        $have_dbi = 'Yes';
    }

    # Test for pgSQL DBI::Driver
    $found = 0;
    my @drivers = DBI->available_drivers;

	foreach(@drivers){ # coolest
		if(/Pg/){
			$found = 1;
			last;
		}
	}
    unless ($found) {
        ++$errors;
        push @fatal_errors, "You must install the pgSQL DBD driver.";
        $have_dbd = '<span style="color:red">NO</span>';
    } else {
        $have_dbd = 'Yes';
    }        

    # Test for connection
    $found = 0;

    my $dsn  = "dbi:Pg:dbname=$iB::IN{'DB_NAME'}";
	$dsn    .= "\;host=$iB::IN{'DB_IP'}" if $iB::IN{'DB_IP'};
    $dsn    .= "\;port=$iB::IN{'DB_PORT'}" if $iB::IN{'DB_PORT'};

    my $dbh = DBI->connect("$dsn","$iB::IN{'DB_USER'}","$iB::IN{'DB_PASS'}",{});

    if (!$dbh) {
        ++$errors;
        push @fatal_errors, "pgSQL connection error: $DBI::errstr";
		push @fatal_errors, "Use psql for creating database \"$iB::IN{'DB_NAME'}\" before them" if($DBI::errstr=~/does not exist in the system catalog/);
        goto 'ERRORS';
    }

    # Grab the postgres_tables.txt file and set about
    # creating our tables.

    my @SQLS;
    {
        local $/ = undef;
        open (PGSQL, "$iB::CONFIG->{'IKON_DIR'}/INSTALL_DATA/postgres_schema.txt") || &iB::install_error( "Cannot locate the INSTALL_DATA/postgres_tables.txt file");
        @SQLS = split /\;\n/, <PGSQL>;
        close (MYSQL);
  
        for my $SQL (@SQLS) {
          next if $SQL =~ /^\s+$/;
          if ($iB::IN{'DB_PREFIX'} ne "ib_") {
            $SQL =~ s/CREATE TABLE ib_(\w+) \(/CREATE TABLE $iB::IN{'DB_PREFIX'}$1 (/ig;
          }
          $sth = $dbh->prepare($SQL);
          $sth->execute();
          if ($DBI::errstr) {
            ++$errors;
            push @fatal_errors, "pgSQL create table error. $DBI::errstr ($SQL)";
          }
        }
    }
    $dbh->disconnect();

    $iB::CONFIG->{'DB_NAME'}   = $iB::IN{'DB_NAME'};
    $iB::CONFIG->{'DB_IP'}     = $iB::IN{'DB_IP'};
    $iB::CONFIG->{'DB_PORT'}   = $iB::IN{'DB_PORT'};
    $iB::CONFIG->{'DB_DRIVER'} = $iB::IN{'DB_DRIVER'};
    $iB::CONFIG->{'DB_DIR'}    = "$iB::CONFIG->{'IKON_DIR'}/Database";
    $iB::CONFIG->{'DB_USER'}   = $iB::IN{'DB_USER'};
    $iB::CONFIG->{'DB_PASS'}   = $iB::IN{'DB_PASS'};
    $iB::CONFIG->{'DB_PREFIX'} = $iB::IN{'DB_PREFIX'};

ERRORS:

    if ($errors) {
        my $htm = qq~
                  <table cellspacing='0' cellpadding='4' width='100%' align='center' border='0'>
                  <tr>
                   <td class='ti' colspan='2'><span style='color:#CC0000'><u>postgreSQL Database Creation Error</u></span></td>
                  </tr>
                  <tr>
                   <td class='t' colspan='2'>$errors error(s) were found trying to set up SQL, please use go back to correct these errors</td>
                  </tr>
                  <tr>
                    <td class='t' colspan='2'><ul>
                  ~;

        for my $e (@fatal_errors) {
            $htm .= qq~<li>$e\n~;
        }
        $htm .= qq~
                    </ul>
                    </td>
                  <tr>
                    <td align='left' bgcolor='#8888AA' colspan='2'><input type='button' class='forminput' style='width:100' value=' << BACK ' onClick='history.go(-1)'></td>
                  </tr>
                  </table>
         ~;
        return $htm;
    }
    else {
        return $obj->end_setup();
    }
}





####################################################
# END OF SET UP
####################################################

sub end_setup {
    my $obj = shift;

    # Write the board info file...
    $functions->write_boardinfo( $iB::CONFIG );

    return qq~
                  <form action='installer.$iB::EXT' method='post'>
                  <input type='hidden' name='act' value='populate'>
                  <input type='hidden' name='DO'  value='0'>
                  <table cellspacing='0' cellpadding='4' width='100%' align='center' border='0'>
                  <tr>
                   <td class='ti' colspan='2'><span style='color:#CC0000'><u>Database set up Complete</u></span></td>
                  </tr>
                  <tr>
                   <td class='t' colspan='2'>The database set up procedure is now complete.<br><br>You may now proceed.</td>
                  </tr>
                  <tr>
                    <td align='left' bgcolor='#8888AA'><input type='button' class='forminput' style='width:100' value=' << BACK ' onClick='window.location="installer.$iB::EXT?act=database&DO=0"'></td>
                    <td align='right' bgcolor='#8888AA'><input type='submit' class='forminput' style='width:100' value=' PROCEED >> '></td>
                  </tr>
                  </table>
                  </form>
                ~;
}







1;