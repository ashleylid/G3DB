% script for testing meshes

% dirName = '~/code/grasp_db/objects/grasp_meshes/final_mesh';
dirName = 'E:/GIT/grasp_db/objects/grasp_meshes/final_mesh';
% dirName = '~/code/grasp_db/objects/grasp_meshes/final_mesh_beforeVREP';
% dirName = 'final-mesh/bad';
listing = dir(dirName);

np = 2000;

for i = 1:length(listing)
    fileName = [dirName '/' listing(i).name];
    if strcmp(fileName(end-3:end), '.obj')
        obj = read_wobj(fileName); 
        tree = getAABBTree(obj);
        points = zeros(3,np);
        for j = 1:np, points(:,j) = getRandomPointInVolume(tree); end
        scatter3(points(1,:), points(2,:), points(3,:)), axis equal
        title(sprintf('Random Internal Points for %s', listing(i).name), 'Interpreter', 'none')
        pause
    end
end
