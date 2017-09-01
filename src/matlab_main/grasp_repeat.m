function [db_output, init_positions] = grasp_repeat(vrep, id, grasp_number, object_name, project_root, image_dir, meshpath, init_positions, hand_obj)
                    
    % function [db_output, initial_pos_orient] = grasp(vrep, id, grasp_number, scene_name, img_folder_name, scene_number, initial_pos_orient, object_name, java_path, mesh_path)
    % Called from main.m
    % Main file to grasp an object. Output is the db_output (data)
    % inputs: 
    % vrep handle; 
    % id int; 
    % grasp_number int; 
    % scene_name string; 
    % img_folder_name string; 
    % scene_number int; 
    % object_name string;
    % java_path string; 
    % mesh_path string. 

    %% Init
    % Retrieve all handles, and make them available everywhere 
    persistent h 
    h = barrett_init(vrep, id, object_name);
    vrep.simxSynchronousTrigger(id);
    % create struct of db entries 
    db_output = init_db_struct(object_name); 
    % ensure hand is open at the beginning of the grasp
    res = vrep.simxSetIntegerSignal(id , 'closing', 0, vrep.simx_opmode_oneshot);
    vrep.simxSynchronousTrigger(id);
    vrchk(vrep, res, true);
    %  enable streaming of all objects in VREP simulator 
    stream;
    % get initial positions
    get_init_positions;
%     vrep.simxSynchronousTrigger(id);
    
    %% =========   main loop
    % make sure hand and object are in exactly the same place before each
    % grasp
    
    [~, ~, power_pinch, hand_quaternion, look_at_position] = move_hand(vrep, h, init_positions, init_positions(1,:), project_root, meshpath, hand_obj, object_name); 
    db_output.power_pinch = power_pinch; 
    db_output.hand_quaternion = hand_quaternion; 
    db_output.look_at_position = look_at_position; 

    disp('Capturing camera image before grasp...');
    scene_img_before_grasp0  = camera_image(vrep, h); 
    % save jpg image to grasp dir
    filename = sprintf('%s/scene_img_before_grasp_%d.jpg',image_dir ,grasp_number); 
    imwrite(scene_img_before_grasp0, filename, 'jpg');
    % save jpg image file name to db - for reference 
    
    
    [res, hand_position] = vrep.simxGetObjectPosition(id, h.hand, h.reference_frame, vrep.simx_opmode_buffer);
    vrchk(vrep, res, true);
    [res, hand_orientation] = vrep.simxGetObjectOrientation(id, h.hand, h.reference_frame, vrep.simx_opmode_buffer);
    vrchk(vrep, res, true);
    
    [res, finger_tip1] = vrep.simxGetObjectPosition(id, h.fingerTip1Sensor, h.reference_frame, vrep.simx_opmode_buffer);
    vrchk(vrep, res, true);
    [res, finger_tip2] = vrep.simxGetObjectPosition(id, h.fingerTip2Sensor, h.reference_frame, vrep.simx_opmode_buffer);
    vrchk(vrep, res, true);
    [res, finger_tip0] = vrep.simxGetObjectPosition(id, h.fingerTip0Sensor, h.reference_frame, vrep.simx_opmode_buffer);
    vrchk(vrep, res, true);
    
    grasp_measure_total = [];
    
    for repeat_grasp = 1:10
        repeat_grasp
        % ===== grasp object 
        disp('Performing grasp...');
        res = vrep.simxSetIntegerSignal(id , 'closing', 1, vrep.simx_opmode_oneshot);
        vrep.simxSynchronousTrigger(id);
        vrchk(vrep, res, true);
        pause(5) %this is as long as it takes - dont remove

        % ==== test grasp by removing box
        [res, object_position_before] = vrep.simxGetObjectPosition(id, h.object, h.reference_frame, vrep.simx_opmode_buffer);
        vrchk(vrep, res, true);
        [res, object_orientation_before] = vrep.simxGetObjectOrientation(id, h.object, h.reference_frame, vrep.simx_opmode_buffer);
        vrchk(vrep, res, true);

        disp('Testing grasp...');
        % read if grasp is in collision with either the box (table / base) 
        collision_state  = collision_box(vrep, id);
        pause(1)
        % remove the box that the object is resting on
        [grasp_measure, box_pos2, object_position_after, object_orientation_after] = test_grasp(h, vrep, init_positions(1,:), box_pos);
        grasp_measure_total = [grasp_measure_total, grasp_measure]
        
        if repeat_grasp == 1
            disp('Capturing camera image after grasp...');
            scene_img_after_grasp0  = camera_image(vrep, h);
            filename = sprintf('%s/scene_img_after_grasp_%d.jpg',image_dir ,grasp_number);
            imwrite(scene_img_after_grasp0, filename, 'jpg')
        end

        % Clean up
        % replace box  
        vrep.simxSetObjectPosition(id , h.box, h.reference_frame, box_pos2, vrep.simx_opmode_oneshot);
        vrep.simxSynchronousTrigger(id);
        % replace object and hand 
        move_hand_repeat(vrep, h, init_positions, hand_position, hand_orientation)   
    end
    grasp_measure = sum(grasp_measure_total)/10
   
%     % open hand - I used this to check for sticking before I increased
%     the number of points that I tested for intersection. 
%     disp('Open hand...');
%     res = vrep.simxSetIntegerSignal(id , 'closing', 0, vrep.simx_opmode_oneshot);
%     vrep.simxSynchronousTrigger(id);
%     vrchk(vrep, res);
%     pause(5)
%     % record object position to check if the hand is sticking to the object
%     disp('Testing sticking...');
%     [res, object_position_checkstick] = vrep.simxGetObjectPosition(id, h.object, h.reference_frame, vrep.simx_opmode_buffer);
%     vrchk(vrep, res, true);
    
    fprintf('Capturing data...\n');
    db_output.grasp_measure = grasp_measure; 
    db_output.hand_orientation = hand_orientation;
    db_output.hand_position = hand_position;
    db_output.finger_tip1 = finger_tip1;
    db_output.finger_tip2 = finger_tip2;
    db_output.finger_tip0 = finger_tip0; 
    db_output.collision_state = collision_state;
    db_output.object_position_before = object_position_before;
    db_output.object_orientation_before= object_orientation_before;
    db_output.object_position_after = object_position_after;
    db_output.object_orientation_after = object_orientation_after;
%    db_output.object_position_checkstick = object_position_checkstick;
    

    if vrep.simxGetConnectionId(id) == -1,
        error('Lost connection to remote API.');
    end
    % close off streaming actions
    stream_end;

end % main function
   
