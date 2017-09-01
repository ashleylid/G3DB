
# bash commands for getting the YCB data ready for recording
#  file to rename files like top level objects found in 
#  downloadedYCB16k/object/google_16k - be in downloadedYCB16k when you run this
#  remember to work with mtl, obj and png separately

# find all png files and copy them up to the top level object directory 
#  in the top directory go 3 folders down and find all png files and copy them one folder up
# (1)
find -mindepth 3 -type f -name "*.obj" -execdir cp {} .. \;
find -mindepth 3 -type f -name "*.mtl" -execdir cp {} .. \;

# to find the word "textured" in a file and rename it to the top level file name
sed -i "s|textured|${PWD##*/}|g" textured.obj
# (2)
# for all files 
for d in ./*/ ; do (cd "$d" && sed -i "s|textured|${PWD##*/}|g" textured.obj); done
# (3)
# for all files 
for d in ./*/ ; do (cd "$d" && sed -i "s|texture_map|${PWD##*/}|g" textured.mtl); done

# (4)
# do (1) for png

# (5)
# rename all the top level png files to the object name - for png, obj and mtl 
# then rename the files to the folder name which is the object name 
find . -type f -name "texture_map.png" -printf "/%P\n" | while read FILE ; do DIR=$(dirname "$FILE" ); mv ."$FILE" ."$DIR""$DIR".png;done

# for png obj and mtl
#  copy all the files to the top directory so you can put them across with the main files
#  then move all the files up to the main folder so can copy where you like and put them all together
find -mindepth 2 -type f -name "*.png" -execdir cp {} .. \;
