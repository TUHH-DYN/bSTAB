# bSTAB

Hamburg University of Technology,

Dynamics Group

www.tuhh.de/dyn


Open-source software for computing the basin stability of nonlinear multi-stable dynamical systems

[![DOI](https://zenodo.org/badge/278140661.svg)](https://zenodo.org/badge/latestdoi/278140661)



The pervasiveness of multi-stability in nonlinear dynamical systems calls for novel concepts of stability and a consistent quantification of long-term behavior. The basin stability is a global stability metric that builds on estimating the basin of attraction volumes by Monte Carlo sampling. The computation involves extensive numerical time integrations, attractor characterization, and clustering of trajectories. We introduce \texttt{bSTAB}, an open-source software project that aims at enabling researchers to efficiently compute the basin stability of their dynamical systems with minimal efforts and in a highly automated manner. The source code, available at \url{https://github.com/TUHH-DYN/bSTAB/}, is available for the programming language \texttt{Matlab} featuring parallelization for distributed computing, automated sensitivity and bifurcation analysis as well as plotting functionalities. We illustrate the versatility and robustness of \texttt{bSTAB} for four canonical dynamical systems from several fields of nonlinear dynamics featuring periodic and chaotic dynamics, complicated multi-stability, non-smooth dynamics, and fractal basins of attraction. The \texttt{bSTAB} projects aims at fostering interdisciplinary scientific collaborations in the field of nonlinear dynamics and is driven by the interaction and contribution of the community to the software package.

Following
Menck, P., Heitzig, J., Marwan, N. et al. How basin stability complements the linear-stability paradigm. Nature Phys 9, 89–92 (2013). https://doi.org/10.1038/nphys2516 
