function collisionState  = collision_box(vrep, id)
% function collisionState  = collision(vrep, id)
% function to check if there is a collision between the box and the hand 
% returns 1 for each finger that is in collision and 0 otherwise 


    % get collision handle - added to scene
    [res, collisionObjectHandle] = vrep.simxGetCollisionHandle(id, 'Collision', vrep.simx_opmode_oneshot_wait);
    vrep.simxSynchronousTrigger(id);
    vrchk(vrep, res);
    [res, collisionObjectHandle0] = vrep.simxGetCollisionHandle(id, 'Collision0', vrep.simx_opmode_oneshot_wait);
    vrep.simxSynchronousTrigger(id);
    vrchk(vrep, res);
    [res, collisionObjectHandle1] = vrep.simxGetCollisionHandle(id, 'Collision1', vrep.simx_opmode_oneshot_wait);
    vrep.simxSynchronousTrigger(id);
    vrchk(vrep, res);

    %enable streaming
    [res, collisionState] = vrep.simxReadCollision(id, collisionObjectHandle, vrep.simx_opmode_streaming);
    vrep.simxSynchronousTrigger(id);
    vrchk(vrep, res, true);
    [res, collisionState0] = vrep.simxReadCollision(id, collisionObjectHandle0, vrep.simx_opmode_streaming);
    vrep.simxSynchronousTrigger(id);
    vrchk(vrep, res, true);
    [res, collisionState1] = vrep.simxReadCollision(id, collisionObjectHandle1, vrep.simx_opmode_streaming);
    vrep.simxSynchronousTrigger(id);
    vrchk(vrep, res, true);

    % read collision state buffer
    [res, collisionState] = vrep.simxReadCollision(id, collisionObjectHandle, vrep.simx_opmode_buffer);
    vrep.simxSynchronousTrigger(id);
    vrchk(vrep, res, true);
    [res, collisionState0] = vrep.simxReadCollision(id, collisionObjectHandle0, vrep.simx_opmode_buffer);
    vrep.simxSynchronousTrigger(id);
    vrchk(vrep, res, true);
    [res, collisionState1] = vrep.simxReadCollision(id, collisionObjectHandle1, vrep.simx_opmode_buffer);
    vrep.simxSynchronousTrigger(id);
    vrchk(vrep, res, true);
    collisionState = [collisionState, collisionState0, collisionState1];

end