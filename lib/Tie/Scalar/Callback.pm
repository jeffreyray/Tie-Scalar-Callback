package Tie::Scalar::Callback;
use strict;
use warnings;

use Tie::Scalar;
use base qw(Tie::StdScalar);

sub TIESCALAR {
    my $class = shift;
    my $self  = {
        ON_STORE   => undef,
        ON_FETCH   => undef,
        @_,
    };
    return bless $self, $class;
}

sub FETCH {
    my $self = shift;
    &{ $self->{ON_FETCH} } if $self->{ON_FETCH};
    return $self->{VALUE};
}

sub STORE {
    my $self = shift;
    $self->{VALUE} = shift;
    &{ $self->{ON_STORE} } if $self->{ON_STORE};
}



1;
