#!/usr/local/bin/python
import os, sys

# set the matplotlib backend so figures can be saved in the background
import matplotlib
import tensorflow as tf
matplotlib.use("Agg")

# import the necessary packages
from keras.layers import Dense, Dropout, Input, Embedding, LSTM, TimeDistributed
from keras.models import Model


from imutils import paths
import matplotlib
import matplotlib.pyplot as plt
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
import cv2

#Allow one gpu to
os.environ["CUDA_DEVICE_ORDER"]="PCI_BUS_ID";
os.environ["CUDA_VISIBLE_DEVICES"]="1";
#This allows for gpu memory growth over all visipble gpus
config = tf.ConfigProto()
config.gpu_options.allow_growth = True

# construct the argument parse and parse the arguments
ap = argparse.ArgumentParser()
ap.add_argument("-d", "--dataset", required=True,
	help="path to input dataset")
args = vars(ap.parse_args())


hilbert = []
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
		if rawCSVHilbert.size == 1000:
			hilbert.append(rawCSVHilbert)

data = np.array(hilbert)
np.save('dataTrain.npy', data)



#Define the input
sequence_length = 1000;
X = data
#Reshaping the data
X = np.expand_dims(X, axis=2) # reshape (training_size, 88200) to (569, 30, 1)
print(X.shape)

inputs_ae = Input(shape=(sequence_length, 1))
encoded_ae = LSTM(128, return_sequences=True, dropout=0.3)(inputs_ae, training=True)
decoded_ae = LSTM(32, return_sequences=True, dropout=0.3)(encoded_ae, training=True)
out_ae = TimeDistributed(Dense(1))(decoded_ae)
sequence_autoencoder = Model(inputs_ae, out_ae)
sequence_autoencoder.compile(optimizer='adam', loss='mse', metrics=['mse'])
sequence_autoencoder.fit(X, X, batch_size=16, epochs=100, verbose=2, shuffle=True)

encoder = Model(inputs_ae, encoded_ae)
XX = encoder.predict(X)
XXF = np.concatenate([XX, F], axis=2)

inputs1 = Input(shape=(X_train1.shape[1], X_train1.shape[2]))
lstm1 = LSTM(128, return_sequences=True, dropout=0.3)(inputs1, training=True)
lstm1 = LSTM(32, return_sequences=False, dropout=0.3)(lstm1, training=True)
dense1 = Dense(50)(lstm1)
out1 = Dense(1)(dense1)
model1 = Model(inputs1, out1)
model1.compile(loss=’mse’, optimizer=’adam’, metrics=[‘mse’])
model1.fit(X_train1, y_train1, epochs=30, batch_size=128, verbose=2, shuffle=True)
