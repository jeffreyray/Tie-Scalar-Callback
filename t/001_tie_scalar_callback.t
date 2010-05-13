#!/usr/bin/perl -w
use Test::More 'no_plan';
use warnings;
use strict;

use_ok 'Tie::Scalar::Callback';


my $var;


# basic test
{
    my (@varss, @varsf);
    my ($f, $s) = (0, 0);
    tie $var, 'Tie::Scalar::Callback',
        ON_STORE => sub { $s++; @varss = @_;  },
        ON_FETCH => sub { $f++; @varsf = @_;  };
    $var = 1;
    my $var2 = $var;
    is($s, 1, 'store function called');
    is($f, 1, 'fetch function called');
    is_deeply(\@varss, [undef, 1], 'store args correct');
    is_deeply(\@varsf, [1], 'fetch args correct');
}



