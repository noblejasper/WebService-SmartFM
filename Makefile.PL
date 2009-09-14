use inc::Module::Install;

name 'Net-SmartFM';
all_from 'lib/Net/SmartFM.pm';

#requires 'Any::Moose';

build_requires 'Test::More';
use_test_base;
auto_include_deps;
author_tests('xt');
auto_set_repository;
WriteAll;
