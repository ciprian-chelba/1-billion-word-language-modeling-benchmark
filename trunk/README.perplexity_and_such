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

Measuring Perplexity, Out-of-Vocabulary Rate, and N-gram Hit-Ratios

For crystal clear clarity on the numbers below, we measure perplexity (PPL), 
and out-of-vocabulary (OoV) rates the following way:

. the training/test sentence "I like bench-marking" is embedded in 
<S> and </S> tokens, producing "<S> I like bench-marking </S>". 
Predicting the end of sentence is critical to being able to assign 
a probability to any sentence in the set of sentences of finite length: 
{<S> V* </S>}, where V is the vocabulary of the language model (excluding <S>, </S>)

. words that are not listed in the LM vocabulary are mapped to the distinguished
<UNK> word (which is part of the LM vocabulary!); in our example "bench-marking" 
is not in the vocabulary, so the sentence gets mapped to "<S> I like <UNK> </S>". 

We are thus using what people commonly call an "open-vocabulary" LM: 
during both training and test we will encounter words outside the vocabulary, and 
we deal with them by mapping them to <UNK>. 

In contrast, a "closed-vocabulary"LM does not need to do this. All words/symbols 
that it encounters in test data are known a-priori, at training time; e.g., a LM 
operating at the letter level would be a "closed-vocabulary" LM.

. n-gram events are extracted by sliding a window of length n over the text, e.g. 
for an n-gram order n=5 we count 4 separate 5-grams: 
"</S> </S> </S> <S> I", 
"</S> </S> <S> I like", 
"</S> <S> I like <UNK>", 
"<S> I like <UNK> </S>"

The padding with </S> at sentence beginning is not strictly necessary 
(one can simply count"<S> I", "<S> I like", etc.) but it is a useful trick for counting 
maximal order n-grams without violating the sentence independence assumption. 

An n-gram LM that does not use this counting scheme in training can be still 
evaluated this way, since it will back-off cost-free to the context "<S>".

. perplexity (PPL) is computed by 
PPL = exp {-1/4 [ log P(I | </S> </S> </S> <S>) + 
                  log P(like | </S> </S> <S> I) + 
                  log P(<UNK> | </S> <S> I like) + 
                  log P(</S> | <S> I like <UNK>)]}

. the out-of-vocabulary (OoV) rate is 1/4: 
relative frequency of <UNK> in test data, after embedding in<S> ... </S>, 
but not counting <S> as a word since it is never predicted.

. n-gram hit ratios across 1/.../n-gram orders are reported cumulatively: 
assuming the n-gram "</S> </S> <S> I like" is requested from the LM, but the 
longest one retrieved is "<S> I like", we count each of a 1/2/3-gram hit, 
but not a 4/5-gram one.