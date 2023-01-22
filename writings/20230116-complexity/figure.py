import matplotlib.pyplot as plt
import numpy as np

plt.rcParams["figure.figsize"] = [7.00, 3.50]
plt.rcParams["figure.autolayout"] = True

def draw_curve(p1, p2):
   a = (p2[1] - p1[1]) / (np.cosh(p2[0]) - np.cosh(p1[0]))
   b = p1[1] - a * np.cosh(p1[0])
   x = np.linspace(p1[0], p2[0], 100)
   y = a * np.cosh(x) + b
   return x, y

p1 = [0, 1]
p2 = [1, 2]
p3 = [2, 1]

x, y = draw_curve(p1, p2)


plt.plot(x, y)

x, y = draw_curve(p2, p3)


plt.plot(x, y)


plt.show()