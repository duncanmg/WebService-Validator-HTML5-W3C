package WebService::Validator::HTML5::W3C;

use 5.010;
use Moo;
use Params::Validate qw/:all/;
use LWP;
use HTTP::Request::Common;
use HTML::TreeBuilder::LibXML;

has 'validator_url' => ( 'is' => 'rw', 'default' => 'http://validator.w3.org/nu/#textarea' );

has 'user_agent' => ( 'is' => 'rw', 'default' => "MyApp/0.1" );

has 'ua' => (
  'is'      => 'rw',
  'default' => sub {
    my $lwp = LWP::UserAgent->new();
    return $lwp;
  }
);

has 'result' => ( 'is' => 'rw' );

has 'errors' => ( 'is' => 'rw', 'default' => sub { [] } );

=head1 NAME

WebService::Validator::HTML5::W3C - The great new WebService::Validator::HTML5::W3C!

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.02';

=head1 SYNOPSIS

Validates HTML5 using the W3C validator at http://validator.w3.org/nu.
Direct HTML input only.

    use WebService::Validator::HTML5::W3C;

    my $v = WebService::Validator::HTML5::W3C->new();
    my $valid =  $v->validate_direct_input(
          '<!DOCTYPE html> <html> <head> <title>Test</title> </head> <body> <p></p> </body> </html>');

    print ($valid ? "Document was valid." : "Document was not valid.") . "\n";

    foreach my $e ( @{ $v->errors } ) {
      print $e . "\n";
    }

=head1 METHODS

=head2 new

  my $v = WebService::Validator::HTML5::W3C->new();

=head3 Optional constructor arguments

=over

=item validator_url

Override the default location of the validator service which is http://validator.w3.org/nu/#textarea

=item user_agent

Override the default user agent which is "MyApp/0.1"

=item ua

Override the default ua which is LWP::UserAgent->new()

=item result

Holds the raw result from the validator. Please leave this as the deault.

=item errors

Holds the list of errors, Please leave this as the deault.

=back

=cut

=head2 validate_direct_input

    my $valid =  $v->validate_direct_input(
          '<!DOCTYPE html> <html> <head> <title>Test</title> </head> <body> <p></p> </body> </html>');

=cut

sub validate_direct_input {
  my ( $self, $text ) = validate_pos( @_, 1, { type => SCALAR } );

  $self->_post_text($text);

  return $self->_analyze_result();

}

sub _post_text {
  my ( $self, $text ) = validate_pos( @_, 1, { type => SCALAR } );
  $self->result(
    $self->ua->request(
      POST $self->validator_url,
      Content_Type      => 'form-data',
      Connection        => 'keep-alive',
      Referer           => 'https://validator.w3.org/nu/',
      'Accept-Encoding' => 'None',
      Content           => [
        'showsource' => 'no',
        'content'    => $text
      ]
    )
  );
  return 1;
}

sub _analyze_result {
  my $self = shift;
  my $tb   = HTML::TreeBuilder::LibXML->new;
  $tb->parse( $self->result->content );
  $tb->eof;

  my $result = shift @{ $tb->findnodes('//div[@id="results"]') };

  my $success = $result->findnodes('//p[@class="success"]');
  return 1 if scalar @$success;

  $self->_process_errors($result);

  return;
}

sub _process_errors {
  my ( $self, $result ) = validate_pos( @_, 1, { type => OBJECT } );
  my @errors = $result->findnodes(
    '//li[contains(@class,"error") or contains(@class,"warn") or contains(@class,"info")]');
  foreach my $e (@errors) {
    push @{ $self->errors }, $e->string_value;
  }
  return 1;
}

=head1 AUTHOR
Duncan Garland, C<< <duncan.garland\ at ntlworld.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-webservice-validator-html5-w3c at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=WebService-Validator-HTML5-W3C>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc WebService::Validator::HTML5::W3C


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=WebService-Validator-HTML5-W3C>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/WebService-Validator-HTML5-W3C>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/WebService-Validator-HTML5-W3C>

=item * Search CPAN

L<http://search.cpan.org/dist/WebService-Validator-HTML5-W3C/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2018 Duncan Garland.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


=cut

1;    # End of WebService::Validator::HTML5::W3C

