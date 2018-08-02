# Variant Sampler

 This is a JavaFX application that iteratively finds the number of
 necessary trials to see all possible variants at least once.
 The purpose of the software is to assist synthetic biology
 researchers in establishing the number of wells required
 to see every variant at least once. [Click here to download
 a JAR for it.](https://amorehead.github.io/assets/jar/Variant%20Sampler.jar)
 
 Credit goes to eledman (Elise Edman) for the original solution to this problem.

 Glossary:

 1. "Variants" can be thought of as the number of distinct promoters.

 2. "Wells" can be thought of as the individual chambers into which variants will settle.

 3. "Trials" can be thought of as how many times each variant is going to be seen at least once.

 Results:

 1. The "average number of wells" metric states how many wells on average
  had to be used to see every distinct variation of promoters.

 2. The "standard deviation of trials" metric describes how separated
  on average the results of the trials were.

 3. The "amount of time it took to perform this computation" metric simply states how
  many seconds, minutes, or hours it took to finish displaying the current computation's
  results.
