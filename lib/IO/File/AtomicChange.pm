package IO::File::AtomicChange;

use strict;
use warnings;

our $VERSION = '0.01_01';

use base qw(IO::File);
use Carp;
use File::Temp qw(:mktemp);
use File::Copy;

sub new {
    my $class = shift;
    my $self = $class->SUPER::new();
    $self->temp_file("");
    $self->target_file("");
    $self->backup_dir("");
    $self->open(@_) if @_;
    $self;
}

sub _accessor {
    my($self, $tag, $val) = @_;
    ${*$self}{$tag} = $val if $val;
    return ${*$self}{$tag};
}
sub temp_file   { return shift->_accessor("io_file_atomicchange_temp", @_) }
sub target_file { return shift->_accessor("io_file_atomicchange_path", @_) }
sub backup_dir  { return shift->_accessor("io_file_atomicchange_back", @_) }

sub DESTROY {
    carp "[CAUTION] disposed object without closing file handle." unless $_[0]->_closed;
}

sub open {
    my ($self, $path, $mode, $opt) = @_;
    ref($self) or $self = $self->new;

    my $temp = mktemp("${path}.XXXXXX");
    $self->temp_file($temp);
    $self->target_file($path);

    copy_preserving_attr($path, $temp) if -f $path;
    if (exists $opt->{backup_dir}) {
        unless (-d $opt->{backup_dir}) {
            croak "no such directory: $opt->{backup_dir}";
        }
        $self->backup_dir($opt->{backup_dir});
    }

    $self->SUPER::open($temp, $mode) ? $self : undef;
}

sub _closed {
    my $self = shift;
    my $tag = "io_file_atomicchange_closed";

    my $oldval = ${*$self}{$tag};
    ${*$self}{$tag} = shift if @_;
    return $oldval;
}

sub close {
    my ($self, $die) = @_;
    unless ($self->_closed(1)) {
        if ($self->SUPER::close()) {

            if (-f $self->target_file) {
                $self->copy_modown_to_temp;
                $self->backup if $self->backup_dir;
            }

            rename($self->temp_file, $self->target_file)
                or ($die ? croak "close (rename) atomic file: $!\n" : return undef);
        } else {
            $die ? croak "close atomic file: $!\n" : return undef;
        }
    }
    1;
}

sub copy_modown_to_temp {
    my($self) = @_;

    my($mode, $uid, $gid) = (stat($self->target_file))[2,4,5];
    chown $uid, $gid, $self->temp_file;
    chmod $mode,      $self->temp_file;
}

sub backup {
    my($self) = @_;

    require Path::Class;
    require POSIX;

    my $basename = Path::Class::file($self->target_file)->basename;

    my $backup_file;
    my $n = 0;
    while ($n < 7) {
        $backup_file = sprintf("%s/%s_%s_%d%s",
                               $self->backup_dir,
                               $basename,
                               POSIX::strftime("%Y-%m-%d_%H%M%S",localtime()),
                               $$,
                               ($n == 0 ? "" : ".$n"),
                              );
        last unless -f $backup_file;
        $n++;
    }
    croak "already exists backup file: $backup_file" if -f $backup_file;

    copy_preserving_attr($self->target_file, $backup_file);
}


sub delete {
    my $self = shift;
    unless ($self->_closed(1)) {
        $self->SUPER::close();
        return unlink($self->temp_file);
    }
    1;
}

sub detach {
    my $self = shift;
    $self->SUPER::close() unless ($self->_closed(1));
    1;
}

sub copy_preserving_attr {
    my($from, $to) = @_;

    File::Copy::copy($from, $to) or croak $!;

    # mode, uid, gid
    my($mode, $uid, $gid, $atime, $mtime) = (stat($from))[2,4,5,8,9];
    chown $uid, $gid, $to;
    chmod $mode,      $to;

    # atime, mtime
    utime $atime, $mtime, $to;
}


1;
__END__

=head1 NAME

IO::File::AtomicChange - fixme

=head1 SYNOPSIS

  use IO::File::AtomicChange;
  fixme

=head1 DESCRIPTION

IO::File::AtomicChange is fixme

=head1 AUTHOR

HIROSE Masaaki E<lt>hirose31 _at_ gmail.comE<gt>

=head1 REPOSITORY

L<http://github.com/hirose31/p5-io-file-atomicchange/tree/master>

  git clone git://github.com/hirose31/p5-io-file-atomicchange.git

patches and collaborators are welcome.

=head1 SEE ALSO

=head1 COPYRIGHT & LICENSE

Copyright HIROSE Masaaki 2009-

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
