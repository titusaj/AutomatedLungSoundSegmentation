AutomatedLungSoundSegmenetation

This project deals with automated lung sound segmentation.

Day 1: Found this intresting paper out Turkey that uses dyanamic time warping (DTW) to fit the lung sounds intiatlly. Have alot of the preprocessing methods already build for parsing raw lungs sounds and there assocaited ground truth from the DSW paper. Going to revive this work as a fist step to implementing the segmenetation methods.

Day 2: Still trying to figure out how to implement the smooth version of the power band of the spectogram transform, working on getting that working with a hanning window implementation

Day 3: Going to work on the deep learning version of this implemetnation today. Working with tensorflow to implement a LSTM.

Day 4: Still working on how to insert this into an LSTM for segmentatition not finding any examples whre they are putting the ground truth into the proccessing pipeline.

Day 5: Figuring out how to do the ground truth segmentation smoothing function to match what is seen in the paper

Day 6: Figured out the problem in how the mean energy was be calculated,working out how to fix this power represenation problem.

Day 7: Working out how to create the network for processing the dataflow in the system.

Day 8: Got the envolopes of intrest that go into the network, need to figure outthe insertion into the network today, go input as a 4 layer input.

Day 9: Got the envolope model figured out where just create a symetrical unet model for input into the system.

Day 10: Starting out in the morning with trying to preprocess all the data arrays for insertion into the model.

Day 11: Pausing unet implementation for right now having trouble with the memory allocation working out how to get the model workinng with out this.

Day 12: Got the test paradigm working out now and getting the expected overfit result, now got to work out why the output for this model is so big.
