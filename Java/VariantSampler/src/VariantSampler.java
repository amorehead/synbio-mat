/*
 Alex Morehead
 7/19/2018

 This is a JavaFX program that iteratively finds the number of
 necessary samples to see all possible variants at least once.

 Credit goes to eledman (Elise Edman) for the original solution to this problem.

 Glossary:

 1. "Variants" can be thought of as the quantity "n",
  representing the number of sides on an n-sided die.

 2. "Wells" can be thought of as representing the individual rolls of a die.

 3. "Samples" or "iterations" can be thought of as representing the numbers of
  times an n-sided die was rolled, or rather will be rolled, until all sides of
  the die were/are seen at least once.
*/

package VariantSampler.src;

import javafx.application.Application;
import javafx.geometry.HPos;
import javafx.geometry.Pos;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.control.TextField;
import javafx.scene.layout.GridPane;
import javafx.stage.Stage;

import java.math.BigDecimal;
import java.math.BigInteger;
import java.util.*;

public class VariantSampler extends Application {
    private final TextField tfNumberOfVariants = new TextField();
    private final TextField tfNumberOfIterations = new TextField();
    private final TextField tfAverageNumberOfWells = new TextField();
    private final TextField tfStandardDeviationOfSamples = new TextField();
    private final TextField tfElapsedSeconds = new TextField();
    private final Button btCalculate = new Button("Calculate");

    /* This is a global list that will be referenced
    repeatedly during the execution of this program. */
    private static final List<Double> listOfSamples = new ArrayList<>();

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
        gridPane.add(new Label("Number of variants involved in this experiment:"), 0, 0);
        gridPane.add(tfNumberOfVariants, 1, 0);
        gridPane.add(new Label("Number of samples (A.K.A. iterations) taken in this experiment:"), 0, 1);
        gridPane.add(tfNumberOfIterations, 1, 1);
        gridPane.add(new Label("Average number of wells needed to see all variants at least once:"), 0, 2);
        gridPane.add(tfAverageNumberOfWells, 1, 2);
        gridPane.add(new Label("Standard deviation of the samples:"), 0, 3);
        gridPane.add(tfStandardDeviationOfSamples, 1, 3);
        gridPane.add(new Label("Amount of time it took to perform this computation:"), 0, 4);
        gridPane.add(tfElapsedSeconds, 1, 4);
        gridPane.add(btCalculate, 0, 5);

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

        // This sets dummy values for the gross and net income fields.
        tfNumberOfVariants.setText("6");
        tfNumberOfIterations.setText("38");

        // This processes the programs events.
        btCalculate.setOnAction(e -> performComputations());

        // This creates a scene and places it in the stage.
        Scene scene = new Scene(gridPane, 800, 600);
        primaryStage.setTitle("Variant Sampler: An Experimentation Simulator"); // This sets the stage's title.
        primaryStage.setScene(scene); // This places the scene in the stage.
        primaryStage.show(); // This actually displays the stage.
    }

    /* This is a helper function that picks a random variant, adds
    it to the list of variants already found, and then checks to
    see whether or not all possible variants have been seen. */
    private static void findNumberOfWells(BigInteger numberOfVariants) {
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

    private void performComputations() {

        // This gets the gross and net income values from the text fields.
        BigInteger numberOfVariants = new BigInteger(tfNumberOfVariants.getText());
        BigInteger totalNumberOfSamples = new BigInteger(tfNumberOfIterations.getText());

        // This is to keep track of how much time the computation takes to complete.
        BigDecimal tStart = BigDecimal.valueOf(System.currentTimeMillis());

        // This finds the number of wells for the number of iterations previously specified.
        for (int i = 0; i < totalNumberOfSamples.intValue(); i++)
            findNumberOfWells(numberOfVariants);

        // This averages the number of wells for each iteration.
        double sumOfGeneratedSamples = listOfSamples.stream().mapToDouble(i -> i).sum();
        double averageNumberOfWells = sumOfGeneratedSamples / totalNumberOfSamples.intValue();

        // This finds the standard deviation of the well counts.
        double standardDeviationOfSamples = findStandardDeviation(listOfSamples, averageNumberOfWells);

        // This allows us to show the user how long the computation took.
        BigDecimal tEnd = BigDecimal.valueOf(System.currentTimeMillis());
        BigDecimal tDelta = tEnd.subtract(tStart);
        BigDecimal elapsedSeconds = tDelta.divide(BigDecimal.valueOf(1000.0));

        // This displays the calculation results.
        tfNumberOfVariants.setText((String.format("%,d", numberOfVariants)));
        tfNumberOfIterations.setText((String.format("%,d", totalNumberOfSamples)));
        tfAverageNumberOfWells.setText(String.format("%,4.2f", averageNumberOfWells));
        if (standardDeviationOfSamples >= 0)
            tfStandardDeviationOfSamples.setText(String.format("%,4.2f", standardDeviationOfSamples));
        else tfStandardDeviationOfSamples.setText("N/A");
        if (elapsedSeconds.intValue() >= 3600)
            tfElapsedSeconds.setText(String.format("%,4.2f hours", elapsedSeconds));
        else if (elapsedSeconds.intValue() >= 60)
            tfElapsedSeconds.setText(String.format("%,4.2f minutes", elapsedSeconds.divide(BigDecimal.valueOf(60))));
        else
            tfElapsedSeconds.setText(String.format("%,4.2f seconds", elapsedSeconds.divide(BigDecimal.valueOf(60))));
    }
}
