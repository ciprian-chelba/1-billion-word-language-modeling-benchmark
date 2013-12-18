#!/usr/bin/perl -w
# Modified version of the same script downloaded from 
# http://statmt.org/wmt11/translation-task.html
binmode(STDIN, ":utf8");
binmode(STDOUT, ":utf8");

use strict;
use utf8;

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

  # Added by ciprianchelba@google.com at drtonyrobinson@gmail.com's suggestion.
  # use Unicode (http://en.wikipedia.org/wiki/List_of_Unicode_characters) 
  # instead of strange renditions; the two are different if you have good eyesight, 
  # or use "od -t x1" to inspect them.
  s/á/á/g;
  s/ë/ë/g;
  s/é/é/g;  
  s/ê/ê/g;
  s/ñ/ñ/g;
  s/ö/ö/g;
  s/ú/ú/g;
  # /Added by ciprianchelba@google.com at drtonyrobinson@gmail.com's suggestion.

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
