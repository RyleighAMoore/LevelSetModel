# -*- coding: utf-8 -*-
"""
Created on Wed Jan 23 14:02:35 2019

@author: Jacob
"""

import pandas as pd
import numpy as np
from mpl_toolkits.mplot3d import Axes3D
import matplotlib.pyplot as plt
from matplotlib import cm
from matplotlib.ticker import LinearLocator, FormatStrFormatter
import csv


def find_saddleNN(matrix):
    saddles = np.zeros(matrix.shape, dtype=np.int8)
    for i, row in enumerate(matrix):
        for j, element in enumerate(row):
            if i * j > 0 and i < matrix.shape[0] - 1 and j < matrix.shape[1] - 1:
                mini = matrix[i - 1:i + 2, j - 1:j + 2]
                if mini[1, 1] == max(mini[1]) and mini[1, 1] == min(mini[:, 1]):
                    saddles[i, j] = 1
                elif mini[1, 1] == min(mini[1]) and mini[1, 1] == max(mini[:, 1]):
                    saddles[i, j] = 1
    return saddles


def find_saddleNNN(matrix):
    saddles = np.zeros(matrix.shape, dtype=np.int8)
    for i, row in enumerate(matrix):
        for j, element in enumerate(row):
            if i * j > 0 and i < matrix.shape[0] - 1 and j < matrix.shape[1] - 1:
                mini = matrix[i - 1:i + 2, j - 1:j + 2]
                pos = [np.mean((mini[0, 1], mini[1, 0])), mini[1, 1], np.mean((mini[1, 2], mini[2, 1]))]
                neg = [np.mean((mini[0, 1], mini[1, 2])), mini[1, 1], np.mean((mini[1, 0], mini[2, 1]))]
                if mini[1, 1] == max(pos) and mini[1, 1] == min(neg):
                    saddles[i, j] = 1
                elif mini[1, 1] == min(pos) and mini[1, 1] == max(neg):
                    saddles[i, j] = 2
    return saddles


matrix = pd.read_csv('C:/Users/Rylei/MATLAB/Projects/GitLevelSetModel/ry.csv', header=None).values
saddlesNN = find_saddleNN(matrix)
# saddlesNN is a matrix with 1's in the positions that are saddle points


# Plotting points
xs, ys, zs = [], [], []
for i, row in enumerate(saddlesNN):
    for j, element in enumerate(row):
        if element != 0:
            xs.append(j)
            ys.append(i)
            zs.append(matrix[i, j])

fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')
x, y = np.meshgrid(np.arange(0, len(matrix[0]), 1), np.arange(0, len(matrix), 1))
#ax.plot_surface(x, y, matrix, cmap=cm.coolwarm, linewidth=0, antialiased=1, alpha=0.5)
#ax.scatter(xs, ys, zs, color='k')
fig.show()
np.savetxt("C:/Users/Rylei/MATLAB/Projects/GitLevelSetModel/rysadNNN.csv", saddlesNN, delimiter=",")



