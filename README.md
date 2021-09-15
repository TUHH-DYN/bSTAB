# bSTAB
## An open-source software for computing the basin stability of nonlinear multi-stable dynamical systems

Hamburg University of Technology, Dynamics Group, www.tuhh.de/dyn

Developed by Merten Stender, m.stender@tuhh.de

Reference the code by [![DOI](https://zenodo.org/badge/278140661.svg)](https://zenodo.org/badge/latestdoi/278140661)

**Full (open access) paper published in Nonlinear Dynamics:** https://link.springer.com/article/10.1007/s11071-021-06786-5


Many nonlinear dynamical systems exhibit *multi-stability*: at a fixed parameter configuration, the system has more than one possible steady-state solution. The time-asymptotic behavior hence solely depends on the initial condition or instantaneous perturbations from which the trajectories evolve. Conceptually, the sensitivity of the steady-state behavior is prescribed by the shape of the basins of attraction (the sets in state space that collect all states leading to the same attracting set). Classical local stability metrics (perturbation-based linearization) assess the stability of a state against *small perturbations*, i.e. stating whether the system will return back to the same attractor after being perturbed. However, the size of small perturbations is not strictly defined. Moreover, even small perturbations may result in a different steady-state solution if the system exhibits multi-stability. 

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

## Damped driven pendulum: bi-stability

The damped driven pendulum 

    dy_1 /dt = y_2
    dy_2 /dt = -a* y_1 + T - K*sin(y_1)

exhibits bi-stability (competing fixed point and limit cycle solution) for specific parameter settings (e.g. a=0.1, K=1.0, T=0.5) as descriped by Menck et al. [1]. Both solutions are stable from a local perspective (negative real part, Floquet multiplier smaller than unity), such that the time-asymptotic behavior of the pendulum solely depends on the initial condition from which it is started. The basin stability analysis will now analyse the probabilities of arriving on either the fixed point (FP) or the limit cycle (LC) solution by sampling a set of N initial conditions from a region of interest selected by the user. The probabilities are proportional to the volumes of the basins of attraction within the region of interest, i.e. a subset of the state space. 

Running the basin stability analysis using **bSTAB** comes down to 

```Matlab
current_case = 'pendulum_case1';
[props] = init_bSTAB(currentCase);
[props] = setup_pendulum(props);
[res_tab, res_detail, props] = compute_bs(props);
```

which initializes the toolbox and sets a name for the current case study. The case is defined by the user in setup_pendulum function, and the basin stability analysis is run by calling the compute_bs routine. The results can be visualized by calling several pre-defined plotting functionalities

```Matlab
plot_bs_bargraph(props, res_tab, true);
plot_bs_statespace(props, res_detail, 1, 2);
```
As a result, the basin stability values are shown by means of a bar plot. In this case, there is a probability of 15% to arrive on the fixed point solution, whereas there is a probability of 85% to arrive on the limit cycle solution. One may hence state that the LC solution is *globally more stable* than the FP solution. The Monte Carlo sampling states are depicted in state space and colored by their time-asymptotic behavior. Even for this small system, the shape of the basins of attraction is complicated. 

![basin stability bar graph](https://github.com/TUHH-DYN/bSTAB/blob/master/bSTAB-M/case_pendulum/fig_basinstability.png)
![state space graph](https://github.com/TUHH-DYN/bSTAB/blob/master/bSTAB-M/case_pendulum/fig_statespace.png)
