/*
 Alex Morehead
 6/10/2018

 This is a program that finds the number of necessary
 samples to see all possible variants at least once.

  Credit goes to eledman (Elise Edman) for the original solution to this problem.
*/

import java.util.ArrayList;
import java.util.HashSet;
import java.util.Scanner;
import java.util.Set;

public class couponProblem {

    // This is a global variable which will be referenced repeatedly during the execution of this program.
    private static ArrayList<Integer> numberOfWellsList = new ArrayList<>();

    // This is our main method.
    public static void main(String[] args) {
        findNumberOfNecessarySamples();
    }

    /* This is a function that calculates the average number of
     samples needed to see all possible variants at least once. */
    private static void findNumberOfNecessarySamples() {
        Scanner input = new Scanner(System.in);
        System.out.print("Please enter a desired number of variants: ");
        int numberOfVariants = input.nextInt();
        int numberOfSamples = (numberOfVariants >= 50000) ? 2 * numberOfVariants : 100000;

        for (int i = 0; i < numberOfSamples; i++)
            takeSample(new HashSet<Integer>(), 0, numberOfVariants);
        int total = numberOfWellsList.stream().mapToInt(i -> i).sum();
        int averageNumberOfSamples = total / numberOfSamples;
        System.out.println("The average number of samples necessary to see all variants: "
                + averageNumberOfSamples);
    }

    /* This is a helper function that picks a random variant, adds
     it to the list of variants already found, and then checks to
     see whether or not all possible variants have been seen. */
    private static void takeSample(Set<Integer> foundVariants, int numberOfWells, int numberOfVariants) {
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
            takeSample(foundVariants, numberOfWells, numberOfVariants);
    }

}
