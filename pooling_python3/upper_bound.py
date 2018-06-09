import numpy as np
import scipy.stats as spsts


def find_num_rolls(num_of_variants=6):
    nums_gen = []
    all_found = False
    num_of_rolls = 0

    while not all_found:
        nums_gen.append(np.random.randint(1, num_of_variants + 1))

        num_of_rolls += 1

        every_one_found = True

        for i in range(1, num_of_variants + 1):
            if i not in nums_gen:
                all_found = False
                every_one_found = False

        if every_one_found:
            break

    return num_of_rolls


def find_upper_bound(num_of_variants=6, num_samples=100000, upper_bound=0.95):
    roll_list = []
    for i in range(num_samples):
        roll_list.append(find_num_rolls(num_of_variants))

    mean_of_rolls = np.mean(roll_list)
    std_dev = np.std(roll_list)
    upper_bound = mean_of_rolls + spsts.invgauss.std(upper_bound) * std_dev / num_samples ** 0.5

    print(upper_bound)
    return upper_bound


find_upper_bound()
