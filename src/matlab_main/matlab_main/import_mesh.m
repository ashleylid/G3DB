function  import_mesh(vrep, id, template, mass, COM, matrix, name, meshpath)
    % Refresh scene and import new morphed mesh. 
    % 
    % vrep: vrep object created in main
    % id: vrep id for communication created in main
    % template: from config.m
    % mass: from getRandomObject
    % COM: from getRandomObject
    % matrix: from getRandomObject
    % name: from getRandomObject
    name 
    meshpath
       
    scene_name = sprintf(template);

    %load a scene... Takes the following input(connection id,string
    %of scene path,option,operation mode)
    res = vrep.simxLoadScene(id, scene_name, 0, vrep.simx_opmode_blocking);
    vrchk(vrep, res, true); 

    %disp('sending signals to import mesh');
    %signal to send location of mesh
    res=vrep.simxSetStringSignal(id ,'mesh_location', meshpath, vrep.simx_opmode_oneshot_wait); %
    vrchk(vrep, res);
    vrep.simxSynchronousTrigger(id);

    if res == vrep.simx_return_ok
        disp('mesh_location has been sent!');
    else
        error('unable to send location of mesh.');
    end

    %signal to send name of object
    res=vrep.simxSetStringSignal(id,'name_signal', name,vrep.simx_opmode_oneshot_wait); %vrchk(vrep, res, true);
    vrep.simxSynchronousTrigger(id);
    if res==vrep.simx_return_ok
        disp('name_signal has been sent!');
    else
        error('unable to send name of mesh.')
    end
    %Signal to send COM of object
    COM_send=vrep.simxPackFloats(COM);
    vrep.simxSynchronousTrigger(id);
    res=vrep.simxSetStringSignal(id,'COM_signal', COM_send,vrep.simx_opmode_oneshot_wait); %vrchk(vrep, res, true);
    vrep.simxSynchronousTrigger(id);
    if res==vrep.simx_return_ok
        disp('COM_signal has been sent!');
    else
        error('unable to send COM of mesh.')
    end
    %Signal to send mass of object
    res=vrep.simxSetFloatSignal(id,'mass_signal', mass,vrep.simx_opmode_oneshot_wait); %vrchk(vrep, res, true);
    vrep.simxSynchronousTrigger(id);
    if res==vrep.simx_return_ok
        disp('mass_signal has been sent!');
    else
        error('unable to send mass of mesh.')
    end
    %send inertia tensor of the object
    matrix_send=vrep.simxPackFloats(matrix);
    vrep.simxSynchronousTrigger(id);
    res=vrep.simxSetStringSignal(id,'matrix_signal', matrix_send,vrep.simx_opmode_oneshot_wait); %vrchk(vrep, res, true);
    vrep.simxSynchronousTrigger(id);
    if res==vrep.simx_return_ok
        disp('matrix_signal has been sent!');
    else
        error('unable to send inertia of mesh.')
    end
    %Send a signal to move the mesh
    obj2move='string_of_object_to_move';
    res=vrep.simxSetStringSignal(id,'move_signal', obj2move,vrep.simx_opmode_blocking); %vrchk(vrep, res, true);
    vrep.simxSynchronousTrigger(id);
    if res==vrep.simx_return_ok
        disp('move_signal has been sent!');
    else
        error('unable to send signal to move the object.')
    end
end
