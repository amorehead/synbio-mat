import numpy as np
import random


# creates the first generation
def first_gen(num_wells, num_variants, plate):
    pool = []
    for i in range(1, num_variants + 1):
        for j in range(100 / num_variants):
            pool.append(i)
    if len(pool) < 100:
        for i in range(100 - len(pool)):
            pool.append(np.random.randint(num_variants + 1))
    random.shuffle(pool)

    plate = []
    for i in range(num_wells):
        well = []
        for j in range(100 / num_wells):
            selection = np.random.randint(len(pool))
            well.append(pool[selection])
            del pool[selection]
        plate.append(well)

    if ((100 / num_wells) * num_wells) < 100:
        for i in range(100 - ((100 / num_wells) * num_wells)):
            rand_well = np.random.randint(num_wells)
            selection = np.random.randint(len(pool))
            plate[rand_well].append(pool[selection])
            del pool[selection]
    return plate


# determines the brightnesses in the individual wells
def determine_brightness1(brightness, plate):
    brightnesses = []
    for i in range(len(plate)):
        well_brightness = 0
        for j in range(len(plate[i])):
            well_brightness += brightness[plate[i][j]][1]
        if (well_brightness == 0):
            brightnesses.append(0)
        else:
            brightnesses.append(well_brightness)
    return brightnesses


# determines the brightnesses in the individual wells
def determine_brightness2(brightness, plate):
    brightnesses = []
    for i in range(len(plate)):
        well_brightness = 0
        for j in range(len(plate[i])):
            well_brightness += brightness[plate[i][j]][1]
        if (well_brightness == 0):
            brightnesses.append(0)
        else:
            brightnesses.append(well_brightness)
    return brightnesses


# chooses the top 10% brightest wells
def choose_wells(plate, well_brightnesses):
    ordered_brightnesses = np.sort(well_brightnesses)
    min_brightness = ordered_brightnesses[int(np.ceil(num_wells * .9)) - 1]
    top_wells = []
    for i in range(len(well_brightnesses)):
        if well_brightnesses[i] >= min_brightness:
            top_wells.append(plate[i])
    return top_wells


# recombines the wells into a single pool
def recombine(top_wells, num_variants):
    pool = []
    total = 0
    for i in range(len(top_wells)):
        for j in range(len(top_wells[i])):
            if top_wells[i][j] != 0:
                total += 1
    for i in range(1, num_variants + 1):
        count_variant = 0
        for j in top_wells:
            count_variant += j.count(i)
        pool.append([i, float(count_variant) / total])
    np.random.shuffle(pool)
    return pool


def next_gens(num_wells, pool):
    pool_elements = []
    for i in pool:
        for j in range(int(round(i[1] * 100))):
            pool_elements.append(i[0])
    # The following is to account for rounding errors above.
    if (len(pool_elements) != 100):
        if len(pool_elements) > 100:
            while len(pool_elements) > 100:
                del pool_elements[np.random.randint(len(pool_elements))]
        else:
            while len(pool_elements) < 100:
                pool_elements.append(pool[np.random.randint(len(pool))][0])
    random.shuffle(pool_elements)
    print(pool_elements)

    next_gen = []
    wells_left = num_wells
    total = 100
    num_individuals = 0
    for i in range(num_wells):
        single_well = [0]
        # Assuming good enough distribution throughout the solution
        if ((total / wells_left) - 3 <= 0):
            min_lim = 1
        else:
            min_lim = (total / wells_left) - 3
        if ((total / wells_left) + 3 > total):
            max_lim = total / wells_left
        else:
            max_lim = (total / wells_left) + 3
        if min_lim == 1 and max_lim == 1 or max_lim == 0:
            chosen_individuals = np.random.randint(1)
        else:
            chosen_individuals = np.random.randint(min_lim, max_lim)
        num_individuals += chosen_individuals
        total -= chosen_individuals
        for j in range(chosen_individuals):
            random_sample = np.random.randint(len(pool_elements))
            single_well.append(pool_elements[random_sample])
            del pool_elements[random_sample]
        next_gen.append(single_well)
        wells_left -= 1

    if num_individuals < 100:
        while len(pool_elements) != 0:
            well = np.random.randint(0, num_wells)
            random_sample = np.random.randint(len(pool_elements))
            next_gen[well].append(pool_elements[random_sample])
            del pool_elements[random_sample]
    return next_gen


if __name__ == "__main__":
    # If you alter the number of variants, you also have to alter
    # this brightness array so that each variant has a brightness that
    # is associated with it.
    num_variants = 6
    brightness = [[0, 0], [1, 1], [2, .9], [3, .1], [4, .15], [5, .2], [6, .3]]

    # Can alter the number of wells to see
    # how many iterations are expected to converge.
    # For example, with 6 variants, with 30 wells, the
    # number of iterations to see convergence is about 6.
    # With 35 wells, the number of iterations is closer to
    # 5.
    # Number of iterations is representative of # of generations.
    num_wells = 35

    iteration = 0
    for z in range(20):
        gen = first_gen(num_wells, num_variants, [])
        well_brightnesses = np.asarray(determine_brightness1(brightness, gen))

        num_iterations = 1
        print("Iteration: ", num_iterations)
        print("Highest well brightness: ", max(well_brightnesses))

        top_wells = choose_wells(gen, well_brightnesses)
        print("top wells: ", top_wells)

        done = False

        while not done:
            num_iterations += 1

            for i in top_wells:
                all_high = True
                for j in i:
                    if (j != 0 and j != 1):
                        all_high = False
                if all_high:
                    done = True
                    iteration += num_iterations
                    break
            if done:
                break

            pool = recombine(top_wells, num_variants)
            print("Pool: ", pool)
            gen = next_gens(num_wells, pool)

            print("Iteration: ", num_iterations)
            print("New generation: ", gen)
            well_brightnesses = np.asarray(determine_brightness2(brightness, gen))
            # print "Brightnesses in each well: ", well_brightnesses
            top_wells = choose_wells(gen, well_brightnesses)
            print("Top wells: ", top_wells)
            print("Highest well brightness: ", max(well_brightnesses))

    print("Average # of iterations: ", float(iteration) / 20)
