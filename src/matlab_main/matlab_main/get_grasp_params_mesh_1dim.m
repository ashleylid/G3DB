function [new_pos, new_orient, power_pinch, look_at_position] = get_grasp_params_mesh(object_position, project_root, meshpath, hand_obj, object_name, db_output)
    % Returns new random grasp parameters. Called from grasp.m. 
    % 
    % vrep: VRep object of class remApi.  
    % h.id: VRep scene number
    % obj_name: Name of mesh
    % h: Struct of handles to objects and reference frame in VRep scene (from barret_init.m) 
    % object_position: Current position of object relative to h.reference_frame
    % project_root: Path to project root directory
    % 
    % new_pos: Position vector of hand relative to h.reference_frame
    % new_orient: Orientation vector (Euler angles) of hand relative to h.reference_frame
    % target_point: Point within object toward which the grasp is directed
    % power_pinch: Distance of the hand from the object surface 
   
    % Read in mesh and create tree of verticies  

    obj = read_wobj(meshpath); % from http://groups.csail.mit.edu/graphics/classes/6.837/F03/models
    tree = getAABBTree(obj);
    
    positionOK = false;
    grasp_attempt = 1; 
    
    while ~positionOK
           
        % get random point inside volume 
        intersections = [];
        
        while isempty(intersections)
            
            point = getRandomPointInVolume(tree);
            % find random direction from point to hand
            direction = randn(3,1); 
            %% SET ORIENTATION TO ONLY ROTATE AROUND GAMMA 
            direction = [0;0;randn];
            %% 
            direction = direction / norm(direction);

            %find farthest surface point in above direction 
            intList = tree.getIntersections(point, direction);
            % check if the point is on the surface, meaning that the
            % intersection will be null
      
            intersections = zeros(3,intList.size());
            for j = 1:intList.size()
                intersections(:,j) = intList.get(j-1);
            end
        end
   
        % temp mx to repeat the point for every intersection
        a = repmat(point, 1, intList.size());
        b = intersections;
        distances = sum((a - b).^2, 1).^.5;
        % find the closest point 
        intersection = intersections(:, distances == min(distances));
        look_at_position = intersection; % save the position to look at on the object
        %% SET LOOK AT POSITION 
        look_at_position = [0.015439656201881;0.031973148323213;0.078449521613477];
        %%
        % choose random distance from surface point between where palm touches and where fingertips touch when closed
        power_pinch = .15*rand; %fingers are about 15cm, but if to close or too far away it fails (find out more in learning) 
        %% SET POWER PINCH
        power_pinch = 0.12;
        bounding_box_centre = mean(tree.myBoundingBox,1); %this is what VRep treats as object position
        
        object_offset = object_position' - bounding_box_centre'; 
        
        new_pos = intersection + power_pinch*direction + object_offset; 
        
        hand_vector = [0 0 1];
%         vector from new hand position to point
        new_orient = -direction;
         
         %         rotation from hand vector to new orient
         Q  = quaternion.rotateutov(hand_vector,new_orient);
        
        hand_rot_matrix = RotationMatrix(Q);
         
        new_orient = EulerAngles(Q, 'xyz');
       
                 % test intersection of hand with object ... 
        
        clearOfObject = ~handIntersectingObject(obj, object_offset, hand_obj, new_pos, new_orient);
       
        % test intersection of hand with support box: make sure hand is not
        % intersecting what the object is resting on
        % We will not attempt positions that are below the radius of the palm
        % We will, however, allow some failures depending on
        % orientation of the hand and finger spread. 
        % collision of box is checked separately - its possible to collide
        % with the box and still have a successful grasp
        bottom = tree.myBoundingBox(1,3) + object_position(3); 
        clearOfBox = new_pos(3) > bottom + .06; % radius is 50mm, knuckles stick out a bit farther 
        positionOK = clearOfBox && clearOfObject;
        grasp_attempt = grasp_attempt+1
        
        % if we are not able to find a grasp, after 100 attempts then save
        % a mesh of the file so we can later figure out what about that
        % mesh made it fail. 
        if grasp_attempt > 100
           
            figure('Visible', 'Off'); hold on
            
            new_hand_vert = hand_obj.vertices; 
            new_hand_vert =  hand_rot_matrix * new_hand_vert';
            
            new_pos_plot = repmat(new_pos, 1, size(new_hand_vert,2));
            new_hand_vert = new_hand_vert + new_pos_plot;
            plot_hand_obj = Morph.updateObj(hand_obj, new_hand_vert); 

            plot3(new_pos(1), new_pos(2), new_pos(3), 'co')
            new_point = point + object_offset; 
            plot3(new_point(1), new_point(2), new_point(3), 'g*')
            new_intersection = intersection + object_offset;
            plot3(new_intersection(1), new_intersection(2), new_intersection(3), 'mo')
            
            obj_verticies =  obj.vertices;        
            object_offset = repmat(object_offset', size(obj_verticies,1), 1 );
            new_pos_obj = obj_verticies + object_offset; 
            new_obj = Morph.updateObj(obj, new_pos_obj'); 
            
            db_output.random_point_in_object = new_point;
            db_output.obj_surface_intersection = new_intersection;

            plotMesh(plot_hand_obj, [], 'r');
            plotMesh(new_obj, [], 'b');
                      
            file = sprintf('%s%i',object_name, grasp_attempt);
            flocation =  [project_root '/grasp_db/data']; 
            
            saveas(gcf, fullfile(flocation, file),'fig')
            % to view figure: openfig('file.fig','new','visible')
            % stop this whole program if we cant find a grasp
            if grasp_attempt > 150
                error('Program exit')
                ME = MException('VerifyOutput:OutOfBounds', ...
                    'Results are outside the allowable limits');
                throw(ME);
            end
        end 
        
        
      
    end
    
  
