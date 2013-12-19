#!/usr/bin/perl -w
# Modified version of the same script downloaded from
# http://statmt.org/wmt11/translation-task.html
binmode(STDIN, ":utf8");
binmode(STDOUT, ":utf8");

use strict;
use utf8;
# NFC normalize the input text, see http://perldoc.perl.org/Unicode/Normalize.html.
# This may still lead to different results depending on the Perl version you are running.
# I (ciprianchelba@google.com) ran this on perl 5.14.2, see 
# README.corpus_generation_checkpoints for exact configuration
# and checkpoints in the corpus generation pipeline. If you run on an earlier/different
# version of Perl, use the md4 ckeck sums to make sure your data matches my run.
require 5.14.2;
use Unicode::Normalize;

my $language = "en";
my $QUIET = 0;
my $HELP = 0;

while (@ARGV) {
  $_ = shift;
  /^-l$/ && ($language = shift, next);
  /^-q$/ && ($QUIET = 1, next);
  /^-h$/ && ($HELP = 1, next);
}

if ($HELP) {
  print "Usage ./normalize-punctuation.perl (-l [en|de|...]) \
         < textfile > normalizedfile\n";
  exit;
}
if (!$QUIET) {
  print STDERR "Normalize punctuation v1\n";
  print STDERR "Language: $language\n";
}

while(<STDIN>) {
  s/\r//g;
  # remove extra spaces
  s/\(/ \(/g;
  s/\)/\) /g; s/ +/ /g;
  s/\) ([\.\!\:\?\;\,])/\)$1/g;
  s/\( /\(/g;
  s/ \)/\)/g;
  s/(\d) \%/$1\%/g;
  s/ :/:/g;
  s/ ;/;/g;
  # normalize unicode punctuation
  # Added by ciprianchelba@google.com
  s/’/'/g;
  s/‘/'/g;
  s/'/'/g;
  s/—/--/g;
  s/–/--/g;
  s/…/... /g;
  s/ ★ / /g;
  s/„/"/g;
  s/″/"/g;
  s/“/"/g;
  s/”/"/g;
  # /Added by ciprianchelba@google.com

  # Added by ciprianchelba@google.com and tonyr@cantabResearch.com
  # at Alex Shinn's (ashinn@google.com) advice:
  # use single Unicode (http://en.wikipedia.org/wiki/List_of_Unicode_characters)
  # instead of composed renditions, use "od -t x1" to inspect them.
  $_ = NFC($_);
  # /Added by ciprianchelba@google.com and tonyr@cantabResearch.com

  s/â€ž/\"/g;
  s/â€œ/\"/g;
  s/â€/\"/g;
  s/â€“/-/g;
  s/â€”/ - /g; s/ +/ /g;
  s/Â´/\'/g;
  s/([a-z])â€˜([a-z])/$1\'$2/gi;
  s/([a-z])â€™([a-z])/$1\'$2/gi;
  s/â€˜/\"/g;
  s/â€š/\"/g;
  s/â€™/\"/g;
  s/''/\"/g;
  s/Â´Â´/\"/g;
  s/â€¦/.../g;
  # French quotes
  s/Â Â«Â / \"/g;
  s/Â«Â /\"/g;
  s/Â«/\"/g;
  s/Â Â»Â /\" /g;
  s/Â Â»/\"/g;
  s/Â»/\"/g;
  # handle pseudo-spaces
  s/Â \%/\%/g;
  s/nÂºÂ /nÂº /g;
  s/Â :/:/g;
  s/Â ÂºC/ ÂºC/g;
  s/Â cm/ cm/g;
  s/Â \?/\?/g;
  s/Â \!/\!/g;
  s/Â ;/;/g;
  s/,Â /, /g; s/ +/ /g;

  # English "quotation," followed by comma, style
  if ($language eq "en") {
    s/\"([,\.]+)/$1\"/g;
  }
  # Czech is confused
  elsif ($language eq "cs" || $language eq "cz") {
  }
  # German/Spanish/French "quotation", followed by comma, style
  else {
    s/,\"/\",/g;
    s/(\.+)\"(\s*[^<])/\"$1$2/g; # don't fix period at end of sentence
  }

  print STDERR $_ if /ï»¿/;

  if ($language eq "de" || $language eq "es" || $language eq "cz" || $language eq "cs" || $language eq "fr") {
    s/(\d)Â (\d)/$1,$2/g;
  }
  else {
    s/(\d)Â (\d)/$1.$2/g;
  }
  print $_;
}
