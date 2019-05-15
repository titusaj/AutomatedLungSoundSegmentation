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


from imutils import paths
import matplotlib.pyplot as plt
import pylab
pylab.show
import numpy as np
import argparse
import random
import csv
import os

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
print("[INFO] loading raw vectors in...")
envelopeFiles = []
labels = []

print(args["dataset"])

# define the paths
for filename in os.listdir(args["dataset"]):
	if filename.endswith(".csv"):
		with open(filename) as csv_file:
			csv_reader = csv.reader(csv_file, delimiter=',')
			line_count = 0
			if line_count == 0:
				


labelPath = sorted(list(paths.list_images(args["dataset"])))
random.seed(42)
random.shuffle(labelPath)

# loop over the input envelopes
for envelope in envelopePath:
	# load the image, pre-process it, and store it in the data list
	data.append(envelope)

# loop over the input images
for label in labelPath:
	# load the image, pre-process it, and store it in the data list
	labels.append(label)

# scale the raw pixel intensities to the range [0, 1]
#data = np.array(data, dtype="float") / 255.0
#labels = np.array(labels)

print data.shape
print labels.shape

# split into input (X) and output (Y) variables
X = data
Y = labels


# fix random seed for reproducibility
seed = 7
np.random.seed(seed)

# define 10-fold cross validation test harness
kfold = StratifiedKFold(n_splits=10, shuffle=True, random_state=seed)
kFoldCount = 1
cvscores = []

#Open log file
f = open("logFile.txt", "a")


for train, test in kfold.split(X, Y):
	# initialize the model
	print("[INFO] compiling model...")
	#model = LeNet.build(img_width, img_height, depth=3, classes=2)
	model = LeNet(reduction=0.5, classes=2)
	#model = VGG_16(classes=2)
	opt = Adam(lr=INIT_LR, decay=INIT_LR / (EPOCHS))
	model.compile(loss="binary_crossentropy", optimizer=opt, metrics=["accuracy"])


	Z = to_categorical(Y, num_classes=2)


 	print train.shape
	print test.shape

	print X[train].shape
	print Z[train].shape

	# Set callback functions to early stop training and save the best model so far
	callbacks = [EarlyStopping(monitor='val_loss', patience=2),ModelCheckpoint(filepath='best_model.h5', monitor='val_loss', save_best_only=True)]

	# Fit the model
	print("[INFO] training network...")
	model.fit(X[train], Z[train],epochs= EPOCHS, batch_size=BS, verbose = 1)
	#H = model.fit_generator(aug.flow(X[train], Z[train], batch_size=BS),
	#	validation_data=None, steps_per_epoch=len(X[train]) // BS,
	#	epochs=EPOCHS, verbose=1)

	# save the model to disk
	print("[INFO] serializing network...")
	model.save(args["model"]+str(kFoldCount))
	kFoldCount = kFoldCount + 1

	# evaluate the model
	scores = model.evaluate(X[test], Z[test], verbose=0)
	print("%s: %.2f%%" % (model.metrics_names[1], scores[1]*100))
	f.write("%s: %.2f%%\n" % (model.metrics_names[1], scores[1]*100))
	#f.write("%s: %.2f%%" % (model.metrics_names[1], scores[1]*100))
	cvscores.append(scores[1] * 100)


print("%.2f%% (+/- %.2f%%)" % (np.mean(cvscores), np.std(cvscores)))
f.write("%.2f%% (+/- %.2f%%)\n" % (np.mean(cvscores), np.std(cvscores)))


	# plot the training loss and accuracy
	#plt.style.use("ggplot")
	#plt.figure()
	#N = EPOCHS
	#plt.plot(np.arange(0, N), H.history["loss"], label="train_loss")
	#plt.plot(np.arange(0, N), H.history["val_loss"], label="val_loss")
	#plt.plot(np.arange(0, N), H.history["acc"], label="train_acc")
	#plt.plot(np.arange(0, N), H.history["val_acc"], label="val_acc")
	#plt.title("Training Loss and Accuracy on Wheeze/Not Wheeze")
	#plt.xlabel("Epoch #")
	#plt.ylabel("Loss/Accuracy")
	#plt.legend(loc="lower left")
	#plt.savefig(args["plot"])
