Copyright 2013 Google Inc. All rights reserved.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
--------------------------------------------------------------------------

As Unicode and Perl evolve, it is a good idea to publish your own version of the data in 
{training,heldout}-monolingual.tokenized.shuffled/* if you match our checksums,
such that future users of this project need not regenerate their own data, 
and instead use your copy.

A copy of the already pre-processed data, paper describing the benchmark, and other stuff is hosted at: http://www.statmt.org/lm-benchmark/

Data in training-monolingual.tokenized/ was generated using:
$ for year in 2007 2008 2009 2010 2011; do 
    for language in en; do 
      echo "Working on training-monolingual/news.${year}.${language}.shuffled"; 
      time cat training-monolingual/news.${year}.${language}.shuffled | \
      ./scripts/normalize-punctuation.perl -l $language | \
      ./scripts/tokenizer.perl -l $language > \
      training-monolingual.tokenized/news.${year}.${language}.shuffled.tokenized; 
      echo "Done working on training-monolingual/news.${year}.${language}.shuffled"; 
    done; 
  done;

Data in {dev,test}.tokenized:
$ for f in newstest2010-src.en.sgm news-test2008-src.en.sgm newstest2009-src.en.sgm newssyscomb2009-src.en.sgm; do 
    cat dev/$f | ./scripts/remove-xml.perl | \
    ./scripts/normalize-punctuation.perl -l en | \
    ./scripts/tokenizer.perl -l en > dev.tokenized/$f.tokenized; 
  done;

As it turns out, the data in {dev,test}.tokenized is mismatched to the training data in training-monolingual.tokenized, resulting in small (pruned to 15M n-grams) LMs doing much better than unpruned ones (1.2B n-grams):
katz:        Perplexity for 77756 n-grams: 2336.6989
pruned katz:     Perplexity for 77756 n-grams: 259.6913

kneser-ney:     Perplexity for 77756 n-grams: 428.0134
pruned kneser-ney: Perplexity for 77756 n-grams: 334.2701

So we set aside the last 20k sentences from 
training-monolingual.tokenized/news.2011.en.shuffled.tokenized
as dev+test data:
news.2011-tail20000-head10000.en.shuffled.tokenized (dev)
news.2011-tail20000-tail10000.en.shuffled.tokenized (test).

On this training/dev set the results are:
. training data amount: 2.9B (2933179059) words
. vocabulary size: 862368, (see baseline-lms/arpalm.{katz,kn}.sorted.gz)

. dev set OoV ratio: 0.14%, no_oov_words/no_predicted_words=336/239648;
. dev set perplexity, hit ratios
   . Katz@1.2B n-grams: PPL=84, (100%, 99%, 92%, 81%, 71%) 1, ..., 5-gram hit ratios
   . Katz@15M n-grams: PPL=131, (100%, 92%, 55%, 15%,  2%) 1, ..., 5-gram hit ratios

. test set OoV ratio: 0.15%, no_oov_words/no_predicted_words=330/215666;
. test set perplexity, hit ratios
   . Katz@1.2B n-grams: PPL=486, (100%, 98%, 84%, 58%, 33%) 1, ..., 5-gram hit ratios
   . Katz@15M n-grams:  PPL=118, (100%, 93%, 57%, 16%,  2%) 1, ..., 5-gram hit ratios

To get a better picture for what is going on, I unleashed MapReduce on it, and computed a few stats. 

Here is what I found out:

1. a lot of the data at training-monolingual.tokenized/news.20??.en.shuffled.tokenized consists of duplicate sentences. To give you some numbers: out of 112905708 sentences, 30467544 have count higher than one; these are not short sentences, in  fact most of the dups are long sentences according to the following histogram:

 Histogram of sentence lengths with duplicates from one Reduce shard (about 1M sentences)

 histogram[1]=3
 histogram[2]=201
 histogram[3]=567
 histogram[4]=1097
 histogram[5]=1991
 histogram[6]=2953
 histogram[7]=4127
 histogram[8]=5010
 histogram[9]=5988
 histogram[10]=6569
 histogram[11]=7205
 histogram[12]=7787
 histogram[13]=8404
 histogram[14]=8691
 histogram[15]=9065
 histogram[16]=9729
 histogram[17]=9924
 histogram[18]=9934
 histogram[19]=10314
 histogram[20]=10599
 histogram[>20]=183636

2. After removing the duplicates (we thus keep unique sentences) and thoroughly shuffling the data, the total number of words in the data drops from 2.9B to 0.8B (829250940 including  sentence boundary markers).

3. As a final step, Tony Robinson tried reproducing the corpus generation from scratch, and failed due to mismatches between his Perl version and ours, as well as irreproduceable use of the random number generator used for shuffling the data.

The final solution shuffles and sorts the raw data published at statmt.org, partitions it in training/held-out data sets, and then pre-processes it.

README.corpus_generation_checkpoints lists the md5sum checksums for all the generated files, and the versions of Perl, sort and tar used for producing it.
