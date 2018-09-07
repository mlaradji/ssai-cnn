#!/bin/bash

source ../config/python

conda install -c conda-forge python-lmdb lmdb "boost 1.67.0 py36h3e44d54_0" "boost-cpp 1.67.0 h3a22d5f_0"
conda install -c anaconda "py-boost 1.67.0 py36h04863e7_4"
