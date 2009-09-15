use inc::Module::Install;

name 'WebService-SmartFM';
all_from 'lib/WebService/SmartFM.pm';

requires 'WebService::Simple';

build_requires 'Test::More';
use_test_base;
auto_include_deps;
author_tests('xt');
auto_set_repository;
WriteAll;
