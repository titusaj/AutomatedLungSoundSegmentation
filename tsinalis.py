def tsinalis(input_shape, n_classes):
    """
    Input size should be [batch, 1d, 2d, ch] = (None, 1, 15000, 1)
    """
    model = Sequential(name='Tsinalis')
    model.add(Conv1D (kernel_size = (200), filters = 20, input_shape=input_shape, activation='relu'))
    print(model.input_shape)
    print(model.output_shape)
    model.add(MaxPooling1D(pool_size = (20), strides=(10)))
    print(model.output_shape)
    model.add(keras.layers.core.Reshape([20,-1,1]))
    print(model.output_shape)
    model.add(Conv2D (kernel_size = (20,30), filters = 400, activation='relu'))
    print(model.output_shape)
    model.add(MaxPooling2D(pool_size = (1,10), strides=(1,2)))
    print(model.output_shape)
    model.add(Flatten())
    print(model.output_shape)
    model.add(Dense (500, activation='relu'))
    model.add(Dense (500, activation='relu'))
    model.add(Dense(n_classes, activation = 'softmax',activity_regularizer=keras.regularizers.l2()  ))
    model.compile( loss='categorical_crossentropy', optimizer=keras.optimizers.SGD(), metrics=[keras.metrics.categorical_accuracy])
    return model
