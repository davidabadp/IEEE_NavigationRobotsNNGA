import pandas as pd
from matplotlib import pyplot as plt

df = pd.read_csv("ROBOTS_OUT.txt", sep=',')

plt.plot(df["num_obs"])
plt.semilogy()
plt.show()
