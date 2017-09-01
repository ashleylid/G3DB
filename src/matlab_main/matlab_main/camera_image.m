function [kinect_img] = camera_image(vrep, h)

[result, resolution, kinect_img] = vrep.simxGetVisionSensorImage2(h.id, h.kinect_img, 0, vrep.simx_opmode_oneshot_wait);
%     [result, resolution, img0]=vrep.simxGetVisionSensorImage2(id,cam0,0,vrep.simx_opmode_oneshot_wait);
%     [result, resolution, img1]=vrep.simxGetVisionSensorImage2(id,cam1,0,vrep.simx_opmode_oneshot_wait);


% function [img, img0, img1, hand_depth_sensor_img] = camera_image(vrep, id)
% inputs: 
% vrep and id 
% outputs: 
% kinect_img / 0 / 1 - image of scene from 3 angles
% hand_depth_sensor_img - image from depth sensor stuck to hand


% NOTE: you need to modify the way in which the camera inside VREP
% operates. So from within VREP:
% copy and paste the vision sensor and check "ignore depth" from within its properties 
% for image and "ignore rgb" for depth. Make sure the correct filters are listed as follows: 
% Original image to work image and work image to output image

%     [res, cam0] = vrep.simxGetObjectHandle(id, 'kinect_visionSensor#0', vrep.simx_opmode_oneshot_wait); 
%     vrchk(vrep, res);
%     [res, cam1] = vrep.simxGetObjectHandle(id, 'kinect_visionSensor#1', vrep.simx_opmode_oneshot_wait); 
%     vrchk(vrep, res);
    % camera streaming
%        fprintf('Capture depth image from hand perspective...\n');
% %      % get depth image of image of object from perspective of hand
% %      [result, resolution, hand_depth_sensor_img] = vrep.simxGetVisionSensorImage2(id, hand_vision_sensor, 0, vrep.simx_opmode_oneshot_wait);
%      
%      [res, det, auxData, auxPacketInfo] = vrep.simxReadVisionSensor(h.id, h.hand_vision_sensor, vrep.simx_opmode_oneshot_wait);
%      vrep.simxSynchronousTrigger(h.id);
%      vrchk(vrep, res, true);
%      width = auxData(auxPacketInfo(1)+1);
%      height = auxData(auxPacketInfo(1)+2);
%      pts = reshape(auxData((auxPacketInfo(1)+2+1):end), 4, width*height);
%       % Each column of pts has [x;y;z;distancetosensor]
%      pts = pts(:,pts(4,:)<4.9999);
%       % Here, we only keep points within 1 meter, to focus on the table
%      hand_depth_sensor_img = pts(1:3,pts(4,:)<1);


  

 
