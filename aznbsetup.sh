#!/bin/bash

# Activate environment
source /home/nbuser/anaconda3_420/bin/activate

# Install packages
conda update -c conda-forge conda conda-build
conda install -y -c conda-forge folium=0.11* jinja2=2.10* osmnx=0.15* pandas=1.0* geopandas=0.80* descartes shapely poppler

pip install --upgrade pip

source /home/nbuser/anaconda3_420/bin/deactivate