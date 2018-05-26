#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'WebService::Validator::HTML5::W3C' ) || print "Bail out!\n";
}

diag( "Testing WebService::Validator::HTML5::W3C $WebService::Validator::HTML5::W3C::VERSION, Perl $], $^X" );
