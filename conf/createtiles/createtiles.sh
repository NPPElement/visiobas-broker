#!/bin/bash

# do NOT forget to install `python-gdal` library
# assuming you are on a debian like OS
# sudo apt install python-gdal

# get the tool
test ! -f gdal2tiles.py \
  && curl https://raw.githubusercontent.com/commenthol/gdal2tiles-leaflet/master/gdal2tiles.py \
  > gdal2tiles.py \
  && echo "'python-gdal' library required - please install sudo apt install python-gdal"

if [ $# -eq 0 ]
then
  echo "Нет файла в параметрах"
  exit 1
fi
src_file=$1

# process ...
export GDAL_ALLOW_LARGE_LIBJPEG_MEM_ALLOC=1
python ./gdal2tiles.py -l -p raster -z 0-4 -w none $src_file $src_file

echo ' '