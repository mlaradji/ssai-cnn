This project was forked from [mitmul: ssai-cnn](https://github.com/mitmul/ssai-cnn).
This is an implementation of [Volodymyr Mnih's dissertation](https://www.cs.toronto.edu/~vmnih/docs/Mnih_Volodymyr_PhD_Thesis.pdf) methods on his [Massachusetts road & building dataset](https://www.cs.toronto.edu/~vmnih/data/) and mitmul's methods that are published in [this paper](http://www.ingentaconnect.com/content/ist/jist/2016/00000060/00000001/art00003).

# Differences

- The requirements have been updated.

# Requirements

It is recommended to install anaconda with python 3.6.5. Using `conda install`, install the following packages:
- Chainer 1.5.0.2
- Cython 0.28.2
- NumPy 1.14.3
- tqdm
- OpenCV 3.4.2
- lmdb 0.9.22
- Boost 1.67.0 (Boost.NumPy is no longer a separate package from Boost.)

To install in one go, use
```
conda install 
```

Note that some of the packages are from the conda-forge repository, which might need to be added.

# Set-up
## Build utils

```
$ cd $SSAI_HOME/scripts/utils
$ bash build.sh
```

Be sure to edit the values in `build.sh` to your situation.

## Create Dataset

```
$ bash shells/download.sh
$ bash shells/create_dataset.sh
```

Dataset         | Training | Validation |  Test
:-------------: | :------: | :--------: | :---:
  mass_roads    | 8580352  |   108416   | 379456
mass_roads_mini | 1060928  |   30976    | 77440
mass_buildings  | 1060928  |   30976    | 77440
  mass_merged   | 1060928  |   30976    | 77440

# Start Training

```
$ CHAINER_TYPE_CHECK=0 CHAINER_SEED=$1 \
nohup python scripts/train.py \
--seed 0 \
--gpu 0 \
--model models/MnihCNN_multi.py \
--train_ortho_db data/mass_merged/lmdb/train_sat \
--train_label_db data/mass_merged/lmdb/train_map \
--valid_ortho_db data/mass_merged/lmdb/valid_sat \
--valid_label_db data/mass_merged/lmdb/valid_map \
--dataset_size 1.0 \
> mnih_multi.log 2>&1 < /dev/null &
```

# Prediction

```
python scripts/predict.py \
--model results/MnihCNN_multi_2016-02-03_03-34-58/MnihCNN_multi.py \
--param results/MnihCNN_multi_2016-02-03_03-34-58/epoch-400.model \
--test_sat_dir data/mass_merged/test/sat \
--channels 3 \
--offset 8 \
--gpu 0 &
```

# Evaluation

```
$ PYTHONPATH=".":$PYTHONPATH python scripts/evaluate.py \
--map_dir data/mass_merged/test/map \
--result_dir results/MnihCNN_multi_2016-02-03_03-34-58/ma_prediction_400 \
--channel 3 \
--offset 8 \
--relax 3 \
--steps 1024
```

# Results

## Conventional methods

Model                         | Mass. Buildings | Mass. Roads            | Mass.Roads-Mini
:---------------------------- | :-------------- | :--------------------- | :--------------
MnihCNN                       | 0.9150          | 0.8873                 | N/A
MnihCNN + CRF                 | 0.9211          | 0.8904                 | N/A
MnihCNN + Post-processing net | 0.9203          | 0.9006                 | N/A
Single-channel                | 0.9503062       | 0.91730195 (epoch 120) | 0.89989258
Single-channel with MA        | 0.953766        | 0.91903522 (epoch 120) | 0.902895

## Multi-channel models (epoch = 400, step = 1024)

Model                       | Building-channel | Road-channel | Road-channel (fixed)
:-------------------------- | :--------------- | :----------- | :-------------------
Multi-channel               | 0.94346856       | 0.89379946   | 0.9033020025
Multi-channel with MA       | 0.95231262       | 0.89971473   | 0.90982972
Multi-channel with CIS      | 0.94417078       | 0.89415726   | 0.9039476538
Multi-channel with CIS + MA | 0.95280431       | 0.90071099   | 0.91108087

## Test on urban areas (epoch = 400, step = 1024)

Model                       | Building-channel | Road-channel
:-------------------------- | :--------------- | :-----------
Single-channel with MA      | 0.962133         | 0.944748
Multi-channel with MA       | 0.962797         | 0.947224
Multi-channel with CIS + MA | 0.964499         | 0.950465

# x0_sigma for inverting feature maps

```
159.348674296
```

# After prediction for single MA

```
$ bash shells/predict.sh
$ python scripts/integrate.py --result_dir results --epoch 200 --size 7,60
$ PYTHONPATH=".":$PYTHONPATH python scripts/evaluate.py --map_dir data/mass_merged/test/map --result_dir results/integrated_200 --channel 3 --offset 8 --relax 3 --steps 256
$ PYTHONPATH="." python scripts/eval_urban.py --result_dir results/integrated_200 --test_map_dir data/mass_merged/test/map --steps 256
```

# Pre-trained models and Predicted results

- [Pre-trained models](https://github.com/mitmul/ssai-cnn/wiki/Pre-trained-models)
- [Predicted results](https://github.com/mitmul/ssai-cnn/wiki/Predicted-results)

# Reference

If you use this code for your project, please cite this journal paper:

- [Multiple Object Extraction from Aerial Imagery with Convolutional Neural Networks](http://www.ingentaconnect.com/content/ist/jist/2016/00000060/00000001/art00003) ([bibtex](http://www.ingentaconnect.com/content/ist/jist/2016/00000060/00000001/art00003;jsessionid=3bmr095n0lb07.alice?format=bib))

```Shunta Saito, Takayoshi Yamashita, Yoshimitsu Aoki, "Multiple Object Extraction from Aerial Imagery with Convolutional Neural Networks", Journal of Imaging Science and Technology, Vol. 60, No. 1, pp. 10402-1-10402-9, 2015```
