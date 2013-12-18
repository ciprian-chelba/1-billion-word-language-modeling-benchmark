#!/usr/bin/perl -w

# Copyright 2013 Google Inc. All rights reserved.
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Blame ciprianchelba@google.com for this script.
#
# MapReduce like splitting of training data. Assumes each input sentence/line is 
# unique.
# I ran: 
# $ sort -u --parallel=10 news.20XX.en.shuffled.tokenized 
#   --output=news.20XX.en.shuffled.tokenized.sorted
# to get the input data.
#
# A sample command line for running this:
# ./scripts/split-input-data.perl
# --output_file_base="$PWD/training-monolingual.tokenized.shuffled.perl/news.en"
# --num_shards=100
# --input_file=./training-monolingual.tokenized/news.20XX.en.shuffled.tokenized.sorted
use strict;
use Symbol;
use warnings;
use Getopt::Long;

# A portable random number generator (http://en.wikipedia.org/wiki/Xorshift). 
{
    use integer; #use integer math
    my $x = 123456789;
    my $y = 362436069;
    my $w = 88675123; 
    my $z = 521288629;

    sub set_random_seed {
    	$w = shift;
    }

    sub random { 
    	my $t = $x ^ ($x << 11);
    	$x = $y;
    	$y = $z;
    	$z = $w;
    	my $rand = $w = ($w ^ ($w >> 19)) ^ ($t ^ ($t >> 8)); 
    	return $rand;
    }
}

my $input_file = "";
my $num_shards = 100;
my $output_file_base = "";
my $debug = 0;
&GetOptions("input_file=s" => \$input_file,
            "num_shards=i" => \$num_shards,
	    "output_file_base=s" => \$output_file_base,
            "debug" => \$debug);
print STDERR
  "input_file=$input_file, ",
  "num_shards=$num_shards, ",
  "output_file_base=$output_file_base\n";

# Open $num_shards handles for output shards.
my @handles;
my @file_names;
for (my $shard = 0; $shard < $num_shards; ++$shard) {
  my $fh = gensym;
  my $fh_file_name = sprintf("%s-%05d-of-%05d", 
                             $output_file_base, 
                             $shard, 
                             $num_shards);
  if ($debug) {
    print STDERR "$fh_file_name\n";
  }
  open $fh, ">$fh_file_name";
  push @handles, $fh;
  push @file_names, $fh_file_name;
}

# Open input file, traverse one line at a time, and output <K, V> pairs where
# K=random number, and V = sentence. 
# Each <K, V> pair is output to shard (K modulo $num_shards).
set_random_seed(0);
open(INPUT, $input_file) or die "Cannot open $input_file.";
while ($_=<INPUT>) {
  chomp;
  my $key = random($num_shards * 1000);
  my $shard = $key % $num_shards;
  if ($debug) {
    print STDERR "$file_names[$shard] gets $key $_\n";
  }
  print { $handles[$shard] } "$key $_\n";
}
close(INPUT);

# Close all handles.
foreach my $handle (@handles) {
  close $handle;
}

# Sort all shards based on key value, and remove the key.
for (my $shard = 0; $shard < $num_shards; ++$shard) {
  `sort -n --output="$output_file_base.temp" $file_names[$shard]`;
  # remove keys from each line
  open(INPUT, "$output_file_base.temp");
  open(OUTPUT, ">$file_names[$shard]");
  while ($_=<INPUT>) {
    $_ =~ s/^\d+ //;
    print OUTPUT $_;
  }
  close(INPUT);
  close(OUTPUT);
  `rm -f $output_file_base.temp`;
}
exit;
