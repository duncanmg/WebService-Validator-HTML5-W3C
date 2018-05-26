use 5.006;
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME             => 'WebService::Validator::HTML5::W3C',
    AUTHOR           => q{Duncan Garland <duncan.garland\@ntlworld.com>},
    VERSION_FROM     => 'lib/WebService/Validator/HTML5/W3C.pm',
    ABSTRACT_FROM    => 'lib/WebService/Validator/HTML5/W3C.pm',
    LICENSE          => 'artistic_2',
    PL_FILES         => {},
    MIN_PERL_VERSION => 5.006,
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => 0,
    },
    BUILD_REQUIRES => {
        'Test::More' => 0,
        'Test::Exception' => 0,
    },
    PREREQ_PM => {
	'Moo' => 0,
	'Params::Validate' => 0,
	'LWP' => 0,
	'HTTP::Request::Common' => 0,
	'HTML::TreeBuilder::LibXML' => 0,
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'WebService-Validator-HTML5-W3C-*' },
);
