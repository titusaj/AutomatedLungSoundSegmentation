import numpy as np
import os


import numpy as np
from keras.models import *
from keras.layers import *
from keras.optimizers import *
from keras.callbacks import ModelCheckpoint, LearningRateScheduler
from keras import backend as keras
from keras.backend import transpose

def unetLungNet():
    model = Sequential()

    inputs = Input(shape=(8000,1))

    conv1 = Conv1D(8, 3, activation='relu', padding='same')(inputs)
    conv1 = Conv1D(8, 3, activation='relu', padding='same')(conv1)
    pool1 = MaxPooling1D(pool_size=2)(conv1)

    conv2 = Conv1D(16, 3, activation='relu', padding='same')(pool1)
    conv2 = Conv1D(16, 3, activation='relu', padding='same')(conv2)
    pool2 = MaxPooling1D(pool_size=2)(conv2)

    conv3 = Conv1D(32, 3, activation='relu', padding='same')(pool2)
    conv3 = Conv1D(32, 3, activation='relu', padding='same')(conv3)
    pool3 = MaxPooling1D(pool_size=2)(conv3)

    conv4 = Conv1D(64, 3, activation='relu', padding='same')(pool3)
    conv4 = Conv1D(64, 3, activation='relu', padding='same')(conv4)
    pool4 = MaxPooling1D(pool_size=2)(conv4)

    conv5 = Conv1D(128, 3, activation='relu', padding='same')(pool4)
    conv5 = Conv1D(128, 3, activation='relu', padding='same')(conv5)
    print("Conv5")
    print(conv5.shape)
    print("Conv4")
    print(conv4.shape)

    up_conv5 = UpSampling1D(size = 2) (conv5)

    print("UpSampling1d")
    print(up_conv5.shape)

    up6 = concatenate([UpSampling1D(size=2)(conv5), conv4], axis=2)

    conv6 = Conv1D(64, 3, activation='relu', padding='same')(up6)
    conv6 = Conv1D(64, 3, activation='relu', padding='same')(conv6)

    up7 = concatenate([UpSampling1D(size=2)(conv6), conv3], axis=2)

    conv7 = Conv1D(32, 3, activation='relu', padding='same')(up7)
    conv7 = Conv1D(32, 3, activation='relu', padding='same')(conv7)

    up8 = concatenate([UpSampling1D(size=2)(conv7), conv2], axis=2)

    conv8 = Conv1D(16, 3, activation='relu', padding='same')(up8)
    conv8 = Conv1D(16, 3, activation='relu', padding='same')(conv8)

    up9 = concatenate([UpSampling1D(size=2)(conv8), conv1], axis=2)

    conv9 = Conv1D(8, 3, activation='relu', padding='same')(up9)
    conv9 = Conv1D(8, 3, activation='sigmoid', padding='same')(conv9)

    conv10 = Conv1D(1,1, activation='sigmoid')(conv9)

    model = Model(inputs=[inputs], outputs=[conv10])

    #model.compile(optimizer=Adam(lr=1e-5), loss=dice_coef_loss, metrics=[dice_coef])

    return model


    #model.compile(optimizer = Adam(lr = 1e-4), loss = 'binary_crossentropy', metrics = ['accuracy'])

    #model.summary()

    #return model
