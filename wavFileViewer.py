import matplotlib.pyplot as plt
import numpy as np
import wave
import sys


spf = wave.open('/home/auscultechdx/Documents/ICBHI_final_database/101_1b1_Pr_sc_AKGC417L.wav','r')

#Extract Raw Audio from Wav File
signal = spf.readframes(-1)
signal = np.fromstring(signal, 'Int16')


#If Stereo
if spf.getnchannels() == 2:
    print 'Just mono files'
    sys.exit(0)

plt.figure(1)
plt.title('Signal Wave...')
plt.plot(signal)
plt.show()
