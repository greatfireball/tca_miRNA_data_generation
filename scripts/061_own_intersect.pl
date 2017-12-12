#!/usr/bin/env perl

use strict;
use warnings;

my %input = ();

use Getopt::Long;
use Data::Dumper;

GetOptions(
    "input=s%" => \%input
    );

# split input keys into seperate files
foreach my $key (keys %input)
{
    $input{$key} = [ split(/,/, $input{$key}) ];
}

my @genome = ();
my %chromosomes = ();
my %strands    = ();
my %conditions = ();


foreach my $key (keys %input)
{
    foreach my $file (@{$input{$key}})
    {
	warn "Working on file '$file'\n";
	open(FH, "<", $file) || die "Unable to open file '$file': $!";
	while(<FH>)
	{
	    # go through the bed files
	    chomp;

	    # NW_001809801.1	79510	79534	XM_001647792.1	1	+
	    # NW_001809801.1	79527	79534	XM_001647792.1	1	+
	    # NW_001809801.1	248783	248807	XM_001647796.1	1	-
            # NW_001809801.1	533942	533950	XM_001647802.1	1	-
            # NW_001809801.1	2779750	2779790	XM_001647839.1	1	+

	    my ($chromosome, $start, $stop, $mrna_ids, undef, $strand) = split(/\t/, $_);

	    # check if chromosome is already known
	    unless (exists $chromosomes{$chromosome})
	    {
		$chromosomes{$chromosome} = int(keys %chromosomes);
	    }
	    $chromosome = $chromosomes{$chromosome};

	    # check if strand is already known
	    unless (exists $strands{$strand})
	    {
		$strands{$strand} = int(keys %strands);
	    }
	    $strand = $strands{$strand};

	    # check if condition/key is already known
	    unless (exists $conditions{$key})
	    {
		$conditions{$key} = int(keys %conditions);
	    }
	    my $condition = $conditions{$key};

	    # for each chromosomal position we need to consider:
	    # Counter + strand
	    # Counter - strand

	    for (my $i=$start; $i<=$stop; $i++)
	    {
		$genome[$chromosome][$strand][$i][$condition]++;
	    }
	}
	close(FH) || die "Unable to close file '$file': $!";
    }
}

# print the output
my @conditions_ordered = sort (keys %conditions);
print "# Conditional counts are printed in the following order: ", join(", ", ("total", @conditions_ordered)), "\n";

foreach my $chromosome_key (sort keys %chromosomes)
{
    my $chromosome = $chromosomes{$chromosome_key};
    foreach my $strand_key (sort keys %strands)
    {
	my $strand = $strands{$strand_key};

	# check if the strand and the chromosome are existing
	unless (defined $genome[$chromosome] && ref($genome[$chromosome]) eq "ARRAY")
	{
	    # chromosomes should be always defined!
	    die "Missing entry for chromosome '$chromosome_key'\n";
	}
	unless (defined $genome[$chromosome][$strand] && ref($genome[$chromosome][$strand]) eq "ARRAY")
	{
	    # if no feature is annotated on the strand if could be missing
	    warn "No feature on chromosome '$chromosome_key' for ($strand_key)-strand.\n";
	    next;
	}

	my $start = -1;
	for (my $i=0; $i<@{$genome[$chromosome][$strand]}; $i++)
	{
	    my $counts_on_position = get_counts_for_position(\@genome, $chromosome, $strand, $i, \%conditions);

	    if ($counts_on_position->{total} > 0)
	    {
		# we found a new block
		$start = $i;
		my $stop = -1;

		my @counts = ($counts_on_position);

		for (my $j=$i+1; $j<@{$genome[$chromosome][$strand]}; $j++)
		{
		    my $counts_on_inner_position = get_counts_for_position(\@genome, $chromosome, $strand, $j, \%conditions);

		    if ($counts_on_inner_position->{total} > 0)
		    {
			$stop = $j;
			push(@counts, $counts_on_inner_position);
		    } else {
			last;
		    }
		}
		if ($stop == -1)
		{
		    $stop = int(@{$genome[$chromosome][$strand]});
		}

		print join("\t", ($chromosome_key, $start, $stop, sprintf("length=%d;counts=%s", @counts+0, generate_cigar_like_string(\@counts, ["total", @conditions_ordered])), ".", $strand_key)), "\n";
		$i = $stop+1;
		$start = -1; $stop = -1;
	    }
	}
	$genome[$chromosome][$strand] = undef; # reduce memory footprint
    }
    $genome[$chromosome] = undef; # reduce memory footprint
}

sub generate_cigar_like_string
{
    my ($ref_counts, $ref_ordered_conditions) = @_;

    my @output = ();

    foreach my $counts (@{$ref_counts})
    {
	push(@output, join("/", map {$counts->{$_}} (@{$ref_ordered_conditions})));
    }

    return join(",", @output);
}

sub get_counts_for_position
{
    my ($ref_genome, $chr, $str, $pos, $ref_conditions) = @_;

    my %counts = ( total => 0 );
    foreach my $condition (keys %{$ref_conditions})
    {
	my $val = $ref_genome->[$chr][$str][$pos][$ref_conditions->{$condition}];
	$counts{$condition} = (defined $val) ? $val : 0;
	$counts{total} += $counts{$condition};
    }

    return \%counts;
}
