#!/bin/bash

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

# Does all the corpus preparation work.
#
# Assumes you have already untarred training-monolingual.tgz:
# tar --extract -v \
# --file ../statmt.org/tar_archives/training-monolingual.tgz \
# --wildcards training-monolingual/news.20??.en.shuffled
#
# Takes the data in:
# ./training-monolingual/news.20??.en.shuffled
# and runs punctuation normalization and tokenization, producing the data in:
# ./training-monolingual.tokenized/news.20??.en.shuffled.tokenized
#
# It then unique-sorts the data (quite a few sentences are replicated in the data),
# splits the data in 100 shards, randomly shuffled, sets aside held-out data, and 
# splits it into 50 test partitions.

# Set environemnt vars LANG and LANGUAGE to make sure all users have the same 
# locale settings.
export LANG=en_US.UTF-8
export LANGUAGE=en_US:

# Punctuation normalization and tokenization.
if [ -d training-monolingual.tokenized ]
then
  rm -rf training-monolingual.tokenized/*
else
  mkdir training-monolingual.tokenized
fi

for year in 2007 2008 2009 2010 2011; do 
  for language in en; do 
    echo "Working on training-monolingual/news.${year}.${language}.shuffled"; 
    time cat training-monolingual/news.${year}.${language}.shuffled | \
      ./scripts/normalize-punctuation.perl -l $language | \
      ./scripts/tokenizer.perl -l $language > \
      training-monolingual.tokenized/news.${year}.${language}.shuffled.tokenized; 
    echo "Done working on training-monolingual/news.${year}.${language}.shuffled."; 
  done; 
done;

# Unique sort of the sentences in the corpus. Quite a few sentences are replicated,
# dropping the number of words from about 2.9B to about 0.8B.
sort -u --parallel=10 \
  --output=./training-monolingual.tokenized/news.20XX.en.shuffled.tokenized.sorted  \
  ./training-monolingual.tokenized/news.20??.en.shuffled.tokenized
echo "Done sorting corpus."; 

# Split the data in 100 shards
if [ -d training-monolingual.tokenized.shuffled ]
then
  rm -rf training-monolingual.tokenized.shuffled/*
else
  mkdir training-monolingual.tokenized.shuffled
fi
./scripts/split-input-data.perl \
  --output_file_base="$PWD/training-monolingual.tokenized.shuffled/news.en" \
  --num_shards=100 \
  --input_file=./training-monolingual.tokenized/news.20XX.en.shuffled.tokenized.sorted
echo "Done splitting/shuffling corpus into 100 shards news.en-000??-of-00100."; 

# Hold 00000 shard out, and split it 50 way.
if [ -d heldout-monolingual.tokenized.shuffled ]
then
  rm -rf heldout-monolingual.tokenized.shuffled/*
else
  mkdir heldout-monolingual.tokenized.shuffled
fi

mv ./training-monolingual.tokenized.shuffled/news.en-00000-of-00100 \
  heldout-monolingual.tokenized.shuffled/
echo "Set aside shard 00000 of news.en-000??-of-00100 as held-out data."; 

./scripts/split-input-data.perl \
  --output_file_base="$PWD/heldout-monolingual.tokenized.shuffled/news.en.heldout" \
  --num_shards=50 \
  --input_file=./heldout-monolingual.tokenized.shuffled/news.en-00000-of-00100
echo "Done splitting/shuffling held-out data into 50 shards."; 
