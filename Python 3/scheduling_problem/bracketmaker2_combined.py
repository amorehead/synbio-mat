"""
Elise Edman & Alex Morehead
8/4/2018

This is a program that finds an "optimal"
bracket for quiz-style tournaments having
three teams compete simultaneously.
"""

from ortools.linear_solver import pywraplp


# This is our main method.
def main():
    solver = pywraplp.Solver('SolveSchedulingProblemMIP',
                             pywraplp.Solver.CBC_MIXED_INTEGER_PROGRAMMING)

    # This represents the number of teams in the tournament (variables h and i).
    n = 9
    # This represents the number of rooms used for the tournament (variable j).
    r = 3
    # This represents the number of time-slots used during the tournament (variable k).
    t = 4
    # This represents the number of matches taking place during the tournament (variable m).
    m = 4

    # This creates our four-dimensional list for the tournament.
    x = {}

    # This populates our four-dimensional list for the tournament.
    for h in range(n):
        for i in range(n):
            for j in range(r):
                for k in range(t):
                    if h == i:
                        x[h, i, j, k] = solver.IntVar(0, 0, 'x[%i,%i,%i,%i]' % (h, i, j, k))
                    else:
                        x[h, i, j, k] = solver.IntVar(0, 1, 'x[%i,%i,%i,%i]' % (h, i, j, k))

    # Now, we will begin establishing our constraints for the tournament.

    # Constraint 1: This says that teams cannot play themselves. -- [No Longer Needed]
    # for h in range(n):
    #     solver.Add((x[h, h, j, k] for j in range(n) for k in range(t)) == 0)

    # Constraint 2: The order of team pairings does not matter.
    # In other words, the tournament matrix is the same across the diagonal.
    for h in range(n):
        for j in range(r):
            for k in range(t):
                solver.Add((x[h, i, j, k] == x[i, h, j, k] for i in range(n)))

    # Constraint 3: No pair plays each other more than once.
    for h in range(n - 1):
        for i in range(h + 1, n):
            solver.Add(solver.Sum([x[h, i, j, k] for j in range(r) for k in range(t)]) <= 1)

    # Constraint 4: No team can be in more than one place at a time.
    for h in range(n):
        for k in range(t):
            solver.Add(solver.Sum([x[h, i, j, k] for i in range(n) for j in range(r)]) <= 2)

    # Constraint 5: Each team plays exactly "m" matches.
    for i in range(n):
        solver.Add(solver.Sum([x[h, i, j, k] for j in range(r) for k in range(t) for h in range(n)]) == 2 * m)

    # Constraint 6: Each room and each time-slot is completely filled up until the last time-slot.
    for j in range(r):
        for k in range(t - 1):
            solver.Add(solver.Sum([x[h, i, j, k] for i in range(n - 1) for h in range(i + 1, n)]) == 3)

    # Constraint 7: Three teams play in a room at each time-slot.
    for g in range(n - 2):
        for h in range(g + 1, n - 1):
            for i in range(h + 1, n):
                solver.Add(solver.Sum(
                    [x[g, h, j, k] + x[h, i, j, k] + x[g, i, j, k] for j in range(r) for k in range(t)]) != 2)

    # This tells the solver object to find a solution for the proposed tournament scenario.
    solver.Solve()

    # The following displays the solution to the user.
    print("Total cost = ", solver.Objective().Value())
    print()
    for h in range(n):
        for i in range(n):
            for j in range(r):
                for k in range(t):
                    if x[h, i, j, k].solution_value() > 0:
                        print("Teams %i,%i assigned to room %i at time-slot %i." % (h, i, j, k))

    print()
    print("Time to complete this computation: ", solver.WallTime(), " milliseconds")


# This ensures that the main method gets called at the script's startup.
if __name__ == "__main__":
    main()
