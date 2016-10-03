# Mail::Sender.pm version 0.6.7
#
# Copyright (c) 1997 Jan Krynicky <Jenda@Krynicky.cz>. All rights reserved.      
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.

package Mail::Sender;
require Exporter;
@ISA = (Exporter);
@EXPORT = qw();   #&new);
@EXPORT_OK = qw(@error_str);

$Mail::Sender::VERSION='0.6.7';
$Mail::Sender::ver=$Mail::Sender::VERSION;

use strict 'vars';
use FileHandle;
use Socket;
use File::Basename;

#use MIME::Base64;
#use MIME::QuotedPrint;
                    # if you do not use MailFile or SendFile you may
                    # comment out these lines.
                    #MIME::Base64 and MIME::QuotedPrint may be found at CPAN.
my $chunksize=1024*3;

#internals

sub HOSTNOTFOUND {
 $!=2;
 $Mail::Sender::Error="The SMTP server $_[0] was not found.";
 return -1;
}

sub SOCKFAILED {
 $!=5;
 $Mail::Sender::Error='socket() failed';
 return -2;
}

sub CONNFAILED {
 $!=5;
 $Mail::Sender::Error='connect() failed';
 return -3;
}

sub SERVNOTAVAIL {
 $!=40;
 $Mail::Sender::Error='Service not available';
 return -4;
}

sub COMMERROR {
 $!=5;
 $Mail::Sender::Error='Unspecified communication error';
 return -5;
}

sub USERUNKNOWN {
 $!=2;
 $Mail::Sender::Error="Local user \"$_[0]\" unknown on host \"$_[1]\"";
 return -6;
}

sub TRANSFAILED {
 $!=5;
 $Mail::Sender::Error='Transmission of message failed';
 return -7;
}

sub TOEMPTY {
 $!=14;
 $Mail::Sender::Error="Argument \$to empty";
 return -8;
}

sub NOMSG {
 $!=22;
 $Mail::Sender::Error="No message specified";
 return -9;
}

sub NOFILE {
 $!=22;
 $Mail::Sender::Error="No file name specified";
 return -10;
}

sub FILENOTFOUND {
 $!=2;
 $Mail::Sender::Error="File \"$_[0]\" not found";
 return -11;
}

sub NOTMULTIPART {
 $!=40;
 $Mail::Sender::Error="Not available in singlepart mode";
 return -12;
}

@Mail::Sender::Errors = ('OK',
              'not available in singlepart mode',
              'file not found',
              'no file name specified in call to MailFile or SendFile',
              'no message specified in call to MailMsg or MailFile',
              'argument $to empty',
              'transmission of message failed',
              'local user $to unknown on host $smtp',
              'unspecified communication error',
              'service not available',
              'connect() failed',
              'socket() failed',
              '$smtphost unknown'
             );

=head1 NAME

Mail::Sender - module for sending mails with attachments through an SMTP server

Version 0.6.7

=head1 SYNOPSIS

 use Mail::Sender;
 $sender = new Mail::Sender
  {smtp => 'mail.yourdomain.com', from => 'your@address.com'};
 $sender->MailFile({to => 'some@address.com',
  subject => 'Here is the file',
  msg => "I'm sending you the list you wanted.",
  file => 'filename.txt'});

=head1 DESCRIPTION

C<Mail::Sender> provides an object oriented interface to sending mails.
It doesn't need any outer program. It connects to a mail server
directly from Perl, using Socket.

Sends mails directly from Perl through a socket connection. 

=head1 CONSTRUCTORS

=over 2

=item C<new Mail::Sender ([from [,replyto [,to [,smtp [,subject [,headers [,boundary]]]]]]])>

=item new Mail::Sender {[from => 'somebody@somewhere.com'] , [to => 'else@nowhere.com'] [...]}

=item .

Prepares a sender. This doesn't start any connection to the server. You
have to use C<$Sender->Open> or C<$Sender->OpenMultipart> to start
talking to the server.

The parameters are used in subsequent calls to C<$Sender->Open> and
C<$Sender->OpenMultipart>. Each such call changes the saved variables.
You can set C<smtp>,C<from> and other options here and then use the info
in all messages.

 from      = the senders e-mail address

 replyto   = the reply-to address

 to        = the recipient's address(es)

 cc        = address(es) to send a copy (carbon copy)

 bcc       = address(es) to send a copy (blind carbon copy)
             these adresses will not be visible in the mail!

 smtp      = the IP or domain addres of you SMTP (mail) server

 subject   = the subject of the message

 headers   = the additional headers

 boundary  = the message boundary


 return codes:
  ref to a Mail::Sender object =  success
  -1 = $smtphost unknown
  -2 = socket() failed
  -3 = connect() failed
  -4 = service not available
  -5 = unspecified communication error
  -6 = local user $to unknown on host $smtp
  -7 = transmission of message failed
  -8 = argument $to empty
  -9 = no message specified in call to MailMsg or MailFile
  -10 = no file name specified in call to SendFile or MailFile
  -11 = file not found
  -12 = not available in singlepart mode
   Mail::Sender::Error contains a textual description of last error.

=back

=cut
#package main;
sub new {
 my $this = shift;
 my $class = ref($this) || $this;
 my $self = {};
 bless $self, $class;
 return $self->initialize(@_);
}
#package Mail::Sender;

sub initialize {
 my $self = shift;

 delete $self->{buffer};
 $self->{'proto'} = (getprotobyname('tcp'))[2];
 $self->{'port'} = getservbyname('smtp', 'tcp');  # was (..)[2]

 $self->{'boundary'} = 'Message-Boundary-9140';

 if ($#_ < 0) {return $self;}
 if (ref $_[0] eq 'HASH') {
  my $key;
  my $hash=$_[0];
  foreach $key (keys %$hash) {
   $self->{lc $key}=$hash->{$key};
  }
 } else {
  ($self->{'from'}, $self->{'reply'}, $self->{'to'}, $self->{'smtp'},
   $self->{'subject'}, $self->{'headers'}, $self->{'boundary'}
  ) = @_;
 }

 $self->{'fromaddr'} = $self->{'from'};
 $self->{'replyaddr'} = $self->{'reply'};

# $self->{'to'} =~ s/[ \t]+/, /g if ($self->{'to'}); # pack spaces and add comma
 $self->{'to'} =~ s/[ \t]+/ /g if ($self->{'to'}); # pack spaces and add comma
 $self->{'to'} =~ s/,,/,/g;

 $self->{'cc'} =~ s/[ \t]+/ /g if ($self->{'to'}); # pack spaces and add comma
 $self->{'cc'} =~ s/,,/,/g;

 $self->{'bcc'} =~ s/[ \t]+/ /g if ($self->{'to'}); # pack spaces and add comma
 $self->{'bcc'} =~ s/,,/,/g;

 $self->{'fromaddr'} =~ s/.*<([^\s]*?)>/$1/ if ($self->{'fromaddr'}); # get from email address
 if ($self->{'replyaddr'}) {
  $self->{'replyaddr'} =~ s/.*<([^\s]*?)>/$1/; # get reply email address
  $self->{'replyaddr'} =~ s/^([^\s]+).*/$1/; # use first address
 }
 $self->{'smtp'} =~ s/^\s+//g; # remove spaces around $smtp
 $self->{'smtp'} =~ s/\s+$//g;

 $self->{'smtpaddr'} = ($self->{'smtp'} =~
 /^(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})$/)
 ? pack('C4',$1,$2,$3,$4)
 : (gethostbyname($self->{'smtp'}))[4];

 $self->{'boundary'} =~ tr/=/-/;
 
 if (!defined($self->{'smtpaddr'})) { return $self->{'error'}=HOSTNOTFOUND($self->{smtp}); }

 return $self;
}

=head1 METHODS

=over 2

=item C<Open([from [, replyto [, to [, smtp [, subject [, headers]]]]]])>

=item Open({[from => "somebody@somewhere.com"] , [to => "else@nowhere.com"] [...]})

=item .

Opens a new message. If some parameters are unspecified or empty, it uses
the parameters passed to the "C<$Sender=new Mail::Sender(...)>";

see C<new Mail::Sender> for info about the parameters.

=cut

sub Open {
 my $self = shift;
 if ($self->{'socket'}) {
  if ($self->{'error'}) {
   $self->Cancel;
  } else {
   $self->Close;
  }
 }
 delete $self->{'error'};
 my %changed;
 $self->{multipart}=0;

 if (ref $_[0] eq 'HASH') {
  my $key;
  my $hash=$_[0];
  foreach $key (keys %$hash) {
   $self->{lc $key}=$hash->{$key};
   $changed{$key}=1;
  }
 } else {
  my ($from, $reply, $to, $smtp, $subject, $headers ) = @_;

  if ($from) {$self->{'from'}=$from;$changed{'from'}=1;}
  if ($reply) {$self->{'reply'}=$reply;$changed{'reply'}=1;}
  if ($to) {$self->{'to'}=$to;$changed{'to'}=1;}
  if ($smtp) {$self->{'smtp'}=$smtp;$changed{'smtp'}=1;}
  if ($subject) {$self->{'subject'}=$subject;$changed{'subject'}=1;}
  if ($headers) {$self->{'headers'}=$headers;$changed{'headers'}=1;}
 }

 $self->{'to'} =~ s/[ \t]+/ /g if ($changed{to}); 
 $self->{'to'} =~ s/,,/,/g if ($changed{to});
 $self->{'cc'} =~ s/[ \t]+/ /g if ($changed{cc}); 
 $self->{'cc'} =~ s/,,/,/g if ($changed{cc});
 $self->{'bcc'} =~ s/[ \t]+/ /g if ($changed{bcc}); 
 $self->{'bcc'} =~ s/,,/,/g if ($changed{bcc});

 $self->{'boundary'} =~ tr/=/-/ if $changed{boundary};

 if ($changed{from}) {
  $self->{'fromaddr'} = $self->{'from'};
  $self->{'fromaddr'} =~ s/.*<([^\s]*?)>/$1/; # get from email address
 }

 if ($changed{reply}) {
  $self->{'replyaddr'} = $self->{'reply'};
  $self->{'replyaddr'} =~ s/.*<([^\s]*?)>/$1/; # get reply email address
  $self->{'replyaddr'} =~ s/^([^\s]+).*/$1/; # use first address
 }

 if ($changed{smtp}) {
  $self->{'smtp'} =~ s/^\s+//g; # remove spaces around $smtp
  $self->{'smtp'} =~ s/\s+$//g;
  $self->{'smtpaddr'} = ($self->{'smtp'} =~
  /^(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})$/)
  ? pack('C4',$1,$2,$3,$4)
  : (gethostbyname($self->{'smtp'}))[4];
 }

 if (!$self->{'to'}) { return $self->{'error'}=TOEMPTY; }
 
 if (!defined($self->{'smtpaddr'})) { return $self->{'error'}=HOSTNOTFOUND($self->{smtp}); }

 my $s = &FileHandle::new(FileHandle);
 $self->{'socket'} = $s;
 
 if (!socket($s, AF_INET, SOCK_STREAM, $self->{'proto'})) { 
   return $self->{'error'}=SOCKFAILED; }
 
 if (!connect($s, pack('Sna4x8', AF_INET, $self->{'port'}, $self->{'smtpaddr'}))) { 
   return $self->{'error'}=CONNFAILED; }
 
 my($oldfh) = select($s); $| = 1; select($oldfh);
 
 $_ = <$s>; if (/^[45]/) { close $s; return $self->{'error'}=SERVNOTAVAIL; }
 
 print $s "helo localhost\r\n";
 $_ = <$s>; if (/^[45]/) { close $s; return $self->{'error'}=COMMERROR; }
 
 print $s "mail from: <$self->{'fromaddr'}>\r\n";
 $_ = <$s>; if (/^[45]/) { close $s; return $self->{'error'}=COMMERROR; }
 
 foreach (split(/, */, $self->{'to'}),split(/, */, $self->{'cc'}),split(/, */, $self->{'bcc'})) {

  if (/<(.*)>/) {
   print $s "rcpt to: $1\r\n";
  } else {
   print $s "rcpt to: <$_>\r\n";
  }

  $_ = <$s>; if (/^[45]/) { close $s; return $self->{'error'}=USERUNKNOWN($self->{to}, $self->{smtp}); }
 }
 
 print $s "data\r\n";
 $_ = <$s>; if (/^[45]/) { close $s; return $self->{'error'}=COMMERROR; }
 
 print $s "To: $self->{'to'}\r\n";
 print $s "From: $self->{'from'}\r\n";
 print $s "Cc: $self->{'cc'}\r\n";
 print $s "Reply-to: $self->{'replyaddr'}\r\n" if $self->{'replyaddr'};
 print $s "X-Mailer: Perl Mail::Sender Version $Mail::Sender::ver Jan Krynicky  <Jenda\@Krynicky.cz> Czech Republic\r\n" unless defined $Mail::Sender::NO_X_MAILER;
 if ($self->{'headers'}) {print $s $self->{'headers'},"\r\n"};
 print $s "Subject: $self->{'subject'}\r\n\r\n";
 
 return $self;
}


=item C<OpenMultipart([from [, replyto [, to [, smtp [, subject [, headers [, boundary]]]]]]])>

=item OpenMultipart({[from => "somebody@somewhere.com"] , [to => "else@nowhere.com"] [...]})

=item .

Opens a multipart message. If some parameters are unspecified or empty, it uses
the parameters passed to the C<$Sender=new Mail::Sender(...)>.

see C<new Mail::Sender> for info about the parameters.

=cut
sub OpenMultipart {
 my $self = shift;
 if ($self->{'socket'}) {
  if ($self->{'error'}) {
   $self->Cancel;
  } else {
   $self->Close;
  }
 }
 delete $self->{'error'};
 my %changed;
 $self->{'multipart'}=1;

 if (ref $_[0] eq 'HASH') {
  my $key;
  my $hash=$_[0];
  foreach $key (keys %$hash) {
   $self->{lc $key}=$hash->{$key};
   $changed{$key}=1;
  }
 } else {
  my ($from, $reply, $to, $smtp, $subject, $headers, $boundary) = @_;

  if ($from) {$self->{'from'}=$from;$changed{'from'}=1;}
  if ($reply) {$self->{'reply'}=$reply;$changed{'reply'}=1;}
  if ($to) {$self->{'to'}=$to;$changed{'to'}=1;}
  if ($smtp) {$self->{'smtp'}=$smtp;$changed{'smtp'}=1;}
  if ($subject) {$self->{'subject'}=$subject;$changed{'subject'}=1;}
  if ($headers) {$self->{'headers'}=$headers;$changed{'headers'}=1;}
  if ($boundary) {
   $self->{'boundary'}=$boundary;
  }
 }

 $self->{'to'} =~ s/[ \t]+/ /g if ($changed{to}); 
 $self->{'to'} =~ s/,,/,/g if ($changed{to});
 $self->{'cc'} =~ s/[ \t]+/ /g if ($changed{cc}); 
 $self->{'cc'} =~ s/,,/,/g if ($changed{cc});
 $self->{'bcc'} =~ s/[ \t]+/ /g if ($changed{bcc}); 
 $self->{'bcc'} =~ s/,,/,/g if ($changed{bcc});
 $self->{'boundary'} =~ tr/=/-/ if $changed{boundary};

 if ($changed{from}) {
  $self->{'fromaddr'} = $self->{'from'};
  $self->{'fromaddr'} =~ s/.*<([^\s]*?)>/$1/; # get from email address
 }

 if ($changed{reply}) {
  $self->{'replyaddr'} = $self->{'reply'};
  $self->{'replyaddr'} =~ s/.*<([^\s]*?)>/$1/; # get reply email address
  $self->{'replyaddr'} =~ s/^([^\s]+).*/$1/; # use first address
 }

 if ($changed{smtp}) {
  $self->{'smtp'} =~ s/^\s+//g; # remove spaces around $smtp
  $self->{'smtp'} =~ s/\s+$//g;
  $self->{'smtpaddr'} = ($self->{'smtp'} =~
  /^(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})$/)
  ? pack('C4',$1,$2,$3,$4)
  : (gethostbyname($self->{'smtp'}))[4];
 }

 if (!$self->{'to'}) { return $self->{'error'}=TOEMPTY; }
 
 if (!defined($self->{'smtpaddr'})) { return $self->{'error'}=HOSTNOTFOUND($self->{smtp}); }

 my $s = &FileHandle::new(FileHandle);
 $self->{'socket'} = $s;
 
 if (!socket($s, AF_INET, SOCK_STREAM, $self->{'proto'})) { 
   return $self->{'error'}=SOCKFAILED; }
 
 if (!connect($s, pack('Sna4x8', AF_INET, $self->{'port'}, $self->{'smtpaddr'}))) { 
   return $self->{'error'}=CONNFAILED; }
 
 my($oldfh) = select($s); $| = 1; select($oldfh);
 
 $_ = <$s>; if (/^[45]/) { close $s; return $self->{'error'}=SERVNOTAVAIL; }
 
 print $s "helo localhost\r\n";
 $_ = <$s>; if (/^[45]/) { close $s; return $self->{'error'}=COMMERROR; }
 
 print $s "mail from: <$self->{'fromaddr'}>\r\n";
 $_ = <$s>; if (/^[45]/) { close $s; return $self->{'error'}=COMMERROR; }
 
 foreach (split(/, */, $self->{'to'}),split(/, */, $self->{'cc'}),split(/, */, $self->{'bcc'})) {
  if (/<(.*)>/) {
   print $s "rcpt to: $1\r\n";
  } else {
   print $s "rcpt to: <$_>\r\n";
  }
  $_ = <$s>; if (/^[45]/) { close $s; return $self->{'error'}=USERUNKNOWN($self->{to}, $self->{smtp}); }
 }
 
 print $s "data\r\n";
 $_ = <$s>; if (/^[45]/) { close $s; return $self->{'error'}=COMMERROR; }
 
# print $s "MIME-Version: 1.0\r\n";
 print $s "To: $self->{'to'}\r\n";
 print $s "Cc: $self->{'cc'}\r\n" if $self->{'cc'};
 print $s "From: $self->{'from'}\r\n";
 print $s "Reply-to: $self->{'replyaddr'}\r\n" if $self->{'replyaddr'};
 print $s "X-Mailer: Perl Mail::Sender Version $Mail::Sender::ver Jan Krynicky  <Jenda\@Krynicky.cz> Czech Republic\r\n"  unless defined $Mail::Sender::NO_X_MAILER;
 print $s "Subject: $self->{'subject'}\r\n";
 if ($self->{'headers'}) {print $s $self->{'headers'},"\r\n"};
 print $s "MIME-Version: 1.0\r\nContent-type: Multipart/Mixed;\r\n\tboundary=$self->{'boundary'}\r\n";
 print $s "\r\n"; 
 
 return $self;
}


=item C<MailMsg([from [, replyto [, to [, smtp [, subject [, headers]]]]]], message)>

=item MailMsg({[from => "somebody@somewhere.com"]
               [, to => "else@nowhere.com"] [...], msg => "Message"})

=item .

Sends a message. If a mail in $sender is opened it gets closed
and a new mail is created and sent. $sender is then closed.
If some parameters are unspecified or empty, it uses
the parameters passed to the "C<$Sender=new Mail::Sender(...)>";

see C<new Mail::Sender> for info about the parameters.

=cut

sub MailMsg {
 my $self = shift;
 my $msg;
 if (ref $_[0] eq 'HASH') {
  my $hash=$_[0];
  $msg=$hash->{msg};
  delete $hash->{msg}
 } else {
  $msg = pop;
 }
 return $self->{'error'}=NOMSG unless $msg;

 ref $self->Open(@_)
 and
 $self->SendEx($msg)
 and
 $self->Close >= 0
 and
 return $self;
}


=item C<MailFile([from [, replyto [, to [, smtp [, subject [, headers]]]]]], message, file(s))>

=item MailFile({[from => "somebody@somewhere.com"]
               [, to => "else@nowhere.com"] [...],
               msg => "Message", file => "File"})

=item .

Sends one or more files by mail. If a mail in $sender is opened it gets closed
and a new mail is created and sent. $sender is then closed.
If some parameters are unspecified or empty, it uses
the parameters passed to the "C<$Sender=new Mail::Sender(...)>";

The C<file> parameter may be a "filename", a "list, of, file, names" or a \@list of file names.

see C<new Mail::Sender> for info about the parameters.

=cut

sub MailFile {
 my $self = shift;
 my $msg;
 my $file;my $desc;
 my @files;
 if (ref $_[0] eq 'HASH') {
  my $hash = $_[0];
  $msg = $hash->{msg};
  delete $hash->{msg};
  $file=$hash->{file};
  delete $hash->{file};
  $desc=$hash->{description};
  delete $hash->{description};
 } else {
  $desc=pop if ($#_ >=2);
  $file = pop;
  $msg = pop;
 }
 return $self->{'error'}=NOMSG unless $msg;
 return $self->{'error'}=NOFILE unless $file;

 if (ref $file eq 'ARRAY') {
  @files=@$file;
 } elsif ($file =~ /,/) {
  @files=split / *, */,$file;
 } else {
  @files = ($file);
 }
 foreach $file (@files) {
  return $self->{'error'}=FILENOTFOUND($file) unless ($file =~ /^&/ or -e $file);
 }

 ref $self->OpenMultipart(@_)
 and
 ref $self->Body
 and
 $self->SendEx($msg)
 or return undef;
 foreach $file (@files) {
  my $cnt;
  my $filename = basename $file;
  $self->Part({encoding => 'BASE64',
               disposition => "attachment; filename=\"$filename\"",
               ctype => "application/octet-stream; name=\"$filename\"; type=Unknown",
               description => $desc});

#print "Opening $file\n";
               
  open SENDFILE_4563, "<$file";binmode SENDFILE_4563;
  while (read SENDFILE_4563, $cnt, $chunksize) {
   $self->Send(encode_base64($cnt));
  }
  close SENDFILE_4563;
 }
 $self->Close;
 return $self;
}



=item C<Send(@strings)>

Prints the strings to the socket. Doesn't add any end-of-line characters.
You should use C<\r\n> as the end-of-line.

=cut
sub Send {
 my $self = shift;
 my $s;#=FileHandle::new FileHandle;
 $s = $self->{'socket'};
 print $s @_;
 return 1;
}

=item C<SendLine(@strings)>

Prints the strings to the socket. Add the end-of-line character at the end.

=cut
sub SendLine {
 my $self = shift;
 my $s;#=FileHandle::new FileHandle;
 $s = $self->{'socket'};
 print $s (@_,"\r\n");
 return 1;
}

=item C<SendEnc(@strings)>

Prints the strings to the socket. Doesn't add any end-of-line characters.
You should use C<\r\n> as the end-of-line.
Encodes the text using the selected encoding (Base64/Quoted-printable)

=cut
sub SendEnc {
 my $self = shift;
 my $code = $self->{code};
 my $s;#=FileHandle::new FileHandle;
 $s = $self->{'socket'};
 my $str;
 if (defined $self->{buffer}) {
  $str=(join '',($self->{buffer},@_));
 } else {
  $str=join '',@_;
 }
 my ($len,$blen);
 $len = length $str;
 if (($blen=($len % 57)) >0) {  #was 3
  $self->{buffer} = substr($str,($len-$blen),$blen);
  $str=substr $str,0,$len-$blen;
 } else {
  delete $self->{buffer};
 }
 print $s (&$code($str));
 return 1;
}

=item C<SendLineEnc(@strings)>

Prints the strings to the socket. Add the end-of-line character at the end.
Encodes the text using the selected encoding (Base64/Quoted-printable)

Do NOT mix up Send[Line][Ex] and Send[Line]Enc! SendEnc does some buffering
necessary for correct Base64 encoding, and Send is not aware of that!

Ussage of Send[Line][Ex] in non 7BIT parts not recommended.
Using C<Send(encode_base64($string))> may, but may NOT work!
In particular if you use several such to create one part,
the data is very likely to get crippled.

=cut
sub SendLineEnc {
 my $self = shift;
 return $self->SendEnc(@_,"\r\n");
}

=item C<SendEx(@strings)>

Prints the strings to the socket. Doesn't add any end-of-line characters.
Changes all end-of-lines to C<\r\n>.

=cut
sub SendEx {
 my $self = shift;
 my $s;#=FileHandle::new FileHandle;
 $s = $self->{'socket'};
 my $str;
 foreach $str (@_) {
  $str =~ s/\n/\r\n/; 
 }
 print $s @_;
 return 1;
}

=item C<SendLineEx(@strings)>

Prints the strings to the socket. Doesn't add any end-of-line characters.
Changes all end-of-lines to C<\r\n>.

=cut
sub SendLineEx {
 my $self = shift;
 my $s;#=FileHandle::new FileHandle;
 $s = $self->{'socket'};
 my $str;
 foreach $str (@_) {
  $str =~ s/\n/\r\n/; 
 }
 print $s (@_,"\r\n");
 return 1;
}


=item Part( I<description>, I<ctype>, I<encoding>, I<disposition>, I<autocode>);

=item Part( { [description => "desc"] , [ctype], [encoding], [disposition]});

 Prints a part header for the multipart message.
 The undef or empty variables are ignored.

=over 2

=item description

The title for this part.

=item ctype

the content type (MIME type) of this part. May contain some other
parameters, such as B<charset> or B<name>.

Defaults to "application/octet-stream".

=item encoding

the encoding used for this part of message. Eg. Base64, Uuencode, 7BIT
...

Defaults to "7BIT".

=item disposition

This parts disposition. Eg: 'attachment; filename="send.pl"'.

Defaults to  "attachment".

=back

=cut
sub Part {
 my $self = shift;
 if (! $self->{'multipart'}) { return $self->{'error'}=NOTMULTIPART; }
 
 my ($description, $ctype, $encoding, $disposition);
 if (ref $_[0] eq 'HASH') {
  my $hash=$_[0];
  $description=$hash->{description};
  $ctype=$hash->{ctype};
  $encoding=$hash->{encoding};
  $disposition=$hash->{disposition};
 } else {
  ($description, $ctype, $encoding, $disposition) = @_;
 }

 $ctype="application/octet-stream" unless $ctype;
 $disposition = "attachment" unless $disposition;
 $encoding="7BIT" unless $encoding;

 my $code;
 if ($encoding =~ /Base64/i) {
  $code=\&encode_base64;
 } elsif ($encoding =~ /Quoted-printable/i) {
  $code=\&encode_qp;
 } else {
  $code=sub{return $_[0];};
 }

 $self->{'code'}=$code;

 if ($self->{buffer}) {
  my $code = $self->{code};
  my $s=$self->{"socket"};
  print $s (&$code($self->{buffer}));
  delete $self->{buffer};
 }

 $self->Send("\r\n--$self->{'boundary'}\r\n");
 $self->Send("Content-type: $ctype\r\n");
 if ($description) {$self->Send("Content-description: $description\r\n");}
 $self->Send("Content-transfer-encoding: $encoding\r\n");
 $self->Send("Content-disposition: $disposition\r\n");
 $self->SendLine;
 return 1;
}


=item Body([charset [, encoding [, content-type]]]);

Sends the head of the multipart message body. You can specify the
charset and the encoding. Default is "US-ASCII","7BIT",'text/plain'.

If you pass undef or zero as the parameter, this function uses the default
value:

    Body(0,0,'text/html');

=cut
sub Body {
 my $self = shift;
 if (! $self->{'multipart'}) { return $self->{'error'}=NOTMULTIPART; }
 my $charset = shift || 'US-ASCII';
 my $encoding = shift || '7BIT';
 my $conttype = shift || 'text/plain';
 $self->Part("Mail message body","$conttype; charset=$charset",
             $encoding, 'inline');
 return $self;
} 

=item SendFile( I<description>, I<ctype>, I<encoding>, I<disposition>, I<file>);

=item SendFile( { [description => "desc"] , [ctype => "ctype"], [encoding => "encoding"],
              [disposition => "disposition"], file => "file"});

 Sends a file as a separate part of the mail mesage. Only in multipart mode.

=over 2

=item description

The title for this part.

=item ctype

the content type (MIME type) of this part. May contain some other
parameters, such as B<charset> or B<name>.

Defaults to "application/octet-stream".

=item encoding

the encoding used for this part of message. Eg. Base64, Uuencode, 7BIT
...

Defaults to "Base64".

=item disposition

This parts disposition. Eg: 'attachment; filename="send.pl"'.

Defaults to  "attachment".

=item file

The name of the file to send or a 'list, of, names' or a
['reference','to','a','list','of','filenames']. Each file will be sent as
a separate part.

=back

=cut
sub SendFile {
 my $self = shift;
 if (! $self->{'multipart'}) { return $self->{'error'}=NOTMULTIPART; }
 
 my ($description, $ctype, $encoding, $disposition, $file, @files);
 if (ref $_[0] eq 'HASH') {
  my $hash=$_[0];
  $description=$hash->{description};
  $ctype=$hash->{ctype};
  $encoding=$hash->{encoding};
  $disposition=$hash->{disposition};
  $file=$hash->{file};
 } else {
  ($description, $ctype, $encoding, $disposition, $file) = @_;
 }
 return ($self->{'error'}=NOFILE) unless $file;

 if (ref $file eq 'ARRAY') {
  @files=@$file;
 } elsif ($file =~ /,/) {
  @files=split / *, */,$file;
 } else {
  @files = ($file);
 }
 foreach $file (@files) {
  return $self->{'error'}=FILENOTFOUND($file) unless ($file =~ /^&/ or -e $file);
 }

 $ctype="application/octet-stream" unless $ctype;
 $disposition = "attachment" unless $disposition;
 $encoding='Base64' unless $encoding;

 my $code;
 if ($encoding =~ /Base64/i) {
  $code=\&encode_base64;
 } elsif ($encoding =~ /Quoted-printable/i) {
  $code=\&encode_qp;
 } else {
  $code=sub{return $_[0];};
 }
 $self->{'code'}=$code;

 if ($self->{buffer}) {
  my $code = $self->{code};
  my $s=$self->{'socket'};
  print $s (&$code($self->{buffer}));
  delete $self->{buffer};
 }

 foreach $file (@files) {
  my $cnt='';
  my $name=  basename $file;
  $self->Send("\r\n--$self->{'boundary'}\r\n");
  $self->Send("Content-type: $ctype; name=\"$name\"; type=Unknown\r\n");
  if ($description) {$self->Send("Content-description: $description\r\n");}
  $self->Send("Content-transfer-encoding: $encoding\r\n");
  $self->Send("Content-disposition: $disposition; filename=\"$name\"\r\n");
  $self->SendLine;
  open SENDFILE_4563, "<$file";binmode SENDFILE_4563;
  while (read SENDFILE_4563, $cnt, $chunksize) {
   $self->Send(&$code($cnt));
  }
#  $self->Send("==\n");
  close SENDFILE_4563;
 }
 $self->SendLine();
 return 1;
}


=item Close;

Close and send the mail. This method should be called automaticaly when destructing
the object, but you should call it yourself just to be sure it gets called.
And you should do it as soon as posible to close the connection and free the socket.

The mail is being sent to server, but is not processed by the server
till the sender object is closed!

=cut
sub Close {
 my $self = shift;
 my $s;#=new FileHandle;
 $s = $self->{'socket'};
 return 1 unless $s;
 if ($self->{buffer}) {
  my $code = $self->{code};
  print $s (&$code($self->{buffer}));
  delete $self->{buffer};
 }
 if ($self->{'multipart'}) { print $s "\r\n--",$self->{'boundary'},"--\r\n";}
 print $s "\r\n.\r\n";
 
 $_ = <$s>; if (/^[45]/) { close $s; return $self->{'error'}=TRANSFAILED; }
 
 print $s "quit\r\n";
 $_ = <$s>;
 
 close $s;
 delete $self->{'socket'};
 return 1;
}

=item Cancel;

Cancel an opened message.

SendFile and other methods may set $sender->{'error'}.
In that case "undef $sender" calls $sender->Cancel not $sender->Close!!!

=cut
sub Cancel {
 my $self = shift;
 my $s;#=new FileHandle;
 $s = $self->{'socket'};#      print "\$sender->Cancel() called\n";
 close $s;
 delete $self->{'socket'};
 delete $self->{'error'};
 return 1;
}

sub DESTROY {
 my $self = shift;
 if (defined $self->{'socket'}) {
  if ($self->{'error'}) {
   $self->Cancel;
  } else {
   $self->Close;
  }
 }
}


=item @Mail::Sender::Errors

Contains the description of errors returned by functions in Mail::Sender.

Ussage: @Mail::Sender::Errors[$sender->{error}]

=back

=head1 EXAMPLES

 use Mail::Sender;
 
 #$sender = new Mail::Sender { from => 'somebody@somewhere.com',
    smtp => 'ms.chipnet.cz', boundary => 'This-is-a-mail-boundary-435427'};
 # # if you do not care about errors.
 # # otherwise use
 #
 ref ($sender = new Mail::Sender { from => 'somebody@somewhere.com',
       smtp => 'ms.chipnet.cz', boundary => 'This-is-a-mail-boundary-435427'})
 or die "Error($sender) : $Mail::Sender::Error\n";
 
 $sender->Open({to => 'friend@other.com', subject => 'Hello dear friend'});
 $sender->SendLine("How are you?");
 $sender->SendLine;
 $sender->Send(<<'*END*');
 I've found these jokes.

  Doctor, I feel like a pack of cards.
  Sit down and I'll deal with you later.
 
  Doctor, I keep thinking I'm a dustbin.
  Don't talk rubbish.
 
 Hope you like'em. Jenda
 *END*
 
 $sender->Close;
 
 $sender->Open({to => 'mama@home.org, papa@work.com',
                cc => 'somebody@somewhere.com',
                subject => 'Sorry, I'll come later.'});
 $sender->SendLine("I'm sorry, but due to a big load of work,
    I'll come at 10pm at best.");
 $sender->SendLine("\nHi, Jenda");
 
 $sender->Close;
 
 $sender->OpenMultipart({to => 'Perl-Win32-Users@activeware.foo',
                         subject => 'Mail::Sender.pm - new module'});
 $sender->Body;
 $sender->Send(<<'*END*');
 Here is a new module Mail::Sender.
 It provides an object based interface to sending SMTP mails.
 It uses a direct socket connection, so it doesn't need any
 additionl program.
 
 Enjoy, Jenda
 *END*
 $sender->SendFile(
  {description => 'Perl module Mail::Sender.pm',
   ctype => 'application/x-zip-encoded',
   encoding => 'Base64',
   disposition => 'attachment; filename="Sender.zip"; type="ZIP archive"',
   file => 'sender.zip'
  });
 $sender->Close;
 
 _END_


If everything you need is to send a simple message you may use:

 use Mail::Sender;

 ref ($sender = new Mail::Sender({from => 'somebody@somewhere.com',smtp
 => 'ms.chipnet.cz'})) or die "$Mail::Sender::Error\n";

 (ref ($sender->MailMsg({to =>'Jenda@Krynicky.cz', subject => 'this is a test',
                         msg => "Hi Johnie.\nHow are you?"}))
  and print "Mail sent OK."
 )
 or die "$Mail::Sender::Error\n";

If you want to attach some files:

 use Mail::Sender;

 ref ($sender = new Mail::Sender({from => 'somebody@somewhere.com',smtp
 => 'mail.yourdomain.com'})) or die "$Mail::Sender::Error\n";

 (ref ($sender->MailFile(
  {to =>'you@address.com', subject => 'this is a test',
   msg => "Hi Johnie.\nI'm sending you the pictures you wanted.",
   file => 'image1.jpg,image2.jpg'
  }))
  and print "Mail sent OK."
 )
 or die "$Mail::Sender::Error\n";

If you want to send a HTML mail:

 use Mail::Sender;
 open IN, $htmlfile or die "Cannot open $htmlfile : $!\n";
 $sender = new Mail::Sender {smtp => 'mail.yourdomain.com'};
 $sender->Open({ from => 'your@address.com', to => 'other@address.com', subject => 'HTML test',
        headers => "MIME-Version: 1.0\r\nContent-type: text/html\r\nContent-Transfer-Encoding: 7bit"
 }) or die $Mail::Sender::Error,"\n";

 while (<IN>) { $sender->Send($_) };
 close IN;
 $sender->Close();


DO NOT mix Open(Multipart)|Send(Line)(Ex)|Close with MailMsg or MailFile.
Both Send(Msg/File) close any Open-ed mail. Do not try this:

 $sender = new Mail::Sender ...;
 $sender->OpenMultipart...;
 $sender->Body;
 $sender->Send("...");
 $sender->MailFile({file => 'something.ext');
 $sender->Close;

This WON'T work!!!

=head1 DISCLAIMER

This module is based on SendMail.pm Version : 1.21 that appeared in
Perl-Win32-Users@activeware.com mailing list. I don't remember the name
of the poster and it's not mentioned in the script. Thank you mr. C<undef>.

=head1 AUTHOR

Jan Krynicky <Jenda@Krynicky.cz>

=head1 COPYRIGHT

Copyright (c) 1997 Jan Krynicky <Jenda@Krynicky.cz>. All rights reserved.
This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut

