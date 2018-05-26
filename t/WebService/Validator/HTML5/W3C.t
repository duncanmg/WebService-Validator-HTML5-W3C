use strict;
use warnings;
use Test::More;
use Test::Exception;

use_ok('WebService::Validator::HTML5::W3C');

my $v = WebService::Validator::HTML5::W3C->new;
isa_ok( $v, 'WebService::Validator::HTML5::W3C' );

my $res;
lives_ok(
  sub {
    $res = $v->validate_direct_input(
      '<!DOCTYPE html> <html> <head> <title>Test</title> </head> <body> <p></p> </body> </html>');
  },
  "validate_direct_input lives"
);
ok( $res, "Document was valid" );

lives_ok(
  sub {
    $res = $v->validate_direct_input(
      '<!DOCTYPE html> <html> <head> <titleTest</title> </head> <body> <p></p> </body> </html>');
  },
  "validate_direct_input lives with invalid HTML"
);
ok( !$res, "Document was not valid" );

ok( scalar @{ $v->errors }, "Got some errors" );

foreach my $e ( @{ $v->errors } ) {

  # print $e . "\n";
}

done_testing;

