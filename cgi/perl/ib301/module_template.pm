################################################
#
# This is a module template.
# This is designed to give you a head start on creating
# new modules for iB3
#
################################################

#------------------------------------------------------
# Add your package declaration here. For example
# if the module is called "Date.pm" - then you'll need
# to use package Date;
#------------------------------------------------------

package Date;
use strict;

#------------------------------------------------------
# This BEGIN block will import any needed modules
# Lib/FUNC contains the base classes for ikonboard
# Including the output / member and mail routines.
#------------------------------------------------------

BEGIN {
    require 'Lib/FUNC.pm';
}

#------------------------------------------------------
# If we want to import any other libraries, do so here.
# Following on from the Date.pm example, lets import
# the standard Time::localtime module that is bundled with
# perl.
#------------------------------------------------------

use Time::localtime;

#------------------------------------------------------
# Here we load the skin file for this module, possibly called
# "DateView.pm"
#------------------------------------------------------

require $iB::SKIN->{'DIR'} . '/DateView.pm' or die $!;

#------------------------------------------------------
# We create our constructors. This is a variabled "blessed"
# to the imported package. This lets perl know that you are accessing
# the packages subroutines
#------------------------------------------------------

# Standard board routines, such as get_date
my $std        = FUNC::STD->new();
# Member routines, such as LoadMember
my $mem        = FUNC::Member->new();
# Our printing library
my $output     = FUNC::Output->new();
$$module$$::lang = $std->LoadLanguage('$$module$$Words');


#------------------------------------------------------
# We now need to define a constructor for this module. This
# allows you to "bless" a variable to this package.
#
# So, if this module was called "Date.pm" we would use something
# like this in our script to use it.
#
# use Date;
# my $date = Date->new();
#------------------------------------------------------

sub new {
    my $pkg = shift;
    my $obj = {};
    bless $obj, $pkg;
    return $obj;
}


#------------------------------------------------------
# Our subroutine
# Continuing the example, lets write the subroutine that
# takes a UNIX timestamp and returns a nicely formatted
# date for our script to use.
#------------------------------------------------------

sub printable_date {
    # First, we need to get the "blessed" variable that "points" to this
    # module. We call this "obj" to make our lives easier.
    
    my $obj = shift;

    # Now we need to get the value that was sent to this subroutine from the script
    # if we used $date->printable_date("1092838473"); then the "1092838473" will be
    # stored in perls @_ array.

    my $raw_date = @_;

    # If we were to print $raw_date, it'd print 1092838473
    # Obviously, this is no good, so we now use Time::localtime to convert it.
    # Time::localtime *exports* it's subroutine names - so we don't have to use
    # a blessed variable, or call new on it. Don't worry about how it does that,
    # just accept that it does :D
    # All we need do is get Time::localtime to return us a set of variables that
    # are based on the time we gave it in the parenthisis.
    
    my $time_elements = localtime($raw_date);

    # Although $time_elements looks like a standard (scalar) variable - it is actually
    # "tied" to the subroutines in the module. It works along the same lines as the "new" constuctor
    # we saw.

    # If we wanted to print the year, all we'd need to do is..
    # print $time_elements->year; # This accesses a subroutine called "year" in Time::localtime
    # If we wanted to print the converted hour, we'd need to print...
    # print $time_elements->hour;
    # Seeing a pattern? :D

    # Lets return to the script, the month date, month name and year that our UNIX timestamp
    # holds. ( 25 11, 2001 ).
    # Because perl is odd, January is month number 0, March is month number 2
    # Human conventions find this odd, so we simply add 1 to the month we need.
    # Also, to make perl y2k compliant, we need to add "1900" to the year.

    my $to_return = "$time_elements->mday $time_elements->mon+1, $time_elements->year+1900";

    # Now lets hand that back to the script.

    return $to_return;

}

# We can now use this module in the following fashion:
#
# use Date;
# my $date = Date->new();
#
# my $converted_date = $date->printable_date("1092838473");
#
# print $converted_date;
#
# This will print 25 11, 2001 ( probably)







#------------------------------------------------------
# This is where ikonboard will look for further instructions after the module
#Êhas been loaded if we have specified as such from ikonboard.cgi.
# We've developed it like this to make it easier to use.
#
# If, you wanted to code a feature that would print the date, then you'd have
# have a subroutine called "printable_date" - this function would then take a
# UNIX timestamp, and make it human readable.
#------------------------------------------------------

sub Process {
    my ($obj, $db) = @_;
    my $CodeNo = $iB::IN{'CODE'};


    # We set up a hash. The left hand side is what the CODE value
    # was from the accessing URL (eg: CODE=save_date). To the right
    # is the sub routine that it will execute.
    # If this module is only used internally, then you can do away
    # with the whole sub process routine.

    my %Mode = ( 'printable_date'       => \&printable_date,
                 'another_sub'          => \&sub_two,
               );
    $Mode{$CodeNo} ? $Mode{$CodeNo}->($obj,$db) : FatalError();
} 

sub FatalError { die "I'm working on it!" }

1;

__END__
=pod

=NAME

Module name here

=DESCRIPTION

What the module does here


=AUTHOR

Your Name Here
<email@email.com>
=cut




