#!/usr/bin/perl -w
use strict;
use Number::Misc ':all';
use Test;
BEGIN { plan tests => 30 };

# variables
my ($warn_hold);

# stubs for convenience
sub bool_comp;
sub comp;


# is_numeric
bool_comp is_numeric('3'),                       1;
bool_comp is_numeric('0003'),                    1;
bool_comp is_numeric('0.003'),                   1;
bool_comp is_numeric('0.00.3'),                  0;
bool_comp is_numeric('3,003'),                   1;
bool_comp is_numeric('  3'),                     0;
bool_comp is_numeric(undef),                     0;
bool_comp is_numeric('3,003',  convertible=>1),  1;
bool_comp is_numeric('  3',    convertible=>1),  1;
bool_comp is_numeric('0.00.3', convertible=>1),  0;

# to_number
comp to_number(' 3 '),                         3;
comp to_number(' 3,000 '),                     3000;
comp to_number('whatever'),                    undef;
comp to_number('whatever', always_number=>1),  0;

# commafie
comp commafie(2000),    '2,000';
comp commafie(2000.33),    '2,000.33';
comp commafie(-2000),  '-2,000';
comp commafie(100),       '100';


# zero_pad
comp zero_pad(2, 3),   '002';
comp zero_pad(2, 10),  '0000000002';
comp zero_pad(444, 2), '444';

# rand_in_range
RAND_LOOP: {
	for (1..100) {
		my $number = rand_in_range(-1, 10);
		
		if ( ($number < -1) || $number > 10 ) {
			ok 0;
			last RAND_LOOP;
		}
	}
	
	ok 1;
}

# is_even
# Turning of warnings because some of the tests produce expected warnings.
# I hate it when installations produce tons of warnings but I don't know
# which of them is actually a problem.  The following tests product warnings
# that aren't actually problems.
bool_comp is_even(1), 0;
bool_comp is_even(2), 1;
$warn_hold = $SIG{'__WARN__'};
$SIG{'__WARN__'} = sub {  };
comp is_even(undef), undef;
comp is_even('fred'), undef;
$SIG{'__WARN__'} = $warn_hold;

# is_odd
bool_comp is_odd(1), 1;
bool_comp is_odd(2), 0;
$warn_hold = $SIG{'__WARN__'};
$SIG{'__WARN__'} = sub {  };
comp is_odd(undef), undef;
comp is_odd('fred'), undef;
$SIG{'__WARN__'} = $warn_hold;



#------------------------------------------------------------------------------
# comp
#
sub comp {
	my ($val1, $val2) = @_;
	
	# if both undef
	if ( (! defined $val1) && (! defined $val2) )
		{ ok 1 }
	
	# if first is not defined, false
	elsif (! defined $val1)
		{ ok 0 }
	
	# if second is not defined, false
	elsif (! defined $val2)
		{ ok 0 }
	
	# else if same
	elsif ($val1 eq $val2)
		{ ok 1 }
	
	# else not same
	else
		{ ok 0 }
}
#
# comp
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# bool_comp
#
sub bool_comp {
	my ($val1, $val2) = @_;
	
	# if both true
	if ( $val1 && $val2 )
		{ ok 1 }
	
	# if both true
	elsif ( (! $val1) && (! $val2) )
		{ ok 1 }
	
	# else not ok
	else
		{ ok 0 }
}
#
# bool_comp
#------------------------------------------------------------------------------

