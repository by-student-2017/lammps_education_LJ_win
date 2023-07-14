package require topotools
mol load psf ../INPUT/waterhexamer.psf pdb ../INPUT/waterhexamer.pdb
topo writegmxtop waterhexamer.top [list ../INPUT/par_water_ions.str ]

exit