import numpy as np

global num_of_wells_list
num_of_wells_list = []


# This is a function that will find the number of wells needed to see all possible variants.
def find_num_of_wells(found_variants, num_of_wells, num_of_variants):
    found_variants.append(np.random.randint(1, num_of_variants + 1))
    num_of_wells += 1
    all_found = True

    for i in range(1, num_of_variants + 1):
        if i not in found_variants:
            all_found = False

    if all_found:
        num_of_wells_list.append(num_of_wells)

    else:
        find_num_of_wells(found_variants, num_of_wells, num_of_variants)


# This is our mainline for running this script.
if __name__ == "__main__":
    num_variants = int(input("Please enter a desired number of variants: "))
    num_of_iterations = 2 * num_variants if num_variants >= 50000 else 100000

    for i in range(num_of_iterations):
        find_num_of_wells([], 0, num_variants)
    total_num_of_wells = sum(num_of_wells_list)
    print("The average number of wells needed to see all variants at least once is {0}.".format(
        float(total_num_of_wells) / num_of_iterations))

    # Output with 100,000 iterations acting over 6 variants:
    # 14.67353
    # 14.71791
    # 14.70181
