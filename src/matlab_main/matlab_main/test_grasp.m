function [grasp_measure, box_pos2, object_position_after, object_orientation_after] = test_grasp(h, vrep, object_position, box_pos)
% function [grasp_measure, finger_angularVelocity, box_pos2] = test_grasp(h, vrep, object_position, box_pos)
% function that tests if the grasp is successful by removing the box and returning it. 
% threshold is set by checking the z position of the object 
% inputs: h handles struct; vrep int; 
% object_position vector xyz; box_pos vector xyz.
% grasp_measure boolean; finger_angularVelocity vector alpha beta gamma;
% box_pos2 vector xyz. 


% % stream velocity readings for physics simulation confirmation - if angular
% % velocity is large then the simulation failed
% [res, finger_linearVelocity, finger_angularVelocity] = vrep.simxGetObjectVelocity(h.id, h.FingerTip1, vrep.simx_opmode_streaming);
% vrchk(vrep, res, true);

% removal of box - get the position of box then set to some distance away
[res, box_pos2] =  vrep.simxGetObjectPosition(h.id, h.box, h.reference_frame, vrep.simx_opmode_buffer);
vrchk(vrep, res, true);
pause(0.2)
vrep.simxSetObjectPosition(h.id , h.box, h.reference_frame, box_pos+100, vrep.simx_opmode_oneshot);
pause(5)

[res, object_orientation_after] = vrep.simxGetObjectOrientation(h.id, h.object, h.reference_frame, vrep.simx_opmode_buffer);
vrchk(vrep, res, true);

% read object position to see if object has fallen, or if it is still held 
[res, object_position_after] = vrep.simxGetObjectPosition(h.id, h.object, h.reference_frame, vrep.simx_opmode_buffer);
grasp_measure = object_position(3) - object_position_after(3);
% % 
% % 1 = grasp success
if grasp_measure < 0.1
    grasp_measure = 1; 
else
    grasp_measure = 0;
end 
