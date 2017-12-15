#!/usr/bin/perl
use strict;
use warnings;
# takes ff bedfile and extracts signal positions
# signal strength defined by user


my $bed_file		= $ARGV[0];
my $signal_strength	= $ARGV[1];

open(BED,"<",$bed_file) || die;
while(<BED>){
	chomp;

	# ignore comment lines and pipe them through
	if($_ =~ /^#/)
	{
	    print "$_\n";
	    next;
	}

	# parse the bed line
	my $bed_line	= $_;	# chr	start	stop	info	.	strand
	my ($bed_chr, $bed_start, $bed_stop, $bed_info, undef, $bed_strand)	= split("\t",$bed_line);
	my %data_from_bed_info = ();
	foreach my $key_value (split(";",$bed_info))           # length=XY;counts=pos_1sum/pos1_rep1/pos2_rep2/.../pos1_repN/,pos2_sum/pos2_rep1/...
	{
	    my ($key, $value) = split("=", $key_value,2);
	    $data_from_bed_info{$key} = $value;
	}

	# split the count data
	$data_from_bed_info{counts} = [ map { [ split('/', $_) ] } (split(",", $data_from_bed_info{counts})) ];

	# go through the bed counts and keep stretches which are
	# supported by $signal_strength or more peaks and store the
	# coordinates in new array @subregions
	my @subregions = ();

	for(my $i=0; $i<@{$data_from_bed_info{counts}}; $i++)
	{
	    if ($data_from_bed_info{counts}[$i][0] >= $signal_strength)
	    {
		my $start = $i;
		my $stop  = $i;
		for(my $j=$i+1; $j<@{$data_from_bed_info{counts}}; $j++)
		{
		    if ($data_from_bed_info{counts}[$i][0] < $signal_strength)
		    {
			$i = $j;
			last;
		    } else {
			$stop = $j;
		    }
		}

		push(@subregions, { start => $start, stop => $stop } );
	    }
	}
	foreach(keys %bed_pos_tmp_hash){
		my $bed_pos_tmp_hash_id		= $_;
		my @bed_pos_tmp_hash_array	= @{$bed_pos_tmp_hash{$bed_pos_tmp_hash_id}};
		my @bed_pos_tmp_hash_positions	= ();	# 1000,1001,1002,...
		my @bed_pos_tmp_hash_info	= ();	# 5/1/1/0/1/1/1,1/1/0/0/0/0/0,...
		foreach(@bed_pos_tmp_hash_array){
			my ($bed_pos_tmp_hash_array_pos, $bed_pos_tmp_hash_array_nt) = split(";",$_);
			push(@bed_pos_tmp_hash_positions,$bed_pos_tmp_hash_array_pos);
			push(@bed_pos_tmp_hash_info,$bed_pos_tmp_hash_array_nt);
		}
		my $bed_pos_tmp_hash_info_str		= join(",",@bed_pos_tmp_hash_info);
		my @bed_pos_tmp_hash_positions_sort 	= sort { $a <=> $b } @bed_pos_tmp_hash_positions;
		my $bed_pos_tmp_hash_positions_start	= $bed_pos_tmp_hash_positions_sort[0];
		my $bed_pos_tmp_hash_positions_stop	= $bed_pos_tmp_hash_positions_sort[-1];
		print join("\t",
			   $bed_chr,
			   $bed_pos_tmp_hash_positions_start,
			   $bed_pos_tmp_hash_positions_stop,
			   $bed_pos_tmp_hash_info_str,
			   ".",
			   $bed_strand
		    ), "\n";
	}
}
close(BED) || die;


# output:
# chr	start	stop	sum1,sum2,sum3,...	.	strand
