function [new_pos, new_orient, power_pinch, hand_quaternion, look_at_position] = move_hand(vrep, h, init_positions, object_position, project_root, meshpath, hand_obj, object_name) 
    % function [new_pos, new_orient, power_pinch] = move_hand(vrep, h, init_positions, object_position, project_root, meshpath, hand_obj, object_name) 
    % function to move hand to new location calculated in
    % get_grasp_params_mesh.m 
    
    res = vrep.simxStopSimulation(h.id, vrep.simx_opmode_oneshot);
    vrep.simxSynchronousTrigger(h.id);
    vrchk(vrep, res, true);
    
    % reset the object and move hand to new position 
    res = vrep.simxSetObjectPosition(h.id, h.object, h.reference_frame, init_positions(1,:), vrep.simx_opmode_oneshot); vrchk(vrep, res, true);
    vrep.simxSynchronousTrigger(h.id);
    res = vrep.simxSetObjectOrientation(h.id, h.object, h.reference_frame, init_positions(2,:), vrep.simx_opmode_oneshot); vrchk(vrep, res, true); 
    vrep.simxSynchronousTrigger(h.id);
    
    [new_pos, new_orient, power_pinch, look_at_position] = get_grasp_params_mesh(object_position, project_root, meshpath, hand_obj, object_name);
    
    res = vrep.simxSetObjectOrientation(h.id, h.hand, -1, new_orient, vrep.simx_opmode_oneshot); vrchk(vrep, res, true);  
    vrep.simxSynchronousTrigger(h.id);
    res = vrep.simxSetObjectPosition(h.id, h.hand, h.reference_frame, new_pos, vrep.simx_opmode_oneshot); vrchk(vrep, res, true);
    vrep.simxSynchronousTrigger(h.id)
    
    res = vrep.simxStartSimulation(h.id, vrep.simx_opmode_oneshot); vrchk(vrep, res, true);
    vrep.simxSynchronousTrigger(h.id);
    vrchk(vrep, res, true);
    
    % quaternion (x,y,z,w)
    [res retInts hand_quaternion retStrings retBuffer] = vrep.simxCallScriptFunction(h.id,'getQuaternion',vrep.sim_scripttype_childscript,'getObjectQuaternion', h.hand, [],'',[],vrep.simx_opmode_blocking);
    
    
end