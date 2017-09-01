function [pts, pts0, pts1] = xyz_sensor(vrep, h, opmode)
    % Read from xyz sensor.

    % (C) Copyright Renaud Detry 2013.
    % Distributed under the GNU General Public License.
    % (See http://www.gnu.org/copyleft/gpl.html)

    fprintf('Capturing point clouds...\n');

    % Again, the data comes in a funny format. Use the lines below to move the
    % data to a Matlab matrix
    vrep.simxSynchronousTrigger(h.id);
    
    [res, det, auxData, auxPacketInfo] = vrep.simxReadVisionSensor(h.id, h.xyzSensor, opmode);
    vrchk(vrep, res, true);
    width = auxData(auxPacketInfo(1)+1);
    height = auxData(auxPacketInfo(1)+2);
    pts = reshape(auxData((auxPacketInfo(1)+2+1):end), 4, width*height);
      % Each column of pts has [x;y;z;distancetosensor]
    pts = pts(:,pts(4,:)<4.9999);
      % Each column of pts has [x;y;z;distancetosensor]
      % Here, we only keep points within 1 meter, to focus on the table
    pts = pts(1:3,pts(4,:)<1);
    %   plot depth points  
    %   subplot(221)
    %   plot3(pts(1,:), pts(2,:), pts(3,:), '*');
    %   axis equal;
    %   view([-169 -46]);
    [res, det, auxData, auxPacketInfo] = vrep.simxReadVisionSensor(h.id, h.xyzSensor0, opmode); vrchk(vrep, res, true);
    width = auxData(auxPacketInfo(1)+1);
    height = auxData(auxPacketInfo(1)+2);
    pts0 = reshape(auxData((auxPacketInfo(1)+2+1):end), 4, width*height);
      % Each column of pts has [x;y;z;distancetosensor]
    pts0 = pts0(:,pts0(4,:)<4.9999);
      % Each column of pts has [x;y;z;distancetosensor]
      % Here, we only keep points within 1 meter, to focus on the table
    pts0 = pts0(1:3,pts0(4,:)<1);
    %   subplot(222)
    %   plot3(pts0(1,:), pts0(2,:), pts0(3,:), '*');
    %   axis equal;
    %   view([-169 -46]);
    [res, det, auxData, auxPacketInfo] = vrep.simxReadVisionSensor(h.id, h.xyzSensor1, opmode); vrchk(vrep, res, true);
    width = auxData(auxPacketInfo(1)+1);
    height = auxData(auxPacketInfo(1)+2);
    pts1 = reshape(auxData((auxPacketInfo(1)+2+1):end), 4, width*height);
    % Each column of pts has [x;y;z;distancetosensor]
    pts1 = pts1(:,pts1(4,:)<4.9999);
    % Each column of pts has [x;y;z;distancetosensor]
    % Here, we only keep points within 1 meter, to focus on the table
    pts1 = pts1(1:3,pts1(4,:)<1);
    %   subplot(223)
    %   plot3(pts1(1,:), pts1(2,:), pts1(3,:), '*');
    %   axis equal;
    %   view([-169 -46]);



end
