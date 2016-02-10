 ------------------------------------------------------------------------------
 Matlab tools for "Saliency Estimation using a non-parametric vision model"
 
 Contact: Naila Murray at <nmurray@cvc.uab.es>
 ------------------------------------------------------------------------------


--------------
Contents
--------------

This code package includes the following files:

- SWAM_demo.m: loads a sample image and returns and displays a saliency map.

- SWAM.m: converts the image to the opponent colour space, generates a saliency map for each channel and combines these maps to produce the final saliency map.

- rgb2opponent.m: converts the image to the opponent colour space.

- generate_csf.m: returns the value of the csf at a specific relative contrast and spatial frequency.

- DWT.m: performs the forward DWT on one channel of an image.

- IDWT.m: performs the inverse DWT on one channel of an image.

- symmetric_filtering.m: performs 1D Gabor filtering with symmetric edge handling.

- 3.jpg and 35.jpg: sample images.


---------------
Getting Started
----------------

To run the demo, execute SWAM_demo.m


------------------------------------
Suggested values for parameters
------------------------------------

nu_0: peak spatial frequency for CSF; suggested value of 3.7677; suggested range of {3,5}
window sizes: window sizes for computing relative contrast; suggested value of [{11:15} {25:29}]


