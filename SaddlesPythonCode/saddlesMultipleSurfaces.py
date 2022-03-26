# -*- coding: utf-8 -*-
"""
Created on Sun Mar 20 16:54:43 2022

@author: Rylei
"""

from findsaddlepointsNEW import findsaddlematrix
import pandas as pd
import numpy as np

import os
# assign directory
directory = 'C:/Users/Rylei/Documents/ResearchKen/MATLABCode/LevelSetModel/IsotropicSurfaces/'

# iterate over files in
# that directory
count = 1
for fname in os.listdir(directory):
    print(count)
    matrix=pd.read_csv(directory +fname,header=None).to_numpy()

    saddles = findsaddlematrix(matrix)
    np.savetxt('C:/Users/Rylei/Documents/ResearchKen/MATLABCode/LevelSetModel/IsotropicSurfacesSaddles/' +fname,saddles,delimiter=',')
    count +=1