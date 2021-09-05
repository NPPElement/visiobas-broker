#!/bin/bash
# 
 
time docker run -v /opt/zambia-latest.osm.pbf:/data.osm.pbf -v /opt/services/home/openstreetmap-data/:/var/lib/postgresql/12/main overv/openstreetmap-tile-server:1.3.10 import