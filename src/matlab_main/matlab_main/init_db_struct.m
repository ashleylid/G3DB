function db_output = init_db_struct(object_name)
    % function db_output = init_db_struct(scene_name)
    % function that creates output struct for database 
    % input: object_name
    % output: db_output struct

    %% init struct of output values 
    object_position_initial = [];
    object_orientation_initial = [];
    object_position_before = [];
    object_orientation_before = [];
    object_position_after = [];
    object_orientation_after = [];
    %object_position_checkstick = [];
    hand_position = []; 
    hand_orientation = []; 
    hand_quaternion = [];
    
    finger_tip1 = [];
    finger_tip2 = [];
    finger_tip0 = [];

    look_at_position = [];
    grasp_measure = 2;
    collision_state = []; 
    power_pinch = 1; 
 

    
    db_output = struct('object_name', object_name, 'object_position_initial', object_position_initial, 'object_orientation_initial', object_orientation_initial, 'object_position_before', object_position_before, 'object_orientation_before', object_orientation_before,   ...
        'object_position_after', object_position_after, 'object_orientation_after', object_orientation_after,   ...
        'hand_orientation', hand_orientation, 'hand_quaternion', hand_quaternion,  'hand_position', hand_position, ... 
        'finger_tip1', finger_tip1, 'finger_tip2', finger_tip2, 'finger_tip0', finger_tip0, ...
        'look_at_position', look_at_position, ...
    'grasp_measure', grasp_measure, ... 
        'collision_state', collision_state, ...
        'power_pinch', power_pinch);
    
        
      
    