# -*- coding: utf-8 -*-
"""
Created on Wed Jan 23 14:02:35 2019

@author: Jacob
"""
import os

import pandas as pd
import numpy as np
from mpl_toolkits.mplot3d import Axes3D
import matplotlib.pyplot as plt
from matplotlib import cm
from matplotlib.ticker import LinearLocator, FormatStrFormatter
from matplotlib.pyplot import imshow
from tqdm import tqdm
import re

def isSaddle(string): #for building list of saddle identities
    m = bool(re.search(r'.*B.*[Aa].*B.*[Aa]',string))
    m = m or bool(re.search(r'[Aa].*B.*[Aa].*B.*',string))
    return m

allidents = ['A','B'] #create all possible identities and put in a list
for _ in range(7):
    newlist = []
    for ident in allidents:
        if len(allidents[0]) % 2 == 0:
            newlist.append(ident+'A')
            newlist.append(ident+'B')
        else:
            newlist.append(ident+'a')
            newlist.append(ident+'b')
    allidents = newlist
saddleidents = []
nonsaddleidents = []
for ident in allidents:
    if isSaddle(ident):
        saddleidents.append(ident)
    else:
        nonsaddleidents.append(ident)

matrix = np.random.random(size=(500,500))
def fastsaddles(matrix):
    c = matrix[1:-1,1:-1]
    nw = np.asarray(np.where(matrix[:-2,:-2] >= c, 'a','b'), dtype=np.object) #directional matrices are boolean arrays of where taller than the center
    n = np.asarray(np.where(matrix[:-2,1:-1] >= c, 'A','B'), dtype=np.object)
    ne = np.asarray(np.where(matrix[:-2,2:] >= c, 'a','b'), dtype=np.object)
    e = np.asarray(np.where(matrix[1:-1,2:] >= c, 'A','B'), dtype=np.object)
    se = np.asarray(np.where(matrix[2:,2:] >= c, 'a','b'), dtype=np.object)
    s = np.asarray(np.where(matrix[2:,1:-1] >= c, 'A','B'), dtype=np.object)
    sw = np.asarray(np.where(matrix[2:,:-2] >= c, 'a','b'), dtype=np.object)
    w = np.asarray(np.where(matrix[1:-1,:-2] >= c, 'A','B'), dtype=np.object)
    identities = n+ne+e+se+s+sw+w+nw
    saddles = np.asarray(np.zeros(matrix.shape),dtype=bool) #adds border of zeros
    saddles[1:-1,1:-1] = np.isin(identities,saddleidents)
    return saddles

saddlelistz=[]
saddlelistx=[]
saddlelisty=[]
count =0
filenames = []
PercLevels = []
for filename in os.listdir('.'):
    if filename[-4:] == '.csv':
        filenames.append(filename)
        perclevel = filename.partition('Perc_')[2][:-4]
        perclevel = float(perclevel)
        PercLevels.append(perclevel)
for filename in tqdm(filenames):
    matrix=pd.read_csv(filename,header=None).to_numpy()
    saddles = fastsaddles(matrix)
    #saddlesComb = find_saddleNN(matrix) + find_saddleNNN(matrix)
    #saddles is a matrix with 1's in the positions that are saddle points
#
#    zheights = np.multiply(saddles,matrix)
#    zs = zheights[np.nonzero(zheighresults.txt'ts)]
#    saddlelistz.append(zs)

    for i,row in enumerate(saddles):
        for j,value in enumerate(row):
            if value == 1:
                saddlelistz.append(matrix[i,j])
                saddlelistx.append(j)
                saddlelisty.append(i)

print('Saddle Mean: '+str(np.mean(saddlelistz)))
print('Saddle Median: '+str(np.median(saddlelistz)))
print('Saddle StDev: '+str(np.std(saddlelistz)))
text_file = 'Saddle Mean: '+str(np.mean(saddlelistz))
text_file += '\nSaddle Median: '+str(np.median(saddlelistz))
text_file += '\nSaddle StDev: '+str(np.std(saddlelistz))
print('Perc Mean: '+str(np.mean(PercLevels)))
print('Perc Median: '+str(np.median(PercLevels)))
print('Perc StDev: '+str(np.std(PercLevels)))
text_file += '\nPerc Mean: '+str(np.mean(PercLevels))
text_file += '\nPerc Median: '+str(np.median(PercLevels))
text_file += '\nPerc StDev: '+str(np.std(PercLevels))
with open('results.txt', 'w') as filepath:
    print(text_file, file=filepath)

#fig4 = plt.figure()
#plt.hist(saddlelistx, density=True)
#plt.title('Saddle Distribution in the x direction', fontsize=65)
#plt.xlabel('x location', fontsize=55)
#plt.ylabel('Density', fontsize=55)
#plt.show()
#fig5 = plt.figure()
#plt.title('Saddle Distribution in the y direction', fontsize=65)
#plt.xlabel('y location', fontsize=55)
#plt.ylabel('Density', fontsize=55)
#plt.hist(saddlelisty, bins=11, density=True)
#plt.show()

fig3 = plt.figure(figsize=(15,15))
plt.hist(saddlelistz, bins=25, density=True, alpha=0.5)
plt.hist(PercLevels, bins=25, density=True, alpha=0.5)
plt.title('Saddle Height Distribution', fontsize=65)
plt.xlabel('Height (z location)', fontsize=55)
plt.ylabel('Density', fontsize=55)
plt.savefig('figure.png')
plt.show()


#fig4 = plt.figure()
#plt.hist(diffSortedZ, density=True)
#plt.title('Saddle Difference Height Distribution', fontsize=65)
#plt.xlabel('Height (z location)', fontsize=55) 
#plt.ylabel('Density', fontsize=55)
#plt.show()




#plt.rc('xtick',labelsize=25)
#plt.rc('ytick',labelsize=25)


# np.savetxt('C:/Users/Rylei/Documents/ResearchKen/MATLABCode/LevelSetModel/realdataGriddedScaledSaddles.csv',saddles,delimiter=',')