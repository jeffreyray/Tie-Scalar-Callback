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

This module allows you to tie a scalar variable whose value will be reset
(subject to an expiration policy) after a certain time and/or a certain number
of uses. One possible application for this module might be to time out session
variables in mod_perl programs.

When tying, you can specify named arguments in the form of a hash. The
following named parameters are supported:

=over 4

=item C<EXPIRES>

Use C<EXPIRES> to specify an interval or absolute time after which the
value will be reset. (Technically, the value will still be there, but the
module's FETCH sub will return the value as dictated by the expiration
policy.)

Values for the C<EXPIRES> field are modeled after Netscape's cookie expiration
times. Except, of course, that negative values don't really make sense in a
universe with linear, one-way time. The following forms are all valid for the
C<EXPIRES> field:

    +30s                    30 seconds from now
    +10m                    ten minutes from now
    +1h                     one hour from now
    +3M                     in three months
    +10y                    in ten years time
    25-Apr-2001 00:40:33    at the indicated time & date

Assigning a value to the variable causes C<EXPIRES> to be reset to the
original value.

=item C<VALUE>

Using the C<VALUE> hash key, you can specify an initial value for the
variable.

=item C<NUM_USES>

Alternatively or in addition to C<EXPIRES>, you can also specify a maximum
number of times the variable may be read from before it expires. If both
C<EXPIRES> and C<NUM_USES> are set, the variable will expire when either
condition becomes true. If C<NUM_USES> isn't set or set to a negative
value, it won't influence the expiration process.

Assigning a value to the variable causes C<NUM_USES> to be reset to the
original value.

=item C<POLICY>

The expiration policy determines what happens to the variable's value when
it expires. If you don't specify a policy, the variable will be C<undef>
after it has expired. You can specify either a scalar value or a code
reference as the value of the C<POLICY> parameter. If you specify a scalar
value, that value will be returned after the variable has expired. Thus,
the default expiration policy is equivalent to

    POLICY => undef

If you specify a code reference as the value of the C<POLICY> parameter,
that code will be called when the variable value is C<FETCH()>ed after it
has expired. This might be used to set some other variable, or reset the
variable to a different value, for example.

=back

=head1 INSTALLATION

See perlmodinstall for information and options on installing Perl modules.

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests through the web interface at
L<http://rt.cpan.org/Public/Dist/Display.html?Name=Tie-Scalar-Timeout>.

=head1 AVAILABILITY

The latest version of this module is available from the Comprehensive Perl
Archive Network (CPAN). Visit L<http://www.perl.com/CPAN/> to find a CPAN
site near you, or see
L<http://search.cpan.org/dist/Tie-Scalar-Timeout/>.

The development version lives at
L<http://github.com/hanekomu/Tie-Scalar-Timeout/>.
Instead of sending patches, please fork this project using the standard git
and github infrastructure.

=head1 AUTHOR

  Marcel Gruenauer <marcel@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2003 by Marcel Gruenauer.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


