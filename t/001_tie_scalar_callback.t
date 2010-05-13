#!/usr/bin/perl -w
use Test::More 'no_plan';
use warnings;
use strict;

use_ok 'Tie::Scalar::Callback';


my $var;

tie $var, 'Tie::Scalar::Callback', ON_STORE => sub {  };
