function handles = barrett_init(vrep, id, object_name)
% daughter script for barrett.m
% Initialize barrett and retrieve all handles, and stream joints, the
% barrett hand pose, the kinect and hand pose.

    handles = struct('id', id);

    % reference frame 
    [res, reference_frame] = vrep.simxGetObjectHandle(id, 'ReferenceFrame', vrep.simx_opmode_oneshot_wait); vrchk(vrep, res); 
    handles.reference_frame = reference_frame; 

    % thumb
    [res, fingerJoints(1,1)] = vrep.simxGetObjectHandle(id, 'Barrett_spherical0', vrep.simx_opmode_oneshot_wait); vrchk(vrep, res); % Joint B1
    vrep.simxSynchronousTrigger(id);
    [res, fingerJoints(1,2)] = vrep.simxGetObjectHandle(id, 'Barrett_spherical', vrep.simx_opmode_oneshot_wait); vrchk(vrep, res);
    vrep.simxSynchronousTrigger(id);
    [res, fingerJoints(2,1)] = vrep.simxGetObjectHandle(id, 'Barrett_spherical1', vrep.simx_opmode_oneshot_wait); vrchk(vrep, res); % Joint C1
    vrep.simxSynchronousTrigger(id);
    [res, fingerJoints(2,2)] = vrep.simxGetObjectHandle(id, 'Barrett_spherical2', vrep.simx_opmode_oneshot_wait); vrchk(vrep, res);
    vrep.simxSynchronousTrigger(id);
    % right
    [res, fingerJoints(3,1)] = vrep.simxGetObjectHandle(id, 'Barrett_spherical9', vrep.simx_opmode_oneshot_wait); vrchk(vrep, res); % Joint B0
    vrep.simxSynchronousTrigger(id);
    [res, fingerJoints(3,2)] = vrep.simxGetObjectHandle(id, 'Barrett_spherical10', vrep.simx_opmode_oneshot_wait); vrchk(vrep, res);
    vrep.simxSynchronousTrigger(id);
    [res, fingerJoints(4,1)] = vrep.simxGetObjectHandle(id, 'Barrett_spherical7', vrep.simx_opmode_oneshot_wait); vrchk(vrep, res); % Joint C0
    vrep.simxSynchronousTrigger(id);
    [res, fingerJoints(4,2)] = vrep.simxGetObjectHandle(id, 'Barrett_spherical8', vrep.simx_opmode_oneshot_wait); vrchk(vrep, res); 
    vrep.simxSynchronousTrigger(id);
    %left
    [res, fingerJoints(5,1)] = vrep.simxGetObjectHandle(id, 'Barrett_spherical4', vrep.simx_opmode_oneshot_wait); vrchk(vrep, res); % Joint B2
    vrep.simxSynchronousTrigger(id);
    [res, fingerJoints(5,2)] = vrep.simxGetObjectHandle(id, 'Barrett_spherical5', vrep.simx_opmode_oneshot_wait); vrchk(vrep, res);
    vrep.simxSynchronousTrigger(id);
    [res, fingerJoints(6,1)] = vrep.simxGetObjectHandle(id, 'Barrett_spherical3', vrep.simx_opmode_oneshot_wait); vrchk(vrep, res); % Joint C2
    vrep.simxSynchronousTrigger(id);
    [res, fingerJoints(6,2)] = vrep.simxGetObjectHandle(id, 'Barrett_spherical6', vrep.simx_opmode_oneshot_wait); vrchk(vrep, res); 
    vrep.simxSynchronousTrigger(id);

    handles.fingerJoints = fingerJoints; 
    
    %joint positions
    
    [res, fingerJoint_pos(1)] = vrep.simxGetObjectHandle(id, 'BarrettHand_jointB_1', vrep.simx_opmode_oneshot_wait); vrchk(vrep, res); 
    vrep.simxSynchronousTrigger(id);
    [res, fingerJoint_pos(2)] = vrep.simxGetObjectHandle(id, 'BarrettHand_jointC_1', vrep.simx_opmode_oneshot_wait); vrchk(vrep, res); 
    vrep.simxSynchronousTrigger(id);
    [res, fingerJoint_pos(3)] = vrep.simxGetObjectHandle(id, 'BarrettHand_jointB_0', vrep.simx_opmode_oneshot_wait); vrchk(vrep, res); 
    vrep.simxSynchronousTrigger(id);
    [res, fingerJoint_pos(4)] = vrep.simxGetObjectHandle(id, 'BarrettHand_jointC_0', vrep.simx_opmode_oneshot_wait); vrchk(vrep, res); 
    vrep.simxSynchronousTrigger(id);
    [res, fingerJoint_pos(5)] = vrep.simxGetObjectHandle(id, 'BarrettHand_jointB_2', vrep.simx_opmode_oneshot_wait); vrchk(vrep, res); 
    vrep.simxSynchronousTrigger(id);
    [res, fingerJoint_pos(6)] = vrep.simxGetObjectHandle(id, 'BarrettHand_jointC_2', vrep.simx_opmode_oneshot_wait); vrchk(vrep, res); 
    vrep.simxSynchronousTrigger(id);
    
    handles.fingerJoint_pos = fingerJoint_pos;
    
    % hand handle
    [res, hand] = vrep.simxGetObjectHandle(id, 'BarrettHand', vrep.simx_opmode_oneshot_wait); vrchk(vrep, res);
    handles.hand = hand;

%     %hand vision sensor handle 
%     [res, hand_vision_sensor] = vrep.simxGetObjectHandle(id, 'fast3DLaserScanner_sensor0', vrep.simx_opmode_oneshot_wait); vrchk(vrep, res);
%     handles.hand_vision_sensor = hand_vision_sensor;

        % kinect vision sensor handle, for rgb image of scene
    [res, kinect_img] = vrep.simxGetObjectHandle(id, 'kinect_visionSensor', vrep.simx_opmode_oneshot_wait); vrchk(vrep, res);
    handles.kinect_img = kinect_img;

    
        % Object and box (what the object is resting on) handles
    [res, object] = vrep.simxGetObjectHandle(id, object_name, vrep.simx_opmode_oneshot_wait); vrchk(vrep, res);
    [res, box] = vrep.simxGetObjectHandle(id, 'Cuboid', vrep.simx_opmode_oneshot_wait); vrchk(vrep, res);
    handles.object = object;
    handles.box = box;

     % bhand finger tips
     [res, fingerTip1Sensor] = vrep.simxGetObjectHandle(id, 'BarrettHand_fingerTipSensor1', vrep.simx_opmode_oneshot_wait); vrchk(vrep, res);
     [res, fingerTip2Sensor] = vrep.simxGetObjectHandle(id, 'BarrettHand_fingerTipSensor2', vrep.simx_opmode_oneshot_wait); vrchk(vrep, res);
     [res, fingerTip0Sensor] = vrep.simxGetObjectHandle(id, 'BarrettHand_fingerTipSensor0', vrep.simx_opmode_oneshot_wait); vrchk(vrep, res);
     % add hand reference point to handles structure for position calculation
     % and plotting end grasp positions
     handles.fingerTip1Sensor = fingerTip1Sensor;
     handles.fingerTip2Sensor = fingerTip2Sensor;
     handles.fingerTip0Sensor = fingerTip0Sensor;



%     % xyzSensor depth sensors
%     [res, xyzSensor] = vrep.simxGetObjectHandle(id, 'fast3DLaserScanner_sensor', vrep.simx_opmode_oneshot_wait); vrchk(vrep, res);
%     [res, xyzSensor0] = vrep.simxGetObjectHandle(id, 'fast3DLaserScanner_sensor#0', vrep.simx_opmode_oneshot_wait); vrchk(vrep, res);
%     [res, xyzSensor1] = vrep.simxGetObjectHandle(id, 'fast3DLaserScanner_sensor#1', vrep.simx_opmode_oneshot_wait); vrchk(vrep, res);
%     handles.xyzSensor = xyzSensor; 
%     handles.xyzSensor0 = xyzSensor0; 
%     handles.xyzSensor1 = xyzSensor1; 
%     pause(2)



    %Unit test for handle creation
    if (res==vrep.simx_error_noerror)
        [res, objs] = vrep.simxGetObjects(id,vrep.sim_handle_all,vrep.simx_opmode_oneshot_wait); vrchk(vrep, res)
        %fprintf('Number of objects in the scene: %d\n',length(objs));
    else 
        fprintf('Unable to create handles');
    end
end

