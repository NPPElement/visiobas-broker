#!/bin/bash
# 
cd /opt/
wget https://planet.maps.mail.ru/pbf/planet-latest.osm.pbf 
time docker run -v /opt/planet-latest.osm.pbf:/data.osm.pbf -v /opt/services/home/openstreetmap-data/:/var/lib/postgresql/12/main overv/openstreetmap-tile-server:1.3.10 import