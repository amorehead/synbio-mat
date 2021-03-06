"""
Alex Morehead
7/16/2018

This is a program that finds an "optimal"
bracket for quiz-style tournaments having
three teams compete simultaneously.
"""

import math
from itertools import chain, combinations


# This is a function for finding the necessary number of time slots.
def calc_real_time_slots(number_of_teams, number_of_quizzes, number_of_rooms):
    # This defines an integer value to find the number of team matchups needed.
    number_of_matches = float((number_of_teams * number_of_quizzes)) / 3

    # This makes the number of team matchups an integer by flooring the number if necessary.
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


# This is a function for calculating the number of Partial Steiner Triples given a number of teams.
def find_number_of_triples(number_of_teams):
    if number_of_teams % 6 == 5:
        number_of_triples = (((1 / 3) * number_of_teams) * (1 / 2) - 1) - 1
    else:
        number_of_triples = (((1 / 3) * number_of_teams) * (1 / 2))
    return number_of_triples


# This function will print out a formatted version of the generated bracket.
def print_bracket(number_of_rooms, number_of_time_slots):
    print("\n", list(range(1, number_of_time_slots + 1)))
    for n in range(1, number_of_rooms + 1):
        print("", n)


# This is a function that will yield all "n"-sized chunks of list "l".
def find_chunks(l, n):
    for i in range(0, len(l), n):
        yield l[i:i + n]


# This is our main method.
if __name__ == "__main__":
    # This obtains necessary data from the user.
    number_of_teams = int(input("Please enter a desired number of teams: "))
    number_of_quizzes = int(input("Please enter a desired number of quizzes: "))
    number_of_rooms = int(input("Please enter a desired number of rooms: "))

    # This finds the real number of time slots given the previous input data.
    real_number_of_time_slots = calc_real_time_slots(number_of_teams, number_of_quizzes, number_of_rooms)
    print("The real number of time slots is {0}.".format(int(real_number_of_time_slots)))

    # This finds the ideal number of time slots given the previous input data.
    ideal_number_of_time_slots = calc_ideal_time_slots(number_of_teams)
    print("The ideal number of time slots is {0}.".format(int(ideal_number_of_time_slots)))

    # This initializes a list to be the same size as the "numberOfTeams".
    team_integers = list(range(1, number_of_teams + 1))

    # This finds the number of participants in the tournament.
    number_of_participants = 3 * number_of_rooms

    # This populates our list of team matchups with triplet-pairings of teams.
    prelim_team_matchups = []
    for z in chain.from_iterable(combinations(team_integers, 3) for r in range(3)):
        prelim_team_matchups.append(set(z))

    # This displays the list of team matchups.
    print("The preliminary team matchups are {0}.".format(prelim_team_matchups))

    # This stores the number of preliminary team matchups.
    number_of_prelim_team_matchups = len(prelim_team_matchups)

    # This displays the number of preliminary team matchups.
    print("The number of preliminary team matchups is {0}.".format(number_of_prelim_team_matchups))

    # This finds triple pairings of teams from the original list of team integers.
    triple_pairings = list(find_chunks(team_integers, 3))

    # This initializes the list of time slots.
    time_slots = [[] for i in range(number_of_rooms)]

    # This populates the first time slot of the tournament.
    time_slots[0] = triple_pairings

    # This initializes the list of opposing teams seen.
    teams_seen_list = {i: i + 1 for i in range(number_of_teams - 1)}

    # This prints out the filled time slots.
    print("The time slots filled are {0}.".format(time_slots))
