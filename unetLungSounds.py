import numpy as np
import os


import tensorflow as tf
from tensorflow import keras

import numpy as np
from keras.preprocessing import sequence
from keras.models import Sequential
from keras.layers import Dense, Dropout, Activation
from keras.layers import Embedding, Reshape
from keras.layers import Conv1D, MaxPooling1D, UpSampling1D, Conv2D, MaxPooling2D, Flatten
from keras.callbacks import ModelCheckpoint, LearningRateScheduler
from keras import regularizers




def down_block(x, filters, kernel_size=(3), padding="same", strides=1):
    c = keras.layers.Conv1D(filters, kernel_size, padding=padding, strides=strides, activation="relu")(x)
    c = keras.layers.Conv1D(filters, kernel_size, padding=padding, strides=strides, activation="relu")(c)
    p = keras.layers.MaxPool1D((2))(c)
    return c, p

def up_block(x, skip, filters, kernel_size=(3), padding="same", strides=1):
    print('Got here3')
    print(x.shape)
    us = keras.layers.UpSampling1D((2))(x)
    print(us.shape)
    print(skip.shape)
    concat = keras.layers.Concatenate()([us, skip])
    c = keras.layers.Conv1D(filters, kernel_size, padding=padding, strides=strides, activation="relu")(concat)
    c = keras.layers.Conv1D(filters, kernel_size, padding=padding, strides=strides, activation="relu")(c)
    return c

def bottleneck(x, filters, kernel_size=(3), padding="same", strides=1):
    c = keras.layers.Conv1D(filters, kernel_size, padding=padding, strides=strides, activation="relu")(x)
    c = keras.layers.Conv1D(filters, kernel_size, padding=padding, strides=strides, activation="relu")(c)
    return c

def unetLungNet(): #This represents a 256 x1 x4 array that is input into the network
    f = [8, 16, 32, 64,128]
    inputs = keras.layers.Input((None,882000))
    print('got here 1')
    p0 = inputs
    c1, p1 = down_block(p0, f[0]) #128 -> 64
    c2, p2 = down_block(p1, f[1]) #64 -> 32
    c3, p3 = down_block(p2, f[2]) #32 -> 16
    c4, p4 = down_block(p3, f[3]) #16->8

    print('got here 2')
    bn = bottleneck(p4, f[4])

    u1 = up_block(bn, c4, f[3]) #8 -> 16
    u2 = up_block(u1, c3, f[2]) #16 -> 32
    u3 = up_block(u2, c2, f[1]) #32 -> 64
    u4 = up_block(u3, c1, f[0]) #64 -> 128
    print('got here 4')

    '''
    model.add(Flatten())
    model.add(Dense(100, activation='relu'))
    model.add(Dense(882000, activation='softmax'))
    model.compile(loss='categorical_crossentropy', optimizer='adam', metrics=['accuracy'])

    '''


    outputs = keras.layers.Dense(882000, activation='softmax')(u4)
    #outputs = keras.layers.Conv1D(882000, padding="same", activation="sigmoid")(u4)
    model = keras.models.Model(inputs, outputs)

    return model


    '''
    #UpSampling Layers
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
    model.add(MaxPooling1D(pool_size=2))

    model.add(Conv1D(128, 3, activation = 'relu', padding = 'same', kernel_initializer = 'he_normal'))
    model.add(Conv1D(128, 3, activation = 'relu', padding = 'same', kernel_initializer = 'he_normal'))
    model.add(MaxPooling1D(pool_size=2))


    #Bottleneck layer
    model.add(Conv1D(64, 2, activation = 'relu', padding = 'same', kernel_initializer = 'he_normal'))
    model.add(UpSampling1D(size = 2))
    model.add(concatenate([drop4,up6], axis = 2))

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
