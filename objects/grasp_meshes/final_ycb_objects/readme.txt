for f in file 

> move the lower level obj file up 
find -mindepth 3 -type f -name "*.obj" -execdir cp {} .. \;

> rename the file to the folder
find . -type f -name "textured.obj" -printf "/%P\n" | while read FILE ; do DIR=$(dirname "$FILE" ); mv ."$FILE" ."$DIR""$DIR".obj;done

> delete folders 
find -mindepth 2 -type d -exec rm -d {} \;
