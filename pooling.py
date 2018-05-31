import numpy as np

def first_plate(num_wells, num_variants, plate):
   for i in range(num_wells):
      num_in_well = (np.random.randint(num_variants))
      single_well = []
      for j in range(num_in_well):
         single_well.append(np.random.randint(1, num_variants))
      plate.append(single_well)
   return plate

def determine_brightness(brightness, plate):
   brightnesses = []
   for i in range(len(plate)):
      well_brightness = 0
      weight_sum = 0
      for j in range(len(plate[i])):
         well_brightness += plate[i][j]*brightness[plate[i][j]-1][1]
         weight_sum+=brightness[plate[i][j]-1][1]
      brightnesses.append(well_brightness/weight_sum)
   
   
   
if __name__ == "__main__":
   num_variants = 6
   num_wells = 14
   plate1 = first_plate(num_wells, num_variants,[])
   brightness = [[1,1], [2,.9], [3,.8], [4,.7], [5,.6], [6,.5]]
   well_brightnesses = determine_brightness(brightness,plate1)
   
   