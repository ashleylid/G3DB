joint_pregrasp_pos = zeros(6,3);
jnt_mx_array_complete = zeros(6,12);

for i = 1:6


    for j = 1:2
        [res, jnt_mx_array]= vrep.simxGetJointMatrix(id, h.fingerJoints(i,j), vrep.simx_opmode_buffer); 
        vrep.simxSynchronousTrigger(id);
        jnt_mx_array_complete(i,:) = jnt_mx_array;
    end
end

    
for i = 1:6

    [res, joint_pregrasp_pos(i,:)] = vrep.simxGetObjectPosition(id, h.fingerJoint_pos(i), h.reference_frame, vrep.simx_opmode_buffer);
    vrep.simxSynchronousTrigger(id);

end 

[res, sph1] =  vrep.simxGetObjectPosition(id, h.fingerJoints(2,1),h.reference_frame , vrep.simx_opmode_buffer);
[res, sph7] =  vrep.simxGetObjectPosition(id, h.fingerJoints(4,1),h.reference_frame , vrep.simx_opmode_buffer);
[res, sph3] =  vrep.simxGetObjectPosition(id, h.fingerJoints(6,1),h.reference_frame , vrep.simx_opmode_buffer);

joint_pregrasp_pos_j1 = [joint_pregrasp_pos(1:2,:); sph1];
joint_pregrasp_pos_j2 = [joint_pregrasp_pos(3:4,:); sph7];
joint_pregrasp_pos_j3 = [joint_pregrasp_pos(5:6,:); sph3];

vrchk(vrep, res, true);
db_output.hand_pregrasp = jnt_mx_array_complete; 
db_output.joint_pregrasp_pos = [joint_pregrasp_pos_j1; joint_pregrasp_pos_j2; joint_pregrasp_pos_j3];