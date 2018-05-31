import numpy as np

global num_wells_list 
num_wells_list = []

def take_sample(found_variants, num_wells, num_variants):
    found_variants.append(np.random.randint(1, num_variants+1))
    num_wells+=1
    all_found = True
    for i in range(1, num_variants+1):
        if i not in found_variants:
            all_found = False
    if(all_found == True):
        num_wells_list.append(num_wells)
    else:
        take_sample(found_variants, num_wells, num_variants)
        
if __name__ == "__main__":
    num_variants = 6
    num_samples = 100000
    
    for i in range(num_samples):
        take_sample([], 0, num_variants)
    total = sum(num_wells_list)
    print float(total)/num_samples
    
    # answer with 100000 iterations is
    # 14.69937
    # 14.68126
    # 14.68242