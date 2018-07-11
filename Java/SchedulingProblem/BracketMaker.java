/*
 Alex Morehead
 7/10/2018

 This is a program that finds an "optimal"
 bracket for quiz-style tournaments having
 three teams compete simultaneously.

 Credit goes to Google's Guava development
 team for creating the set operation tools
 used throughout the execution of this program.
*/

package SchedulingProblem;

import java.util.*;

import java.util.stream.*;

import com.google.common.collect.*;

public class BracketMaker {

    // This is our main method.
    public static void main(String[] args) {

        // This allows us to read keyboard input from the user.
        Scanner input = new Scanner(System.in);

        // This obtains necessary data from the user.
        System.out.print("Please enter a desired number of teams: ");
        int numberOfTeams = input.nextInt();
        System.out.print("Please enter a desired number of quizzes: ");
        int numberOfQuizzes = input.nextInt();
        System.out.print("Please enter a desired number of rooms: ");
        int numberOfRooms = input.nextInt();

        // This finds the number of time slots needed for the previously-specified values.
        int realNumberOfTimeSlots = calcRealTimeSlots(numberOfTeams, numberOfQuizzes, numberOfRooms);
        System.out.printf("\nThe real number of time slots is %,d.", realNumberOfTimeSlots);

        // This finds the ideal number of time slots for the previously-specified values.
        int idealNumberOfTimeSlots = calcIdealTimeSlots(numberOfTeams);
        System.out.printf("\nThe ideal number of time slots is %,d.\n", idealNumberOfTimeSlots);

        // This initializes a set to be the same size as the "numberOfTeams".
        List<Integer> teamIntegers = IntStream.range(1, numberOfTeams + 1)
                .boxed().collect(Collectors.toList());
        Set<Integer> teams = ImmutableSet.copyOf(teamIntegers);
        Set<Set<Integer>> teamCombinations = Sets.powerSet(teams);

        // This displays all possible team combinations.
        for (Integer integer : teamIntegers)
            System.out.print("\nTeam " + integer);
    }

    // This is a function for finding the ideal number of time slots.
    private static int calcIdealTimeSlots(int numberOfTeams) {
        /* In a perfect round-robin scenario, the number of teams can
        determine the number of quizzes ((number of teams - 1) /2)
        and the number of rooms (number of teams / 3). */

        int idealNumberOfQuizzes = (numberOfTeams - 1) / 2;
        int idealNumberOfRooms = numberOfTeams / 3;
        int idealNumberOfMatches = (numberOfTeams * idealNumberOfQuizzes) / 3;
        return idealNumberOfMatches / idealNumberOfRooms;

    }

    // This is a function for finding the necessary number of time slots.
    private static int calcRealTimeSlots(int numberOfTeams, int numberOfQuizzes, int numberOfRooms) {

        // This defines an integer value to find the number of time slots needed.
        double numberOfMatches = (numberOfTeams * numberOfQuizzes) / 3;

        // This pre-defines an integer for later use.
        int numberOfTimeSlots;

        // This makes the number of time slots an integer by flooring the number if necessary.
        if (numberOfMatches % 3 == 0) return ((int) numberOfMatches) / numberOfRooms;
        else return ((int) Math.floor(numberOfMatches)) / numberOfRooms;

    }

}
