% obj = read_wobj('tea-bowl.obj')

function [tree, v] = getAABBTree(obj)
    v = obj.vertices; %vertices
    f = [];
    for i = 1:length(obj.objects)
        if ~isempty(obj.objects(i).data) && isfield(obj.objects(i).data, 'vertices')
            f = obj.objects(i).data.vertices; %vertex indices of faces
        end
    end
% if ~isempty(obj.objects(2).data)
%     f = obj.objects(2).data.vertices; %vertex indices of faces
% end
    if isempty(f)
        error('Could not find faces')
    end
%     fprintf('%i vertices, %i faces\n', size(v,1), size(f,1));
    
%     maxx = max(v(:,1));
%     minx = min(v(:,1));
%     maxy = max(v(:,2));
%     miny = min(v(:,2));
%     maxz = max(v(:,3));
%     minz = min(v(:,3));
%     [maxx-minx maxy-miny maxz-minz]
    
    
    nFaces = size(f,1);
    polygons = zeros(nFaces, 3, 3);
    for i = 1:nFaces
        polygons(i,:,:) = v(f(i,:),:);
    end
    
    
    tree = ca.uwaterloo.nrlab.ray.AABBTree.makeTree(polygons);
    
%     plot figure
%     figure
%     scatter3(v(:,1), v(:,2), v(:,3)), axis equal, hold on    
%     b = tree.myBoundingBox;
%     plot3([b(1,1) b(2,1) b(2,1) b(1,1) b(1,1)], [b(1,2) b(1,2) b(2,2) b(2,2) b(1,2)], [b(1,3) b(1,3) b(1,3) b(1,3) b(1,3)])
%     plot3([b(1,1) b(2,1) b(2,1) b(1,1) b(1,1)], [b(1,2) b(1,2) b(2,2) b(2,2) b(1,2)], [b(2,3) b(2,3) b(2,3) b(2,3) b(2,3)])
%     xlabel('x')
%     title('Vertices', 'FontSize', 18)
end