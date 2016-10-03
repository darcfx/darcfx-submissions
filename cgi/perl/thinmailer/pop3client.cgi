#******************************************************************************
# $Id: POP3Client.pm,v 2.5 1999/12/19 18:35:07 sdowd Exp $
#
# Description:  POP3Client module - acts as interface to POP3 server
# Author:       Sean Dowd <pop3client@dowds.net>
#
# Copyright (c) 1999  Sean Dowd.  All rights reserved.
# This module is free software; you can redistribute it and/or modify
# it under the same terms as Perl itself.
#
#******************************************************************************

package pop3client;

use strict;
use Carp;
use IO::Socket;
use Config;

use vars qw($VERSION @ISA @EXPORT @EXPORT_OK);

require Exporter;

@ISA = qw(Exporter AutoLoader);
# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.
@EXPORT = qw(
	
);

my $ID =q( $Id: pop3client.cgi,v 2.5 1999/12/19 18:35:07 sdowd Exp $ );
$VERSION = substr q$Revision: 2.5 $, 10;


# Preloaded methods go here.

#******************************************************************************
#* constructor
#* new Mail::POP3Client( USER => user,
#*                       PASSWORD => pass,
#*                       HOST => host,
#*                       AUTH_MODE => [APOP|PASS],
#*                       TIMEOUT => 30,
#*                       DEBUG => 1 );
#* OR (deprecated)
#* new Mail::POP3Client( user, pass, host [, port, debug, auth_mode])
#******************************************************************************
sub new
{
  my $classname = shift;
  my $self = {
	      DEBUG => 0,
	      SERVER => "pop3",
	      PORT => 110,
	      COUNT => -1,
	      SIZE => -1,
	      ADDR => "",
	      STATE => 'DEAD',
	      MESG => 'OK',
	      BANNER => '',
	      MESG_ID => '',
	      AUTH_MODE => 'APOP',
	      EOL => "\015\012",
	      TIMEOUT => 60,
	      STRIPCR => 0,
	     };
  $Config{osname} =~ /MacOS/i && ($self->{STRIPCR} = 1);
  bless( $self, $classname );
  $self->_init( @_ );

  if ( $self->User() && $self->Pass() )
    {
      $self->Connect();
    }

  return $self;
}



#******************************************************************************
#* initialize - check for old-style params
#******************************************************************************
sub _init {
  my $self = shift;

  # if it looks like a hash
  if ( @_ && (scalar( @_ ) % 2 == 0) )
    {
      # ... and smells like a hash...
      my %hashargs = @_;
      if ( ( defined($hashargs{USER}) &&
	     defined($hashargs{PASSWORD}) ) ||
	   defined($hashargs{HOST})
	 )
	{
	  # ... then it must be a hash!  Push all values into my internal hash.
	  foreach my $key ( keys %hashargs )
	    {
	      $self->{$key} = $hashargs{$key};
	    }
	}
      else {$self->_initOldStyle( @_ );}
    }
  else {$self->_initOldStyle( @_ );}
}

#******************************************************************************
#* initialize using the old positional parameter style new - deprecated
#******************************************************************************
sub _initOldStyle {
  my $self = shift;
  $self->User( shift );
  $self->Pass( shift );
  my $host = shift;
  $host && $self->Host( $host );
  my $port = shift;
  $port && $self->Port( $port );
  my $debug = shift;
  $debug && $self->Debug( $debug );
  my $auth_mode = shift;
  $auth_mode && ($self->{AUTH_MODE} = $auth_mode);
}

#******************************************************************************
#* Is the socket alive?
#******************************************************************************
sub Version {
  return $VERSION;
}


#******************************************************************************
#* Is the socket alive?
#******************************************************************************
sub Alive
{
  my $me = shift;
  $me->State =~ /^AUTHORIZATION$|^TRANSACTION$/i;
} # end Alive


#******************************************************************************
#* What's the frequency Kenneth?
#******************************************************************************
sub State
{
  my $me = shift;
  my $stat = shift or return $me->{STATE};
  $me->{STATE} = $stat;
} # end Stat


#******************************************************************************
#* Got anything to say?
#******************************************************************************
sub Message
{
  my $me = shift;
  my $msg = shift or return $me->{MESG};
  $me->{MESG} = $msg;
} # end Message


#******************************************************************************
#* set/query debugging
#******************************************************************************
sub Debug
{
  my $me = shift;
  my $debug = shift or return $me->{DEBUG};
  $me->{DEBUG} = $debug;
  
} # end Debug


#******************************************************************************
#* set/query the port number
#******************************************************************************
sub Port
{
  my $me = shift;
  my $port = shift or return $me->{PORT};
  
  $me->{PORT} = $port;

} # end port


#******************************************************************************
#* set the host
#******************************************************************************
sub Host
{
  my $me = shift;
  my $host = shift or return $me->{HOST};

  $me->{INTERNET_ADDR} = inet_aton( $host ) or
    $me->Message( "Could not inet_aton: $host, $!") and return;
  $me->{HOST} = $host;
} # end host


#******************************************************************************
#* query the socket to use as a file handle
#******************************************************************************
sub Socket {
  my $me = shift;
  return $me->{'SOCKET'};
}


#******************************************************************************
#* set/query the USER
#******************************************************************************
sub User
{
  my $me = shift;
  my $user = shift or return $me->{USER};
  $me->{USER} = $user;
  
} # end User


#******************************************************************************
#* set/query the password
#******************************************************************************
sub Pass
{
  my $me = shift;
  my $pass = shift or return $me->{PASSWORD};
  $me->{PASSWORD} = $pass;
  
} # end Pass


#******************************************************************************
#* 
#******************************************************************************
sub Count
{
  my $me = shift;
  my $c = shift;
  if (defined $c and length($c) > 0) {
    $me->{COUNT} = $c;
  } else {
    return $me->{COUNT};
  }
    
} # end Count


#******************************************************************************
#* set/query the size of the mailbox
#******************************************************************************
sub Size
{
  my $me = shift;
  my $c = shift;
  if (defined $c and length($c) > 0) {
    $me->{SIZE} = $c;
  } else {
    return $me->{SIZE};
  }
  
} # end Size


#******************************************************************************
#* 
#******************************************************************************
sub EOL {
  my $me = shift;
  return $me->{'EOL'};
}


#******************************************************************************
#* 
#******************************************************************************
sub Close
{
  my $me = shift;
  if ($me->Alive()) {
    my $s = $me->Socket();
    $me->_sockprint( "QUIT", $me->EOL );
    close( $me->Socket() ) or $me->Message("close failed: $!") and return 0;
    $me->State('DEAD');
  }
  1;
} # end Close


#******************************************************************************
#* 
#******************************************************************************
sub DESTROY
{
  my $me = shift;
  $me->Close;
} # end DESTROY


#******************************************************************************
#* Connect to the specified POP server
#******************************************************************************
sub Connect
{
  my ($me, $host, $port) = @_;
  
  $host and $me->Host($host);
  $port and $me->Port($port);

  $me->Close();

  my $s = IO::Socket::INET->new( PeerAddr  => $me->Host(),
				 PeerPort  => $me->Port(),
				 Proto     => "tcp",
				 Type      => SOCK_STREAM,
				 Timeout   => $me->{TIMEOUT} )
    or 
      $me->Message( "could not connect socket [$me->{HOST}, $me->{PORT}]: $!" )
	and
	  return 0;
  $me->{SOCKET} = $s;

  $s->autoflush( 1 );
  
  defined(my $msg = $me->_sockread()) or $me->Message("Could not read") and return 0;
  chomp $msg;
  $me->{BANNER}= $msg;
  $me->{MESG_ID}= $1 if ($msg =~ /(<[\w\d\-\.]+\@[\w\d\-\.]+>)/);
  $me->Message($msg);
  $me->State('AUTHORIZATION');
  
  $me->User() and $me->Pass() and $me->Login();
  
} # end Connect


#******************************************************************************
#* login to the POP server.  If the AUTH_MODE is set to APOP an the
#* server supports it, it will use APOP.  Otherwise uid and password are
#* sent in clear text.
#******************************************************************************
sub Login
{
  my $me= shift;
  if ($me->{AUTH_MODE} eq 'APOP' && $me->{MESG_ID}) { $me->Login_APOP(); }
  else { $me->Login_Pass(); }
}


#******************************************************************************
#* login to the POP server using APOP (md5) authentication.
#******************************************************************************
sub Login_APOP
{
  require MD5;
  
  my $me = shift;
  my $s = $me->Socket();
  my $hash= MD5->hexhash ($me->{MESG_ID} . $me->Pass);
  
  $me->_sockprint( "APOP " , $me->User , ' ', $hash, $me->EOL );
  my $line = $me->_sockread();
  chomp $line;
  $me->Message($line);
  $line =~ /^\+OK/ or $me->Message("APOP failed: $line") and $me->State('AUTHORIZATION')
    and return 0;
  $me->State('TRANSACTION');
  
  $me->POPStat() or return 0;
}


#******************************************************************************
#* login to the POP server using simple (cleartext) authentication.
#******************************************************************************
sub Login_Pass
{
  my $me = shift;
  my $s = $me->Socket();
  $me->_sockprint( "USER " , $me->User() , $me->EOL );
  my $line = $me->_sockread();
  chomp $line;
  $me->Message($line);
  $line =~ /^\+/ or $me->Message("USER failed: $line") and $me->State('AUTHORIZATION')
    and return 0;
  
  $me->_sockprint( "PASS " , $me->Pass() , $me->EOL );
  $line = $me->_sockread();
  chomp $line;
  $me->Message($line);
  $line =~ /^\+OK/ or $me->Message("PASS failed: $line") and $me->State('AUTHORIZATION')
    and return 0;
  
  $me->State('TRANSACTION');

  $me->POPStat() or return 0;
  
} # end Login


#******************************************************************************
#* Get the Head of a message number.  If you give an optional number
#* of lines you will get the first n lines of the body also.  This
#* allows you to preview a message.
#******************************************************************************
sub Head
{
  my $me = shift;
  my $num = shift;
  my $lines = shift;
  $lines ||= 0;
  $lines =~ /\d+/ || ($lines = 0);
  my $header = '';
  my $s = $me->Socket();
  
  $me->_sockprint( "TOP $num $lines", $me->EOL );
  my $line = $me->_sockread();
  chomp $line;
  $line =~ /^\+OK/ or $me->Message("Bad return from TOP: $line") and return;
  $line =~ /^\+OK (\d+) / and my $buflen = $1;
  
  while (1) {
    $line = $me->_sockread();
    last if $line =~ /^\.\s*$/;
    $line =~ s/^\.\././;
    $header .= $line;
  }
  
  return wantarray ? split(/\r?\n/, $header) : $header;
} # end Head


#******************************************************************************
#* Get the header and body of a message
#******************************************************************************
sub HeadAndBody
{
  my $me = shift;
  my $num = shift;
  my $mandb = '';
  my $s = $me->Socket();
  
  $me->_sockprint( "RETR $num", $me->EOL );
  my $line = $me->_sockread();
  chomp $line;
  $line =~ /^\+OK/ or $me->Message("Bad return from RETR: $line") and return;
  $line =~ /^\+OK (\d+) / and my $buflen = $1;
  
  while (1) {
    $line = $me->_sockread();
    last if $line =~ /^\.\s*$/;
    # convert any '..' at the start of a line to '.'  
    $line =~ s/^\.\././;  
    $mandb .= $line;  
  } 
  
  return wantarray ? split(/\r?\n/, $mandb) : $mandb;
  
} # end HeadAndBody


#******************************************************************************
#* get the body of a message
#******************************************************************************
sub Body
{
  my $me = shift;
  my $num = shift;
  my $body = '';
  my $s = $me->Socket();
  
  $me->_sockprint( "RETR $num", $me->EOL );
  my $line = $me->_sockread();
  chomp $line;
  $line =~ /^\+OK/ or $me->Message("Bad return from RETR: $line") and return;
  $line =~ /^\+OK (\d+) / and my $buflen = $1;
  
  # skip the header
  do {
    $line = $me->_sockread();
  } until $line =~ /^\s*$/;
  
  while (1) {
    $line = $me->_sockread();
    last if $line =~ /^\.\s*$/;
    # convert any '..' at the start of a line to '.'  
    $line =~ s/^\.\././;  
    $body .= $line;  
  } 
  
  return wantarray ? split(/\r?\n/, $body) : $body;
  
} # end Body


#******************************************************************************
#* handle a STAT command - returns the number of messages in the box
#******************************************************************************
sub POPStat {
  my $me = shift;
  my $s = $me->Socket();
  
  $me->_sockprint( "STAT", $me->EOL );
  my $line = $me->_sockread();
  $line =~ /^\+OK/ or $me->Message("STAT failed: $line") and return -1;
  $line =~ /^\+OK (\d+) (\d+)/ and $me->Count($1), $me->Size($2);
  
  return $me->Count();
}


#******************************************************************************
#* issue the LIST command
#******************************************************************************
sub List {
  my $me = shift;
  my $num = shift || '';
  my $CMD = shift || 'LIST';
  $CMD=~ tr/a-z/A-Z/;
  
  my $s = $me->Socket();
  $me->Alive() or return;
  
  my @retarray = ();
  my $ret = '';
  
  $me->_sockprint( "$CMD $num", $me->EOL );
  my $line = $me->_sockread();
  $line =~ /^\+OK/ or $me->Message("$line") and return;
  if ($num) {
    $line =~ s/^\+OK\s*//;
    return $line;
  }
  while( defined( $line = $me->_sockread() ) ) {
    $line =~ /^\.\s*$/ and last;
    $ret .= $line;
    chomp $line;
    push(@retarray, $line);
  }
  if ($ret) {
    return wantarray ? @retarray : $ret;
  }
}

#******************************************************************************
#* issue the LIST command, but return results in an indexed array.
#******************************************************************************
sub ListArray {
  my $me = shift;
  my $num = shift || '';
  my $CMD = shift || 'LIST';
  $CMD=~ tr/a-z/A-Z/;
  
  my $s = $me->Socket();
  $me->Alive() or return;
  
  my @retarray = ();
  my $ret = '';
  
  $me->_sockprint( "$CMD $num", $me->EOL );
  my $line = $me->_sockread();
  $line =~ /^\+OK/ or $me->Message("$line") and return;
  if ($num) {
    $line =~ s/^\+OK\s*//;
    return $line;
  }
  while( defined( $line = $me->_sockread() ) ) {
    $line =~ /^\.\s*$/ and last;
    $ret .= $line;
    chomp $line;
    my ($num, $uidl) = split ' ', $line;
    $retarray[$num] = $uidl;
  }
  if ($ret) {
    return wantarray ? @retarray : $ret;
  }
}


#******************************************************************************
#* retrieve the given message number - uses HeadAndBody
#******************************************************************************
sub Retrieve {
  return HeadAndBody( @_ );
}


#******************************************************************************
#* implement the LAST command - see the rfc (1081) OBSOLETED by RFC
#******************************************************************************
sub Last {
  my $me = shift;
  
  my $s = $me->Socket();
  
  $me->_sockprint( "LAST", $me->EOL );
  my $line = $me->_sockread();
  
  $line =~ /\+OK (\d+)\D*$/ and return $1;
}


#******************************************************************************
#* reset the deletion stat
#******************************************************************************
sub Reset {
  my $me = shift;
  
  my $s = $me->Socket();
  $me->_sockprint( "RSET", $me->EOL );
  my $line = $me->_sockread();
  $line =~ /\+OK .*$/ and return 1;
  return 0;
}


#******************************************************************************
#* delete the given message number
#******************************************************************************
sub Delete {
  my $me = shift;
  my $num = shift || return;
  
  my $s = $me->Socket();
  $me->_sockprint( "DELE $num",  $me->EOL );
  my $line = $me->_sockread();
  $me->Message($line);
  $line =~ /^\+OK / && return 1;
  return 0;
}


#******************************************************************************
#* UIDL - submitted by Dion Almaer (dion@member.com)
#******************************************************************************
sub Uidl {
  my $me = shift;
  my $num = shift || '';
  
  my $s = $me->Socket();
  $me->Alive() or return;
  
  my @retarray = ();
  my $ret = '';
  
  $me->_sockprint( "UIDL $num", $me->EOL );
  my $line = $me->_sockread();
  $line =~ /^\+OK/ or $me->Message($line) and return;
  if ($num) {
    $line =~ s/^\+OK\s*//;
    return $line;
  }
  while( defined( $line = $me->_sockread() ) ) {
    $line =~ /^\.\s*$/ and last;
    $ret .= $line;
    chomp $line;
    my ($num, $uidl) = split ' ', $line;
    $retarray[$num] = $uidl;
  }
  if ($ret) {
    return wantarray ? @retarray : $ret;
  }
}



#*****************************************************************************
#* funnel all read/write through here to allow easier debugging
#* (mitra@earth.path.net)
#*****************************************************************************
sub _sockprint
{
  my $me = shift;
  my $s = $me->Socket();
  $me->Debug and carp "POP3 -> ", @_;
  print $s @_;
}

sub _sockread
{
  my $me = shift;
  my $line = $me->Socket()->getline();

  # Macs seem to leave CR's or LF's sitting on the socket.  This
  # removes them.
  $me->{STRIPCR} && ($line =~ s/^[\r]+//);
  
  $me->Debug and carp "POP3 <- ", $line;
  return $line;
}


# end package Mail::POP3Client

# Autoload methods go after =cut, and are processed by the autosplit program.

1;
__END__



################################################################################
# POD Documentation (perldoc Mail::POP3Client or pod2html this_file)
################################################################################

=head1 NAME

Mail::POP3Client - Perl 5 module to talk to a POP3 (RFC1939) server

=head1 SYNOPSIS

  use Mail::POP3Client;
  $pop = new Mail::POP3Client( USER     => "me",
			       PASSWORD => "mypassword",
			       HOST     => "pop3.do.main" );
  for( $i = 1; $i <= $pop->Count(); $i++ ) {
    foreach( $pop->Head( $i ) ) {
      /^(From|Subject):\s+/i && print $_, "\n";
    }
  }
  $pop->Close();
  # OR
  $pop2 = new Mail::POP3Client( HOST  => "pop3.otherdo.main" );
  $pop2->User( "somebody" );
  $pop2->Pass( "doublesecret" );
  $pop2->Connect() || die $pop2->Message();
  $pop2->Close();

=head1 DESCRIPTION

This module implements an Object-Oriented interface to a POP3 server.
It implements RFC1939 (http://www.faqs.org/rfcs/rfc1939.html)

=head1 EXAMPLES

Here is a simple example to list out the From: and Subject: headers in
your remote mailbox:

  #!/usr/local/bin/perl
  
  use Mail::POP3Client;
  
  $pop = new Mail::POP3Client( USER     => "me",
			       PASSWORD => "mypassword",
			       HOST     => "pop3.do.main" );
  for ($i = 1; $i <= $pop->Count(); $i++) {
    foreach ( $pop->Head( $i ) ) {
      /^(From|Subject):\s+/i and print $_, "\n";
    }
    print "\n";
  }

=head1 CONSTRUCTORS

Old style (deprecated):
   new Mail::POP3Client( USER, PASSWORD [, HOST, PORT, DEBUG, AUTH_MODE] );

New style (shown with defaults):
   new Mail::POP3Client( USER      => "",
                         PASSWORD  => "",
                         HOST      => "pop3",
                         PORT      => 110,
                         AUTH_MODE => 'PASS',
                         DEBUG     => 0,
                         TIMEOUT   => 60,
                       );

=over 4

=item *
USER is the userID of the account on the POP server

=item *
PASSWORD is the cleartext password for the userID

=item *
HOST is the POP server name or IP address (default = 'pop3')

=item *
PORT is the POP server port (default = 110)

=item *
DEBUG - any non-null, non-zero value turns on debugging (default = 0)

=item *
AUTH_MODE - pass 'APOP' to attempt APOP (MD5) authorization. (default is 'PASS')

=item *
TIMEOUT - set a timeout value for socket operations (default = 60)

=back

=head1 METHODS

These commands are intended to make writing a POP3 client easier.
They do not necessarily map directly to POP3 commands defined in
RFC1081 or RFC1939, although all commands should be supported.  Some
commands return multiple lines as an array in an array context.

=over 8

=item I<new>( USER => 'user', PASSWORD => 'password', HOST => 'host',
              PORT => 110, DEBUG => 0, AUTH_MODE => 'PASS', TIMEOUT => 60 )

Construct a new POP3 connection with this.  You should use the
hash-style constructor.  B<The old positional constructor is
deprecated and will be removed in a future release.  It is strongly
recommended that you convert your code to the new version.>

You should give it at least 2 arguments: USER and PASSWORD.  The
default HOST is 'pop3' which may or may not work for you.  You can
specify a different PORT (be careful here).

new will attempt to Connect to and Login to the POP3 server if you
supply a USER and PASSWORD.  If you do not supply them in the
constructor, you will need to call Connect yourself.

The valid values for AUTH_MODE are 'PASS' and 'APOP'.  APOP implies
that an MD5 checksum will be used instrad of passing your password in
cleartext.  However, B<if the server does not support APOP, the
cleartext method will be used.  Be careful.>

If you enable debugging with DEBUG => 1, messages about command will
go to STDERR.

Another warning, it's impossible to differentiate between a timeout
and a failure.


=item I<Head>( MESSAGE_NUMBER )

Get the headers of the specified message, either as an array or as a
string, depending on context.

You can also specify a number of preview lines which will be returned
with the headers.  This may not be supported by all POP3 server
implementations as it is marked as optional in the RFC.  Submitted by
Dennis Moroney <dennis@hub.iwl.net>.

=item I<Body>( MESSAGE_NUMBER )

Get the body of the specified message, either as an array of lines or
as a string, depending on context.

=item I<HeadAndBody>( MESSAGE_NUMBER [, PREVIEW_LINES ] )

Get the head and body of the specified message, either as an array of
lines or as a string, depending on context.

=over 4

=item Example

foreach ( $pop->HeadAndBody( 1, 10 ) )
   print $_, "\n";

prints out a preview of each message, with the full header and the
first 10 lines of the message (if supported by the POP3 server).

=back

=item I<Retrieve>( MESSAGE_NUMBER )

Same as HeadAndBody.

=item I<Delete>( MESSAGE_NUMBER )

Mark the specified message number as DELETED.  Becomes effective upon
QUIT.  Can be reset with a Reset message.

=item I<Connect>

Start the connection to the POP3 server.  You can pass in the host and
port.

=item I<Close>

Close the connection gracefully.  POP3 says this will perform any
pending deletes on the server.

=item I<Alive>

Return true or false on whether the connection is active.

=item I<Socket>

Return the file descriptor for the socket.

=item I<Size>

Set/Return the size of the remote mailbox.  Set by POPStat.

=item I<Count>

Set/Return the number of remote messages.  Set during Login.

=item I<Message>

The last status message received from the server.

=item I<State>

The internal state of the connection: DEAD, AUTHORIZATION, TRANSACTION.

=item I<POPStat>

Return the results of a POP3 STAT command.  Sets the size of the
mailbox.

=item I<List>

Return a list of sizes of each message.

=item I<ListArray>

Return a list of sizes of each message.  This returns an indexed
array, with each message number as an index (starting from 1) and the
value as the next entry on the line.  Beware that some servers send
additional info for each message for the list command.  That info may
be lost.

=item I<Uidl>( [MESSAGE_NUMBER] )

Return the unique ID for the given message (or all of them).  Returns
an indexed array with an entry for each valid message number.
Indexing begins at 1 to coincide with the server's indexing.

=item I<Last>

Return the number of the last message, retrieved from the server.

=item I<Reset>

Tell the server to unmark any message marked for deletion.

=item I<User>( [USER_NAME] )

Set/Return the current user name.

=item I<Pass>( [PASSWORD] )

Set/Return the current user name.

=item I<Login>

Attempt to login to the server connection.

=item I<Host>( [HOSTNAME] )

Set/Return the current host.

=item I<Port>( [PORT_NUMBER] )

Set/Return the current port number.

=back

=head1 AUTHOR

Sean Dowd <pop3client@dowds.net>

=head1 CREDITS

Based loosely on News::NNTPClient by Rodger Anderson
<rodger@boi.hp.com>.

=head1 SEE ALSO

perl(1).

=cut
