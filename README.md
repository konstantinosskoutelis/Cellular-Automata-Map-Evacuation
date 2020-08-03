# Room Evacuation Simulation with Cellular Automata in SystemVerilog

## Prelude

The following project was part of a university assignment, taken a step further and improving some crucial aspects of our project, mostly regarding visualization and preprocessing. <br> The team consisted of 2 members :

- [Aslanidis Antonis](https://github.com/konstantinosskoutelis)
- [Konstantinos Skoutelis](https://github.com/konstantinosskoutelis)

The assignment could be broken down into 3 parts:

- Preprocessing
- Hardware Simulation
- Visualization <br>

Functionality of each one is explained in below.

## FSM

The whole procedure could be explained in short from the shape below. Basically the _circular shapes_ describe the Hardware FSM ( implemented in SystemVerilog) and the _rectangular shapes_ are the Python Notebooks Used for Data Preprocessing & Analysis from left to right, respectively.
![FSM](/media/fsm.png)
Specifically, the first Python Notebook in _Part A_ will create 2 memory files _[mem.sv](MEM_LINK)_ & _[weights.sv](WEIGHTS_LINK)_ , which will be in a ready-to-use memory format for our hardware implementation. After the hardware is simulation is complete, we export our grid values in relation to the simulation time, and use it as our input, for our Data Analysis notebook, which will convert the values to a sequence of frames and finally export it in a _.gif_ format, basically visualizing our evacuation algorithm.

## Part A - Data Preprocessing

**Input** : _map.png_ <br>
**Output** : _[weights.sv](WEIGHTS_LINK)_ & _[mem.sv](MEM_LINK)_ <br>
In this part we will convert a png top view of our map, in 2 SystemVerilog memory files. <br>

**Map Format** : <br> ![map](/media/map64.png) <br>

- **Red Color** : Person
- **Green Color** : Exit
- **Blue Color** : Wall
- **Black Color** : Free Space<br>

The files we create based on the above picture, specified by the above mentioned rules, are:

- **[mem.sv](MEM_LINK)** : responsible for providing a represantation of the map in a 3 FF / 3bit state for each pixel, based on their absolute RGB values. So for example, for a red block we will have (R,G,B) = (255,0,0) and convert it into a 3'b1000 for a pixel in a hardware memory format.
- **[weights.sv](WEIGHTS_LINK)** : the file will hold the value of the Manhattan Distance of the closest exit to each pixel, unless the pixel is that of a wall object, in which case it will replace it with an absurdly large value.

> It is worth noting that the files output are scalable and does not depend on the size of our grid dimensions, as well as the sum of our project was made to be as parameterized as possible for more flexibilty.

## Part B - Hardware Implementation

As described above, having our files ready we proceed to simulate in hardware the algorithm as shown in the FSM. In short, for a grid with dimensions **x,y**:<br>

- load the FFs values from memory, of our grid and weights files in x\*y clock cycles
- scan each pixel's value. If it is a person we look at each of its neighbors and move it combinationally if possible, according to the FSM, based on the John von Neumann CA
- repeat until completion or manual stop

In Modelsim we ould see the grid's FFs changing states and people getting closer to exits, as well as people stepping on an exit and thus being removed from our grid.
<br> <br>
**Problems**:

- _people congestion_ : solved by setting neighboring blocks with people to absurdly large value - not taken in consideration
- _wall in front of exits_ : not solved yet, needs an alternative route for a person, not only based on the heuristic of our Manhattan Distance weights

## Part C - Data Visualization

After we have completed our simulation we export our field variable representing our grid in relation to time of our simulation. The file format has a line for each timestamp, which holds all values of our FFs for each pixel, so it will hold **x\*y** 3bit values for each time step, or each frame, when constructed in a reverse way from Part A.<br>
**TIPS**:<br>

- There is an option to save the frames in a specific _frames folder_ for larger maps, or hold in memory for the execution of the program.
- There is an option to upscale images to 512\*512 pixels for the gif creation for better visualization

After executing that for 4 different scenarios we got the following results (see _media folder_ for more details):

- [Scenario 1](https://imgur.com/oG1QNxA)
- [Scenario 2](https://imgur.com/JcitY1Q)
- [Scenario 3](https://imgur.com/AXe9ZsR)
- [Scenario 4](https://imgur.com/b3txL9t)
