#!/bin/bash

source ../config/python

cd $conda_dir/lib
ln -s libboost_python3{6,}.so.1.67.0
ln -s libboost_python3{6,}.so
ln -s libboost_python3{6,}.a
