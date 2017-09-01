function [dataFile, mass, centreOfMass, inertiaMatrix, name, meshpath, date] = getRandomObjectYCB(morphedMeshDir, setOfObjectsFolder, morph, objectMassCsv, number_object, index)
    % Creates a new object and returns its mesh file path and physical 
    % properties. The mesh is randomly morphed from a randomly selected
    % object (from ~110 manually curated examples). The mass is manually 
    % specified per original mesh, and updated according to the relative
    % volume of the new object. The inertial properties are estimated by
    % assuming uniform density. 
    % 
    % morphedMeshDir, setOfObjectsFolder, morph: set up in
    % config file   
    %
    % projectDir: root directory of the grasp_db project (contains objects
    %   folder)
    % morphedMeshDir: directory for storing new .obj files for morphed
    %   meshes
    % meshFile: full path to mesh file of new (randomly morphed) object
    %   (note that the mesh units are in cm)
    % mass: mass of object
    % centreOfMass: centre of mass of object (m)
    % inertiaMatrix: inertia tensor divided by mass (m^2)    
    
%     javaaddpath([projectDir javaDirectory])
    
%     [index, objectDirectory] = ObjectDataYCB.getRandomObjectIndex(setOfObjectsFolder);
    objectDirectory = dir([setOfObjectsFolder, '*.obj']);
    [obj, ~, name] = ObjectDataYCB.getObject(index, setOfObjectsFolder, objectDirectory);
%      name = objectDirectory(index).name(1:end-4)
%      name = strsplit(name, '/')
%      name = name(end)
%      name = name(1:end-4)
    
    % Creating morphed object, this is set in your config file if you want
    % to morph meshes, the first object should be unmorphed
    if morph == 1 %&& number_object ~= 1
        
        cr = ObjectDataYCB.getMorphCoefficientsRanges(index);
        coefficients = Morph.getRandomCoeffs(cr);
        origin = ObjectDataYCB.getMorphOrigin(obj, index);
        axis = ObjectDataYCB.getMorphAxis(index);
        % perform morph & write new .obj file ... 
        newVertices = Morph.radialMorph(obj.vertices', origin, axis, coefficients);
        newobj = Morph.updateObj(obj, newVertices);
    else 
        origin = Morph.getCentreOfMass(obj);
        newobj = obj;
    end
    
    % data of creation 
    date=datestr(clock, 'dd-mmm-yyyy-HH-MM-SS');
    % create data file
    dataFile = [morphedMeshDir '/' name '-' date];
    mkdir(dataFile);
    
    % save mesh in datafile
    meshFile = [dataFile '/' name '-' date];
    write_wobj(newobj, [meshFile '.obj']);
    meshpath=[dataFile '/' name '-' date '.obj'];
    
    % calculate new physics parameters ... 
    mass = ObjectDataYCB.getMass(index, objectMassCsv) * Morph.getVolume(newobj) / (Morph.getVolume(obj));
    centreOfMass = Morph.getCentreOfMass(newobj); 
    inertiaMatrix = Morph.getInertiaMatrix(newobj); 
    inertiaMatrix=reshape(inertiaMatrix,[1,9]); %reshape inertia an COM so that they can be packed and sent as a signal
    % When you input inertia using a signal, V-rep divides the inertia by
    % the mass automatically 
    % BT: inertia matrix in VRep seems less realistic with this scaling, e.g. 3mm radius of gyration for a bottle
%     inertiaMatrix=inertiaMat.*mass;
    centreOfMass=reshape(centreOfMass,[1,3]);
    disp(centreOfMass);
    disp(inertiaMatrix); 
    
    if morph == 1 && number_object ~= 1
        csvwrite([meshFile '-params.csv'], [coefficients' origin' axis' mass centreOfMass(:)' inertiaMatrix(:)']);
    else
        csvwrite([meshFile '-params.csv'], [origin' mass centreOfMass(:)' inertiaMatrix(:)']);
    end
  
end

