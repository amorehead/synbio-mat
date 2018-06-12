/*
 Alex Morehead
 6/11/2018

 This is a program that finds the number of
 generations needed to optimize, in other words
 maximize brightness levels of generational output.

 Credit goes to Eledman (Elise Edman) for the original solution to this problem.
*/

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;

public class poolingProblem {

    // This is our main method.
    public static void main(String[] args) {
        // If you alter the number of variants, you also have to alter
        // this brightness array so that each variant has a brightness that
        // is associated with it.
        int numberOfVariants = 6;

        double[][] brightness = {{0, 0}, {1, 1}, {2, .9}, {3, .1}, {4, .15}, {5, .2}, {6, .3}};

        // Can alter the number of wells to see
        // how many iterations are expected to converge.
        // For example, with 6 variants, with 30 wells, the
        // number of iterations to see convergence is about 6.
        // With 35 wells, the number of iterations is closer to 5.
        // Number of iterations is representative of # of generations.
        int numberOfWells = 35;

        int iteration = 0;
        int range = 20;
        for (int z = 0; z < range; z++) {
            ArrayList<ArrayList<Integer>> gen = findFirstGen(numberOfVariants, numberOfWells);
            ArrayList<Double> wellBrightnesses = determineBrightness1(brightness, gen);

            int numberOfIterations = 1;
            System.out.println("Iteration: " + numberOfIterations);
            System.out.println("Highest well brightness: " + Collections.max(wellBrightnesses));

            ArrayList<ArrayList<Integer>> topWells = chooseWells(gen, wellBrightnesses, numberOfWells);
            System.out.println("Top wells: " + topWells);

            boolean done = false;

            while (!done) {
                numberOfIterations++;

                for (int i = 0; i < topWells.size(); i++) {
                    boolean allHigh = true;
                    for (int j = 0; j < i; j++)
                        if (j != 0 && j != 1)
                            allHigh = false;
                    if (allHigh) {
                        done = true;
                        iteration += numberOfIterations;
                        break;
                    }
                }
                if (done)
                    break;
            }

            ArrayList<ArrayList<Double>> pool = recombine(topWells, numberOfVariants);
            System.out.println("Pool: " + pool);
            gen = findNextGens(numberOfWells, pool);

            System.out.println("Iteration: " + numberOfIterations);
            System.out.println("New generation: " + gen);
            wellBrightnesses = determineBrightness2(brightness, gen);
            System.out.println("Brightnesses in each well: " + wellBrightnesses);
            topWells = chooseWells(gen, wellBrightnesses, numberOfWells);
            System.out.println("Top wells: " + topWells);
            System.out.println("Highest well brightness: " + Collections.max(wellBrightnesses));
        }

        System.out.println("Average number of iterations: " + ((double) iteration) / range);
    }

    /* This is a function that derives the first
     generation given a number of variants and wells. */
    private static ArrayList<ArrayList<Integer>> findFirstGen(int numberOfVariants, int numberOfWells) {

        // This creates our simulated pool.
        ArrayList<Integer> pool = new ArrayList<>();

        // This populates our pool.
        for (int i = 1; i < numberOfVariants + 1; i++)
            for (int j = 0; j < (100 / numberOfVariants); j++)
                pool.add(i);

        // This ensures that the pool contains at least 100 entities.
        if (pool.size() < 100)
            for (int i = 0; i < (100 - pool.size()); i++)
                pool.add((int) (Math.random() * numberOfVariants));

        // The following will randomize the pool's distribution.
        Collections.shuffle(pool);

        // This creates our simulated plate.
        ArrayList<ArrayList<Integer>> plate = new ArrayList<>();

        // This creates and populates our simulated well.
        for (int i = 0; i < numberOfWells; i++) {
            ArrayList<Integer> well = new ArrayList<>();
            for (int j = 0; j < (100 / numberOfWells); j++) {
                int selection = (int) (Math.random() * pool.size());
                well.add(pool.get(selection));
                pool.remove(selection);
            }
            // This adds the well to the plate.
            plate.add(well);
        }

        // This adds randomly-selected entities from our pool to our plate.
        if (((100 / numberOfWells) * numberOfWells) < 100) {
            for (int i = 0; i < (100 - ((100 / numberOfWells) * numberOfWells)); i++) {
                if (pool.size() <= 0)
                    break;
                int randomWellNumber = (int) (Math.random() * numberOfWells);
                int selection = (int) (Math.random() * pool.size());
                plate.get(randomWellNumber).add(pool.get(selection));
                pool.remove(selection);
            }
        }

        // This returns our simulated plate for the first generation.
        return plate;
    }

    // This is a function that determines the brightnesses in individual wells.
    private static ArrayList<Double> determineBrightness1(double[][] brightness, ArrayList<ArrayList<Integer>> plate) {
        ArrayList<Double> brightnesses = new ArrayList<>();
        for (int i = 0; i < plate.size(); i++) {
            double wellBrightness = 0;
            for (int j = 0; j < plate.get(i).size(); j++)
                wellBrightness += brightness[plate.get(i).get(j)][1];
            if (wellBrightness == 0)
                brightnesses.add(0.0);
            else
                brightnesses.add(wellBrightness);
        }
        return brightnesses;
    }

    // This is a function that determines the brightnesses in individual wells.
    private static ArrayList<Double> determineBrightness2(double[][] brightness, ArrayList<ArrayList<Integer>> plate) {
        ArrayList<Double> brightnesses = new ArrayList<>();
        for (int i = 0; i < plate.size(); i++) {
            double wellBrightness = 0;
            for (int j = 0; j < plate.get(i).size(); j++)
                wellBrightness += brightness[plate.get(i).get(j)][1];
            if (wellBrightness == 0)
                brightnesses.add(0.0);
            else
                brightnesses.add(wellBrightness);
        }
        return brightnesses;
    }

    // This is a function that chooses the top 10% of wells according to brightness.
    private static ArrayList<ArrayList<Integer>> chooseWells(ArrayList<ArrayList<Integer>> plate, ArrayList<Double> wellBrightnesses, int numberOfWells) {
        Collections.sort(wellBrightnesses);
        double minimumBrightness = wellBrightnesses.get((int) Math.ceil(numberOfWells * 0.9) + 1);
        ArrayList<ArrayList<Integer>> topWells = new ArrayList<>();
        for (int i = 0; i < wellBrightnesses.size(); i++)
            if (wellBrightnesses.get(i) >= minimumBrightness)
                topWells.add(plate.get(i));
        return topWells;
    }

    // This is a function that recombines the wells into a single pool.
    private static ArrayList<ArrayList<Double>> recombine(ArrayList<ArrayList<Integer>> topWells, int numberOfVariants) {
        ArrayList<ArrayList<Double>> pool = new ArrayList<>();
        int total = 0;

        for (int i = 0; i < topWells.size(); i++)
            for (int j = 0; j < topWells.get(i).size(); j++)
                if (topWells.get(i).get(j) != 0)
                    total++;
        for (int i = 1; i < (numberOfVariants + 1); i++) {
            int countVariant = 0;
            for (ArrayList<Integer> j : topWells)
                countVariant += j.stream().count();
            pool.add(new ArrayList<Double>(Arrays.<Double>asList((double) i, (double) ((countVariant) / total))));
        }
        Collections.shuffle(pool);
        return pool;
    }

    /* This is a function that derives successive
     generations given a number of wells and a pool. */
    private static ArrayList<ArrayList<Integer>> findNextGens(int numberOfWells, ArrayList<ArrayList<Double>> pool) {
        ArrayList<Double> poolElements = new ArrayList<>();

        for (int i = 0; i < pool.size(); i++)
            for (int j = 0; j < ((int) Math.round(pool.get(i).get(1) * 100)); j++)
                poolElements.add(pool.get(i).get(0));

        // This proceeding section is meant to account for rounding errors introduced above.
        if (poolElements.size() != 100)
            if (poolElements.size() > 100)
                while (poolElements.size() > 100)
                    poolElements.remove((int) (Math.random() * poolElements.size()));
            else
                while (poolElements.size() < 100)
                    poolElements.add(pool.get((int) (Math.random() * pool.size())).get(0));

        Collections.shuffle(poolElements);
        System.out.println(poolElements);

        ArrayList<ArrayList<Integer>> nextGen = new ArrayList<>();
        int wellsLeft = numberOfWells;
        int total = 100;
        int numberOfEntities = 0;
        int minLimit;
        int maxLimit;
        int chosenEntities;
        int randomSample;
        for (int i = 0; i < numberOfWells; i++) {
            ArrayList<Integer> singleWell = new ArrayList<>(Arrays.asList(0));

            // The following assumes there was sufficient distribution throughout the solution.
            if ((total / wellsLeft) - 3 <= 0)
                minLimit = 1;
            else
                minLimit = (total / wellsLeft) - 3;
            if ((total / wellsLeft) + 3 > total)
                maxLimit = total / wellsLeft;
            else
                maxLimit = (total / wellsLeft) + 3;
            if (minLimit == 1 && maxLimit == 1 || maxLimit == 0)
                chosenEntities = (int) (Math.random());
            else
                chosenEntities = (int) (Math.random() * maxLimit) + minLimit;

            numberOfEntities += chosenEntities;
            total -= chosenEntities;

            for (int j = 0; j < chosenEntities; j++) {
                if (poolElements.size() <= 0)
                    break;
                randomSample = (int) (Math.random() * poolElements.size());
                singleWell.add(poolElements.get(randomSample).intValue());
                poolElements.remove(randomSample);
            }
            nextGen.add(singleWell);
            wellsLeft -= 1;
        }

        int well;
        if (numberOfEntities < 100)
            while (poolElements.size() != 0) {
                well = (int) (Math.random() * numberOfWells);
                randomSample = (int) (Math.random() * poolElements.size());
                nextGen.get(well).add(poolElements.get(randomSample).intValue());
                poolElements.remove(randomSample);
            }
        return nextGen;
    }
}
