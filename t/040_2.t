#!/usr/bin/env perl
use strict;
use warnings;
use Test::Script::Run;
use Test::More;

use bed;

my($return,$stdout,$stderr)=run_script('../scripts/046_merge_bed_files.pl');
like($stderr,qr/Example defining to classes with two files each and output to merged.bed/,'print help when no args provided');

($return,$stdout,$stderr)=run_script('../scripts/046_merge_bed_files.pl',[qw(--input bed1=040/041_testset_01.bed bed2=040/041_testset_02.bed)]);
#is($Test::Script::Run::last_script_exit_code,0,'script with one bed file as input');
#print "$return\n$stdout\n$stderr\n";


my $got	= &bed::parser($stdout);
my $expected = &bed::parser(join('',<DATA>));	
is_deeply($got,$expected,'output as expected');

done_testing();

__DATA__
NC_010241.1	0	1	length=1;counts=1/1	.	+
NC_010241.1	30	55	length=25;counts=1/1,1/1,1/1,1/1,1/1,1/1,1/1,1/1,1/1,2/2,1/1,1/1,1/1,1/1,2/2,1/1,1/1,1/1,1/1,1/1,1/1,1/1,1/1,1/1,1/1	.	+
NC_010241.1	10	20	length=10;counts=3/3,3/3,3/3,3/3,3/3,3/3,3/3,3/3,3/3,3/3	.	+
NC_010241.1	10	20	length=10;counts=2/2,2/2,2/2,2/2,2/2,2/2,2/2,2/2,2/2,2/2	.	-
NC_010241.1	50	65	length=15;counts=1/1,1/1,1/1,1/1,1/1,1/1,1/1,1/1,1/1,1/1,1/1,1/1,1/1,1/1,1/1	.	+
NC_010241.1	70	80	length=10;counts=2/2,2/2,2/2,2/2,2/2,2/2,2/2,2/2,2/2,2/2	.	+
NC_010241.1	90	100	length=10;counts=1/1,1/1,1/1,1/1,1/1,1/1,1/1,1/1,1/1,1/1	.	+
