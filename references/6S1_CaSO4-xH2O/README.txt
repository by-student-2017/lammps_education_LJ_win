##############################################################
# EXAMPLE EINSTEIN CRYSTAL THERMODYNAMIC INTEGRATION SCRIPTS #
# Dr S. R. Yeandel                                           #
# 12/05/2022                                                 #
##############################################################

In this directory are example input scripts for computing the Gypsum {0 1 0} surface (ein_lambda=0.5 and pot_lambda=1.0 in this case).

To obtain the value of d_U/d_lambda at this point of the pathway:
1.	Run the simulation in the '1_production_run' directory.
2.	Copy/link the produced 'prod_traj.lmp.gz' from inside '1_production_run' to inside both '2_delta_minus' and '3_delta_plus'.
3.	Run the (very quick) calculations in '2_delta_minus' and '3_delta_plus' and record the output average potential energies.
4.	Compute d_U/d_lambda by central differences, taking into account the multiplicative perturbation of f(lambda) and the chain rule:
	d_U/d_lambda = f'(lambda)*(delta_plus-delta_minus)/(2*(0.01*f(lambda)))
	where the value of 0.01 = 1% perturbation of f(lambda).
	f'(lambda) is the analytical derivative of f(lambda) with respect to lambda.

Repeat this procedure with different lambda values to fully sample the thermodynamic pathway.
Numerically integrate d_U/d_lambda with respect to lambda to obtain delta_F for the thermodynamic pathway.
Repeat this procedure for other thermodynamic pathways as required to obtain the full transformation desired.

IMPORTANT NOTES:
1.	Simulation equilibration time, production time and sampling frequency are controlled from 'input.lmp'.
2.	The values for the points along the thermodynamic pathway are controlled from 'einstein.lmp'.
3.	The starting coordinates for every point along the pathway MUST be identical when the harmonic wells are on.
	This is because the initial positions are used for the equilibrium positions of the wells.
4.	The 'input.lmp' script in '2_delta_minus' and '3_delta_plus' re-computes the potential energy from an already existing trajectory.
	The values of 'Esample' and 'screen' must be set the same as in the production input script.
5.	To use these scripts for bulk phases the 'fix x_walls...' and 'include slab_correction.lmp' commands in 'input.lmp' simply need to be removed.


