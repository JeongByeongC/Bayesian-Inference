# Bayesian-Inference

This repository contains MATLAB code for Bayesian inference and modeling, inspired by Pattern Recognition and Machine Learning (Bishop, 2006) and the research paper “Use It and Improve It or Lose It: Interactions between Arm Function and Use in Humans Post-stroke” by Yukikazu Hidaka et al. The project demonstrates Bayesian parameter estimation for linear equations and extends the concept to function and use models in the context of human behavior and recovery.


## Overview

This repository includes examples and tools for applying Bayesian inference to various models. The primary goal is to provide an understanding of how Bayesian approaches can be applied to infer parameters, assess uncertainty, and model interactions between functional use and recovery dynamics.

---

### Key Features

  1. Bishop Example:

 + Demonstrates Bayesian inference for parameter estimation in a linear equation:

   $y = w_0 + w_1x$
   
 + Incorporates Gaussian noise for data variability.

 + Shows how data quantity affects the accuracy of parameter estimation.

 + Includes posterior distribution visualization and likelihood calculations.


  2. Function and Use Modeling:

+ Implements models for human functional recovery and use dynamics based on the Yukikazu Hidaka et al. study.

+ Provides tools to esimate parameters for:
    + **Function Model**: Models changes in functional ability over time.
 
    + **Use Model**: Describes the relationship between functional use and success strength.
 
+ Uses Bayesian inference to estimate model parameters and assess their uncertainty.

---

### Files and Descriptions

1. Bishop Example

+ bishop_example.m: Demonstrates parameter estimation for a simple linear equation using Bayesian inference. Includes two sections:

	+ Known parameters ( $\alpha$  and  $\beta$ ) for understanding fitting with varying data quantities.

	+ Unknown parameters ( $\alpha$  and  $\beta$ ) with minimal data to demonstrate inference accuracy.

+ likelihood.m: Generates the likelihood function for visualizing the parameter space.

+ posterior.m: Computes posterior variance and standard deviation for Bayesian updates.

+ posterior_predictive.m: Generates predictions using posterior mean and variance.

+ fit.m: Bayesian inference implementation for parameter updates.

+ isclose.m: Checks parameter stability by assessing small changes during updates.

+ f.m: Linear equation function for Bishop example.

2. Function and Use Model

+ function_and_use.m: Implements models for functional recovery and use dynamics, including:

	+ Use Model:
 
		$use(t+1) = w_1 \cdot use(t) + w_2 \cdot function(t) + w_3 \cdot success_strength(t) + w_4$

	+ Function Model:
 
 		$function(t+1) = (1 - w_1) \cdot function(t) + w_1 \cdot use(t)$$

### Dependencies

+ MATLAB R2020b or later

+ No additional toolboxes are required

### Reference

1. Pattern Recognition and Machine Learning

+ Author: Christopher Bishop

+ Publisher: Springer, 2006

2. Use It and Improve It or Lose It: Interactions between Arm Function and Use in Humans Post-stroke

+ Authors: Yukikazu Hidaka, Cheol E Han, Steven L Wolf, Carolee J Winstein, Nicolas Schweighofer

+ Journal: PLoS Computational Biology, 2012
