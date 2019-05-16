import numpy as np
import os

import numpy as np
from keras.preprocessing import sequence
from keras.models import Sequential
from keras.layers import Dense, Dropout, Activation
from keras.layers import Embedding
from keras.layers import Conv1D, MaxPooling1D
from keras.callbacks import ModelCheckpoint, LearningRateScheduler

import keras.backend as K

def unetLungNet(): #This represents a 256 x1 x4 array that is input into the network
    model = Sequential()
    model.add(Conv1D(8, 3, activation = 'relu', padding = 'same', kernel_initializer = 'he_normal',input_shape=(None,1)))
    model.add(Conv1D(8, 3, activation = 'relu', padding = 'same', kernel_initializer = 'he_normal'))
    model.add(MaxPooling1D(pool_size=2))

    model.add(Conv1D(16, 3, activation = 'relu', padding = 'same', kernel_initializer = 'he_normal'))
    model.add(Conv1D(16, 3, activation = 'relu', padding = 'same', kernel_initializer = 'he_normal'))
    model.add(MaxPooling1D(pool_size=2))

    model.add(Conv1D(32, 3, activation = 'relu', padding = 'same', kernel_initializer = 'he_normal'))
    model.add(Conv1D(32, 3, activation = 'relu', padding = 'same', kernel_initializer = 'he_normal'))
    model.add(MaxPooling1D(pool_size=2))

    model.add(Conv1D(64, 3, activation = 'relu', padding = 'same', kernel_initializer = 'he_normal'))
    model.add(Conv1D(64, 3, activation = 'relu', padding = 'same', kernel_initializer = 'he_normal'))
    model.add(Dropout(0.5))
    model.add(MaxPooling1D(pool_size=2))

    model.add(Conv1D(128, 3, activation = 'relu', padding = 'same', kernel_initializer = 'he_normal'))
    model.add(Conv1D(128, 3, activation = 'relu', padding = 'same', kernel_initializer = 'he_normal'))
    model.add(Dropout(0.5))

    model.add(Conv1D(64, 2, activation = 'relu', padding = 'same', kernel_initializer = 'he_normal'))
    model.add(concatenate([drop4,up6], axis = 3))
    model.add(Conv1D(64, 3, activation = 'relu', padding = 'same', kernel_initializer = 'he_normal'))
    model.add(Conv1D(64, 3, activation = 'relu', padding = 'same', kernel_initializer = 'he_normal'))

    model.add(Conv1D(32, 2, activation = 'relu', padding = 'same', kernel_initializer = 'he_normal'))
    model.add(concatenate([conv3,up7], axis = 3))
    model.add(Conv1D(32, 3, activation = 'relu', padding = 'same', kernel_initializer = 'he_normal'))
    model.add(Conv1D(32, 3, activation = 'relu', padding = 'same', kernel_initializer = 'he_normal'))

    model.add(Conv1D(16, 2, activation = 'relu', padding = 'same', kernel_initializer = 'he_normal')(UpSampling1D(size = 2)))
    model.add(concatenate([conv2,up8], axis = 3))
    model.add(Conv1D(16, 3, activation = 'relu', padding = 'same', kernel_initializer = 'he_normal'))
    model.add(Conv1D(16, 3, activation = 'relu', padding = 'same', kernel_initializer = 'he_normal'))

    model.add(Conv1D(8, 2, activation = 'relu', padding = 'same', kernel_initializer = 'he_normal')(UpSampling1D(size = 2))
    model.add(concatenate([conv1,up9], axis = 3))
    model.add(Conv1D(8, 3, activation = 'relu', padding = 'same', kernel_initializer = 'he_normal'))
    model.add(Conv1D(8, 3, activation = 'relu', padding = 'same', kernel_initializer = 'he_normal'))
    model.add(Conv1D(8, 3, activation = 'relu', padding = 'same', kernel_initializer = 'he_normal'))


    model = Model(input = inputs, output = conv10)  

    model.compile(optimizer = Adam(lr = 1e-4), loss = 'binary_crossentropy', metrics = ['accuracy'])

    #model.summary()

    if(pretrained_weights):
    	model.load_weights(pretrained_weights)

    return model
