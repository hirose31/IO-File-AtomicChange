ABSTRACT
================

IO::File::AtomicChange is intended for people who need to update files
reliably and atomically.

For example, in the case of generating a configuration file, you should be
careful about aborting generator program or be loaded by other program
in halfway writing.

IO::File::AtomicChange free you from such a painful situation and boring code.


INSTALLATION
================

IO::File::AtomicChange installation is straightforward. If your CPAN shell is set up,
you should just be able to do

    % cpan IO::File::AtomicChange

Download it, unpack it, then build it as per the usual:

    % perl Makefile.PL
    % make && make test

Then install it:

    % make install


DOCUMENTATION
================

IO::File::AtomicChange documentation is available as in POD. So you can do:

    % perldoc IO::File::AtomicChange

to read the documentation online with your favorite pager.

HIROSE Masaaki


COPYRIGHT & LICENSE
================

Copyright HIROSE Masaaki 2009-

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.
