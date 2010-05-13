#!/usr/bin/perl -w
use Test::More 'no_plan';
use warnings;
use strict;

use_ok 'Tie::Scalar::Callback';


my $var = 1;
tie $var, 'Tie::Scalar::Callback';

