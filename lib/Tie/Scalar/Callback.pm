package Tie::Scalar::Callback;
use strict;
use warnings;

our $VERSION = 1.00;
our $AUTHORITY = "CPAN:JHALLOCK";

use Tie::Scalar;
use base qw(Tie::Scalar);

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
    &{ $self->{ON_FETCH} }( $self->{VALUE} ) if $self->{ON_FETCH};
    return $self->{VALUE};
}

sub STORE {
    my $self = shift;
    my $oldval = $self->{VALUE};
    my $newval = shift;
    $self->{VALUE} = $newval;
    &{ $self->{ON_STORE} }( $oldval, $newval ) if $self->{ON_STORE};
}



1;


__END__
=pod

=head1 NAME

Tie::Scalar::Callback - Scalar variables that execute callbacks

=head1 SYNOPSIS

    use Tie::Scalar::Callback;

    tie my $k, 'Tie::Scalar::Callback',
        ON_FETCH => sub { print "value is $_[0]\n" },
        ON_STORE => sub { print "changing value from $_[0] to $_[1]\n" };

    $k = 1;   # prints "changing value from  to 1\n"
    $l = $k;  # prints "value is 1"
    $k = 2;   # prints "changing value from 1 to 2\n"

=head1 DESCRIPTION

This module allows you to tie a scalar variable which will execute a callback
when storing or retrieving the value. When tying, you can specify named
arguments in the form of a hash. The following named parameters are supported:

=over 4

=item C<ON_STORE>

Use C<ON_STORE> to specify the callback to be executed when the storing to the
variable.  The callback will be passed the old value and the new value of the
tied variable;

=item C<ON_FETCH>

Use C<ON_FETCH> to specify the callback to be executed when the storing to the
variable. The callback will be passed the current value of the tied variable.

=head1 SEE ALSO

L<Gtk2::Ex::DateEntry::CellRenderer>, L<Gtk2::Ex::FormFactory::DateEntry>

=head1 AUTHOR

Jeffrey Hallock  <jeffrey @ jeffrey ray dot info>.

=head1 BUGS

None known. Please send bugs to <jeffrey @ jeffrey ray dot info>.
Patches and suggestions welcome.

The development version is available at
L<http://github.com/jhallock/Tie-Scalar-Callback>

=head1 LICENSE

Tie-Scalar-Callback is Copyright 2010 Jeffrey Ray Hallock

Tie-Scalar-Callback is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by the
Free Software Foundation; either version 3, or (at your option) any later
version.

Tie-Scalar-Callback is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
more details.

You should have received a copy of the GNU General Public License along with
Tie-Scalar-Callback.  If not, see L<http://www.gnu.org/licenses/>.

=cut


