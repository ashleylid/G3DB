classdef ObjectData < handle
    
    methods (Static)
        
        function [index, objectDirectory] = getRandomObjectIndex(setOfObjectsFolder)
            % index: index of a random original object mesh
            % objectDirectory: struct with all information about each file
            % in object folder
            
%             od = ObjectData.getObjectData();
            objectDirectory = dir([setOfObjectsFolder, '*.obj']);
            % enter in name of object you want to repeat 
            index = find( cellfun(@(x)isequal(x,'42_wineglass_final.obj'),{objectDirectory.name}));
            % or choose to randomly over whole set
%             index = randi(size(objectDirectory,1));            
        end
        
        function obj = getObject(index, setOfObjectsFolder, objectDirectory)
            % projectDir: root directory of the grasp_db project (contains objects
            %   folder)
            % index: index of a random original object mesh
            % 
            % obj: struct with data from .obj file (from read_wobj)
            meshFile = ObjectData.getOriginalMeshFileName(index, setOfObjectsFolder, objectDirectory);
            obj = read_wobj(meshFile);
        end
        
        function meshFile = getOriginalMeshFileName(index, setOfObjectsFolder, objectDirectory)
            % setOfObjectsFolder: directory of origional .obj mesh files
            % index: index of a random original object mesh
            % objectDirectory: struct of directory with all information
            % pertaining to objects
            %
            % meshFile: path to .obj file 
            
            meshFile = [setOfObjectsFolder objectDirectory(index).name]; 
        end


        function checkFiles(projectDir)
            % Verifies that all original mesh files are present in the expected
            % place. 

            od = getObjectData();
            for i = 1:length(od)
                fileName = getOriginalMeshFileName(projectDir, od{i}{1});
                assert(~isempty(dir(fileName)), 'Missing file: %s', fileName)
            end
        end
              
        function cr = getMorphCoefficientsRanges(index)
            % index: index of a random original object mesh
            % 
            % cr: ranges for random morph coefficients (see Morph)
            
            od = ObjectData.getObjectData();
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
            
            od = ObjectData.getObjectData();
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
            
            od = ObjectData.getObjectData();
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
            
%             od = ObjectData.getObjectData();
%             params = od{index};
%             mass = params{2};
            mass = csvread(objectMassCsv);
            mass = mass(index); 
        end

        function od = getObjectData()
            % Cell array of object parameters. Each entry is a cell array with the 
            % following entries:  
            %   name (corresponds to .obj file name without '_final.obj' at end)
            %   mass
            %   morph origin (default = bottom directly below COM)
            %   morph axis (default = [0 0 1])
            %   use-box-morph flag (default = 0)
            %   morph coefficient ranges (default as in Morph.getDefaultCoeffRange)
            % 
            % Values with defaults can be omitted or replaced with []. 

            % "done" means the params are happy
            % "params" mean that it looks ok in the plot, but I would like to
            % check it in vrep to make sure.
            
            % ** change the ones to the boxes to morph to **** 
            
            od{1} = {'1_Coffeecup', .2}; % done
            od{2} = {'2_fork', .06}; % done 
            od{3} = {'3_book', 1, [], [], 1}; % done
            od{4} = {'4_PillBox', .05, [], [], 1}; % done 
            od{5} = {'5_bottle', .22, [], [], 1}; % params
            od{6} = {'6_jar', .07}; % done
            od{7} = {'7_bowl', .24}; % done
            od{8} = {'8_cardstand', .4, [], [], 1}; % params
            od{9} = {'9_egg', .05, [], [], [], [.8 1.2; -.1 .1; 0 0; .8 1.2; 0 0]}; %done
            od{10} = {'10_funnel', .08}; % done
            od{11} = {'11_cheese', .2, [], [], 1};  % done 
            od{12} = {'12_dog_bowl', .8}; %params
            od{13} = {'13_tray', .3}; % done 
            od{14} = {'14_rollingpin', .25, [], [], 1}; %params 
            od{15} = {'15_Ashtray', .105}; %done
            od{16} = {'16_bottle_opener', .08, [], [], 1}; % params
            od{17} = {'17_Pot_lid', .25}; %done
            od{18} = {'18_garbage_box', 0.5, [], [], 1}; %para
            od{19} = {'19_Hammer', .75}; % done
            od{20} = {'20_KeurigScoop', .015, [], [], 1}; % params
            od{21} = {'21_key', .015, [], [], 1}; % params
            od{22} = {'22_knife', .06}; % 
            od{23} = {'23_knob', .04}; % params
            od{24} = {'24_mug', .2}; % params
            od{25} = {'25_plate', .265}; % params
            od{26} = {'26_salt', .1}; % done
            od{27} = {'27_Sauce_Bottle', .1}; %done
            od{28} = {'28_Spatula', .15}; %done - check for handle? 
            od{29} = {'29_teacup', .09}; %done
            od{30} = {'30_fruit_juicer', .115}; %params
            od{31} = {'31_icecube_tray', .105, [], [], 1}; % params
            od{32} = {'32_minibowl', .23}; %done
            od{33} = {'33_pan', 2}; %done
            od{34} = {'34_twistedcup', .09}; %done - not sure about size though, may be too big
            od{35} = {'35_twistedvase', 1.5}; %params
            od{36} = {'36_vase', 1.4}; %params
            od{37} = {'37_banana', .12}; %done
            od{38} = {'38_chocolate', .045, [], [], 1}; %params
            od{39} = {'39_beerbottle', .22}; %done (but possibly no longer a beer bottle in some cases) 
            od{40} = {'40_carafe', .26}; %done
            od{41} = {'41_jar_and_lid', .12}; %done
            od{42} = {'42_wineglass', .13}; % done (but now a port glass exists too) 
            od{43} = {'43_wineglass2', .13}; % done same as before - check if bases are large enough
            od{44} = {'44_towelstand', .3, [], [], 1}; % params
            od{45} = {'45_cookiecutter', .01, [], [], 1}; %params
            od{46} = {'46_milkbottle', .15}; % params
            od{47} = {'47_kettle', 1.1}; %done
            od{48} = {'48_bottle_and_plug', .225}; %done
            od{49} = {'49_apple', .12, [], [], 1}; % **needs to be updated - apples dont look like eggs or vases
            od{50} = {'50_carton', .08, [], [], 1}; %done
            od{51} = {'51_teapot', 1.4}; %done
            od{52} = {'52_jar2', .48}; %done 
            od{53} = {'53_watertap', 1.1}; %params
            od{54} = {'54_candlestick', 1.1};%params
            od{55} = {'55_hairdryer', .7}; %done
            od{56} = {'56_headphones', .24}; %done
            od{57} = {'57_remote', .11, [], [], 1}; % **needs to be updated
            od{58} = {'58_perfume', .16}; %done
            od{59} = {'59_towel', .45}; %params
            od{60} = {'60_comb', .09}; %params
            od{61} = {'61_pictureframe', .44, [], [], 1}; %done
            od{62} = {'62_mouse', .11}; %done
            od{63} = {'63_candle', .14}; %done
            od{64} = {'64_tongs', .08, [], [], 1}; %**needs to be updated
            od{65} = {'65_coffeemaker', .64, [], [], 1}; %**needs to be updated
            od{66} = {'66_chocolatebox', .09, [], [], 1}; %params
            od{67} = {'67_jug', .3}; %done
            od{68} = {'68_toy', .205}; %done
            od{69} = {'69_pan_and_lid', .68}; %done
            od{70} = {'70_tray2', .26}; %done
            od{71} = {'71_vase2', 1.4}; %done
            od{72} = {'72_hat', .19}; %done
            od{73} = {'73_juicebottle', .03}; %done
            od{74} = {'74_lamp', 1.1}; %done
            od{75} = {'75_vase3', .71}; %done
            od{76} = {'76_mirror', .7}; %done
            od{77} = {'77_napkinholder', .17}; %done 
            od{78} = {'78_shoe', .32}; %params
            od{79} = {'79_toy_dog', .45}; %params
            od{80} = {'80_tincan', .3}; %done
            od{81} = {'81_candle2', .14}; %done
            od{82} = {'82_robot', .51}; %done
            od{83} = {'83_rocket', .34}; %done
            od{84} = {'84_yogurtcup', .045}; %done
            od{85} = {'85_showerhead', .28}; %done
            od{86} = {'86_bread', .19, [], [], 1}; % params
            od{87} = {'87_bottleset', .41}; %done 
            od{88} = {'88_usb', .013, [], [], [], [.9 1.1; 0 0; 0 0; .9 1.1; 0 0]}; %done
            od{89} = {'89_cucumber', .15}; %done 
            od{90} = {'90_phone', .2, [], [], 1}; % ** phones dont look like this
            od{91} = {'91_peppershaker', .08}; %done
            od{92} = {'92_shell', .16}; %params
            od{93} = {'93_snake', .55}; %params
            od{94} = {'94_weight', 10.9, [], [], 1}; %done 
            od{95} = {'95_boots', .5}; %done 
            od{96} = {'96_carrot', .06}; %done 
            od{97} = {'97_eggplant', .15}; %params
            od{98} = {'98_faucet', 1.1}; %params
            od{99} = {'99_orange', .1}; %done 
            od{100} = {'100_pepper', .08}; %done 
            od{101} = {'101_shampoo', .06, [], [], 1}; %params
            od{102} = {'102_screwdriver', .13}; %done 
            od{103} = {'103_slipper', .145}; %done 
            od{104} = {'104_toaster', 1.8, [], [], 1}; %params
            od{105} = {'105_toothbrush_holder', .19}; %done 
            od{106} = {'106_urn', 1.8, [], [], 1}; %params
            od{107} = {'107_pen', .024}; %done 
            od{108} = {'108_pillow', .69}; %params
            od{109} = {'109_crab', .2}; %done 
            od{110} = {'110_bunny', .27}; %done 
            od{111} = {'111_saltshaker', .07}; %done 
            
        end
              
    end
    
end
