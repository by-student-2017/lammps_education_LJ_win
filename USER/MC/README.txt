This directory has an input script that illustrates how to use LAMMPS
as an energy-evaluation engine in a Monte Carlo (MC) relaxation loop.
It is just an illustration of how to do this for a toy 2d problem, but
the script is fairly sophisticated in its use of variables, looping,
and an if-the-else statement which applies the Boltzmann factor to
accept or reject a trial atomic-displacement move.

The script sets up a perfect 2d hex lattice, then perturbs all
the atom positions to "disorder" the system.  It then
loops in the following manner:

pick a random atom and displace it to a random new position
evaluate the change in energy of the system due to
  the single-atom displacement
accept or reject the trial move
if accepted, continue to the next iteration
if rejected, restore the atom to its original position
  before continuing to the next iteration

The 6 variables at the top of the input script can be adjusted
to play with various MC parameters.

When the script is finished, statistics about the MC procedure
are printed.

Dump file snapshots or images or a movie of the MC relaxation can be
produced by uncommenting the appropriate dump lines in the script.

See the Python script mc.py in python/examples for similar
functionality encoded in a script that invokes LAMMPS as a library.
