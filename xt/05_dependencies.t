# -*- mode: cperl; -*-
use Test::Dependencies
    exclude => [qw(Test::Dependencies Test::Base Test::Perl::Critic
                   IO::File::AtomicChange)],
    style   => 'light';
ok_dependencies();
