% functional test code for AABBTree

clear classes

%% stuff needed for getting grasp params

%javaaddpath ../../src/ray/ray.jar
javaaddpath(pwd) %ray.jar


filename = 'teacup.obj';
obj = read_wobj(filename); % from http://groups.csail.mit.edu/graphics/classes/6.837/F03/models/
[tree, vertices] = getAABBTree(obj);

figure
%np = 2500;
%points = zeros(3,np);
%for i = 1:np, points(:,i) = getRandomPointInVolume(tree); end
points = getRandomPointInVolume(tree); % one random points
scatter3(points(1,:), points(2,:), points(3,:)), axis equal
title('Random Internal Points', 'FontSize', 18)

point = getRandomPointInVolume(tree)';

S = repmat(point, size(vertices,1), 1);

% vector between closest surface point and random point given in center of
% object
vector = sum((S-vertices).^2,2);

i = find(vector == min(vector)); % min distance

% grasp_point
d = (vertices(i,:)-point).* 1.15;


% find the orientation same way as before

% find offest of where to move hand 
% find center point of object
object_center = [((max(vertices(:,1))-min(vertices(:,1)))/2), ((max(vertices(:,2))-min(vertices(:,2)))/2), ((max(vertices(:,3))-min(vertices(:,3)))/2)]; 

% offset = object_center_in_vrep - object_center
% grasp poing wrt vrep position
% offset + d = grasp_point

%% end of stuff needed to get grasp params

% bb = tree.myBoundingBox;
% n = 100;
% xp = linspace(bb(1,1), bb(2,1), n);
% yp = linspace(bb(1,2), bb(2,2), n);
% points = zeros(3,n^2);
% grid = zeros(n,n);
% z = 0;
% for i = 1:n
%     for j = 1:n
%         in = ca.uwaterloo.nrlab.ray.AABBTree.isInVolume(tree, [xp(i), yp(j), z]);
%         points(:,(i-1)*n+j) = [xp(i), yp(j), -5+10*in];
%         grid(i,j) = in;
%     end
% end
% points(:,points(3,:) > 0) = nan;
% scatter3(points(1,:), points(2,:), points(3,:), '.'), axis equal
% imagesc(grid)

v = obj.vertices;
testxy = [-8,2];
differences = v(:,1:2) - repmat(testxy, size(v,1), 1);
distances = sum(differences.^2, 2);
ind = find(distances == min(distances), 1, 'first');

f = obj.objects(4).data.vertices;
% ind = find(f == ind);
% fi = mod(ind,size(f,1));
% % figure
% % hold on
% % colors = {'r', 'g', 'b', 'c', 'm', 'y', 'k'};
% % for i = 1:length(fi)
% %     face = f(fi(i),:);
% %     c = v(face,:); %corners
% %     plot3([c(1,1) c(2,1) c(3,1) c(1,1)], [c(1,2) c(2,2) c(3,2) c(1,2)], [c(1,3) c(2,3) c(3,3) c(1,3)], colors{i})
% % end
% 
% corners = [ ...
%    -8.5524    2.5360   -0.8949; ...
%    -8.9189    2.0826    1.6472; ...
%   -10.3807    3.5311    1.6066
%   ];
% 
% o = [-9.4,2.75,20];
% assert (ca.uwaterloo.nrlab.ray.AABBTree.intersectRayPolygon(corners, o, [0,0,-1], [0 0 0]) > 0);
% box = ca.uwaterloo.nrlab.ray.AABBTree.getPolygonBoundingBox(corners);
% assert (ca.uwaterloo.nrlab.ray.AABBTree.intersectRayBox(box(1,:), box(2,:), o, [0,0,-1]) > 0); 
% 
% edges = [corners; corners(1,:)];
% figure, hold on, plot3(edges(:,1), edges(:,2), edges(:,3))
% x = -10.5:.05:-8.5;
% y = 1.5:.05:4.5;
% for i = 1:length(x)
%     for j = 1:length(y)
%         if ca.uwaterloo.nrlab.ray.AABBTree.intersectRayPolygon(corners, [x(i),y(j),20], [0,0,-1], [0 0 0])             
%             plot(x(i), y(j), 'x')
%         end
%         if ca.uwaterloo.nrlab.ray.AABBTree.intersectRayBox(box(1,:), box(2,:), [x(i),y(j),20], [0,0,-1])
%             plot(x(i), y(j), 'o')            
%         end
%     end
% end
% title('Polygon Intersections (x) and Bounding Box Intersections (o)', 'FontSize', 18)
