/*
 Alex Morehead
 7/9/2018

 This is a program that finds an "optimal"
 bracket for quiz-style tournaments having
 three teams compete simultaneously.
*/

package SchedulingProblem;

import java.util.Scanner;

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

        // This finds the number of necessary time slots for the given previously-specified values.
        int realNumberOfTimeSlots = calcRealTimeSlots(numberOfTeams, numberOfQuizzes, numberOfRooms);
        System.out.printf("The real number of time slots is %,d.", realNumberOfTimeSlots);

        int idealNumberOfTimeSlots = calcIdealTimeSlots(numberOfTeams);
        System.out.printf("\nThe ideal number of time slots is %,d.", idealNumberOfTimeSlots);
    }

    private static int calcIdealTimeSlots(int numberOfTeams) {

        /* In a perfect round-robin scenario, the number of teams can
        determine the number of quizzes ((number of teams - 1) /2)
        and the number of rooms (number of teams / 3). */

        int idealNumberOfQuizzes = (numberOfTeams - 1) / 2;
        int idealNumberOfRooms = numberOfTeams / 3;
        int idealNumberOfMatches = (numberOfTeams * idealNumberOfQuizzes) / 3;
        return idealNumberOfMatches / idealNumberOfRooms;

    }

    // This is a function for finding the number of necessary time slots.
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
