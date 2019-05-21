import numpy as np
import os

import numpy as np
from keras.preprocessing import sequence
from keras.models import Sequential
from keras.layers import Dense, Dropout, Activation
from keras.layers import Embedding, Reshape
from keras.layers import Conv1D, MaxPooling1D, UpSampling1D, Conv2D, MaxPooling2D, Flatten
from keras.callbacks import ModelCheckpoint, LearningRateScheduler
from keras import regularizers

import keras.backend as K

def unetLungNet(): #This represents a 256 x1 x4 array that is input into the network
    '''
    input_shape=(882000,1)
    n_classes = 1
    model = Sequential()
    model.add(Conv1D(filters=8, kernel_size=3, activation='relu', input_shape=(882000,1)))
    model.add(MaxPooling1D(pool_size=2))
    model.add(Conv1D(filters=8, kernel_size=3, activation='relu'))
    model.add(MaxPooling1D(pool_size=2))
    model.add(Dropout(0.5))
    model.add(MaxPooling1D(pool_size=2))
    model.add(Flatten())
    model.add(Dense(100, activation='relu'))
    model.add(Dense(1, activation='softmax'))
    model.compile(loss='categorical_crossentropy', optimizer='adam', metrics=['accuracy'])
    '''
#    model.compile( loss='categorical_crossentropy', optimizer=keras.optimizers.SGD(), metrics=[keras.metrics.categorical_accuracy])
    model = Sequential()
    model.add(Conv1D(8, 3, activation = 'relu', padding = 'same', kernel_initializer = 'he_normal',input_shape=(882000,1)))
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

    model.add(Conv1D(64, 2, activation = 'relu', padding = 'same', kernel_initializer = 'he_normal')(UpSampling1D(size = 2)))
    model.add(concatenate([drop4,up6], axis = 3))
    model.add(Conv1D(64, 3, activation = 'relu', padding = 'same', kernel_initializer = 'he_normal'))
    model.add(Conv1D(64, 3, activation = 'relu', padding = 'same', kernel_initializer = 'he_normal'))

    model.add(Conv1D(32, 2, activation = 'relu', padding = 'same', kernel_initializer = 'he_normal')(UpSampling1D(size = 2)))
    model.add(concatenate([conv3,up7], axis = 3))
    model.add(Conv1D(32, 3, activation = 'relu', padding = 'same', kernel_initializer = 'he_normal'))
    model.add(Conv1D(32, 3, activation = 'relu', padding = 'same', kernel_initializer = 'he_normal'))

    model.add(Conv1D(16, 2, activation = 'relu', padding = 'same', kernel_initializer = 'he_normal')(UpSampling1D(size = 2)))
    model.add(concatenate([conv2,up8], axis = 3))
    model.add(Conv1D(16, 3, activation = 'relu', padding = 'same', kernel_initializer = 'he_normal'))
    model.add(Conv1D(16, 3, activation = 'relu', padding = 'same', kernel_initializer = 'he_normal'))

    model.add(Conv1D(8, 2, activation = 'relu', padding = 'same', kernel_initializer = 'he_normal')(UpSampling1D(size = 2)))
    model.add(concatenate([conv1,up9], axis = 3))
    model.add(Conv1D(8, 3, activation = 'relu', padding = 'same', kernel_initializer = 'he_normal'))
    model.add(Conv1D(8, 3, activation = 'relu', padding = 'same', kernel_initializer = 'he_normal'))
    model.add(Conv1D(8, 3, activation = 'relu', padding = 'same', kernel_initializer = 'he_normal'))

    '''
        model.add(Flatten())
        model.add(Dense(100, activation='relu'))
        model.add(Dense(882000, activation='softmax'))
        model.compile(loss='categorical_crossentropy', optimizer='adam', metrics=['accuracy'])
    '''


    model.summary()

    return model
