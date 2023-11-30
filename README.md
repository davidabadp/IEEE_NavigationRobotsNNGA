# IEEE_NavigationRobotsNNGA
![image](https://github.com/davidabadp/IEEE_NavigationRobotsNNGA/assets/47812104/a280fd88-e0f7-4bb3-9559-d9e8d83386c5)

Resources and extra documentation for the manuscript "Navigation of mobile robots using neural networks and genetic algorithms" published in IEEE Latin America Transactions. The repository is organized in several folders:
- Top: Contains the classes to execute a robotic navigation program and is responsible for carrying out the learning phase of the robots. In addition, it saves the results of the simulations and the weights of the neural network of the best robot in each simulation.
- Top_Working: It also contains the classes to run a robotic navigation program but its function is to reproduce a previously saved robot through the weights of its neural network.
- Utils: Contains a Python program to make graphs of the data saved in the simulations. This data must be saved in the Data folders.
- src: Contains the classes in library format of neural networks and genetic algorithms.
- Project_Images: Contains the most relevant images of the project and the graphic summary of the article. 

# Instructions for running the program
First of all, you must download the Processing program. Next, you must you must download the library that contains the code for the neural networks and genetic algorithms . To do this, the following steps must be followed.

# Build and Install the library
Compile the .java class files: Go to the src/NeuralNetwork folder and run the following command (for windows):

  javac -cp "/path/to/core.jar" -d . *.java
  
Where "/path/to/core.jar" is the location of the core.jar file. 
For example "C:\Program Files\processing-4.0b6\core\library\core.jar".



After that a folder named "NeuralNetwork" with the compiled classes shuld have been created. To create the compress .jar file of the folder run the command:

  jar -cf NeuralNetwork.jar NeuralNetwork
  
Place the .jar file in a folder named "library" inside another one named "NeuralNetwork".

  NeuralNetwork/library/NeuralNetwork.jar
For the last step move the folder to the libraries folder of processing located probably in your documents folder.

  "Path\to\User\Documents\Processing\libraries"
To import the library put import GeneticAlgorithm.*; on top of your sketch.

# Last steps
Finally, you just have to run Top/Top.pde and you will observe the robots' learning stage. At the end of the program, the statistics and neural network weights of the best robot from each of the repetitions will be saved in a folder called Top/Data.

If you wanted to reproduce the simulation of a specific robot, you would simply have to copy the file containing the neural network weights of said robot to the Top_Working/Data folder, run Top_Working/Top_Workind.pde and watch the show.
