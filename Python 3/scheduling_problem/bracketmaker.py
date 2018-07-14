"""
Alex Morehead
7/11/2018

This is a program that finds an "optimal"
bracket for quiz-style tournaments having
three teams compete simultaneously.
"""

import math
from itertools import chain, combinations


# This is a function for finding the necessary number of time slots.
def calc_real_time_slots(number_of_teams, number_of_quizzes, number_of_rooms):
    # This defines an integer value to find the number of time slots needed.
    number_of_matches = float((number_of_teams * number_of_quizzes)) / 3

    # This makes the number of time slots an integer by flooring the number if necessary.
    return (math.ceil(number_of_matches / number_of_rooms)) \
        if (number_of_matches % 3 == 0) else (int(math.ceil(number_of_matches)) // number_of_rooms)


# This is a function for finding the ideal number of time slots.
def calc_ideal_time_slots(number_of_teams):
    """ In a perfect round-robin scenario, the number of teams can
    determine the number of quizzes ((number of teams - 1) /2)
    and the number of rooms (number of teams / 3). """

    ideal_number_of_quizzes = (number_of_teams - 1) / 2
    ideal_number_of_rooms = number_of_teams / 3
    ideal_number_of_matches = (number_of_teams * ideal_number_of_quizzes) / 3
    return ideal_number_of_matches / ideal_number_of_rooms


# This is our main method.
if __name__ == "__main__":
    # This obtains necessary data from the user.
    number_of_teams = int(input("Please enter a desired number of teams: "))
    number_of_quizzes = int(input("Please enter a desired number of quizzes: "))
    number_of_rooms = int(input("Please enter a desired number of rooms: "))

    real_number_of_time_slots = calc_real_time_slots(number_of_teams, number_of_quizzes, number_of_rooms)
    print("The real number of time slots is {0}.".format(int(real_number_of_time_slots)))

    ideal_number_of_time_slots = calc_ideal_time_slots(number_of_teams)
    print("The ideal number of time slots is {0}.".format(int(ideal_number_of_time_slots)))

    # This initializes a list to be the same size as the "numberOfTeams".
    team_integers = list(range(1, number_of_teams + 1))

    # This populates our list of time slots with triplet-pairings of teams.
    prelim_time_slots = []
    for z in chain.from_iterable(combinations(team_integers, 3) for r in range(3)):
        prelim_time_slots.append(set(z))

    # This displays the list of time slots.
    print("The preliminary time slots are {0}.".format(prelim_time_slots))

    # This displays the number of preliminary time slots.
    print("The number of preliminary time slots is {0}.".format(len(prelim_time_slots)))

    # This makes sure the union of any two sets in "prelim_time_slots" is not greater than 1.
    undesirable_intersections = (prelim_time_slots[i] & prelim_time_slots[i + 1] for i in
                                 range(len(prelim_time_slots) - 1) if
                                 len(prelim_time_slots[i] & prelim_time_slots[i + 1]) > 1)

    # This displays the undesirable team intersections.
    print("The undesirable team intersections are {0}.".format(list(undesirable_intersections)))

    # This displays the number of undesirable team intersections.
    print("The number of undesirable team intersections is {0}.".format(len(list(undesirable_intersections))))
