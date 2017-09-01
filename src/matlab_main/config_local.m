% config_local.m for collecting data

data_directory =  '/home/ashley/GIT/grasp_db/home/ashley/G3DB/data/'; 
project_root = '/home/ashley/GIT/'; 
projectDir = [project_root 'grasp_db'];
template = '/home/ashley/GIT/grasp_db/src/scenes/Complex/g3db_scene.ttt';
objectMassCsv = '/home/ashley/GIT/grasp_db/objects/grasp_meshes/final_ycb_objects/mesh_weights_kgs.csv';
javaaddpath([project_root 'grasp_db/src/matlab_main/matlab_main/ray/ray.jar'])
javaaddpath('/home/ashley/GIT/grasp_db/src/matlab_main/matlab_main/ray/ray.jar')
object_folder = '/home/ashley/GIT/grasp_db/objects/grasp_meshes/';
morphedMeshDir =  '/home/ashley/GIT/grasp_db/G3DB/data'; %'E:/GIT/grasp_db/objects/morphed_meshes';
setOfObjectsFolder = [object_folder 'final_ycb_objects/totalYCB16k/'];

addpath(genpath([project_root 'grasp_db/src/matlab_main/matlab_main']))
addpath(genpath([project_root 'grasp_db/src/matlab_main/matlab_main/ray'])) % use genpath to add all subfolders

% set to 1 if you want meshes to be morphed
morph = 1; 
num_grasps_per_object = 1000;
repeat_grasp = 10;
% number of objects per class
number_objects = 10;