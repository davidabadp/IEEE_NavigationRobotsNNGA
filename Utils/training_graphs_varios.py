import pandas as pd
from matplotlib import pyplot as plt
import os

folder_path = r"C:\Users\david\OneDrive\Documentos\GitHub\NAVEGACION_DAVID_TFG\Utils\Data"
archivos = os.listdir(folder_path)
folder_path2 = r"C:\Users\david\OneDrive\Documentos\GitHub\NAVEGACION_DAVID_TFG\Utils\Data2"
archivos2 = os.listdir(folder_path2)
folder_path3 = r"C:\Users\david\OneDrive\Documentos\GitHub\NAVEGACION_DAVID_TFG\Utils\Data3"
archivos3 = os.listdir(folder_path3)
folder_path4 = r"C:\Users\david\OneDrive\Documentos\GitHub\NAVEGACION_DAVID_TFG\Utils\Data4"
archivos4 = os.listdir(folder_path4)

# Lectura de archivos y agrupacion en lista de dataframes
df_list = []
for archivo in archivos:
    #file = folder_path + '/' + archivo
    file = os.path.join(folder_path, archivo)
    df_list.append(pd.read_csv(file, sep=','))

df_list2 = []
for archivo in archivos2:
    #file = folder_path + '/' + archivo
    file = os.path.join(folder_path2, archivo)
    df_list2.append(pd.read_csv(file, sep=','))

df_list3 = []
for archivo in archivos3:
    #file = folder_path + '/' + archivo
    file = os.path.join(folder_path3, archivo)
    df_list3.append(pd.read_csv(file, sep=','))

df_list4 = []
for archivo in archivos4:
    #file = folder_path + '/' + archivo
    file = os.path.join(folder_path4, archivo)
    df_list4.append(pd.read_csv(file, sep=','))

# Generacion de 1 dataframe con los valores de los diferentes experimentos
# cols: exp_1 | exp_2 | exp_3 | exp_4 ...

def show_result (column_name):
    df_num_target = df_list[0][[column_name]]
    df_num_target2 = df_list2[0][[column_name]]
    df_num_target3 = df_list3[0][[column_name]]
    df_num_target4 = df_list4[0][[column_name]]

    n_df = len(df_list)
    n_df2 = len(df_list2)
    n_df3 = len(df_list3)
    n_df4 = len(df_list4)
    for index in range(1,n_df):
        df_num_target = pd.concat([df_num_target,df_list[index][column_name]], 1)

    for index in range(1,n_df2):
        df_num_target2 = pd.concat([df_num_target2,df_list2[index][column_name]], 1)

    for index in range(1,n_df3):
        df_num_target3= pd.concat([df_num_target3,df_list3[index][column_name]], 1)

    for index in range(1,n_df4):
        df_num_target4= pd.concat([df_num_target4,df_list4[index][column_name]], 1)

    df_num_target["mean"] = df_num_target.mean(axis = 1)
    df_num_target2["mean"] = df_num_target2.mean(axis = 1) 
    df_num_target3["mean"] = df_num_target3.mean(axis = 1)
    df_num_target4["mean"] = df_num_target4.mean(axis = 1)

    ejeX = df_list[0]["Generation"]
    ejeX2 = df_list2[0]["Generation"]
    ejeX3 = df_list3[0]["Generation"]
    ejeX4 = df_list4[0]["Generation"]

    plt.plot(ejeX, df_num_target["mean"], label= column_name + ' 100 loss adicional')
    plt.plot(ejeX2, df_num_target2["mean"], label= column_name + ' 500 loss adicional')
    plt.plot(ejeX3, df_num_target3["mean"], label= column_name + ' 1.000 loss adicional')
    plt.plot(ejeX4, df_num_target4["mean"], label= column_name + ' 2.000 loss adicional')
    plt.xlabel("Número de generaciones")
    plt.ylabel("Número de robots")

    plt.title("Nº de robots que alcanzan la meta")
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
