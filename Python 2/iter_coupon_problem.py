import numpy as np
import scipy.stats as sps

global num_of_wells_list
num_of_wells_list = []

# This is a function that will find the number of wells needed to see all possible variants.
def find_num_of_wells(num_of_variants=6):
    found_variants = set()
    num_of_wells = 0
    all_found = False

    # This allows us to skip the first "number_of_variants" amount of variables.
    for i in range(num_of_variants):
        found_variants.add(np.random.randint(1, num_of_variants + 1))
    num_of_wells = num_of_variants

    while not all_found:
        found_variants.add(np.random.randint(1, num_of_variants + 1))
        num_of_wells += 1
        all_found = True

        for i in range(1, num_of_variants + 1):
            if i not in found_variants:
                all_found = False

        if all_found:
            num_of_wells_list.append(num_of_wells)


# This is an experimental function for finding the upper bound of samples given integer variants.
def find_upper_bound(num_of_variants=6, num_of_iterations=100000, upper_bound=0.95):
    for i in range(num_of_iterations):
        find_num_of_wells(num_of_variants)

    sample_list_array = np.array(num_of_wells_list)
    mean_of_samples = np.mean(sample_list_array)
    print "The mean of the samples is", mean_of_samples
    std_dev = np.std(sample_list_array)
    print "The standard deviation of the samples is", std_dev
    upper_bound = mean_of_samples + sps.invgauss.std(upper_bound) * std_dev / num_of_iterations ** 0.5

    print "The upper bound of the samples is", upper_bound
    return upper_bound


# This is the mainline for running this script.
if __name__ == "__main__":

    num_of_variants = int(input("Please enter a desired number of variants: "))
    num_of_iterations = int(input("Please enter a desired number of samples (A.K.A. iterations): "))

    for j in range(num_of_iterations):
        find_num_of_wells(num_of_variants)
    total_num_of_wells = sum(num_of_wells_list)
    print("The average number of wells needed to see all variants at least once is {0}.".format(
        float(total_num_of_wells) / num_of_iterations))

    # Output with 100,000 samples acting over 6 variants:
    # 14.70742
    # 14.70777
    # 14.70725
