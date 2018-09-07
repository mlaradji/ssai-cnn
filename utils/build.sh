./reset_cmake.sh

source ../config/python
PYTHON_DIR=$conda_dir

cmake \
-DPYTHON_LIBRARY=$PYTHON_DIR/lib/libpython3.6m.so \
-DPYTHON_INCLUDE_DIR=$PYTHON_DIR/include/python3.6m \
-DPYTHON_INCLUDE_DIR2=$PYTHON_DIR/include \
-DBOOST_LIBRARY_DIR=$PYTHON_DIR/lib \
-DBoost_INCLUDE_DIR=$PYTHON_DIR/include \
-DBoost_NumPy_INCLUDE_DIR=$PYTHON_DIR/include \
-DBoost_NumPy_LIBRARY_DIR=$PYTHON_DIR/lib \
-DOpenCV_DIR=$PYTHON_DIR/lib \
-Wno-dev \
. && make -j8
