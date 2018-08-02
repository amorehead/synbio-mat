"""
Alex Morehead
7/31/2018

This is a program that finds an "optimal"
bracket for quiz-style tournaments having
three teams compete simultaneously.
"""

from ortools.linear_solver import pywraplp
import math


# This is a function for finding the necessary number of time slots.
def calc_real_time_slots(number_of_teams, number_of_quizzes, number_of_rooms):
    # This defines an integer value to find the number of team matchups needed.
    number_of_matches = float((number_of_teams * number_of_quizzes)) / 3

    # This makes the number of team matchups an integer by flooring the number if necessary.
    return (math.ceil(number_of_matches / number_of_rooms)) \
        if (number_of_matches % 3 == 0) else (int(math.ceil(number_of_matches)) // number_of_rooms)


# This is our main method.
def main():
    # This obtains necessary data from the user.
    number_of_teams = int(input("Please enter a desired number of teams: "))
    number_of_quizzes = int(input("Please enter a desired number of quizzes: "))
    number_of_rooms = int(input("Please enter a desired number of rooms: "))
    number_of_matches = number_of_quizzes

    # This finds the real number of time slots given the previous input data.
    real_number_of_time_slots = calc_real_time_slots(number_of_teams, number_of_quizzes, number_of_rooms)

    # This instantiates a mixed-integer solver.
    solver = pywraplp.Solver('SolveSchedulingProblemMIP',
                             pywraplp.Solver.CBC_MIXED_INTEGER_PROGRAMMING)

    # This marks the beginning of the establishing our four-dimensional list.
    x = {}

    # This populates our four-dimensional list.
    for h in range(number_of_teams):
        for i in range(number_of_teams):
            for j in range(number_of_rooms):
                for k in range(real_number_of_time_slots):
                    x[h, i, j, k] = solver.BoolVar('x[%i,%i,%i,%i]' % (h, i, j, h))
                    print(h, i, j, k)

    # Constraint 1: This says that teams cannot play themselves.
    for h in range(number_of_teams):
        solver.Add((x[h, h, j, k] for j in range(number_of_rooms) for k in range(real_number_of_time_slots)) == 0)

    # Constraint 2: This says that the order of team pairings does not  matter.
    for h in range(number_of_teams):
        for i in range(number_of_teams):
            solver.Add((x[h, i, j, k] - x[i, h, j, k] for j in range(number_of_rooms) for k in
                        range(real_number_of_time_slots)) == 0)

    # Constraint 3: This says that no pair plays each other more than once.
    for h in range(number_of_teams - 1):
        for i in range(h + 1, number_of_teams):
            solver.Add(solver.Sum(
                [x[h, i, j, k] for j in range(number_of_rooms) for k in range(real_number_of_time_slots)]) <= 1)

    # Constraint 4: This says that no team can be in more than one place at a time.
    for h in range(number_of_teams):
        for k in range(real_number_of_time_slots):
            solver.Add(solver.Sum([x[h, i, j, k] for i in range(number_of_teams) for j in range(number_of_rooms)]) <= 1)

    # Constraint 5: This says that each team plays an exact number of matches, "number_of_matches".
    for i in range(number_of_teams):
        solver.Add(solver.Sum(
            [x[h, i, j, k] for j in range(number_of_rooms) for k in range(real_number_of_time_slots) for h in
             range(number_of_teams)]) == 2 * number_of_matches)

    # Constraint 6: This says that each room and each time-slot is filled.
    for j in range(number_of_rooms):
        for k in range(real_number_of_time_slots - 1):
            solver.Add(
                solver.Sum(([x[h, i, j, k] for i in range(number_of_teams) for h in range(number_of_teams)])) == 3)

    # Constraint 7: This makes 3 teams play in each row at each time-slot.
    for g in range(number_of_teams - 2):
        for h in range(g + 1, number_of_teams - 1):
            for i in range(h + 1, number_of_teams):
                solver.Add((solver.Sum(
                    [x[g, h, j, k] + x[h, i, j, k] + x[g, i, j, k] for j in range(number_of_rooms) for k in
                     range(real_number_of_time_slots)])) != 2)

    # This finds a linear solution to the proposed problem.
    sol = solver.Solve()

    # This displays the solution.
    print('Total cost = ', solver.Objective().Value())
    print()
    for h in range(number_of_teams):
        for i in range(number_of_teams):
            for j in range(number_of_rooms):
                for k in range(real_number_of_time_slots):
                    print(h, i, j, k)

    print()
    print("Time = ", solver.WallTime(), " milliseconds")


# This ensures that the main method gets called at the script's startup.
if __name__ == "__main__":
    main()
