/*
 Alex Morehead
 7/30/2018

 Written with generous support by the National Science Foundation.

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
*/

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
    private final TextField tfStandardDeviationOfTrials = new TextField();
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
        gridPane.add(new Label(" Please enter the number of trials to be used in this experiment (ex: 38):"), 0, 2);
        gridPane.add(tfNumberOfIterations, 1, 2);
        gridPane.add(new Label(" Average number of wells needed to see all variants at least once:"), 0, 3);
        gridPane.add(tfAverageNumberOfWells, 1, 3);
        gridPane.add(new Label(" Standard deviation of the trials:"), 0, 4);
        gridPane.add(tfStandardDeviationOfTrials, 1, 4);
        gridPane.add(new Label(" Amount of time it took to perform this computation:"), 0, 5);
        gridPane.add(tfElapsedSeconds, 1, 5);
        gridPane.add(btCalculate, 0, 6);

        // This sets the properties for the program's UI.
        gridPane.setAlignment(Pos.CENTER);
        tfNumberOfVariants.setAlignment(Pos.BOTTOM_RIGHT);
        tfNumberOfIterations.setAlignment(Pos.BOTTOM_RIGHT);
        tfAverageNumberOfWells.setAlignment(Pos.BOTTOM_RIGHT);
        tfStandardDeviationOfTrials.setAlignment(Pos.BOTTOM_RIGHT);
        tfElapsedSeconds.setAlignment(Pos.BOTTOM_RIGHT);
        tfAverageNumberOfWells.setEditable(false);
        tfStandardDeviationOfTrials.setEditable(false);
        tfElapsedSeconds.setEditable(false);
        GridPane.setHalignment(btCalculate, HPos.RIGHT);

        // This displays the program's documentation.
        tDocumentation.setText(" This is a JavaFX application that iteratively finds the number of" +
                " necessary trials\n to see all possible variants at least once." +
                " The purpose of the software is to assist\n synthetic biology" +
                " researchers in establishing the number of P-gel pads required to\n" +
                " see every variant at least once.\n" +
                "\n" +
                " This program was written by amorehead (Alex Morehead) with generous support\n by the National Science Foundation." +
                " Special thanks to eledman (Elise Edman)\n for the original solution to this problem.\n" +
                "\n" +
                " Glossary:\n" +
                "\n" +
                " 1. \"Variants\" can be thought of as the number of distinct promoters.\n" +
                "\n" +
                " 2. \"Wells\" can be thought of as individual P-gel pads.\n" +
                "\n" +
                " 3. \"Trials\" can be thought of as the number of times for the experiment to be performed.\n" +
                "  \n" +
                " Results:\n" +
                " \n" +
                " 1. The \"average number of wells\" metric states how many P-gel pads on average\n" +
                "  had to be used to see every distinct variation of promoters. \n" +
                "\n" +
                " 2. The \"standard deviation of trials\" metric describes how separated on average \n" +
                "  the results of the trials were.\n" +
                "\n" +
                " 3. The \"amount of time it took to perform this computation\" metric displays how \n" +
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
    private void findNumberOfWells(List<Double> listOfTrials, BigInteger numberOfVariants) {
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
        listOfTrials.add(numberOfWells);
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
        List<Double> listOfTrials = new ArrayList<>();

        // This creates empty BigInteger variables for the number of variants and number of Trials.
        BigInteger numberOfVariants = BigInteger.ZERO;
        BigInteger totalNumberOfTrials = BigInteger.ZERO;

        try {
            // This gets the gross and net income values from the text fields.
            numberOfVariants = new BigInteger(tfNumberOfVariants.getText());
            totalNumberOfTrials = new BigInteger(tfNumberOfIterations.getText());
        } catch (Exception e) {
            // This displays the calculation results.
            tfAverageNumberOfWells.setText(" Please enter an integer value for the first two text fields.");
            tfStandardDeviationOfTrials.setText(" Please enter an integer value for the first two text fields.");
            tfElapsedSeconds.setText(" Please enter an integer value for the first two text fields.");
            return;
        }
        // This is to keep track of how much time the computation takes to complete.
        long tStart = System.currentTimeMillis();

        // This finds the number of wells for the number of iterations previously specified.
        for (int i = 0; i < totalNumberOfTrials.intValue(); i++)
            findNumberOfWells(listOfTrials, numberOfVariants);

        // This averages the number of wells for each iteration.
        double sumOfGeneratedTrials = listOfTrials.stream().mapToDouble(i -> i).sum();
        double averageNumberOfWells = sumOfGeneratedTrials / totalNumberOfTrials.intValue();

        // This finds the standard deviation of the well counts.
        double standardDeviationOfTrials = findStandardDeviation(listOfTrials, averageNumberOfWells);

        // This allows us to show the user how long the computation took.
        long tEnd = System.currentTimeMillis();
        long tDelta = tEnd - tStart;
        double elapsedSeconds = tDelta / 1000.0;

        // This displays the calculation results.
        tfNumberOfVariants.setText((String.format("%d", numberOfVariants)));
        tfNumberOfIterations.setText((String.format("%d", totalNumberOfTrials)));

        tfAverageNumberOfWells.setText(String.format("%,4.4f", averageNumberOfWells));
        if (standardDeviationOfTrials >= 0)
            tfStandardDeviationOfTrials.setText(String.format("%,4.4f", standardDeviationOfTrials));
        else tfStandardDeviationOfTrials.setText("N/A");
        if (elapsedSeconds >= 3600)
            tfElapsedSeconds.setText(String.format("%,4.4f hours", elapsedSeconds / 3600));
        else if (elapsedSeconds >= 60)
            tfElapsedSeconds.setText(String.format("%,4.4f minutes", elapsedSeconds / 60));
        else
            tfElapsedSeconds.setText(String.format("%,4.4f seconds", elapsedSeconds));
    }
}
