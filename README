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

The project makes available a standard corpus of reasonable size (0.8 billion words) 
to train and evaluate language models.

A few sample results we obtained at Google on this data are detailed at:
papers/naaclhlt2013.pdf

Besides the scripts needed to rebuild the training/held-out data, it also makes 
available log-probability values for each word in each of ten feld-out data sets, 
for each of the following baseline models:
. unpruned Katz (1.1B n-grams),
. pruned Katz (~15M n-grams), 
. unpruned Interpolated Kneser-Ney (1.1B n-grams), 
. pruned Interpolated Kneser-Ney (~15M n-grams)

The corpus is derived from the training-monolingual.tokenized/news.20??.en.shuffled.tokenized data distributed at http://statmt.org/wmt11/translation-task.html, Monolingual language model training data (Download it all in one file, 11 GB, at http://statmt.org/wmt11/training-monolingual.tgz). 

A copy of the already pre-processed data, paper describing the benchmark, and other stuff is hosted at: http://www.statmt.org/lm-benchmark/

Corpus preparation:
====================
. download the "Monolingual language model training data" (http://statmt.org/wmt11/training-monolingual.tgz, 11 GB). 
$ tar --extract -v --file ../statmt.org/tar_archives/training-monolingual.tgz --wildcards training-monolingual/news.20??.en.shuffled
followed by:
$ ./scripts/get-data.sh

For a more detailed description of the steps involved, see README.corpus_generation. 

The md5sums for the files generated from the statmt.org download are listed at: README.corpus_generation_checkpoints.

You can use:
$ md5sum -c README.corpus_generation_checkpoints
to check that the files you produced match the checksums of those used to produce the results in the paper.

Baseline Language Models:
==========================
. trained and evaluated Katz and Interpolated Kneser-Ney language models.

. the word-level probability assignment for each word in the first 10 shards of the test data
(including the 00000 shard above for which we report LM performance) is available at:
baseline-lms/log/output.tar (tar-ed gzip files; due to their relatively large size they
are hosted on gDrive at https://drive.google.com/file/d/0B3u4EqGe3BUeMWhPS1hkdDZvTjA/edit?usp=sharing).

The output is in the following format:
...
WORDS: <S> Hello , world ! </S>
WORD IDS: 0 1044976486 1699010037 1539844246 217790329 1
Hello   1044976486 -                           1.051147e+01 1.223186e+01 - COST=1.234405e+01
,       1699010037 -              8.899814e-01 8.908027e-01 3.305907e+00 - COST=1.806272e+00
world   1539844246 - 6.488597e+00 5.339889e+00 9.798830e+00 7.934176e+00 - COST=6.488597e+00
!        217790329 - 1.622149e+00 6.229870e+00 6.770101e+00 8.099472e+00 - COST=1.622149e+00
</S>             1 -   NOTFOUND   3.559926e-01 3.563211e-01 2.975316e+00 - COST=3.559926e-01
- TOTAL ------------------------------------------------------------------ COST=2.261707e+01

The output first repeats the input sentence (with <S> and </S> added). Then it shows the corresponding integer word ids. Subsequent lines list ProdLM entries obtained with ProdLMClient and the resulting smoothed cost calculated by ProdLMWrapper. For each word, it shows the entries for the unigram, bigram, trigram etc. ending in the word shown at the beginning of the line. The example above shows a fourgram model. Thus, the first column after the hyphen shows the fourgram entry, followed by the trigram, bigram and unigram entries 1.234405e+01.

The first word of the sentence is "Hello". The implicit first token of the sentence is <S>, resulting in the bigram "<S>". There are no trigram and fourgram for the first word, so those columns are empty. The value stored for the bigram is 1.051147e+01, the value stored for the unigram is 1.223186e+01. ProdLMWrapper uses these to calculate a smoothed cost of .

The line with the exclamation mark shows entries for n-grams ending in "!": the fourgram "Hello , world !" has a value of 1.622149e+00, the trigram ", world !" has a value of 6.229870e+00, etc. NOTFOUND (which is shown as the value for the fourgram ", world ! <S>") indicates that the particular n-gram is not stored in the model.

Baseline LM Results Summary:
=============================

Here are the out-of-vocabulary (OoV) rates and perplexity (PPL)/n-gram hit ratios on the first 10 shards of the held out data (heldout-monolingual.tokenized.shuffled/news.en.heldout-0000?-of-00050)

See README.perplexity_and_such for a description on how we compute perplexity, out-of-vocabulary rate,
and back-off hit ratios.

 oov rate:      446 /  159658 ( 0.28%)
 oov rate:      524 /  165560 ( 0.32%)
 oov rate:      506 /  159982 ( 0.32%)
 oov rate:      463 /  161238 ( 0.29%)
 oov rate:      506 /  164687 ( 0.31%)
 oov rate:      461 /  162336 ( 0.28%)
 oov rate:      515 /  158574 ( 0.32%)
 oov rate:      462 /  164473 ( 0.28%)
 oov rate:      516 /  162800 ( 0.32%)
 oov rate:      522 /  163597 ( 0.32%)

Katz, unpruned, n=5, 1.1B n-grams:
 totalcount = 829250940
 num_ngrams = 793471 39347422 188838562 384508104 513871498 (total: 1127359057)

shard 00000:
 covered 1-grams:   159658 /  159658 (100.00%)
 covered 2-grams:   155451 /  159658 (97.36%)
 covered 3-grams:   127532 /  153583 (83.04%)
 covered 4-grams:    86365 /  147508 (58.55%)
 covered 5-grams:    53245 /  141433 (37.65%)

shards 00000-00009:
 Perplexity for 159658 n-grams: 79.8771
 Perplexity for 165560 n-grams: 86.2621
 Perplexity for 159982 n-grams: 84.2730
 Perplexity for 161238 n-grams: 82.8191
 Perplexity for 164687 n-grams: 83.9454
 Perplexity for 162336 n-grams: 86.6045
 Perplexity for 158574 n-grams: 87.0900
 Perplexity for 164473 n-grams: 83.1226
 Perplexity for 162800 n-grams: 83.3353
 Perplexity for 163597 n-grams: 83.8254

Katz, pruned, n=5, 15M n-grams:
 totalcount = 829250940
 num_ngrams = 793471 6028697 6023662 1818975 178586 (total: 14843391)

shard 00000:
 covered 1-grams:   159658 /  159658 (100.00%)
 covered 2-grams:   147368 /  159658 (92.30%)
 covered 3-grams:    77541 /  153583 (50.49%)
 covered 4-grams:    17559 /  147508 (11.90%)
 covered 5-grams:     1717 /  141433 ( 1.21%)

shards 00000-00009:
 Perplexity for 159658 n-grams: 127.4522
 Perplexity for 165560 n-grams: 135.4776
 Perplexity for 159982 n-grams: 131.6153
 Perplexity for 161238 n-grams: 130.3873
 Perplexity for 164687 n-grams: 132.7091
 Perplexity for 162336 n-grams: 134.0019
 Perplexity for 158574 n-grams: 136.2535
 Perplexity for 164473 n-grams: 131.5179
 Perplexity for 162800 n-grams: 130.4547
 Perplexity for 163597 n-grams: 129.9707

Interpolated Kneser-Ney, unpruned, n=5, 1.1B n-grams:
 totalcount = 829250940
 num_ngrams = 793471 39347424 189080713 388028847 527536365 (total: 1144786820)

shard 00000:
 covered 1-grams:   159658 /  159658 (100.00%)
 covered 2-grams:   155451 /  159658 (97.36%)
 covered 3-grams:   133586 /  159658 (83.67%)
 covered 4-grams:    98104 /  159658 (61.45%)
 covered 5-grams:    69525 /  159658 (43.55%)

shards 00000-00009:
 Perplexity for 159658 n-grams: 67.6118
 Perplexity for 165560 n-grams: 73.0527
 Perplexity for 159982 n-grams: 71.3472
 Perplexity for 161238 n-grams: 70.4651
 Perplexity for 164687 n-grams: 71.1141
 Perplexity for 162336 n-grams: 73.5345
 Perplexity for 158574 n-grams: 73.5653
 Perplexity for 164473 n-grams: 70.4316
 Perplexity for 162800 n-grams: 70.8092
 Perplexity for 163597 n-grams: 71.0961

Interpolated Kneser-Ney, pruned, n=5, 14M n-grams:
 totalcount = 829250940
 num_ngrams = 793471 8702286 4215561 461927 16912 (total: 14190157)

shard 00000:
 covered 1-grams:   159658 /  159658 (100.00%)
 covered 2-grams:   138172 /  159658 (86.54%)
 covered 3-grams:    57238 /  159658 (35.85%)
 covered 4-grams:     6456 /  159658 ( 4.04%)
 covered 5-grams:      259 /  159658 ( 0.16%)

shards 00000-00009:
 Perplexity for 159658 n-grams: 243.2369
 Perplexity for 165560 n-grams: 248.0840
 Perplexity for 159982 n-grams: 244.2888
 Perplexity for 161238 n-grams: 241.7122
 Perplexity for 164687 n-grams: 242.8785
 Perplexity for 162336 n-grams: 247.0062
 Perplexity for 158574 n-grams: 249.6803
 Perplexity for 164473 n-grams: 244.5668
 Perplexity for 162800 n-grams: 246.4912
 Perplexity for 163597 n-grams: 241.8771
