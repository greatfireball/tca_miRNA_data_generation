#!/usr/bin/env perl
use strict;
use warnings;
use Test::Script::Run;
use Test::More;

my ($return,$stdout,$stderr)=run_script('../scripts/miRNA/041_curated_mirdeep2fasta.pl',['040/040_test_miRDeep2_out.csv 10']);


open(HP,"<","040/040_test_miRDeep2_out-hairpin.fa") || die;
open(MA,"<","040/040_test_miRDeep2_out-mature.fa") || die;


my @got_mature	= <MA>;
my @got_hairpin	= <HP>;

#my $got = &parser($stdout);
#my $expected = &parser(join('',<DATA>));
my @exp_hairpin;
my @exp_mature;

while(<DATA>){
	if(s/^hp\t//){
		push(@exp_hairpin,$_);
	}
	elsif(s/^ma\t//){
		push(@exp_mature,$_);
	}
}


#my $expected_mature	= "040/040_expected_mature.fa";
#my $expected_hairpin	= "040/040_expected_hairpin.fa";


is_deeply(\@got_mature,\@exp_mature,'041 mature output as expected');
is_deeply(\@got_hairpin,\@exp_hairpin,'041 hairpin output as expected');


done_testing();



sub parser{
        my $p_stdout            =       $_[0];
        my $p_header            =       "";
        my %p_hash;
        foreach my $p_line ( split("\n",$p_stdout)){
                if($p_line=~/^>/){
                        $p_header       = $p_line;
                }
                else{
                        $p_hash{$p_header}=$p_line;
                }
        }

}

__DATA__
ma	>tca-new-1-5p
ma	GGATAAACCATACTCAGTTGATG
ma	>tca-new-1-3p
ma	TCACTGGGTAGAGTTTGTCCAA
ma	>tca-new-2-5p
ma	ATTGGGAGTTCAGGGCGCGGCTG
ma	>tca-new-2-3p
ma	CCGCGCCCCGCACTCGCGAGG
ma	>tca-new-3-5p
ma	TCGTCGACCAATCAGCTGCGAGC
ma	>tca-new-3-3p
ma	TCGTTCTGATTGGTCGATCCGT
hp	>tca-new-1
hp	GGATAAACCATACTCAGTTGATGTATTATAAAGCATCACTGGGTAGAGTTTGTCCAA
hp	>tca-new-2
hp	ATTGGGAGTTCAGGGCGCGGCTGTGACCTGCAGCCACTCGGAGAGGCCGCGCCCCGCACTCGCGAGG
hp	>tca-new-3
hp	TCGTCGACCAATCAGCTGCGAGCAAGTGATTGAATCGCTCGTTCTGATTGGTCGATCCGT
