LAMMPS USER-CGSDK example problems

Each of these sub-directories contains a sample problem for the SDK
coarse grained MD potentials that you can run with LAMMPS.

These are the two sample systems

peg-verlet:	coarse grained PEG surfactant/water mixture lamella
		verlet version
		this example uses the plain LJ term only, no charges.
		two variants are provided regular harmonic angles and
		the SDK variant that includes 1-3 LJ repulsion.

sds-monolayer:  coarse grained SDS surfactant monolayers at water/vapor
		interface.
		this example uses the SDK LJ term with coulomb and shows
		how to use the combined coulomb style vs. hybrid/overlay
		with possible optimizations due to the small number of
		charged particles in this system
