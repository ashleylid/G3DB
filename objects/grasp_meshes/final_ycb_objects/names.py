# file for saving all objects to txt file in format for ObjectData in database

import os
import numpy as np

file_object  = open("names.txt", "r+") 
filenames = os.listdir("./totalYCB16k")


for file in filenames:
	ind = filenames.index(file)
	string_write = ('od{' + str(ind+1) + '}' + ' = {\'' + file[:-4] + '\'' + ',' + '};' + '\n')
	file_object.write(string_write)



file_object.close()