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
#Condition to load npy with bug in keras
old = np.load
np.load = lambda *a,**k: old(*a, allow_pickle=True, **k)

from numpy import genfromtxt
import argparse
import random
import csv
import os
from scipy import signal, misc

from unetLungSounds import unetLungNet

# construct the argument parse and parse the arguments
ap = argparse.ArgumentParser()
ap.add_argument("-d", "--dataset", required=True,
	help="path to input dataset")
ap.add_argument("-l", "--labels", required=True,
	help="path to input label vectors")
ap.add_argument("-m", "--model", required=True,
	help="path to output model")
args = vars(ap.parse_args())


# initialize the number of epochs to train for, initial learning rate,
# and batch size
EPOCHS = 1024
INIT_LR = 1e-4
BS = 300

# initialize the data and labels

hilbert = []
labels = []

resampledHilberts=[]
resampledLabels = []
'''
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
		print(rawCSVHilbert.size)
		if rawCSVHilbert.size == 8820:
			hilbert.append(rawCSVHilbert)

data = np.array(hilbert)
np.save('dataTrain.npy', data)

# Label Directory loading
print("[INFO] loading raw labels in...")
fileCount = 0
for filename in os.listdir(args["labels"]):
	if filename.endswith(".csv"):

		print(fileCount)
		fileCount += 1
		#Importing the raw csv data
		rawCSVLabels = np.loadtxt(args["labels"]+'/'+filename)
		print(rawCSVLabels.size)
		if rawCSVLabels.size == 8820:
			labels.append(rawCSVLabels)

target = np.array(labels)
np.save('targetTrain.npy', target)
'''
X = np.load('dataTrain.npy')
Y = np.load('targetTrain.npy')

print('X Shape:',X.shape)
print('Y Shape:',Y.shape)

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
model =unetLungNet()
model.summary()
model.compile(loss='binary_crossentropy', optimizer='adam', metrics=['accuracy'])
#Optomizer setting
opt = Adam(lr=INIT_LR, decay=INIT_LR/(EPOCHS))
#model.compile(optimizer="adam", loss="categorical_crossentropy", metrics=["acc"])
#model.compile(loss="binary_crossentropy", optimizer =opt, metrics=["accuracy"])
# Set callback functions to early stop traing and save the best model from training
callback = [EarlyStopping(monitor='val_loss', patience=2),
	ModelCheckpoint(filepath='best_model.h5', monitor='val_loss', save_best_only=True)]
# Fitting the model
model.fit(X,Y,batch_size=BS,epochs=EPOCHS, verbose=1, callbacks = None, validation_data=None)

# save the model to disk
print("[INFO] serializing network...")
model.save(args["model"]+str(kFoldCount))
