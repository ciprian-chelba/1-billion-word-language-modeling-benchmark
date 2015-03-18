The purpose of the project is to make available a standard training and test setup for language modeling experiments.

The training/held-out data was produced from a download at statmt.org using a combination of Bash shell and Perl scripts distributed here.

This also means that your results on this data set are reproducible by the research community at large.

Besides the scripts needed to rebuild the training/held-out data, it also makes
available log-probability values for each word in each of ten held-out data sets,
for each of the following baseline models:
  * unpruned Katz (1.1B n-grams),
  * pruned Katz (~15M n-grams),
  * unpruned Interpolated Kneser-Ney (1.1B n-grams),
  * pruned Interpolated Kneser-Ney (~15M n-grams)

Happy benchmarking!

If you have a paper or similar publication that uses this benchmark, please check it in the papers directory such that it is available to all users of the project.