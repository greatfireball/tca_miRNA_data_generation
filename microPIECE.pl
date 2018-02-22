#!/usr/bin/env perl

use strict;
use warnings;

use FindBin qw($RealBin $Script);
use lib "$RealBin/lib/";

use microPIECE;
use Log::Log4perl;

# get a logger
my $L = Log::Log4perl::get_logger();
Log::Log4perl->init( \q(
	log4perl.rootLogger                     = INFO, Screen
	log4perl.appender.Screen                = Log::Log4perl::Appender::Screen
	log4perl.appender.Screen.stderr         = 1
	log4perl.appender.Screen.layout         = PatternLayout
	log4perl.appender.Screen.layout.ConversionPattern = [%d{yy-MM-dd HH:mm:ss}] %m%n
));

# parse the input parameter
use Getopt::Long;
use Pod::Usage;

# GetOptions
my %opt = ();

GetOptions( # use %opt as defaults (demo-set)
	    \%opt, qw(
	)
    ) || pod2usage(1);

microPIECE::hello();

__END__

=pod



=cut