# relaxed_ik_coppeliasim
Here is the project page that has more information about RelaxedIK that you may want to know about: https://uwgraphics.github.io/relaxed_ik_core/

This is a CoppeliaSim plugin for RelaxedIK. Although it's possible to use RelaxedIK in CoppeliaSim via ROS and the ROS wrapper of RelaxedIK at [relaxed_ik_ros](https://github.com/uwgraphics/relaxed_ik_ros1), it might be more convenient to directly access the RelaxedIK library in the form of a CoppeliaSim Pluggin. That's why we developed this wrapper.

## Dependencies

Note that this wrapper is developed in CoppeliaSim Edu V4.1.0 and Ubuntu 18.04. 

### Rust Dependencies (Not optional)
To use this wrapper, you will first need to install Rust. https://www.rust-lang.org/learn/get-started

### CMake Dependencies
The version of cmake should be 3.16.3 or higher

### Lua Dependencies
luafilesystem: 
+ Available here: https://keplerproject.github.io/luafilesystem/

## Run
1. Install all the dependencies.
1. Clone this repo to the installation folder of CoppeliaSim.
    ```
    cd [The installation folder of CoppeliaSim]
    git clone git@github.com:uwgraphics/relaxed_ik_coppeliasim.git
    ```
1. Get the submodule relaxed_ik_core (the core part of relaxed IK written in Rust) and compile it by running the following commands from the directory of this repo:
    ```
    git submodule update --init
    cd ./relaxed_ik_core
    cargo build
    ```
1. Complie the CoppeliaSim plugin of Relaxed IK with cmake (3.16.3 or higher required) by running the following commands from the directory of this repo. Please check the version of your cmake and update it if necessary before compiling the plugin.
    ```
    cd ./simExtRelaxedIK
    cmake .
    cmake --build .
    ```
1. Go to relaxed_ik_coppeliasim/relaxed_ik_core/config/loaded_robot and configure the name of the pre-computed robot arm you would like to run (available options are baxter, hubo, iiwa7, jaco7, panda, sawyer, ur5 and yumi).
1. Launch CoppeliaSim and include the code in relaxed_ik_coppeliasim/childScriptExample.lua in the threaded child script of your robot arm. 
1. As the only callable function in this RelaxedIK plugin, the following function call takes in a position goal (pos: a table of doubles) and a rotation goal (quat: a table of doubles) and returns a joint angle solution (xopt: also a table of doubles). Usually you want to put it in a loop in order to update the joint angles consistently.
    ```lua
    xopt = simRelaxedIK.solve(pos, quat)
    ```
1. Start the simulation in CoppeliaSim!
