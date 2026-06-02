# Neurodynamical Saliency WAvelet Model (NSWAM)
---
NSWAM is an open source implementation of a saliency and scanpath models cited below:
> Berga, D. & Otazu, X. (2022). A Neurodynamical model of Saliency prediction in V1. [(Official) Neural Computation](https://doi.org/10.1162/neco_a_01464) / [arXiv preprint](https://arxiv.org/abs/1811.06308) -> https://doi.org/10.1162/neco_a_01464

<br><img width="500" height="154" alt="image" src="https://github.com/user-attachments/assets/a1a7ef9d-7bf5-4334-bdbb-8866c34fc106" /><br>
<img width="500" height="456" alt="image" src="https://github.com/user-attachments/assets/55011713-5f18-472a-95e1-56cb9d7a29ec" />

# Neurodynamical Saliency WAvelet Model with Cortical Magnification (NSWAM-CM) and top-down control (Inhibition of Return and Task/Search) 
> Berga, D. & Otazu, X. (2019). Modeling Bottom-Up and Top-Down Attention with a Neurodynamic Model of V1. [(Official) Neurocomputing](https://doi.org/10.1016/j.neucom.2020.07.047) / [bioRxiv preprint](http://dx.doi.org/10.1101/590174) -> https://doi.org/10.1016/j.neucom.2020.07.047
<img width="500" height="219" alt="image" src="https://github.com/user-attachments/assets/e3afc04e-b84f-4c40-b38d-53e2216e9984" />
<img width="500" height="229" alt="image" src="https://github.com/user-attachments/assets/040ec979-a64e-46c6-a182-dc2f0bfbac2d" />
<img width="500" height="271" alt="image" src="https://github.com/user-attachments/assets/4a12c2b6-b47a-4188-849b-d37b66f54183" />
<img width="500" height="227" alt="image" src="https://github.com/user-attachments/assets/b6618133-a8d1-4313-a8b2-cc8487ee0e8d" />
<img width="500" height="118" alt="image" src="https://github.com/user-attachments/assets/81554e68-0ca6-4c1f-8462-33386ea731c1" />

#### RUN
> Run "run.m" to run the model to read several images from "input/" folder with "conf/single" parameters.

> Otherwise, to run an individual image you must run "saliency_nswam.m" (or "nswam.m" by specifying each parameter), by setting the input RGB file (directly from imread) and its path.

> Plot paper figures with "src/plot_metrics_spec_several.m"
> Plot other paper figures with "src/plot_dynamics.m", "src/plot_dynamics_several.m", "src/plot_scanpaths.m"

***Notes (input)***
1. Input images are by default in "input/" and in ".png" format.
2. Configuration parameter files are set by default to "conf/single" (NSWAM) or "conf/scanpath" (NSWAM-CM). Configuration parameters are listed in README.txt and described in "src/confgen_all.m"

***Notes (output)***
1. Output files will be in "output/" with images (by default in ".png") and scanpaths. Other folders such as "gazes", "mean" ... describe the gaze-wise and accumulative gaze-wise saliency maps.
2. Files with dynamical information (membrane time x iteration x channel x scales x orientations x height x width) matrixes will be saved by default in "mats/"

#### BENCHMARK

Check my [saliency benchmark code](https://github.com/dberga/saliency) for running the experiments and/or download the saliency maps and datasets' ground truth.

#### Citing NSWAM and NSWAM-CM:

````
@article{10.1162/neco_a_01464,
    author = {Berga, David and Otazu, Xavier},
    title = "{A Neurodynamic Model of Saliency Prediction in V1}",
    journal = {Neural Computation},
    volume = {34},
    number = {2},
    pages = {378-414},
    year = {2022},
    month = {01},
    issn = {0899-7667},
    doi = {10.1162/neco_a_01464},
    url = {https://doi.org/10.1162/neco\_a\_01464},
    eprint = {https://direct.mit.edu/neco/article-pdf/34/2/378/1982874/neco\_a\_01464.pdf},
}
@article{BERGA2020270,
    title = {Modeling bottom-up and top-down attention with a neurodynamic model of V1},
    journal = {Neurocomputing},
    volume = {417},
    pages = {270-289},
    year = {2020},
    issn = {0925-2312},
    doi = {https://doi.org/10.1016/j.neucom.2020.07.047},
    url = {https://www.sciencedirect.com/science/article/pii/S0925231220311553},
    author = {David Berga and Xavier Otazu}
}
````
