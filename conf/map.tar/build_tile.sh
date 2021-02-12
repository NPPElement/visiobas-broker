#!/bin/bash
# для работы этого скриптта необходимо установить apt install imagemagick возможно понадобится sudo apt update
# после установки выполните скрипт sh build_tile.sh map.png
# папка с файлами пирамиды должна называться tiles и лежать в корне workspace (svg)

if [ $# -eq 0 ]
  then
    echo "Please choose a source file for pyramid"
    exit 1
fi
src_file=$1
# Удаляем фон
#convert $src_file -alpha 	set  	-channel 	RGBA \
#                  -fill 	none 	-opaque 	white   'new-'$src_file
                  
convert $src_file -fuzz 10% -transparent white 'new-'$src_file
                                     
src_pgw=$(echo 'new-'$src_file | sed 's/png/pgw/g')

echo $src_pgw
mkdir tiles

echo  "1.00000000000000\n0.00000000000000\n0.00000000000000\n-1.00000000000000\n0.00000000000000\n0.00000000000000" > $src_pgw
gdal_translate -a_srs epsg:3395 'new-'$src_file map.tif
gdal_retile.py -v -r bilinear -levels 6 -ps 256 256 -co "TILED=YES" -co "COMPRESS=PNG" -of png -targetDir tiles map.tif

echo "Add extra space to the tile with wrong size"
for i in 1 2 3 4 5 6
do
  search_dir="./tiles/$i"
  echo $search_dir
  cd $search_dir
  rm *.xml
#  convert *.tif -set filename: "%t" %[filename:].png
  convert *.png -background none -extent 256x256 -set filename: "%t" %[filename:].png
  cd ../../
done
cd tiles
#convert *.tif -set filename: "%t" %[filename:].png
rm *.xml
convert *.png -background none -extent 256x256 -set filename: "%t" %[filename:].png
mv 6 7
mv 5 6
mv 4 5
mv 3 4
mv 2 3
mv 1 2
mkdir 1
mv *.png 1
cd ../
rm map.tif
src_folder=$(echo $src_file | sed 's/.png//g')
mv tiles $src_folder
rm 'new-'$src_folder.pgw
#rm 'new-'$src_folder.png
