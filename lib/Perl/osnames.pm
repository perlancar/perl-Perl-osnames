package Perl::osnames;

# DATE
# VERSION

use strict;
use warnings;

use Exporter qw(import);
our @EXPORT_OK = qw($data is_unix is_posix);

our $data = [

    ['aix', [qw/unix sysv posix/], 'IBM AIX'],
    ['beos', [qw/posix/], 'See also: haiku'],
    ['cygwin', [qw/unix posix/], ''],

    ['darwin', [qw/unix bsd posix/],

     'Mac OS X. Does not currently (2013) include iOS because Perl has not been
     ported to that platform yet (but PerlMotion is being developed)',

 ],

    ['dec_osf', [qw//], 'DEC Alpha'],
    ['dragonfly', [qw/unix bsd posix/], 'DragonFly BSD'],
    ['freebsd', [qw/unix bsd posix/], ''],
    ['gnukfreebsd', [qw/unix bsd posix/], 'Debian GNU/kFreeBSD'],
    ['haiku', [qw/posix/], 'See also: beos'],
    ['hpux', [qw/unix sysv posix/], 'HP-UX'],
    ['interix', [qw/unix posix/], ''],
    ['irix', [qw/unix sysv posix/], ''],
    ['linux', [qw/unix posix/], ''], # unix-like
    ['MacOS', [qw//], 'Mac OS Classic (which predates Mac OS X)'],
    ['midnightbsd', [qw/unix bsd posix/], ''],
    ['minix', [qw/unix posix/], ''], # unix-like
    ['mirbsd', [qw/unix bsd posix/], 'MirOS BSD'],

    ['MSWin32', [qw//],

     'All Windows platforms including 95/98/ME/NT/2000/XP/CE/.NET. But does not
     include Cygwin (see "cygwin") or Interix (see "interix"). To get more
     details on which Windows you are on, use Win32::GetOSName() or
     Win32::GetOSVersion(). Ref: perlvar.',

 ],

    ['netbsd', [qw/unix bsd posix/], ''],
    ['openbsd', [qw/unix bsd posix/], ''],
    ['sco', [qw/unix sysv posix/], 'SCO UNIX'],
    ['solaris', [qw/unix sysv posix/], 'This includes the old SunOS.'],

    # These OS-es are listed on CPAN Testers OS Leaderboards, but I couldn't
    # google any reports on them. So I couldn't peek the $Config{osname} value.

    # - bigtrig
    # - gnu hurd
    # - os/2
    # - os390/zos
    # - qnx neutrino
    # - tru64 (Tru64 UNIX, unix bsd)
    # - vms

];

for (@$data) {
    # unindent & unwrap text first, Text::Wrap doesn't do those
    $_->[2] =~ s/^[ \t]+//mg;
    $_->[2] =~ s/\n(\n?)(\S)/$1 ? "\n\n$2" : " $2"/mge;
}

# dump: display data as table
#use Data::Format::Pretty::Text qw(format_pretty);
#say format_pretty($data, {
#    table_column_formats=>[{description=>[[wrap=>{columns=>40}]]}],
#    table_column_orders=>[[qw/code summary description/]],
#});

# debug: dump data
#use Data::Dump::Color;
#dd $data;

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
