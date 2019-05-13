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

from imutils import paths
import matplotlib.pyplot as plt
import pylab
pylab.show
import numpy as np
import argparse
import random
import cv2
import os



# construct the argument parse and parse the arguments
ap = argparse.ArgumentParser()
ap.add_argument("-d", "--dataset", required=True,
	help="path to input dataset")
ap.add_argument("-m", "--model", required=True,
	help="path to output model")
ap.add_argument("-l", "--logFile", required=True,
	help="path to the log file name")
ap.add_argument("-p", "--plot", type=str, default="plot.png",
	help="path to output loss/accuracy plot")
args = vars(ap.parse_args())

# initialize the number of epochs to train for, initial learning rate,
# and batch size
EPOCHS = 500
INIT_LR = 1e-3
BS = 125

signalLength = 256; #This represent the length of the vector overal

# grab the audio path will train on all the data within the database
audioPaths = sorted(list(paths.list_images(args["dataset"])))
random.seed(42)
random.shuffle(imagePaths)

# loop over the custom envolope images
for envolopeImages in envolopePaths:
	#Load the processed envelopes and store it in the data list_images
	envolope = pd
