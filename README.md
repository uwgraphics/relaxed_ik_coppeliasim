# Relaxed IK Coppeliasim

This repo is a Relaxed IK plugin for CoppeliaSim. Although it’s possible to access the ROS1 wrapper of Relaxed IK in CoppeliaSim through ROS topics and params, it might be more convenient to directly access Relaxed IK in the form of a CoppeliaSim Pluggin. That’s where the inspiration of this wrapper comes from.

## Relaxed IK Wrappers

More information about Relaxed IK, Collision IK, and all the wrappers could be found in this [documentation](https://uwgraphics.github.io/relaxed_ik_core/).

- [Relaxed IK (Deprecated)](https://github.com/uwgraphics/relaxed_ik/tree/dev)
- [Relaxed IK ROS1](https://github.com/uwgraphics/relaxed_ik_ros1)
- [Relaxed IK Unity](https://github.com/uwgraphics/relaxed_ik_unity)
- [Relaxed IK CoppeliaSim](https://github.com/uwgraphics/relaxed_ik_coppeliasim)
- [Relaxed IK Mujoco](https://github.com/uwgraphics/relaxed_ik_mujoco)

||**Relaxed IK (Deprecated)**|**Relaxed IK ROS1**|**Relaxed IK Unity**|**Relaxed IK Coppeliasim**|**Relaxed IK Mujoco**|  
|:------|:-----|:-----|:-----|:-----|:-----| 
|**Relaxed IK**|:o:|:o:|:o:|:o:|:o:|  
|**Collision IK**|:x:|:o:|:x:|:x:|:x:|  

## Dependencies

### Rust Dependencies (Not optional)
To use this wrapper, you will first need to install Rust. Please go to https://www.rust-lang.org/learn/get-started for more infomation.

### CMake Dependencies
The version of cmake should be 3.16.3 or higher.

### Lua Dependencies
- luafilesystem -> available here: https://keplerproject.github.io/luafilesystem/

## Getting Started

1. Make sure that you have installed all the dependencies.
1. Clone this repo to the installation folder of CoppeliaSim.
1. Initialize relaxed_ik_core (the Rust library of Relaxed IK) as a submodule by running the following command from the root directory of this repo:
    ```bash
    git submodule update --init
    ```
1. Navigate to the *relaxed_ik_core* folder and go through the steps below to get relaxed_ik_core ready.
    1. If your robot is in this list: [baxter, hubo, iiwa7, jaco7, panda, sawyer, ur5, yumi], ignore this step. Else, you will need to clone [this repo](https://github.com/uwgraphics/relaxed_ik) and follow the step-by-step guide [there](https://github.com/uwgraphics/relaxed_ik/blob/dev/src/start_here.py) to get the required robot config files into corresponding folders in the *config* folder in the core. To specify, there should be (replace "sawyer" with your robot name or your urdf name in some cases):
        - 1 self-collision file <collision_sawyer.yaml> in the *collision_files* folder
        - 4 Rust neural network files <sawyer_nn, sawyer_nn.yaml, sawyer_nn_jointpoint, sawyer_nn_jointpoint.yaml> in the *collision_nn_rust* folder
        - 1 info file <sawyer_info.yaml> in the *info_files* folder
        - 1 joint state function file <sawyer_joint_state_define> in the *joint_state_define_functions* folder
        - 1 urdf file <sawyer.urdf> in the *urdfs* folder.
    1. Look at <settings.yaml> in the *config* folder and follow the information there to customize the parameters.
    1. Compile the core:
        ```bash
        cargo build
        ```
1. Complie the CoppeliaSim plugin of Relaxed IK with cmake (3.16.3 or higher required) by running the following commands from the root directory of this repo. Please check the version of your cmake and update it if necessary before compiling the plugin:
    ```bash
    cd ./simExtRelaxedIK
    cmake .
    cmake --build .
    ```
1. Launch CoppeliaSim and include the code in <example.lua> to the threaded child script of your robot arm.
1. As the only callable function in this Relaxed IK plugin, the following function call takes in a position goal (pos: a table of doubles) and a rotation goal (quat: a table of doubles) and returns a joint angle solution (xopt: also a table of doubles). Usually you want to put it in a loop in order to update the joint angles consistently based on the latest Cartesian-space pose goals.
    ```lua
    xopt = simRelaxedIK.solveIK(pos, quat)
    ```
1. Start the simulation in CoppeliaSim!
