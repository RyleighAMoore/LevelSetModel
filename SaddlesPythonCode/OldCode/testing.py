import random as rand
import numpy as np
endStates = []
countSteps = []
a = rand.uniform(0, 1)
for i in range(10000):
    state = 1
    steps = 0
    while (state != 0) & (state != 4):
        steps +=1
        a = rand.uniform(0, 1)
        if state == 1:
            if a< 0.5:
                state = 0
            else: state = 2
        elif state == 2:
            if a< 0.5:
                state = 1
            else: state = 3
        elif state == 3:
            if a< 0.5:
                state = 2
            else: state = 4
    endStates.append(state)
    countSteps.append(steps)
    t=0
r=0
average = np.average(countSteps)
zerosAvg = endStates.count(0)/10000
foursAvg = endStates.count(4)/10000
print(average)
print(zerosAvg)
print(foursAvg)


