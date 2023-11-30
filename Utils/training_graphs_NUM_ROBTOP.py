import pandas as pd
from matplotlib import pyplot as plt

df = pd.read_csv("ROBOTS_TOP.txt", sep=',')

plt.plot(df["porcentaje_robots_top"])
plt.semilogy()
plt.show()
