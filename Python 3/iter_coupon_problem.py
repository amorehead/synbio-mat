"""
Alex Morehead
7/7/2018

This is a program that finds the number of necessary
samples to see all possible variants at least once.

Credit goes to eledman (Elise Edman) for the original solution to this problem.
"""

import numpy as np
import scipy.stats as sps

global num_of_wells_list
num_of_wells_list = list()


# This is a helper function that picks a random variant, adds
# it to the list of variants already found, and then checks to
# see whether or not all possible variants have been seen.
def find_num_of_wells(num_of_variants=6):
    found_variants = set()
    num_of_wells = 0
    all_found = False

    # This allows us to skip the first "number_of_variants" amount of variables.
    for i in range(num_of_variants):
        found_variants.add(np.random.randint(1, num_of_variants + 1))
    num_of_wells = num_of_variants

    # This checks to make sure that we have seen all variants.
    while not all_found:
        found_variants.add(np.random.randint(1, num_of_variants + 1))
        num_of_wells += 1
        all_found = True

        # This checks to see if we have seen all variants.
        if len(found_variants) < num_of_variants:
            all_found = False

    # This is where we add the current run's number of wells to the list of well totals.
    num_of_wells_list.append(num_of_wells)


# This is an experimental function for finding the upper bound of samples given integer variants.
def find_upper_bound(num_of_variants=6, num_of_iterations=100000, upper_bound=0.95):
    for i in range(num_of_iterations):
        find_num_of_wells(num_of_variants)

    sample_list_array = np.array(num_of_wells_list)
    mean_of_samples = np.mean(sample_list_array)
    print("The mean of the samples is", mean_of_samples)
    std_dev = np.std(sample_list_array)
    print("The standard deviation of the samples is", std_dev)
    upper_bound = mean_of_samples + sps.invgauss.std(upper_bound) * std_dev / num_of_iterations ** 0.5

    print("The upper bound of the samples is", upper_bound)
    return upper_bound


# This is our mainline for running this script.
if __name__ == "__main__":

    num_of_variants = int(input("Please enter a desired number of variants: "))
    num_of_iterations = int(input("Please enter a desired number of samples (A.K.A. iterations): "))

    for i in range(num_of_iterations):
        find_num_of_wells(num_of_variants)
    total_num_of_wells = sum(num_of_wells_list)
    print("The average number of wells needed to see all variants at least once is {0}.".format(
        float(total_num_of_wells) / num_of_iterations))
    std_dev = np.std(np.array(num_of_wells_list))
    print("The standard deviation of the wells is {0}.".format(std_dev))

    # Output with 100,000 iterations acting over 6 variants:
    # 14.68072
    # 14.73452
    # 14.71081
