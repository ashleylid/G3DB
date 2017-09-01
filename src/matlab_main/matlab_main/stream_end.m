     
    [res, init_object_pos] = vrep.simxGetObjectPosition(h.id, h.object, h.reference_frame,vrep.simx_opmode_discontinue); 
    vrchk(vrep, res, true);
    [res, init_object_orient] = vrep.simxGetObjectOrientation(h.id, h.object, h.reference_frame, vrep.simx_opmode_discontinue);
    vrchk(vrep, res, true);
   % hand
    [res, init_hand_pos] = vrep.simxGetObjectPosition(h.id, h.hand, h.reference_frame, vrep.simx_opmode_discontinue);
    vrchk(vrep, res, true);
    [res, init_hand_orient] = vrep.simxGetObjectOrientation(h.id, h.hand, h.reference_frame, vrep.simx_opmode_discontinue);
    vrchk(vrep, res, true);
    %finger tips
    [res, finger_tip1] = vrep.simxGetObjectPosition(id, h.fingerTip1Sensor, h.reference_frame, vrep.simx_opmode_discontinue);
    vrchk(vrep, res, true);
    [res, finger_tip2] = vrep.simxGetObjectPosition(id, h.fingerTip2Sensor, h.reference_frame, vrep.simx_opmode_discontinue);
    vrchk(vrep, res, true);
    [res, finger_tip0] = vrep.simxGetObjectPosition(id, h.fingerTip0Sensor, h.reference_frame, vrep.simx_opmode_discontinue);
    vrchk(vrep, res, true);
    
 
     for i = 1:6
        for j = 1:2
            [res, jnt_mx_array]= vrep.simxGetJointMatrix(id, h.fingerJoints(i,j), vrep.simx_opmode_discontinue );
            vrep.simxSynchronousTrigger(id);
        end
    end
    vrchk(vrep, res, true);

    %box position
    [res, box_pos] =  vrep.simxGetObjectPosition(h.id, h.box, h.reference_frame, vrep.simx_opmode_discontinue);
    vrchk(vrep, res, true);
    
