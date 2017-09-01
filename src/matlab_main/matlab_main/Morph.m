classdef Morph < handle
    % Tools for randomly morphing mesh vertices, to introduce random 
    % variability into the object database so that it serves as a larger 
    % training dataset. Larger datasets are associated with reduced 
    % overfitting in neural networks, decision trees, etc. 
    % 
    % Morphing is done symmetrically around a user-defined axis. There are
    % five parameters, or coefficients, c1-c5. Radial morphing around the
    % axis is performed by changing the radius r of each vertex as a function
    % of the projection p onto the axis, 
    % 
    %   r' = (c1 + c2*p + c3*p^2)*r
    % 
    % p is normalized to between -1 and 1 relative to the extent of 
    % the mesh, and r is similarly normalized to between 0 and 1. Also, p is 
    % relative to a user-defined origin, which increases the 
    % flexibility of this approach. The projections p are changed as, 
    % 
    %   p' = (c4 + c5*r^2)*p
    
    methods (Static)
        
        function obj = updateObj(obj, newVertices)
            % Replaces original vertices with morphed vertices. 
            % 
            % obj: from a .obj file via read_wobj
            % newVertices: morphed vertices
            
            assert(size(newVertices, 2) == size(obj.vertices, 1), 'Number of vertices does not match')
            
            obj.vertices = newVertices';
        end
        
        function coeffRange = getDefaultCoeffRange()
            % Returns default ranges for random morphing parameters. 
            % 
            % coeffRange: 2x5 matrix with minimum values of coefficients 
            %   c1-c5 in the first row and maximum values in the second. 
            
            coeffRange = [.75 1.5; -.25 .25; -.25 .25; .75 1.5; -.25 .25];
        end

        function coeffs = getRandomCoeffs(coeffRange)
            % coeffRange: a 2x5 matrix of coefficient minimum and maximum
            %   values (as in getDefaultCoeffRange)
            % coeffs: randomly sampled coefficients c1-c5
            
            coeffs = coeffRange(:,1) + rand(5,1).*diff(coeffRange,1,2);
        end 
        
        function newVertices = radialMorph(vertices, origin, ax, coeffs) 
            % vertices: original (unmorphed) vertices (3xn)
            % origin: point around which morphing occurs (this point is not
            %   moved) (3x1)
            % ax: direction vector around which morphing occurs (3x1)
            % coeffs: morphing coefficients c1-c5 
            
            assert(size(vertices, 1) == 3, 'Expected 3xn matrix of vertices')

            centred = vertices - repmat(origin, 1, size(vertices,2)); 
            axisProjections = ax' * centred;
            planeProjections = centred - ax * axisProjections;
            
            % morph radially
            ar = [min(axisProjections) max(axisProjections)]; %axis range
            np = 2 * (axisProjections - mean(ar)) / (ar(2) - ar(1)); %normalized axis projections from -1 to 1
            radialScales = max(0.25, coeffs(1) + coeffs(2) * np + coeffs(3) * np.^2); % dont go lower than a quater of the original radius
            planeProjections = planeProjections .* repmat(radialScales, 3, 1);
            
            % morph along axis
            planeDistances = sum(planeProjections.^2, 1).^.5;
            relPlaneDistances = planeDistances / max(planeDistances);
            axisScales = coeffs(4) + coeffs(5) * relPlaneDistances.^2;
            axisProjections = axisProjections .* axisScales;
            
            centred = planeProjections + ax * axisProjections;
            
            newVertices = centred + repmat(origin, 1, size(vertices,2));         
        end
        
        function plot(oldVertices, newVertices)
            figure
            subplot(1,2,1), scatter3(oldVertices(1,:), oldVertices(2,:), oldVertices(3,:)), axis equal
            subplot(1,2,2)
            if ~isempty(newVertices)
                scatter3(newVertices(1,:), newVertices(2,:), newVertices(3,:)), axis equal
            end
        end
        
        function COM = getCentreOfMass(obj)
            % obj: from a .obj file via read_wobj
            % COM: estimated centre of mass (this will be slightly
            %   different each time the method is called as it relies on
            %   Monte Carlo integration)
            
            points = getInnerPoints(obj);
            COM = mean(points, 2);
        end
        
        function I = getInertiaMatrix(obj)
            % obj: from a .obj file via read_wobj            
            % I: estimated inertia matrix (3x3 moments of inertia / mass)
            
            % see http://farside.ph.utexas.edu/teaching/336k/Newtonhtml/node64.html
            
            points = getInnerPoints(obj);
            COM = mean(points, 2);
            points = points - repmat(COM, 1, size(points,2));
            Ixx = mean(points(2,:).^2 + points(3,:).^2);
            Iyy = mean(points(1,:).^2 + points(3,:).^2);
            Izz = mean(points(1,:).^2 + points(2,:).^2);
            Ixy = -mean(points(1,:) .* points(2,:));
            Ixz = -mean(points(1,:) .* points(3,:));
            Iyz = -mean(points(2,:) .* points(3,:));
            
            I = [Ixx Ixy Ixz; Ixy Iyy Iyz; Ixz Iyz Izz];
        end
        
        function v = getVolume(obj)
            % obj: from a .obj file via read_wobj            
            % v: estimated object volume. After morphing, the ratio of new
            %   volume over old volume corresponds to the ratio of new over
            %   old mass. 
            
            [tree, ~] = getAABBTree(obj);
            bb = tree.myBoundingBox;
            bbVolume = prod(diff(bb, 1));
            np = 10000;
            nInside = 0;
            points = repmat(bb(1,:), np, 1) + rand(np,3) .* repmat(diff(bb, 1), np, 1);
            for i = 1:np
                nInside = nInside + ca.uwaterloo.nrlab.ray.AABBTree.isInVolume(tree, points(i,:)');
            end
            
            v = bbVolume * nInside / np;
        end
        
        function vertices = fixBase(vertices, baseHeight)
            % Morphing may move some points below the original base of the
            % object. This method moves such points up to the base. 
            % 
            % vertices: 3xn matrix of vertices
            % baseHeight: desired lowest value of vertices in 3rd dimension
            
            assert(size(vertices, 1) == 3, 'Expected 3xn matrix of vertices')
            
            vertices(3, vertices(3,:) < baseHeight) = baseHeight;
        end
        
    end

end

function points = getInnerPoints(obj)
    % Generates random points inside on object mesh. This is useful
    % for estimating centre of mass and inertial properties. 
    % 
    % obj: from a .obj file via read_wobj

    [tree, ~] = getAABBTree(obj);
    np = 5000;
    points = zeros(3,np);
    for i = 1:np
        points(:,i) = getRandomPointInVolume(tree); 
    end
end 
