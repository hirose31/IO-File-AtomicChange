use inc::Module::Install;

name     'IO-File-AtomicChange';
all_from 'lib/IO/File/AtomicChange.pm';
license  'perl';

build_requires 'Test::More';
build_requires 'FindBin';

requires 'IO::File';
requires 'File::Temp';
requires 'File::Copy';
requires 'Path::Class';
requires 'POSIX';

tests 't/*.t';
#author_tests 'xt';

build_requires 'Test::More';
auto_set_repository;
use_test_base;
auto_include;
WriteAll;
