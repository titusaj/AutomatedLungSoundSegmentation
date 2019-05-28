# import the necessary packages
from __future__ import division
from keras.preprocessing.image import img_to_array
from keras.models import load_model
from keras.optimizers import Adam
import numpy as np
import argparse
import imutils
from imutils import paths
import cv2
import os
import math
from sklearn import metrics
import h5py
from sklearn.metrics import confusion_matrix
from sklearn.metrics import f1_score


import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt


ap = argparse.ArgumentParser()
ap.add_argument("-d", "--dataset", required=True,
	help="path to input dataset")
ap.add_argument("-m", "--model", required=True,
	help="path to output model")
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

print(data.shape)



# split into input (X) and output (Y) variables
X = data


#Reshaping the data
X = np.expand_dims(X, axis=2) # reshape (training_size, 88200) to (569, 30, 1)
print(X.shape)


# fix random seed for reproducibility
seed = 7
np.random.seed(seed)


# Intialize TP, FN, TN, FP
TP = 0
FN = 0
TN = 0
FP = 0

#Start probabilities

#fileNum start and stop indicies
fileStarts =[]
fileEnds =[]

segProbs= []




# load the trained convolutional neural network
print("[INFO] loading network...")
model = load_model(args["model"])
#model = DenseNet(reduction=0.5, classes=2, weights_path=weights_path)
opt = Adam(lr=INIT_LR, decay=INIT_LR / EPOCHS)
model.compile(loss="binary_crossentropy", optimizer=opt,
	metrics=["accuracy"])

for vectorCount  in range(0,X.shape[0]):
    testData = X[vectorCount,:,:]
    testData = testData.reshape(1,882000,1)
    print("Test data shape", testData.shape)

    (segmentationProbs) = model.predict(testData)[0]
    segProbs.append(segmentationProbs)
