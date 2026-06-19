# Trajectory Optimisation With Key-points (TrajOptKP)
The project website can be found [here](https://TrajOptKP.github.io).
This package showcases an efficient method to perform gradient-based trajectory optimisation by reducing 
the number of expensive finite-differencing computations required to perform optimisation. The basic
methodology is computing [Key-points](#Key-points) over a trajectory where expensive finite-differencing computations
are performed, the remainder of the dynamics derivatives needed for trajectory optimisation are then
approximated via linear interpolation.

This package includes a set of example tasks that can be solved via trajectory optimisation, including 
non-prehensile manipulation and locomotion. This package is implemented in C++, and uses MuJoCo as the
physics simulator.

Please note that this code is still under active development.

## Dependencies
### [MuJoCo 2.32](http://www.mujoco.org/) or newer
This repository uses a custom fork of MuJoCo (simply for the access to one private function - please 
see this [issue](https://github.com/google-deepmind/mujoco/issues/1453)).

As such you need to git clone a custom fork and then build from source.

```
git clone git@github.com:DMackRus/mujoco.git mujoco_temp
cd mujoco_temp
mkdir build
cd build
cmake ..
cmake --build .
cmake .. -DCMAKE_INSTALL_PREFIX="~/mujoco"
cmake --install .
echo export MJ_HOME='"'$(pwd)/mujoco'"' >> ~/.bashrc
```

These commands also set an environment variable "MJ_HOME" for CMake, if you are installing
MuJoCo differently, remember to set this variable.

### [Eigen 3](https://eigen.tuxfamily.org/index.php?title=Main_Page)
Eigen is used for matrix computations in trajectory optimisation. Download and install it
with the following command:

``` 
sudo apt install -y libeigen3-dev
```

### [YAML](https://github.com/jbeder/yaml-cpp)
This repository uses YAML for configuration files. Install YAML with the following command.
```
sudo apt install -y libyaml-cpp-dev
```

### [GLFW](https://www.glfw.org/)
GLFW is used for visualisation. Download with the following command.
```
sudo apt install -y libglfw3 libglfw3-dev
```

## Container
If you have singularity installed, you can use this 
[singularity container](https://github.com/DMackRus/Apptainer_TrajOptKP) which has all the dependancies 
installation and setup.

## Installation

1. Clone this repository (Please note that this repository uses submodules, 
so you need to clone recursively).
```

[//]: # (git clone --recursive https://github.com/DMackRus/TrajOptKP.git)
Anon
```  
2. Set the following environment variables.
```
export MJ_HOME=$HOME/*path to the home directory of MuJoCo*
(NOTE: "~/" does not work)
```
3. Build the package.
```
cd TrajOptKP
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release ..
make
```

## Usage
### Setup
There are two config yaml files that the user can change to run different examples. The first config 
is called **generalConfig.yaml**. This file determines various high level settings (such as Optimiser, task, etc.)
which are explained in the configuration file.

The second config file is specific to the task being loaded, all task config files are located in **taskConfigs** folder. 
There are some high level settings, as follows:
- **modelFile**: Relative path to the model xml file
- **model_name**: Name of the model, used for saving data
- **timeStep**: Time step for simulation
- **keypoint_method**: Key-point method to use in optimisation. See below for more details.
- **min_N**: Minimum interval between key-points
- **max_N**: Maximum interval between key-points
- **iterative_error_threshold**: Error threshold for iterative error method

As well as these high level settings, there is the task description. Every task is specified by a collection of **robots** amd **rigid_bodies**.
**Robots** are actuated whereas **rigid_bodies** are not. This list of robots and rigid_bodies instantiates the trajectory 
optimisation problem, by defining starting and desired states, as well as cost attributes. Finally, there are also settings
for each DoF that relate to key-point methods, Please see the [Key-points](#Key-points) section for additional details.

### Run the code
To run the code, there is a bash script that handles compilation and execution.
The bash script takes one argument which is the name of the task configSimply run the
following command:
```
bash run.bash <task_name>
```

There are four example task configuration files provided in the **generalConfigs** 
folder. These are:
- **boxSweep.yaml**: Sweeping a large heavy box to a target location.
- **pushNoClutter.yaml**: Pushing a small light cylinder to a goal location with no clutter.
- **PandaMove.yaml**: Moving a Panda robot to a goal location smoothly.
- **walkerMPC.yaml**: Locomotion of a 9 DoF walker model using MPC.

## Examples
Here are some example trajectories that have been generated using this package.

**Manipulation**

Here are 4 example of contact-based manipulation in this repository. The examples are: Sweeping
a large heavy box to a target location, and three examples of pushing a small light cylinder to 
a goal location through varying levels of clutter.

<p align="middle">
   <img src="media/box-sweep.gif" width="300"/>
   <img src="media/push_no_clutter.gif" width="300"/>
   <img src="media/push_low_clutter.gif" width="300"/>
   <img src="media/push_moderate_clutter.gif" width="300"/>
</p>

**Locomotion**

A locomotion example of the 9 DoF walker model. Goal is to keep moving forward whilst keeping the 
body upright at a specific height.

<p align="middle">
<img src="media/walker.gif" width="300"/>
</p>

**Dynamic motion**
Coming soon.

## Key-points
Computation of dynamics gradients via finite-differencing is computationally expensive and 
is generally the bottleneck of gradient-based trajectory optimisation. We propose only 
performing these finite-differencing computations at "key-points" over the trajectory, and
approximating the remainder of the dynamics gradients via linear interpolation. If these
key-points are chosen intelligently, we can compute an approximated set of derivatives significantly
faster without noticeable degradation on the performance of the final optimal trajectory.

[//]: # (![]&#40;media/derivative_interpolation.png&#41;)

[//]: # ()
[//]: # (There are four key-point methods implemented in this repository. Code for these key-point methods)

[//]: # (can be found in [Optimiser.cpp]&#40;https://github.com/DMackRus/TrajOptKP/tree/main/src/Optimiser&#41;.)

[//]: # ()
[//]: # (### Set Interval)

[//]: # (The Set-interval method has one parameter &#40;min_N&#41;)

[//]: # ()
[//]: # (The Set-interval method is the simplest.The key-points are equally spaces with an interval of min_N inbetween them.)

## To-Do
- [ ] Bug test dimensionality reduction stateIndex to qpos index code?? This is possibly the bug from iLQR-SVR work.
- [ ] Add kinematic tree info to state vector struct
- [ ] Write unit tests for new keypoint methods using contact and kinematic chains
- [ ] Write unit tests for kinematic chain creation
- [ ] Make a sharp bitys section to ReadMe, talk about issues in this project. One issue is certain joint types might not be supported (ball joints).
- [ ] change GIFS to show baseline vs key-point trajectories and show optimisation time.
- [ ] Improve README readability.
- [ ] Add more examples
- [ ] starting camera variables in model file
- [ ] improved parallelisation on iterative error method

## Citing
When the work is published, I will add the citation here!

