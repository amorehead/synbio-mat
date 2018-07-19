/*
 Alex Morehead
 7/19/2018

 This is a program that iteratively finds the number of
 necessary samples to see all possible variants at least once.

 Credit goes to eledman (Elise Edman) for the original solution to this problem.

 Glossary:

 1. "Variants" can be thought of as the quantity "n",
  representing the number of sides on an n-sided die.

 2. "Wells" can be thought of as representing the individual rolls of a die.

 3. "Samples" or "iterations" can be thought of as representing the number
 of times an n-sided die was rolled, or rather will be rolled, until all
 sides of the die were/are seen at least once.
*/

import java.util.*;

public class iterativeCouponProblem {

    /* This is a global list that will be referenced
    repeatedly during the execution of this program. */
    private static final List<Double> numberOfWellsList = new ArrayList<>();

    /* This is a global SplittableRandom object which will be referenced
     repeatedly during the execution of this program. */
    private static final SplittableRandom randomInt = new SplittableRandom();

    // This is our main method.
    public static void main(String[] args) {
        findAverageNumberOfWells();
    }

    /* This is a function that calculates the average number of
     samples needed to see all possible variants at least once. */
    private static void findAverageNumberOfWells() {

        // This creates a Scanner object for us to receive input from the user.
        Scanner input = new Scanner(System.in);

        // This defines how many variants we will be using.
        System.out.print("Please enter a desired number of variants: ");
        int numberOfVariants = input.nextInt();

        // This defines how many samples will be taken to find the average number of wells.
        System.out.print("Please enter a desired number of samples (A.K.A. iterations): ");
        int numberOfIterations = input.nextInt();

        // This is to keep track of how much time the computation takes to complete.
        long tStart = System.currentTimeMillis();

        // This finds the number of wells for the number of iterations previously specified.
        for (int i = 0; i < numberOfIterations; i++)
            findNumberOfWells(numberOfVariants);

        // This averages the number of wells for each iteration.
        double total = numberOfWellsList.stream().mapToDouble(i -> i).sum();
        double averageNumberOfSamples = total / numberOfIterations;
        System.out.printf("The average number of wells needed to see all variants at least once is %,4.2f.", averageNumberOfSamples);

        // This finds the standard deviation of the well counts.
        double standardDeviationOfWellCount = findStandardDeviation(numberOfWellsList, averageNumberOfSamples);
        if (standardDeviationOfWellCount >= 0)
            System.out.printf("\nThe standard deviation of the list of wells is %,4.2f.", standardDeviationOfWellCount);
        else System.out.print("\nThe standard deviation of the list of wells could not be computed.");

        // This allows us to show the user how long the computation took.
        long tEnd = System.currentTimeMillis();
        long tDelta = tEnd - tStart;
        double elapsedSeconds = tDelta / 1000.0;
        if (elapsedSeconds >= 3600)
            System.out.printf("\nThe amount of time it took to perform this computation was %,4.2f hours.", (elapsedSeconds / 3600));
        else if (elapsedSeconds >= 60)
            System.out.printf("\nThe amount of time it took to perform this computation was %,4.2f minutes.", (elapsedSeconds / 60));
        else
            System.out.printf("\nThe amount of time it took to perform this computation was %,4.2f seconds.", elapsedSeconds);
    }

    /* This is a helper function that picks a random variant, adds
     it to the list of variants already found, and then checks to
     see whether or not all possible variants have been seen. */
    private static void findNumberOfWells(int numberOfVariants) {
        Set<Integer> foundVariants = new HashSet<>();
        double numberOfWells;
        boolean allFound = false;

        // This allows us to skip the first "numberOfVariants" amount of variables.
        for (int i = 0; i < numberOfVariants; i++)
            foundVariants.add(randomInt.nextInt(numberOfVariants) + 1);
        numberOfWells = numberOfVariants;

        // This checks to make sure that we have seen all variants.
        while (!allFound) {
            foundVariants.add(randomInt.nextInt(numberOfVariants) + 1);
            numberOfWells++;
            allFound = true;

            // This checks to see if we have seen at least the minimum number of variants.
            if (foundVariants.size() < numberOfVariants)
                allFound = false;
        }

        // This is where we add the current run's number of wells to the list of well totals.
        numberOfWellsList.add(numberOfWells);
    }

    /* This is an experimental method for finding the
     standard deviation of a list of doubles given a mean value. */
    private static double findStandardDeviation(List<Double> list, double mean) {
        double squareSum = 0;
        for (Double dbl : list) squareSum += Math.pow(dbl - mean, 2);
        double meanOfDiffs = squareSum / list.size();
        return Math.sqrt(meanOfDiffs);
    }

}
