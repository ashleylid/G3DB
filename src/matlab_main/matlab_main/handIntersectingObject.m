function result = handIntersectingObject(object, objectOffset, hand, handOffset, hand_orient)
    % object: obj of grasped object (from read_wobj), after proper scaling
    % objectOffset: xyz offset of object
    % hand: obj of gripper
    % handOffset: xyz offset of hand
    % handQuaternion: quaternion of gripper orientation
    % 
    % result: 0 if no intersection; 1 if intersection
    
    object = move(object, objectOffset);
    hand = rotate(hand, hand_orient);
    hand = move(hand, handOffset);
    [thingTree, ~] = getAABBTree(object);
    [handTree, ~] = getAABBTree(hand);
    
    result = 0;
    for i = 1:2000
        point = ca.uwaterloo.nrlab.ray.AABBTree.getRandomPointInVolume(thingTree);
        if ca.uwaterloo.nrlab.ray.AABBTree.isInVolume(handTree, point)
            result = 1;
            break;
        end
    end
        
end

function obj = rotate(obj, orient)
    rot_matrix = rotx(orient(1)) * roty(orient(2)) * rotz(orient(3));
    obj.vertices = (rot_matrix * obj.vertices')';
end

function obj = move(obj, offset)
    % offset: amount to move object in each direction 
    assert(size(offset, 1) == 3)
    obj.vertices = obj.vertices + repmat(offset', size(obj.vertices, 1), 1);
       
end





