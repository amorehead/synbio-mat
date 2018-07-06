/*
 Alex Morehead
 7/5/2018

 This is a program that finds the number of necessary
 samples to see all possible variants at least once.

  Credit goes to eledman (Elise Edman) for the original solution to this problem.

//  Current implementation unfinished and untested.  //
*/

#include <iostream>
#include <list>
#include <random>
#include <string>
#include <sstream>
#include <set>

// This makes it easier for us to reference the "std" library.
using namespace std;

/* This is a list that will be referenced
repeatedly during the execution of this program. */
list<double> number_of_wells_list;

/* This is a random variable which will be referenced
 repeatedly during the execution of this program. */
std::random_device rd;

// This is our main function.
int main() {
    find_average_number_of_wells();
    return 0;
}

/* This is a function that calculates the average number of
 samples needed to see all possible variants at least once. */
virtual void find_average_number_of_wells() {
    // The following initializes variables for this function.
    string input;
    int number_of_variants = 0;
    int number_of_iterations = 0;

    // This defines how many variants we will be using.
    cout << "Please enter a desired number of variants: ";
    getline(cin, input);
    stringstream(input) >> number_of_variants;

    // This defines how many samples will be taken to find the average number of wells.
    cout << "Please enter a desired number of samples (A.K.A. iterations): ";
    getline(cin, input);
    stringstream(input) >> number_of_iterations;

    // This finds the number of wells for the number of iterations previously specified.
    for (int i = 0; i < number_of_iterations; i++)
        find_number_of_wells(new HashSet<>(), 0, number_of_variants);

    // This averages the number of wells for each iteration.
    double total = number_of_wells_list.stream().mapToDouble(i->i).sum();
    double average_number_of_samples = total / number_of_iterations;
    cout << "The average number of wells needed to see all variants at least once is %,4.2f." <<
         average_number_of_samples;
}

/* This is a helper function that picks a random variant, adds
 it to the list of variants already found, and then checks to
 see whether or not all possible variants have been seen. */
void find_number_of_wells(set<int> found_variants, double number_of_wells, int number_of_variants) {
    std::mt19937 rng(rd());
    std::uniform_int_distribution<int> uni(min, max);
    found_variants.add(uni);
    number_of_wells++;
    bool allFound = true;
    for (int i = 1; i < number_of_variants + 1; i++)
        if (!found_variants.contains(i)) {
            allFound = false;
            break;
        }

    if (allFound)
        number_of_wells_list.add(number_of_wells);
    else
        find_number_of_wells(found_variants, number_of_wells, number_of_variants);
}

