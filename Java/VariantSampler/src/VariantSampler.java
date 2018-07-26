/*
 Alex Morehead
 7/26/2018

 Written with generous support by the National Science Foundation.

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
*/

package src;

import javafx.application.Application;
import javafx.geometry.HPos;
import javafx.geometry.Pos;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.control.TextField;
import javafx.scene.layout.GridPane;
import javafx.stage.Stage;

import java.math.BigInteger;
import java.util.*;

public class VariantSampler extends Application {
    private final Label tDocumentation = new Label();
    private final TextField tfNumberOfVariants = new TextField();
    private final TextField tfNumberOfIterations = new TextField();
    private final TextField tfAverageNumberOfWells = new TextField();
    private final TextField tfStandardDeviationOfSamples = new TextField();
    private final TextField tfElapsedSeconds = new TextField();
    private final Button btCalculate = new Button("Calculate");

    /* This is a global SplittableRandom object which will be referenced
     repeatedly during the execution of this program. */
    private static final SplittableRandom randomInt = new SplittableRandom();

    // This guarantees the application will launch upon execution in a GUI.
    public static void main(String[] args) {
        launch(args);
    }

    @Override // This overrides the start method in the JavaFX Application class.
    public void start(Stage primaryStage) {
        // This creates the UI.
        GridPane gridPane = new GridPane();
        gridPane.setHgap(5);
        gridPane.setVgap(5);
        gridPane.add(tDocumentation, 0, 0);
        gridPane.add(new Label(" Please enter the number of variants to be involved in this experiment (ex: 6):"), 0, 1);
        gridPane.add(tfNumberOfVariants, 1, 1);
        gridPane.add(new Label(" Please enter the number of samples to be used in this experiment (ex: 38):"), 0, 2);
        gridPane.add(tfNumberOfIterations, 1, 2);
        gridPane.add(new Label(" Average number of wells needed to see all variants at least once:"), 0, 3);
        gridPane.add(tfAverageNumberOfWells, 1, 3);
        gridPane.add(new Label(" Standard deviation of the samples:"), 0, 4);
        gridPane.add(tfStandardDeviationOfSamples, 1, 4);
        gridPane.add(new Label(" Amount of time it took to perform this computation:"), 0, 5);
        gridPane.add(tfElapsedSeconds, 1, 5);
        gridPane.add(btCalculate, 0, 6);

        // This sets the properties for the program's UI.
        gridPane.setAlignment(Pos.CENTER);
        tfNumberOfVariants.setAlignment(Pos.BOTTOM_RIGHT);
        tfNumberOfIterations.setAlignment(Pos.BOTTOM_RIGHT);
        tfAverageNumberOfWells.setAlignment(Pos.BOTTOM_RIGHT);
        tfStandardDeviationOfSamples.setAlignment(Pos.BOTTOM_RIGHT);
        tfElapsedSeconds.setAlignment(Pos.BOTTOM_RIGHT);
        tfAverageNumberOfWells.setEditable(false);
        tfStandardDeviationOfSamples.setEditable(false);
        tfElapsedSeconds.setEditable(false);
        GridPane.setHalignment(btCalculate, HPos.RIGHT);

        // This displays the program's documentation.
        tDocumentation.setText(" This is a JavaFX application that iteratively finds the number of" +
                " necessary samples\n to see all possible variants at least once." +
                " The purpose of the software is to assist\n synthetic biology" +
                " researchers in establishing the size of the sample space for\n" +
                " experiments performed in a laboratory setting.\n" +
                "\n" +
                " This program was written by amorehead (Alex Morehead) with generous support\n by the National Science Foundation." +
                " Special thanks to eledman (Elise Edman)\n for the original solution to this problem.\n" +
                "\n" +
                " Glossary:\n" +
                "\n" +
                " 1. \"Variants\" can be thought of as the quantity \"n\",\n" +
                "  representing the number of sides on an n-sided die.\n" +
                "\n" +
                " 2. \"Wells\" can be thought of as representing the individual rolls of a die.\n" +
                "\n" +
                " 3. \"Samples\" or \"iterations\" can be thought of as representing the numbers of\n" +
                "  times an n-sided die was rolled, or rather will be rolled, until all sides of\n" +
                "  the die were/are seen at least once.\n" +
                "  \n" +
                " Results:\n" +
                " \n" +
                " 1. The \"average number of wells\" metric describes how many rolls on average     \n" +
                "  had to be taken before seeing every side of an n-sided die. \n" +
                "\n" +
                " 2. The \"standard deviation of the samples\" metric discloses how separated on average \n" +
                "  the samples of die rolls were.\n" +
                "\n" +
                " 3. The \"amount of time it took to perform this computation\" metric simply states how \n" +
                "  many seconds, minutes, or hours it took to finish displaying the current computation's \n" +
                "  results.");

        // This sets dummy values for initial fields.
        tfNumberOfVariants.setText("6");
        tfNumberOfIterations.setText("38");

        // This processes the programs events.
        btCalculate.setOnAction(e -> performComputations());

        // This creates a scene and places it in the stage.
        Scene scene = new Scene(gridPane, 1024, 768);
        // This sets the stage's title.
        primaryStage.setTitle("Variant Sampler: An Experiment Simulator for Synthetic Biologists");
        primaryStage.setScene(scene); // This places the scene in the stage.
        primaryStage.show(); // This actually displays the stage.
    }

    /* This is a helper function that picks a random variant, adds
    it to the list of variants already found, and then checks to
    see whether or not all possible variants have been seen. */
    private void findNumberOfWells(List<Double> listOfSamples, BigInteger numberOfVariants) {
        Set<Integer> foundVariants = new HashSet<>();
        double numberOfWells;
        boolean allFound = false;

        // This allows us to skip the first "numberOfVariants" amount of variables.
        for (int i = 0; i < numberOfVariants.intValue(); i++)
            foundVariants.add(randomInt.nextInt(numberOfVariants.intValue()) + 1);
        numberOfWells = numberOfVariants.intValue();

        // This checks to make sure that we have seen all variants.
        while (!allFound) {
            foundVariants.add(randomInt.nextInt(numberOfVariants.intValue()) + 1);
            numberOfWells++;
            allFound = true;

            // This checks to see if we have seen at least the minimum number of variants.
            if (foundVariants.size() < numberOfVariants.intValue())
                allFound = false;
        }

        // This is where we add the current run's number of wells to the list of well totals.
        listOfSamples.add(numberOfWells);
    }

    /* This is an experimental method for finding the
     standard deviation of a list of doubles given a mean value. */
    private static double findStandardDeviation(List<Double> list, double mean) {
        double squareSum = 0;
        for (Double dbl : list) squareSum += Math.pow(dbl - mean, 2);
        double meanOfDiffs = squareSum / list.size();
        return Math.sqrt(meanOfDiffs);
    }

    // This is a method that will initiate the variant sampling process.
    private void performComputations() {
        /* This is a global list that will be referenced
        repeatedly during the execution of this program. */
        List<Double> listOfSamples = new ArrayList<>();

        // This creates empty BigInteger variables for the number of variants and number of samples.
        BigInteger numberOfVariants = BigInteger.ZERO;
        BigInteger totalNumberOfSamples = BigInteger.ZERO;

        try {
            // This gets the gross and net income values from the text fields.
            numberOfVariants = new BigInteger(tfNumberOfVariants.getText());
            totalNumberOfSamples = new BigInteger(tfNumberOfIterations.getText());
        } catch (Exception e) {
            // This displays the calculation results.
            tfAverageNumberOfWells.setText(" Please enter an integer value for the first two text fields.");
            tfStandardDeviationOfSamples.setText(" Please enter an integer value for the first two text fields.");
            tfElapsedSeconds.setText(" Please enter an integer value for the first two text fields.");
            return;
        }
        // This is to keep track of how much time the computation takes to complete.
        long tStart = System.currentTimeMillis();

        // This finds the number of wells for the number of iterations previously specified.
        for (int i = 0; i < totalNumberOfSamples.intValue(); i++)
            findNumberOfWells(listOfSamples, numberOfVariants);

        // This averages the number of wells for each iteration.
        double sumOfGeneratedSamples = listOfSamples.stream().mapToDouble(i -> i).sum();
        double averageNumberOfWells = sumOfGeneratedSamples / totalNumberOfSamples.intValue();

        // This finds the standard deviation of the well counts.
        double standardDeviationOfSamples = findStandardDeviation(listOfSamples, averageNumberOfWells);

        // This allows us to show the user how long the computation took.
        long tEnd = System.currentTimeMillis();
        long tDelta = tEnd - tStart;
        double elapsedSeconds = tDelta / 1000.0;

        // This displays the calculation results.
        tfNumberOfVariants.setText((String.format("%d", numberOfVariants)));
        tfNumberOfIterations.setText((String.format("%d", totalNumberOfSamples)));

        tfAverageNumberOfWells.setText(String.format("%,4.4f", averageNumberOfWells));
        if (standardDeviationOfSamples >= 0)
            tfStandardDeviationOfSamples.setText(String.format("%,4.4f", standardDeviationOfSamples));
        else tfStandardDeviationOfSamples.setText("N/A");
        if (elapsedSeconds >= 3600)
            tfElapsedSeconds.setText(String.format("%,4.4f hours", elapsedSeconds / 3600));
        else if (elapsedSeconds >= 60)
            tfElapsedSeconds.setText(String.format("%,4.4f minutes", elapsedSeconds / 60));
        else
            tfElapsedSeconds.setText(String.format("%,4.4f seconds", elapsedSeconds));
    }
}
