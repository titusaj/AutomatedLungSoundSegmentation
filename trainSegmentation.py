# USAGE

# set the matplotlib backend so figures can be saved in the background
import matplotlib
matplotlib.use("Agg")

# import the necessary packages
from keras.preprocessing.image import ImageDataGenerator
from keras.optimizers import Adam
from sklearn.model_selection import train_test_split
from keras.preprocessing.image import img_to_array
from keras.utils import to_categorical
from sklearn.model_selection import StratifiedKFold
from keras.callbacks import EarlyStopping, ModelCheckpoint
import keras.backend as K

from imutils import paths
import matplotlib.pyplot as plt
import pylab
pylab.show
import numpy as np
from numpy import genfromtxt
import argparse
import random
import csv
import os

from unetLungSounds import unetLungNet

# construct the argument parse and parse the arguments
ap = argparse.ArgumentParser()
ap.add_argument("-d", "--dataset", required=True,
	help="path to input dataset")
ap.add_argument("-l", "--labels", required=True,
	help="path to input label vectors")
ap.add_argument("-m", "--model", required=True,
	help="path to output model")
ap.add_argument("-p", "--plot", type=str, default="plot.png",
	help="path to output loss/accuracy plot")
args = vars(ap.parse_args())


# initialize the number of epochs to train for, initial learning rate,
# and batch size
EPOCHS = 128
INIT_LR = 1e-3
BS = 4

# initialize the data and labels

hilbert = []
labels = []

print(args["dataset"])

# Envolope Directory loading
print("[INFO] loading raw envolopes in...")
fileCount = 0
for filename in os.listdir(args["dataset"]):
	if filename.endswith(".csv"):

		print(fileCount)
		fileCount += 1
		#Importing the raw csv data
		rawCSVHilbert = np.loadtxt(args["dataset"]+'/'+filename)
		hilbert.append(rawCSVHilbert)

data = np.array(hilbert)


# Label Directory loading
print("[INFO] loading raw labels in...")
fileCount = 0
for filename in os.listdir(args["labels"]):
	if filename.endswith(".csv"):

		print(fileCount)
		fileCount += 1
		#Importing the raw csv data
		rawCSVLabels = np.loadtxt(args["labels"]+'/'+filename)
		labels.append(rawCSVLabels)

target = np.array(labels)

print(data.shape)
print(target.shape)


# split into input (X) and output (Y) variables
X = data
Y = target
#Reshaping the data
X = np.expand_dims(X, axis=2) # reshape (training_size, 88200) to (569, 30, 1)
print(X.shape)

#Y = np.expand_dims(Y, axis=2) # reshape (training_size, 88200) to (569, 30, 1)
#print(Y.shape)



# fix random seed for reproducibility
seed = 7
np.random.seed(seed)

# define 10-fold cross validation test harness
kfold = StratifiedKFold(n_splits=3, shuffle=True, random_state=seed)
kFoldCount = 1
cvscores = []

#intialize the model
print("COMPILING MODEL....")
#Fit the model
model = unetLungNet()
#Optomizer setting
opt = Adam(lr=INIT_LR, decay=INIT_LR/(EPOCHS))
model.compile(loss="binary_crossentropy", optimizer =opt, metrics=["accuracy"])
# Set callback functions to early stop traing and save the best model from training
callback = [EarlyStopping(monitor='val_loss', patience=2),
	ModelCheckpoint(filepath='best_model.h5', monitor='val_loss', save_best_only=True)]
# Fitting the model
model.fit(X,Y,batch_size=BS,epochs=EPOCHS, verbose=1, callbacks = callback,
	validation_data=None)
