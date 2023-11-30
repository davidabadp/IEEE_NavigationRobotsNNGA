import pandas as pd
from matplotlib import pyplot as plt
import os

folder_path = r"C:\Users\david\OneDrive\Documentos\GitHub\NAVEGACION_DAVID_TFG\Utils\Data"
archivos = os.listdir(folder_path)

# Lectura de archivos y agrupacion en lista de dataframes
df_list = []
for archivo in archivos:
    #file = folder_path + '/' + archivo
    file = os.path.join(folder_path, archivo)
    df_list.append(pd.read_csv(file, sep=','))


# Generacion de 1 dataframe con los valores de los diferentes experimentos
# cols: exp_1 | exp_2 | exp_3 | exp_4 ...


def show_result (column_name):
    df_num_target = df_list[0][[column_name]]
    n_df = len(df_list)
    for index in range(1,n_df):
        df_num_target = pd.concat([df_num_target,df_list[index][column_name]], 1)

    df_num_target["mean"] = df_num_target.mean(axis = 1)

    ejeX = df_list[0]["Generation"]

    plt.plot(ejeX, df_num_target["mean"], label='column_name')
    plt.title(column_name)
    plt.legend()
    plt.show()

show_result("num_target")
show_result("num_obs")
show_result("num_robotstop")
show_result("dist2obj_target")
show_result("dist_target")
show_result("ener_target")
show_result("dist2obj_obs")
show_result("dist_obs")
show_result("ener_obs")
show_result("dist2obj_null")
show_result("dist_null")
show_result("ener_null")





############################################################

#df = pd.read_csv("Utils/ROBOTS_0.txt", sep=',')


#plt.plot(df["Generation"], df["num_target"])
#plt.plot(df["Generation"], df["num_obs"])
#plt.plot(df["Generation"], df["porcentaje_robots_top"])

#plt.plot(df["Generation"], df["best_fitness"])
##plt.semilogy()
#plt.show()
