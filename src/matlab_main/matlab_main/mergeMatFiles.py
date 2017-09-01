"""Script to load mat files and create hdf5 file - change line 8 to be path to data and line 11-12
to be what you want to exclude from your final file"""
import os
import h5py
import itertools
import numpy as np
import scipy.io as sio

working_path = '<enter full path to data>'
directories  = os.listdir(working_path)
# exclude columns from data
exclude_list = ['hand_depth_sensor_img','img_before_grasp',
                'img_after_grasp','pts0', 'pts1', 'pts2']
for i, directory in enumerate(directories):

    object_path = os.path.join(working_path, directory)
    object_files = \
            [s for s in os.listdir(object_path) if s.endswith('.mat')]

    print '%d / %d %s'%(i, len(directories), directory)
 
    file_dict = None 
    for f in object_files:
        path = os.path.join(object_path, f)
           
        mat = sio.loadmat(path, struct_as_record=True)
        data = mat['data']

        if file_dict is None:
            file_dict = {name:[] for name in data.dtype.names}

        for name in data.dtype.names:
            if name not in exclude_list: 
                file_dict[name].extend(data[name])

    # Quick check to make sure we've actually loaded data
    if file_dict == None: continue  
 
    f = h5py.File('hdf5/GraspDataset.hdf5','a')
    g = f.create_group(directory)
    for key, value in file_dict.iteritems():

        # Smush (1000,) into (1000, 1, N)
        reduced_val = list(itertools.chain(*value))
        try:
            # Try to make as an array
            reduced_val = np.asarray(reduced_val)    
            g.create_dataset(key, data=reduced_val, dtype=np.float32)
        except Exception as e:
            # If can't make array, likely due to wrong string format
            try:
                ls=[n.encode("ascii","ignore") for n in reduced_val[:,0]]
                g.create_dataset(key, data=ls, dtype='S10')
            except Exception as e:
                print e
                print 'BAD KEY: ',key
    
    f.close()
