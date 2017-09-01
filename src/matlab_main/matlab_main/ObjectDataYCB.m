classdef ObjectDataYCB < handle
    
    methods (Static)
        
        function [index, objectDirectory] = getRandomObjectIndex(setOfObjectsFolder, index)
            % index: index of a random original object mesh
            % objectDirectory: struct with all information about each file
            % in object folder
            
%             od = ObjectDataYCB.getObjectDataYCB();
            objectDirectory = dir([setOfObjectsFolder, '*.obj']);
            % enter in name of object you want to repeat 
            %index = find( cellfun(@(x)isequal(x,'025_mug.obj'),{objectDirectory.name}));
            % or choose to randomly over whole set
            %index = randi([1 60]);% random index between 1 and X
            %index = randi(size(objectDirectory,1));    
            index = index%17; % the mug
        end
        
        function [obj, meshFile, name] = getObject(index, setOfObjectsFolder, objectDirectory)
            % projectDir: root directory of the grasp_db project (contains objects
            %   folder)
            % index: index of a random original object mesh
            % 
            % obj: struct with data from .obj file (from read_wobj)
            [meshFile, name] = ObjectDataYCB.getOriginalMeshFileName(index, setOfObjectsFolder, objectDirectory);
            obj = read_wobj(meshFile);
        end
        
        function [meshFile, name] = getOriginalMeshFileName(index, setOfObjectsFolder, objectDirectory)
            % setOfObjectsFolder: directory of origional .obj mesh files
            % index: index of a random original object mesh
            % objectDirectory: struct of directory with all information
            % pertaining to objects
            %
            % meshFile: path to .obj file 
            od = ObjectDataYCB.getObjectDataYCB();
            params = od{index};
            name = params{1};
            meshFile = [setOfObjectsFolder name '.obj']        
        end


        function checkFiles(projectDir)
            % Verifies that all original mesh files are present in the expected
            % place. 

            od = getObjectDataYCB();
            for i = 1:length(od)
                fileName = getOriginalMeshFileName(projectDir, od{i}{1});
                assert(~isempty(dir(fileName)), 'Missing file: %s', fileName)
            end
        end
              
        function cr = getMorphCoefficientsRanges(index)
            % index: index of a random original object mesh
            % 
            % cr: ranges for random morph coefficients (see Morph)
            
            od = ObjectDataYCB.getObjectDataYCB();
            params = od{index};
            
            cr = Morph.getDefaultCoeffRange(); 
            if length(params) >= 5
                if params{5} == 1 %morph parameters for boxes
                    cr = [.5 2; 0 0; 0 0; .5 2; 0 0];
                end
            end
            if length(params) >= 6 %custom morph params
                cr = params{6};
            end
        end
        
        function origin = getMorphOrigin(obj, index)
            % index: index of a random original object mesh
            % obj: struct with data from .obj file (from read_wobj)
            % 
            % origin: origin around which morph occurs (see Morph)
            
            od = ObjectDataYCB.getObjectDataYCB();
            params = od{index};

            origin = Morph.getCentreOfMass(obj); %pre-morph centre of mass
            bottom = min(obj.vertices(:,3));
            origin(3) = bottom;
            if length(params) >= 3 && ~isempty(params{3})
                origin = params{3};
            end
        end
        
        function axis = getMorphAxis(index)
            % index: index of a random original object mesh
            % 
            % axis: axis of symmetry for morph (see Morph)
            
            od = ObjectDataYCB.getObjectDataYCB();
            params = od{index};
            
            axis = [0; 0; 1];
            if length(params) >= 4 && ~isempty(params{4})
                axis = params{4};
            end
        end
        
        function mass = getMass(index, objectMassCsv)
            % index: index of a random original object mesh
            % Reads from an external csv file
            % 
            % mass: object mass (kg)
            
             od = ObjectDataYCB.getObjectDataYCB();
             params = od{index};
             mass = params{2};
             %for working with csv
            %mass = csvread(objectMassCsv);
            %mass = mass(index); 
        end

        function od = getObjectDataYCB()
            % Cell array of object parameters. Each entry is a cell array with the 
            % following entries:  
            %   name (corresponds to .obj file name without '_final.obj' at end)
            %   mass
            %   morph origin (default = bottom directly below COM)
            %   morph axis (default = [0 0 1])
            %   use-box-morph flag (default = 0)
            %   morph coefficient ranges (default as in Morph.getDefaultCoeffRange)
            % mass = params{2}
            % Values with defaults can be omitted or replaced with []. 
                    
%             od{1} = {'24_bowl', .24}; 
%             od{2} = {'25_mug', .2};
%             od{3} = {'27-a_skillet', 2}; 
%             od{4} = {'28_skillet_lid', .265}; 
%             od{5} = {'29_plate', .265}; 
%             od{6} = {'30_fork', .06}; 
%             od{7} = {'31_spoon', .06}; 
%             od{8} = {'32_knife', .06}; 
%             od{9} = {'33_spatula', .15}; 

                
                od{1} = {'013_apple', 0.068};
                od{2} = {'011_banana', 0.066};
                od{3} = {'056_tennis_ball', 0.058};
                od{4} = {'050_medium_clamp',0.059};
                od{5} = {'061_foam_brick',0.028};
                od{6} = {'065-h_cups',0.031};
                od{7} = {'008_pudding_box',0.187};
                od{8} = {'027_skillet',0.950};
                od{9} = {'012_strawberry', 0.018};
                od{10} = {'019_pitcher_base', 0.178};
                od{11} = {'065-f_cups', 0.026};
                od{12} = {'002_master_chef_can',0.414};
                od{13} = {'048_hammer',0.665};
                od{14} = {'044_flat_screwdriver',0.0984};
                od{15} = {'003_cracker_box',0.411};
                od{16} = {'037_scissors',0.082};
                od{17} = {'025_mug',0.118};
                od{18} = {'009_gelatin_box',0.097};
                od{19} = {'057_racquetball',0.041};
                od{20} = {'065-e_cups',0.021};
                od{21} = {'065-d_cups',0.019};
                od{22} = {'024_bowl',0.147};
                od{23} = {'010_potted_meat_can',0.133};
                od{24} = {'016_pear',0.049};
                od{25} = {'021_bleach_cleanser',1.131};
                od{26} = {'015_peach',0.033};
                od{27} = {'065-i_cups',0.035};
                od{28} = {'065-g_cups',0.028};
                od{29} = {'038_padlock',0.304};
                od{30} = {'018_plum',0.025};
                od{31} = {'065-c_cups',0.017};
                od{32} = {'035_power_drill',0.895};
                od{33} = {'006_mustard_bottle',0.603};
                od{34} = {'065-j_cups',0.038};
                od{35} = {'072-a_toy_airplane',0.570};
                od{36} = {'029_plate',0.279};
                od{37} = {'014_lemon',0.029};
                od{38} = {'058_golf_ball',0.046};
                od{39} = {'004_sugar_box',0.514};
                od{40} = {'072-b_toy_airplane',0.570};
                od{41} = {'065-b_cups',0.014};
                od{42} = {'005_tomato_soup_can',0.349};
                od{43} = {'017_orange',0.047};
                od{44} = {'052_extra_large_clamp',0.202};
                od{45} = {'026_sponge',0.0062};
                od{46} = {'055_baseball',0.058};
                od{47} = {'042_adjustable_wrench',0.252};
                od{48} = {'070-a_colored_wood_blocks',0.0108};
                od{49} = {'072-c_toy_airplane',0.570};
                od{50} = {'059_chain',0.098};
                od{51} = {'077_rubiks_cube',0.14};
                od{52} = {'051_large_clamp',0.125};
                od{53} = {'043_phillips_screwdriver',0.097};
                od{54} = {'065-a_cups',0.013};
                od{55} = {'036_wood_block',0.729};
                od{56} = {'054_softball',0.191};
                od{57} = {'040_large_marker',0.0158};
                od{58} = {'053_mini_soccer_ball',0.123};
                od{59} = {'007_tuna_fish_can',0.171};
                od{60} = {'033_spatula',0.0515};
                od{61} = {'030_fork',0.034};
                  
                
             
        end
              
    end
    
end
