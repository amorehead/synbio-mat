# Variant Sampler

 Written by Alex Morehead with generous support by the National Science Foundation.

 This is a JavaFX application that iteratively finds the number of
 necessary trials to see all possible variants at least once.
 The purpose of the software is to assist synthetic biology
 researchers in establishing the number of P-gel pads required
 to see every variant at least once.

 Credit goes to eledman (Elise Edman) for the original solution to this problem.

 Glossary:

 1. "Variants" can be thought of as the number of distinct promoters.

 2. "Wells" can be thought of as individual P-gel pads.

 3. "Trials" can be thought of as the number of times for the experiment to be performed.

 Results:

 1. The "average number of wells" metric states how many P-gel pads on average
  had to be used to see every distinct variation of promoters.

 2. The "standard deviation of trials" metric describes how separated
  on average the results of the trials were.

 3. The "amount of time it took to perform this computation" metric simply states how
  many seconds, minutes, or hours it took to finish displaying the current computation's
  results.
