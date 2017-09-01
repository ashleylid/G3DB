function move_hand_repeat(vrep, h, init_positions, hand_position, hand_orientation) 
    % function [new_pos, new_orient, power_pinch] = move_hand(vrep, h, init_positions, object_position, project_root, meshpath, hand_obj, object_name) 
    % function to move hand to new location calculated in
    % get_grasp_params_mesh.m 
    
    % 
    
    res = vrep.simxStopSimulation(h.id, vrep.simx_opmode_oneshot);
    vrep.simxSynchronousTrigger(h.id);
    vrchk(vrep, res, true);
    
    % reset the object and move hand to new position 
    res = vrep.simxSetObjectPosition(h.id, h.object, h.reference_frame, init_positions(1,:), vrep.simx_opmode_oneshot); vrchk(vrep, res, true);
    vrep.simxSynchronousTrigger(h.id);
    res = vrep.simxSetObjectOrientation(h.id, h.object, h.reference_frame, init_positions(2,:), vrep.simx_opmode_oneshot); vrchk(vrep, res, true); 
    vrep.simxSynchronousTrigger(h.id);
    
    res = vrep.simxSetObjectOrientation(h.id, h.hand, -1, hand_orientation, vrep.simx_opmode_oneshot); vrchk(vrep, res, true);  
    vrep.simxSynchronousTrigger(h.id);
    res = vrep.simxSetObjectPosition(h.id, h.hand, h.reference_frame, hand_position, vrep.simx_opmode_oneshot); vrchk(vrep, res, true);
    vrep.simxSynchronousTrigger(h.id)
    
    res = vrep.simxStartSimulation(h.id, vrep.simx_opmode_oneshot); vrchk(vrep, res, true);
    vrep.simxSynchronousTrigger(h.id);
    vrchk(vrep, res, true);

end