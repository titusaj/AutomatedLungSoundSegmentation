import numpy as np
import os


import tensorflow as tf
from tensorflow import keras


import numpy as np
from keras.preprocessing import sequence
from keras.models import Sequential
from keras.layers import Dense, Dropout, Activation
from keras.layers import Embedding, Reshape
from keras.layers import Conv1D, MaxPooling1D, UpSampling1D, Conv2D, MaxPooling2D, Flatten, Concatenate
from keras.callbacks import ModelCheckpoint, LearningRateScheduler
from keras import regularizers



def unetLungNet():
    model = Sequential()

    #1a
    model.add(Conv1D(4, 3, activation = 'relu', padding = 'same', kernel_initializer = 'he_normal',input_shape=(8820,1)))
    model.add(Conv1D(4, 3, activation = 'relu', padding = 'same', kernel_initializer = 'he_normal'))
    model.add(MaxPooling1D(pool_size=2))

    #1b
    model.add(Conv1D(8, 3, activation = 'relu', padding = 'same', kernel_initializer = 'he_normal'))
    model.add(Conv1D(8, 3, activation = 'relu', padding = 'same', kernel_initializer = 'he_normal'))
    model.add(MaxPooling1D(pool_size=2))
    #1c
    model.add(Conv1D(16, 3, activation = 'relu', padding = 'same', kernel_initializer = 'he_normal'))
    model.add(Conv1D(16, 3, activation = 'relu', padding = 'same', kernel_initializer = 'he_normal'))
    model.add(MaxPooling1D(pool_size=2))
    #2
    model.add(Conv1D(128, 3, activation = 'relu', padding = 'same', kernel_initializer = 'he_normal'))
    model.add(Conv1D(128, 3, activation = 'relu', padding = 'same', kernel_initializer = 'he_normal'))
    model.add(MaxPooling1D(pool_size=2))
    #3
    model.add(Conv1D(256, 3, activation = 'relu', padding = 'same', kernel_initializer = 'he_normal'))
    model.add(Conv1D(256, 3, activation = 'relu', padding = 'same', kernel_initializer = 'he_normal'))
    model.add(MaxPooling1D(pool_size=2))
    #4
    model.add(Conv1D(512, 3, activation = 'relu', padding = 'same', kernel_initializer = 'he_normal'))
    model.add(Conv1D(512, 3, activation = 'relu', padding = 'same', kernel_initializer = 'he_normal'))
    model.add(MaxPooling1D(pool_size=2))
    #5
    model.add(Conv1D(1024, 3, activation = 'relu', padding = 'same', kernel_initializer = 'he_normal'))
    model.add(Conv1D(16, 3, activation = 'relu', padding = 'same', kernel_initializer = 'he_normal'))
    model.add(MaxPooling1D(pool_size=2))
    #6
    model.add(Conv1D(1024, 3, activation = 'relu', padding = 'same', kernel_initializer = 'he_normal'))
    model.add(Conv1D(1024, 3, activation = 'relu', padding = 'same', kernel_initializer = 'he_normal'))
    model.add(MaxPooling1D(pool_size=2))
    #7
    model.add(Conv1D(2048, 3, activation = 'relu', padding = 'same', kernel_initializer = 'he_normal'))
    model.add(Conv1D(2048, 3, activation = 'relu', padding = 'same', kernel_initializer = 'he_normal'))
    model.add(MaxPooling1D(pool_size=2))
    #8
    model.add(Conv1D(4096, 3, activation = 'relu', padding = 'same', kernel_initializer = 'he_normal'))
    model.add(Conv1D(4096, 3, activation = 'relu', padding = 'same', kernel_initializer = 'he_normal'))
    model.add(MaxPooling1D(pool_size=2))


    #Dropout
    model.add(Dropout(0.4))
    model.add(MaxPooling1D(pool_size=2))

    #Dense Layers
    model.add(Flatten())
    model.add(Dense(100, activation='relu',kernel_regularizer=regularizers.l2(0.01),
                activity_regularizer=regularizers.l1(0.01)))
    model.add(Dense(8820, activation='softmax'))

    model.compile(loss='binary_crossentropy', optimizer='adam', metrics=['accuracy'])

    return model
