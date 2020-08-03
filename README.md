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
Specifically, the first Python Notebook in _Part A_ will create 2 memory files _mem.sv_ & _weights.sv_ , which will be in a ready-to-use memory format for our hardware implementation. After the hardware is simulation is complete, we export our grid values in relation to the simulation time, and use it as our input, for our Data Analysis notebook, which will convert the values to a sequence of frames and finally export it in a _.gif _ format, basically visualizing our evacuation algorithm.

## Part A - Data Preprocessing

## Part B - Hardware Implementation

## Part C - Data Visualization
