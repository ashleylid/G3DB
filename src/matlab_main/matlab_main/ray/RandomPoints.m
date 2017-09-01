classdef RandomPoints < handle
    % Static methods for generating random points within meshes and
    % primitive shapes. 
    
    methods (Static)
        
        function point = getRandomPointInMesh(tree)
            % tree: AABBTree (obtained from getAABBTree)
            % point: a random point within the volume of the mesh
            
            point = ca.uwaterloo.nrlab.ray.AABBTree.getRandomPointInVolume(tree);
        end
        
        function point = getRandomPointInBox(centre, dimensions)
            % Note: this assumes the box is aligned with the axes. 
            % 
            % centre: [x;y;z] coordinates of centre
            % dimensions: [length;width;height] of box
            
            point = centre - dimensions/2 + rand(3,1).*dimensions;
        end
        
        function point = getRandomPointInCylinder(centre, height, radius)
            % Note: this assumes the cylinder is vertical. 
            % 
            % centre: [x;y;z] coordinates of centre
            % height: length of cylinder, which is assumed to be vertical
            % radius: radius
            
            point = centre;
            
            point(3) = point(3) - height/2 + rand*height;
            
            directions = randn(2, 1);
            offsets = directions ./ (1/radius * norm(directions)); %on the surface
            offsets = offsets * rand.^(1/2); %in the volume
            point(1:2) = point(1:2) + offsets;
        end
    end
end