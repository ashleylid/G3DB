## The G3DB database

This is the main repository for generation of the G3DB (Grasping 3D database)

***
*still under construction, but if you ignore all the scripts and focus on what is listed here it has been shown to work out of the box. (please ask if you have any questions)*
***

__Prerequisites__

1. Clone/download this repository.
2. MatLab, I use 2013 and haven't found any compatibility issues with later versions.
3. V-REP, The latest version of pro edu should be downloaded from http://www.coppeliarobotics.com/downloads.html. Make sure you have moved across your linker and library files to the main matlab folder (*grasp_db/src/matlab_main*). I.e. make sure you can run V-REP with MatLab as expected.

__Folders__

- *grasp_db/src*: all source related to project.
- *grasp_db/objects* Where all the mesh files and related files are stored. All objects that are imported are manifold and watertight.
- *grasp_bd/objects/grasp_meshes/final_ycb_objects/totalYCB16k* are all the YCB meshes used in the database.
- *grasp_db/data/data* Where all the data is stored while recording.
- *grasp_db/src/matlab_main*: All src for running MatLab with V-REP. config_local.m should be the only file you need to modify. Unless you want to work with different objects. [This is where you put your remote API files for your local V-REP instance, copy over the ones held in the folder.
- *grasp_db/src/matlab_main/matlab_main* All supporting files.

__Files of interest__

*grasp_db/src/scenes/Complex/g3db_scene.ttt*: This is the scene that loads with every grasp. It is the main scene run with the database for recordings.
*grasp_db/objects/bhand.obj*: Object file of the Barrett hand.

__To Run__

1) Run V-REP by going into the main V-REP folder, wherever its stored and run it in terminal with: `$ ./vrep.sh -h -gREMOTEAPISERVERSERVICE_19997_FALSE_TRUE` for headless mode and `$ ./vrep.sh -gREMOTEAPISERVERSERVICE_19997_FALSE_TRUE` otherwise. Note this is where you change the port number for running multiple instances. (Note: I have found that running more than one instance causes issues with OpenGL calls so I run one at a time.) 

2) Run Matlab and point to main directory: 
grasp\_db/src/matlab\_main (The V-REP linker files are on this git directory so you shouldn't have to copy them anymore, unless you change your V-REP version, which should not be an issue).

3) Right click and add folders and sub folders of the file inside matlab_main:  /matlab_main (this should happen in the config file but it just doesn't and then the java scripts won't work properly).

4) In the main matlab folder (matlab\_main) Run Matlab main script with: `> main_main(port_number, object_index )` e.g. `main_main(19997, 17)` will run the mug. 

The first run of every object will record an unmorphed version of the object after then every object will be morphed. 

## Usage
The code is available under the Apache 2.0 license. If you use this code in a publication, please cite:


A. Kleinhans, D. Sabatta, M. Michalik, B. Rosman, R. Detry and B. Tripp. G3DB: _A Database of Simulated Robot Grasps with Images, Morphed Mesh Models and Robotic Hand Parameters_. Under review

 

