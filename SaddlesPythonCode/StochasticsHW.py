import random as rand
import numpy as np
import matplotlib.pyplot as plt

t = 4*np.pi
n = int(np.round(t - np.cos(t) + 1))


def CDF(s):
    return (s - np.cos(s) + 1) / (1 + t - np.cos(t))

val=10000
s = np.linspace(0, t, val)
cdf = CDF(s)
invcdf = []

for k in s:
    f = (cdf <= k)
    r = (t/val)*np.sum(f)
    invcdf.append(r)

jumps = [0]
for i in range(n):
    U = np.random.uniform(0.0,t)
    r = np.sum((np.asarray(invcdf) < U))
    value = invcdf[r-1]
    jumps.append(value)

jumps = np.sort(jumps)
ones = range(len(jumps))
plt.figure()
plt.step(jumps,ones)
plt.show()

plt.figure()
plt.plot(s, np.asarray(invcdf))
plt.plot(s, np.asarray(cdf))
plt.plot(s, s)
plt.show()
