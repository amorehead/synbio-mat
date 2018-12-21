"""
Alex Morehead & Elise Edman
12/19/2018

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
    n = 43  # or 43
    # This represents the number of rooms used for the tournament (variable j).
    r = 18  # or 18
    # This represents the number of time-slots used during the tournament (variable k).
    t = 15  # or 15
    # This represents the number of matches taking place during the tournament (variable m).
    m = 18  # or 18

    # This creates our four-dimensional list for the tournament.
    x = {}

    # This populates our four-dimensional list for the tournament.
    for h in range(1, n + 1):
        for i in range(1, n + 1):
            for j in range(1, r + 1):
                for k in range(1, t + 1):
                    if h == i:
                        x[h, i, j, k] = solver.IntVar(0, 0, 'x[%i,%i,%i,%i]' % (h, i, j, k))
                    else:
                        x[h, i, j, k] = solver.IntVar(0, 1, 'x[%i,%i,%i,%i]' % (h, i, j, k))

    # Now, we will begin establishing our constraints for the tournament.

    # Constraint 1: This says that teams cannot play themselves.
    # This constraint is actually already handled by our list instantiation
    # with the conditional logic in place (if h == i: ...).

    # Constraint 2: The order of team pairings does not matter.
    # In other words, the tournament matrix is the same across the diagonal.
    for h in range(1, n + 1):
        for i in range(1, n + 1):
            for j in range(1, r + 1):
                for k in range(1, t + 1):
                    solver.Add((x[h, i, j, k] == x[i, h, j, k]))

    # Constraint 3: No pair plays each other more than once.
    for h in range(1, n):
        for i in range(h + 2, n + 1):
            solver.Add(solver.Sum([x[h, i, j, k] for j in range(1, r + 1) for k in range(1, t + 1)]) <= 1)

    # Constraint 4: No team can be in more than one place at a time.
    for h in range(1, n + 1):
        for k in range(1, t + 1):
            solver.Add(solver.Sum([x[h, i, j, k] for i in range(1, n + 1) for j in range(1, r + 1)]) <= 2)

    # Constraint 5: Each team plays exactly "m" matches.
    for i in range(1, n + 1):
        solver.Add(
            solver.Sum(
                [x[h, i, j, k] for j in range(1, r + 1) for k in range(1, t + 1) for h in range(1, n + 1)]) == 2 * m)

    # Constraint 6: Each room and each time-slot is completely filled up until the last time-slot.
    for j in range(1, r + 1):
        for k in range(1, t):
            solver.Add(solver.Sum([x[h, i, j, k] for i in range(1, n) for h in range(i + 2, n + 1)]) == 3)

    # Constraint 7: Three teams play in a room at each time-slot.
    for g in range(1, n - 1):
        for h in range(g + 2, n):
            for i in range(h + 2, n + 1):
                solver.Add(solver.Sum(
                    [x[g, h, j, k] + x[h, i, j, k] + x[g, i, j, k] for j in range(1, r + 1) for k in
                     range(1, t + 1)]) >= 2.000001 or (solver.Sum(
                    [x[g, h, j, k] + x[h, i, j, k] + x[g, i, j, k] for j in range(1, r + 1) for k in
                     range(1, t + 1)])) <= 1.999999)

    # The following tells the solver object to find a solution for the proposed tournament scenario.
    result_status = solver.Solve()
    assert result_status == pywraplp.Solver.OPTIMAL
    assert solver.VerifySolution(1e-7, True)

    # The following displays the solution to the user.
    print("The cost of finding this solution was %d.\n" % solver.Objective().Value())
    for h in range(1, n + 1):
        for i in range(1, n + 1):
            for j in range(1, r + 1):
                for k in range(1, t + 1):
                    if x[h, i, j, k].solution_value() > 0:
                        print("Team %i and Team %i were assigned to room %i at time-slot %i." % (h, i, j, k))

    print("\nThe amount of time spent finding this solution was", solver.WallTime(), "milliseconds.")


# This ensures that the main method gets called at the script's startup.
if __name__ == "__main__":
    main()
