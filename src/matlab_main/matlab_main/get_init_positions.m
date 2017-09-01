% mfile to collect initial positions and orientations of required

% objects in scene. Does not take anything, only supports the grasp.m script and returns a cell array: init_positions consisting of
% init_object_pos; xyz value array
% init_object_orient; xyz value array
% init_hand_pos; xyz value array
% init_hand_orient; alpha, beta, gamma values
% object_name; string
% scanner_position0; xyz value array
% scanner_position1; xyz value array
% scanner_position2; xyz value array
% )scanner_orientation0); quaternion
% )scanner_orientation1); quaternion
% )scanner_orientation2); quaternion
% )object_orientation); quaternion
% 
% which is saved the the db 
% this is necassary so that the hand and object are in exactly the same
% positions as they where when they started 

% written by Ashley Kleinhans Aug 2015: kleinhans.ashley(at)gmail.com

if grasp_number == 1
    % get object starting positions
    [res, init_object_pos] = vrep.simxGetObjectPosition(id, h.object, h.reference_frame,vrep.simx_opmode_buffer);
    vrep.simxSynchronousTrigger(id);
    vrchk(vrep, res, true);
    [res, init_object_orient] = vrep.simxGetObjectOrientation(id, h.object, h.reference_frame, vrep.simx_opmode_buffer);
    vrep.simxSynchronousTrigger(id);
    vrchk(vrep, res, true);
   % hand
    [res, init_hand_pos] = vrep.simxGetObjectPosition(id, h.hand, h.reference_frame, vrep.simx_opmode_buffer);
    vrep.simxSynchronousTrigger(id);
    vrchk(vrep, res, true);
    [res, init_hand_orient] = vrep.simxGetObjectOrientation(id, h.hand, h.reference_frame, vrep.simx_opmode_buffer);
    vrep.simxSynchronousTrigger(id);
    vrchk(vrep, res, true);


     % scanner positions and orientations 
%     [res, scanner_position0] = vrep.simxGetObjectPosition(id, h.xyzSensor, h.reference_frame, vrep.simx_opmode_buffer);
%     vrep.simxSynchronousTrigger(id);
%     vrchk(vrep, res, true);
%     [res, scanner_position1] = vrep.simxGetObjectPosition(id, h.xyzSensor0, h.reference_frame, vrep.simx_opmode_buffer);
%     vrep.simxSynchronousTrigger(id);
%     vrchk(vrep, res, true);
%     [res, scanner_position2] = vrep.simxGetObjectPosition(id, h.xyzSensor1, h.reference_frame, vrep.simx_opmode_buffer);
%     vrep.simxSynchronousTrigger(id);
%     vrchk(vrep, res, true);
%     [res, scanner_orientation0] = vrep.simxGetObjectOrientation(id, h.xyzSensor, h.reference_frame, vrep.simx_opmode_buffer);
%     vrep.simxSynchronousTrigger(id);
%     vrchk(vrep, res, true); 
%     [res, scanner_orientation1] = vrep.simxGetObjectOrientation(id, h.xyzSensor0, h.reference_frame, vrep.simx_opmode_buffer);
%     vrep.simxSynchronousTrigger(id);
%     vrchk(vrep, res, true);  
%     [res, scanner_orientation2] = vrep.simxGetObjectOrientation(id, h.xyzSensor1, h.reference_frame, vrep.simx_opmode_buffer);

    % return initial positions
    init_positions = [init_object_pos; init_object_orient; ...
        init_hand_pos; init_hand_orient]; 
%         scanner_position0; scanner_position1; scanner_position2; ...
%         scanner_orientation0; scanner_orientation1; scanner_orientation2]; 
end

%save all positions and orientations to database
db_output.object_position_initial = init_positions(1,:);
db_output.object_orientation_initial = init_positions(2,:);
% db_output.hand_position =  init_positions(3,:);
% db_output.init_hand_orientation =  init_positions(4,:);
% db_output.scanner_position0 = init_positions(5,:);
% db_output.scanner_position1 = init_positions(6,:);
% db_output.scanner_position2 = init_positions(7,:);
% db_output.scanner_orientation0 = init_positions(8,:);
% db_output.scanner_orientation1 = init_positions(9,:);
% db_output.scanner_orientation2 = init_positions(10,:);

