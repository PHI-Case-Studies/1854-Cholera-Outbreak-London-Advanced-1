#!/bin/bash

# Activate environment
source /home/nbuser/anaconda3_420/bin/activate

# Install packages
conda update -c conda-forge conda conda-build
conda install -y -c conda-forge folium=0.10* jinja2=2.10* osmnx=0.10* networkx=2.3* shapely descartes \
    pandas=0.25*

pip install --upgrade pip

source /home/nbuser/anaconda3_420/bin/deactivate