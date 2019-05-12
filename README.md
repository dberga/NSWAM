Neurodynamical Saliency WAvelet Model
---
NSWAM is an open source implementation of a saliency model cited below:
> Berga, D. & Otazu, X. (2018). A Neurodynamical model of Saliency prediction in V1. [arXiv preprint](https://arxiv.org/abs/1811.06308) arXiv:1811.06308.

#### RUN
> Run "run.m" to run the model to read several images from "input/" folder with "conf/single" parameters.

> Otherwise, to run an individual image you must run "saliency_nswam.m" (or "nswam.m" by specifying each parameter), by setting the input RGB file (directly from imread) and its path.

> Plot paper figures with "src/plot_metrics_spec_several.m"
> Plot other paper figures with "src/plot_dynamics.m", "src/plot_dynamics_several.m", "src/plot_scanpaths.m"

***Notes (input)***
1. Input images are by default in "input/" and in ".png" format.
2. Configuration parameter files are set by default to "conf/single" (NSWAM) or "conf/scanpath" (NSWAM-CM). Configuration parameters are listed in README.txt and described in "src/confgen_all.m"

***Notes (output)***
1. Output files will be in "output/" with images by default in ".png" and scanpaths in a specific folder. Other folders such as "gazes", "mean" ... describe the gaze-wise and accumulative gaze-wise saliency maps.
2. Files with dynamical information (membrane time x iteration x channel x scales x orientations x height x width) matrixes will be saved by default in "mats/"



#### Citing NSWAM and NSWAM-CM:

````
@misc{Berga2018b,
Author = {David Berga and Xavier Otazu},
Title = {A Neurodynamical model of Saliency prediction in V1},
Year = {2018},
Eprint = {arXiv:1811.06308},
}
@article{Berga2019,
  doi = {10.1101/590174},
  url = {https://doi.org/10.1101/590174},
  year = {2019},
  month = apr,
  publisher = {Cold Spring Harbor Laboratory},
  author = {David Berga and Xavier Otazu},
  title = {Modeling Bottom-Up and Top-Down Attention with a Neurodynamic Model of V1}
}
````
