function main_main(port, object)
    % Main function to connect to VREP and run grasping scripts
    % port a five number in range <19995 - 20000> that corresponds to the
    % port of the vrep instance you want to attach to 
    
    
    config_local
    
    % config_local.m for collecting data

%     data_directory =  '/home/miaslab/GIT/grasp_db/home/ashley/G3DB/data/'; 
%     project_root = '/home/miaslab/GIT/'; 
%     projectDir = [project_root 'grasp_db'];
%     template = '/home/miaslab/GIT/grasp_db/src/scenes/Complex/g3db_scene.ttt';
%     objectMassCsv = '/home/miaslab/GIT/grasp_db/objects/grasp_meshes/final_ycb_objects/mesh_weights_kgs.csv';
%     javaaddpath([project_root 'grasp_db/src/matlab_linux/matlab_linux_src/ray/ray.jar'])
%     javaaddpath('/media/miaslab/586a0f6c-8cc4-4650-8761-717927901747/home/ashley/GIT/grasp_db/src/matlab/matlab/ray/ray.jar')
%     object_folder = '/home/miaslab/GIT/grasp_db/objects/grasp_meshes/final_ycb_objects/';
%     morphedMeshDir =  '/home/miaslab/GIT/grasp_db/G3DB/data'; %'E:/GIT/grasp_db/objects/morphed_meshes';
%     setOfObjectsFolder = '/home/miaslab/GIT/grasp_db/objects/grasp_meshes/final_ycb_objects/';
% 
%     % set to 1 if you want meshes to be morphed
%     morph = 1; 
%     num_grasps_per_object = 1000;
%     repeat_grasp = 10;
%     number_objects = 10;


    addpath(genpath([project_root 'grasp_db/src/matlab_linux/matlab_linux_src']))
    addpath(genpath([project_root 'grasp_db/src/matlab_linux/matlab_linux_src/ray'])) % use genpath to add all subfolders
    javaaddpath([project_root 'grasp_db/src/matlab_linux/matlab_linux_src/ray/ray.jar'])
    

  
    startup_robot

    %% start up server     
    vrep = remApi('remoteApi');
    vrep.simxFinish(-1);
    id = vrep.simxStart('127.0.0.1', port, true, true, 2000, 5);
    
    persistent init_positions; 
      
    if id > -1,   
        hand_obj = read_wobj([projectDir '/objects/bhand.obj']);
        % turn on synchronous mode
        vrep.simxSynchronous(id, true);
        
    % for each object in obj folder run 10 times with the first being unmorphed

        for q = 1:length(dir([setOfObjectsFolder, '*.obj']))
        % pick a random object give it an index
            obj_index = object; 
        
            for i = 1:number_objects 

                disp('Getting random object ...');
                [dataFile, mass, COM, matrix, object_name, meshpath, ~] = getRandomObjectYCB(morphedMeshDir, setOfObjectsFolder, morph, objectMassCsv, i, obj_index); 
                % import and position object into vrep
                disp('Importing object ...');
                object_name
                meshpath
                import_mesh(vrep, id, template, mass, COM, matrix, object_name, meshpath);
                vrep.simxSynchronousTrigger(id);

                % main grasp loop 
                j = 1; 
                while j <= num_grasps_per_object
                    date = datestr(clock, 'dd-mmm-yyyy-HH-MM-SS');
                    for q = 1:num_grasps_per_object/5
                        number_of_object = i;
                        number_of_grasp = j;
                        fprintf('Number of object: %d, Number of grasp %d ...\n', number_of_object, number_of_grasp);  
                        % perform grasp
                        [data(q), init_positions] =  grasp_repeat(vrep, id, j, object_name, project_root, dataFile, meshpath, init_positions, hand_obj);
                        disp('Saving to db ...');   
                        save([dataFile '/' object_name '-' date '.mat'], 'data');

                        j = j + 1;
                    end   
                        clear data  

                end

                res = vrep.simxStopSimulation(id, vrep.simx_opmode_oneshot);
                vrep.simxSynchronousTrigger(id);
                vrchk(vrep, res, true);

            end
        end
        disp('Failed connecting to remote API server. Exiting.');
    end
         
    % Make sure we close the connexion whenever the script is interrupted.
    cleanupObj = onCleanup(@() cleanup_vrep(vrep, id));
    vrep.simxSynchronousTrigger(id);
end
    
   
    
           

    
   
    
    
