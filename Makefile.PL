use inc::Module::Install;

name     'IO-File-AtomicChange';
all_from 'lib/IO/File/AtomicChange.pm';
license  'perl';

# requires '';

tests 't/*.t';
author_tests 'xt';

build_requires 'Test::More';
auto_set_repository;
use_test_base;
auto_include;
WriteAll;
