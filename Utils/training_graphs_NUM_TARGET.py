import pandas as pd
from matplotlib import pyplot as plt

df = pd.read_csv("ROBOTS_IN.txt", sep=',')

plt.plot(df["num_target"])
plt.semilogy()
plt.show()
