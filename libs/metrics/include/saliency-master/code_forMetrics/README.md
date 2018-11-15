Code to compute the saliency metrics as used for benchmarking saliency models in http://saliency.mit.edu.

Note that the binary human fixation map (zero matrix with 1s at exact locations of fixations) is used as the fixationMap argument to most of the metrics. If, however, a continuous map is required (e.g. for CC and similarity computations), then the binary human fixation map is blurred. Specifically, we use the antonioGaussian.m low-pass filter with cut off frequency fc = 8 cycles per image, which is approximately equivalent to 1 degree of visual angle.
