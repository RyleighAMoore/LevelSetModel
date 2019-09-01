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

def find_saddleNN(matrix):
    saddles=np.zeros(matrix.shape,dtype=np.int8)
    for i,row in enumerate(matrix):
        for j,element in enumerate(row):
            if i*j>0 and i<matrix.shape[0]-1 and j<matrix.shape[1]-1:
                mini=matrix[i-1:i+2,j-1:j+2]
                if mini[1,1]==max(mini[1]) and mini[1,1]==min(mini[:,1]):
                    saddles[i,j]=1
                elif mini[1,1]==min(mini[1]) and mini[1,1]==max(mini[:,1]):
                    saddles[i,j]=1
    return saddles

def find_saddleNNN(matrix):
    saddles=np.zeros(matrix.shape,dtype=np.int8)
    for i,row in enumerate(matrix):
        for j,element in enumerate(row):
            if i*j>0 and i<matrix.shape[0]-1 and j<matrix.shape[1]-1:
                mini=matrix[i-1:i+2,j-1:j+2]
                if mini[1,1]==max([mini[0,0],mini[1,1],mini[2,2]]) and mini[1,1]==min([mini[2,0],mini[1,1],mini[0,2]]):
                    saddles[i,j]=1
                elif mini[1,1]==min([mini[0,0],mini[1,1],mini[2,2]]) and mini[1,1]==max([mini[2,0],mini[1,1],mini[0,2]]):
                    saddles[i,j]=1
    for i,row in enumerate(saddles):
        for j,element in enumerate(row):
            if (i*j)>0:
                mini = saddles[i-1:i+1,j-1:j+1]
                if np.sum(mini) == 2:
                    minind = np.argmin((matrix[i-1:i+1,j-1:j+1]-2)*mini) #Depends on values being between -1 and 1
                    indloc = {0:(i-1,j-1),1:(i-1,j),2:(i,j-1),3:(i,j)}
                    ind = indloc[minind]
                    saddles[ind] = 0
                elif np.sum(mini) > 2:
                    print('Something fishy is going on!')
                    print(i,j)
                    print(matrix[i-1:i+1,j-1:j+1])
    return saddles

def findsaddlematrix(matrix):
    saddles = np.zeros_like(matrix, dtype=int)
    cross = np.array([[0,1,0],[1,0,1],[0,1,0]])
    for i,row in enumerate(matrix):
        for j,element in enumerate(row):
            if i*j>0 and i<matrix.shape[0]-1 and j<matrix.shape[1]-1:
                mini = matrix[i-1:i+2,j-1:j+2]
                mini = np.array(mini < mini[1,1], dtype=int) #mini is now an array with 1 where lower than the center
                if np.sum(mini*cross) >= 2: #checks for at least 2 NN lower
                    minirot90 = np.rot90(mini)
                    minirot180 = np.rot90(minirot90)
                    minirot270 = np.rot90(minirot180)
                    if (np.sum(mini[1]) == 0) or (np.sum(mini[:,1]) == 0): #checks for the traditional saddle case
                        saddles[i,j] = 1
                    elif (mini[0,1] == 1) and (mini[1,0] == 1) and (mini[0,0] == 0): #if the small corner is high
                        if np.sum([np.sum(mini[2]),mini[0,2],mini[1,2]]) < 5: #if the large corner is high
                            saddles[i,j] = 1
                    elif (minirot90[0,1] == 1) and (minirot90[1,0] == 1) and (minirot90[0,0] == 0): #if the corner is high
                        if np.sum([np.sum(minirot90[2]),minirot90[0,2],minirot90[1,2]]) < 5:
                            saddles[i,j] = 1
                    elif (minirot180[0,1] == 1) and (minirot180[1,0] == 1) and (minirot180[0,0] == 0): #if the corner is high
                        if np.sum([np.sum(minirot180[2]),minirot180[0,2],minirot180[1,2]]) < 5:
                            saddles[i,j] = 1
                    elif (minirot270[0,1] == 1) and (minirot270[1,0] == 1) and (minirot270[0,0] == 0): #if the corner is high
                        if np.sum([np.sum(minirot270[2]),minirot270[0,2],minirot270[1,2]]) < 5:
                            saddles[i,j] = 1
    return saddles

     
matrix=pd.read_csv('C:/Users/Rylei/MATLAB/Projects/GitLevelSetModel/Surfaces/realdataScaled.csv',header=None).to_numpy()
saddles = findsaddlematrix(matrix)
#saddlesComb = find_saddleNN(matrix) + find_saddleNNN(matrix)
#saddles is a matrix with 1's in the positions that are saddle points


#Plotting points
xs,ys,zs=[],[],[]
for i,row in enumerate(saddles):
    for j,element in enumerate(row):
        if element!=0:
            xs.append(j)
            ys.append(i)
            zs.append(matrix[i,j])

fig=plt.figure()
ax=fig.add_subplot(111,projection='3d')
x,y=np.meshgrid(np.arange(0,len(matrix[0]),1),np.arange(0,len(matrix),1))
#ax.plot_surface(x,y,matrix,cmap=cm.coolwarm,linewidth=0,antialiased=1,alpha=0.5)
ax.scatter(xs,ys,zs,color='k')
fig.show()

saddlelistz=[]
saddlelistx=[]
saddlelisty=[]
for i,row in enumerate(saddles):
    for j,value in enumerate(row):
        if value == 1:
            saddlelistz.append(matrix[i,j])
            saddlelistx.append(j)
            saddlelisty.append(i)

fig2 = plt.figure()
imshow(saddles)
plt.show()
fig3 = plt.figure()
plt.hist(saddlelistz, density=True)
plt.title('Saddle Height Distribution', fontsize=65)
plt.xlabel('Height (z location)', fontsize=55)
plt.ylabel('Density', fontsize=55)
plt.show()

print('Mean: '+str(np.mean(saddlelistz)))
print('Median: '+str(np.median(saddlelistz)))
print('StDev: '+str(np.std(saddlelistz)))
fig4 = plt.figure()
plt.hist(saddlelistx, density=True)
plt.title('Saddle Distribution in the x direction', fontsize=65)
plt.xlabel('x location', fontsize=55)
plt.ylabel('Density', fontsize=55)
plt.show()
fig5 = plt.figure()
plt.title('Saddle Distribution in the y direction', fontsize=65)
plt.xlabel('y location', fontsize=55)
plt.ylabel('Density', fontsize=55)
plt.hist(saddlelisty, bins=11, density=True)
plt.show()

#plt.rc('xtick',labelsize=25)
#plt.rc('ytick',labelsize=25)


np.savetxt('C:/Users/Rylei/MATLAB/Projects/GitLevelSetModel/Surfaces/realdataScaledSaddles.csv',saddles,delimiter=',')