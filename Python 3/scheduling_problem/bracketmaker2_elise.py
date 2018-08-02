from __future__ import print_function
from ortools.linear_solver import pywraplp


def main():
    """Solving Assignment Problem with MIP"""
    # Instantiate a mixed-integer solver.
    solver = pywraplp.Solver('SolveAssignmentProblemMIP',
                             pywraplp.Solver.CBC_MIXED_INTEGER_PROGRAMMING)

    # Number of teams (h and i)
    n = 9
    # Number of rooms (j)
    r = 3
    # Number of timeslots (k)
    t = 4
    # Number of matches
    m = 4

    # List of teams
    teams = [i for i in range(9)]

    x = {}

    for h in range(n):
        for i in range(n):
            for j in range(r):
                for k in range(t):
                    if (h == i):
                        x[h, i, j, k] = solver.IntVar(0, 0, 'x[%i,%i,%i,%i]' % (h, i, j, k))
                    else:
                        x[h, i, j, k] = solver.IntVar(0, 1, 'x[%i,%i,%i,%i]' % (h, i, j, k))

    # # Objective
    # solver.Minimize(solver.Sum([cost[i][j] * x[i,j] for i in range(num_workers)
    #                                                 for j in range(num_tasks)]))

    # Constraints

    # 2 Ensures that the matrix is the same across the diagonal
    for h in range(n):
        for j in range(r):
            for k in range(t):
                solver.Add((x[h, i, j, k] == x[i, h, j, k]))

    # 3 No pair plays each other more than once
    for h in range(n - 1):
        for i in range(h + 1, n):
            solver.Add(solver.Sum([x[h, i, j, k] for j in range(r) for k in range(t)]) <= 1)

    # 4 No team can be in more than one place at a time
    for h in range(n):
        for k in range(t):
            solver.Add(solver.Sum([x[h, i, j, k] for i in range(n) for j in range(r)]) <= 2)

    # 5 Each team plays exactly m matches
    for i in range(n):
        solver.Add(solver.Sum([x[h, i, j, k] for j in range(r) for k in range(t) for h in range(n)]) == 2 * m)

    # 6 Need 3 teams in a room at each timeslot
    for j in range(r):
        for k in range(t - 1):
            solver.Add(solver.Sum([x[h, i, j, k] for i in range(n - 1) for h in range(i + 1, n)]) == 3)

    # Need 3 teams in a room at each timeslot
    for g in range(n - 2):
        for h in range(g + 1, n - 1):
            for i in range(h + 1, n):
                solver.Add(solver.Sum(
                    [x[g, h, j, k] + x[h, i, j, k] + x[g, i, j, k] for j in range(r) for k in range(t)]) != 2)

    sol = solver.Solve()

    print('Total cost = ', solver.Objective().Value())
    print()
    for h in range(n):
        for i in range(n):
            for j in range(r):
                for k in range(t):
                    if x[h, i, j, k].solution_value() > 0:
                        print('teams %i,%i assigned to room %i at time %i.' % (h, i, j, k))

    print()
    print("Time = ", solver.WallTime(), " milliseconds")


if __name__ == '__main__':
    main()
