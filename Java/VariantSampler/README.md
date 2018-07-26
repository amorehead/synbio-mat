# Variant Sampler

 Written by Alex Morehead with generous support by the National Science Foundation.

 This is a JavaFX application that iteratively finds the number of
 necessary samples to see all possible variants at least once.
 The purpose of the software is to assist synthetic biology
 researchers in establishing the size of the sample space for
 experiments performed in a laboratory setting.

 Credit goes to eledman (Elise Edman) for the original solution to this problem.

 Glossary:

 1. "Variants" can be thought of as the quantity "n",
  representing the number of sides on an n-sided die.

 2. "Wells" can be thought of as representing the individual rolls of a die.

 3. "Samples" or "iterations" can be thought of as representing the numbers of
  times an n-sided die was rolled, or rather will be rolled, until all sides of
  the die were/are seen at least once.
  
 Results:
 
 1. The "average number of wells" metric describes how many rolls on average     
  had to be taken before seeing every side of an n-sided die. 

 2. The "standard deviation of the samples" metric discloses how separated on average 
  the samples of die rolls were.

 3. The "amount of time it took to perform this computation" metric simply states how 
  many seconds, minutes, or hours it took to finish displaying the current computation's 
  results.
