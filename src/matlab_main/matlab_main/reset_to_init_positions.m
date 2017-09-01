%     res = vrep.simxStopSimulation(id, vrep.simx_opmode_oneshot);
%     vrep.simxSynchronousTrigger(id);
%     vrchk(vrep, res, true);

    fprintf('Resetting hand and object...\n');
   
    vrep.simxSynchronousTrigger(id);
    res = vrep.simxSetObjectPosition(id, h.object, h.reference_frame, init_positions(1,:), vrep.simx_opmode_oneshot); vrchk(vrep, res, true);
    vrep.simxSynchronousTrigger(id);
    res = vrep.simxSetObjectOrientation(id, h.object, h.reference_frame, init_positions(2,:), vrep.simx_opmode_oneshot); vrchk(vrep, res, true);  
    vrep.simxSynchronousTrigger(id);
    res = vrep.simxSetObjectPosition(id, h.hand, h.reference_frame, init_positions(3,:), vrep.simx_opmode_oneshot); vrchk(vrep, res, true);
    vrep.simxSynchronousTrigger(id);
    res = vrep.simxSetObjectOrientation(id, h.hand, h.reference_frame, init_positions(4,:), vrep.simx_opmode_oneshot); vrchk(vrep, res, true); 
    vrep.simxSynchronousTrigger(id);
% 
%     res = vrep.simxStartSimulation(id, vrep.simx_opmode_oneshot); vrchk(vrep, res, true);
%     vrep.simxSynchronousTrigger(id);
%     vrchk(vrep, res, true);