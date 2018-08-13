<div>
    <a href="https://travis-ci.org/hirose31/IO-File-AtomicChange"><img src="https://travis-ci.org/hirose31/IO-File-AtomicChange.png?branch=master" alt="Build Status" /></a>
    <a href="https://coveralls.io/r/hirose31/IO-File-AtomicChange?branch=master"><img src="https://coveralls.io/repos/hirose31/IO-File-AtomicChange/badge.png?branch=master" alt="Coverage Status" /></a>
</div>

# NAME

IO::File::AtomicChange - change content of a file atomically

# SYNOPSIS

truncate and write to temporary file. When you call $fh->close, replace
target file with temporary file preserved permission and owner (if
possible).

    use IO::File::AtomicChange;
    
    my $fh = IO::File::AtomicChange->new("foo.conf", "w");
    $fh->print("# create new file\n");
    $fh->print("foo\n");
    $fh->print("bar\n");
    $fh->close; # MUST CALL close EXPLICITLY

If you specify "backup\_dir", save original file into backup directory (like
"/var/backup/foo.conf\_YYYY-MM-DD\_HHMMSS\_PID") before replace.

    my $fh = IO::File::AtomicChange->new("foo.conf", "a",
                                         { backup_dir => "/var/backup/" });
    $fh->print("# append\n");
    $fh->print("baz\n");
    $fh->print("qux\n");
    $fh->close; # MUST CALL close EXPLICITLY

# DESCRIPTION

IO::File::AtomicChange is intended for people who need to update files
reliably and atomically.

For example, in the case of generating a configuration file, you should be
careful about aborting generator program or be loaded by other program
in halfway writing.

IO::File::AtomicChange free you from such a painful situation and boring code.

# INTERNAL

    * open
      1. fix filename of temporary file by mktemp.
      2. if target file already exists, copy target file to temporary file preserving permission and owner.
      3. open temporary file and return its file handle.
    
    * write
      1. write date into temporary file.
    
    * close
      1. close temporary file.
      2. if target file exists and specified "backup_dir" option, copy target file into backup directory preserving permission and owner, mtime.
      3. rename temporary file to target file.

# CAVEATS

You must call "$fh->close" explicitly when commit changes.

Currently, "close $fh" or "undef $fh" don't affect target file. So if you
exit without calling "$fh->close", CHANGES ARE DISCARDED.

# AUTHOR

HIROSE Masaaki <hirose31 \_at\_ gmail.com>

# THANKS TO

kazuho gave me many shrewd advice.

# REPOSITORY

[https://github.com/hirose31/IO-File-AtomicChange](https://github.com/hirose31/IO-File-AtomicChange)

    git clone git://github.com/hirose31/IO-File-AtomicChange.git

patches and collaborators are welcome.

# SEE ALSO

[IO::File](https://metacpan.org/pod/IO::File), [IO::AtomicFile](https://metacpan.org/pod/IO::AtomicFile), [File::AtomicWrite](https://metacpan.org/pod/File::AtomicWrite)

# COPYRIGHT & LICENSE

Copyright HIROSE Masaaki 2009-

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

\# for Emacsen
\# Local Variables:
\# mode: cperl
\# cperl-indent-level: 4
\# cperl-close-paren-offset: -4
\# cperl-indent-parens-as-block: t
\# indent-tabs-mode: nil
\# coding: utf-8
\# End:

\# vi: set ts=4 sw=4 sts=0 et ft=perl fenc=utf-8 ff=unix :
