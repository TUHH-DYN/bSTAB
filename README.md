# bSTAB
## An open-source software for computing the basin stability of nonlinear multi-stable dynamical systems

Hamburg University of Technology, Dynamics Group, www.tuhh.de/dyn

Developed by Merten Stender, m.stender@tuhh.de

[![DOI](https://zenodo.org/badge/278140661.svg)](https://zenodo.org/badge/latestdoi/278140661)


Many nonlinear dynamical systems exhibit *multi-stability*: at a fixed parameter configuration, the system has more than one possible steady-state solution. The time-asymptotic behavior hence solely depends on the initial condition or instantaneous perturbations from which the trajectories evolve. Conceptually, the sensitivity of the steady-state behavior is prescribed by the shape of the basins of attraction (the sets in state space that collect all states leading to the same attracting set). Classical local stability metrics (perturbation-based linearization) assess the stability of a state against *small perturbations*, i.e. stating wheather the system will return back to the same attractor after being perturbed. However, the size of small perturbations is not strictly defined. Moreover, even small perturbations may result in a different steady-state solution if the system exibits multi-stability. 

The concept of **basin stability** [1] introduces a global stability metric including *small* and *large* perturbations into the stability analysis. Using Monte-Carlo sampling, an estimate for the basin stability is given by the volumetric share of a basin of attraction within the state space. For a k=3 multi-stable system (having three stable steady-state solutions), the basin stability values are 

    S(1) = V(1)/V, S(2) = V(2)/V, S(3) = V(3)/V, 
  
where V(i) denotes the volume of the ith basin of attraction, and V is the volume of the full state space (or a relevant subset selected for the analysis). While the theoretical concept is rather simplistic, the implementation of a consistent and robust basin stability computation is not straight-forward. Furthermore, the practical basin stability computation involves several hyperparameters, which affect the results strongly if not chosen correctly. The sensitivity of the basin stability values against those hyperparameters calls for a highly automated computing pipeline that enables the user to perform grid-based searching for optimal hyperparameter selection. 

This toolbox **bSTAB** introduces a programming framework for the computation of basin stability values for time-continuous nonlinear dynamical systems. The toolbox equips the user with easy-to-use routines that require only minimal inputs and coding. The dynamics expert must set up the computation case by specifying the system-related settings, such as the range of initial conditions to be studied, system parameter values, and template solutions for each of the a-priori known multi-stable solutions. Hereafter, the toolbox allows to compute the basin stability values by a total of 3 lines of code. Hyperparameter studies and variations of the basin stability along model parameter variations can be run in the same fashion without requiring any additional coding. 

bSTAB shall foster collaborative research and interdisciplinary communication in the vast field of nonlinear dynamics. We aim at equipping researchers and practitioners with a ready-to-use code, that will help to integrate the basin stability analysis into the toolbox of stability analysis. The open-source code concepts will help to grow the functionalities of bSTAB, integrate more use cases and potentially migrate the current implementation to other, more efficient, programming languages.   


[1] Menck, P., Heitzig, J., Marwan, N. et al. How basin stability complements the linear-stability paradigm. Nature Phys 9, 89–92 (2013). https://doi.org/10.1038/nphys2516 


# Overview and tutorial case

Current tutorial cases:
- damped driven pendulum (bi-stable)
- multi-stable Duffing oscillator (5 co-existing limit cycles)
- Lorenz system (co-existing chaotic attractors)
- non-smooth friction oscillator (bi-stable)


Details coming soon!
