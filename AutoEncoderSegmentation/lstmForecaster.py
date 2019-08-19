inputs2 = Input(shape=(X_train2.shape[1], X_train2.shape[2]))
lstm2 = LSTM(128, return_sequences=True, dropout=0.3)(inputs2, training=True)
lstm2 = LSTM(32, return_sequences=False, dropout=0.3)(lstm2, training=True)
dense2 = Dense(50)(lstm2)
out2 = Dense(1)(dense2)
model2 = Model(inputs2, out2)
model2.compile(loss='mse', optimizer='adam', metrics=['mse'])
model2.fit(X_train2, y_train2, epochs=30, batch_size=128, verbose=2, shuffle=True)


def stoc_drop1(r):
    enc = K.function([encoder.layers[0].input, K.learning_phase()],
                     [encoder.layers[-1].output])
    NN = K.function([model1.layers[0].input, K.learning_phase()],
                    [model1.layers[-1].output])

    enc_pred = np.vstack(enc([x_test, r]))
    enc_pred = np.concatenate([enc_pred, f_test], axis=2)
    NN_pred = NN([enc_pred, r])
    return np.vstack(NN_pred)


scores1 = []
for i in tqdm.tqdm(range(0,100)):
    scores1.append(mean_absolute_error(stoc_drop1(0.5), y_test1))
print(np.mean(scores1), np.std(scores1))
