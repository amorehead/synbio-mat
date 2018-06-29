/*
 Alex Morehead
 6/29/2018

 This is a program that finds the number of necessary
 samples to see all possible variants at least once.

  Credit goes to eledman (Elise Edman) for the original solution to this problem.
*/

import java.util.*;

public class recursiveCouponProblem {

    // This is a global variable which will be referenced repeatedly during the execution of this program.
    private static List<Integer> numberOfWellsList = new ArrayList<>();

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
            findNumberOfWells(new ArrayList<>(), 0, numberOfVariants);

        // This averages the number of wells for each iteration.
        int total = numberOfWellsList.stream().mapToInt(i -> i).sum();
        int averageNumberOfSamples = total / numberOfIterations;
        System.out.println("The average number of wells needed to see all variants at least once is "
                + averageNumberOfSamples + ".");

        // This is to allow us to show the user how long the computation took.
        long tEnd = System.currentTimeMillis();
        long tDelta = tEnd - tStart;
        double elapsedSeconds = tDelta / 1000.0;
        if (elapsedSeconds >= 3600)
            System.out.println("The number of hours it took to perform this computation: " + elapsedSeconds / 3600);
        else if (elapsedSeconds >= 60)
            System.out.println("The number of minutes it took to perform this computation: " + elapsedSeconds / 60);
        System.out.println("The number of seconds it took to perform this computation: " + elapsedSeconds);
    }

    /* This is a helper function that picks a random variant, adds
     it to the list of variants already found, and then checks to
     see whether or not all possible variants have been seen. */
    private static void findNumberOfWells(List<Integer> foundVariants, int numberOfWells, int numberOfVariants) {
        foundVariants.add((int) (Math.random() * numberOfVariants) + 1);
        numberOfWells++;
        boolean allFound = true;
        for (int i = 1; i < numberOfVariants + 1; i++)
            if (!foundVariants.contains(i)) {
                allFound = false;
                break;
            }

        if (allFound)
            numberOfWellsList.add(numberOfWells);
        else
            findNumberOfWells(foundVariants, numberOfWells, numberOfVariants);
    }

}
