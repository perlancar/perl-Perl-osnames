package Perl::osnames;

# DATE
# VERSION

use strict;
use warnings;

use Exporter qw(import);
our @EXPORT_OK = qw($data is_unix is_posix);

our $data = [map {
    chomp;
    my @f = split /\s+/, $_, 3;
    $f[1] = $f[1] eq '-' ? [] : [split /,/, $f[1]];
    \@f;
} split /^/m, <<'_'];
aix          posix,sysv,unix   IBM AIX.
beos         posix             See also: haiku.
cygwin       posix,unix
darwin       bsd,posix,unix    Mac OS X. Does not currently (2013) include iOS. See also: iphoneos.
dec_osf      -                 DEC Alpha.
dragonfly    bsd,posix,unix    DragonFly BSD.
freebsd      bsd,posix,unix
gnukfreebsd  bsd,posix,unix    Debian GNU/kFreeBSD.
haiku        posix             See also: beos.
hpux         posix,sysv,unix   HP-UX.
interix      posix,unix        Optional, POSIX-compliant Unix subsystem for Windows NT. Also known as Microsoft SFU. No longer included in Windows nor supported.
irix         posix,sysv,unix
linux        posix,unix
MacOS        -                 Mac OS Classic (predates Mac OS X). See also: darwin, iphoneos.
midnightbsd  bsd,posix,unix
minix        bsd,posix
mirbsd       bsd,posix,unix    MirOS BSD.
MSWin32      -                 All Windows platforms including 95/98/ME/NT/2000/XP/CE/.NET. But does not include Cygwin (see "cygwin") or Interix (see "interix"). To get more details on which Windows you are on, use Win32::GetOSName() or Win32::GetOSVersion(). Ref: perlvar.
netbsd       bsd,posix,unix
openbsd      bsd,posix,unix
sco          posix,sysv,unix   SCO UNIX.
solaris      posix,sysv,unix   This includes the old SunOS.
_

# dump: display data as table
#use Data::Format::Pretty::Text qw(format_pretty);
#say format_pretty($data, {
#    table_column_formats=>[{description=>[[wrap=>{columns=>40}]]}],
#    table_column_orders=>[[qw/code summary description/]],
#});

# debug: dump data
use Data::Dump::Color;
dd $data;

sub is_posix {
    my $os = shift // $^O;
    for my $rec (@$data) {
        next unless $rec->[0] eq $os;
        for (@{$rec->[1]}) {
            return 1 if $_ eq 'posix';
        }
        return 0;
    }
    undef;
}

sub is_unix {
    my $os = shift // $^O;
    for my $rec (@$data) {
        next unless $rec->[0] eq $os;
        for (@{$rec->[1]}) {
            return 1 if $_ eq 'unix';
        }
        return 0;
    }
    undef;
}

1;
# ABSTRACT: List possible $^O ($OSNAME) values, with description

=head1 DESCRIPTION

This package contains C<$data> which lists possible values of C<$^O> along with
description for each. It also provides some helper functions.

=head2 Tags

=over

=item * unix

Unix-like operating systems. This currently excludes beos/haiku.

=item * bsd

BSD-derived Unix operating systems.

=item * sysv

SysV-derived Unix operating systems.

=item * posix

For POSIX-compliant OSes, including fully-, mostly-, and largely-compliant ones
(source: L<http://en.wikipedia.org/wiki/POSIX>).

From what I can gather, dec_osf is not POSIX compliant, although there is a
posix package for it.

=back


=head1 VARIABLES

None are exported by default, but they are exportable.

=head2 C<$data>

An arrayref of records (arrayrefs), each structured as:

 [$name, \@tags, $description]


=head1 FUNCTIONS

None are exported by default, but they are exportable.

=head2 is_posix([ $os ]) => bool

Check whether C<$os> (defaults to C<$^O> if not specified) is POSIX (checked by
the existence of C<posix> tag on the OS's record in C<$data>). Will return 0, 1,
or undef if C<$os> is unknown.

=head2 is_unix([ $os ]) => bool

Check whether C<$os> (defaults to C<$^O> if not specified) is Unix (checked by
the existence of C<unix> tag on the OS's record in C<$data>). Will return 0, 1,
or undef if C<$os> is unknown.


=head1 SEE ALSO

L<perlvar>

L<Config>

L<Devel::Platform::Info>

The output of C<perl -V>

L<App::osnames>

=cut
