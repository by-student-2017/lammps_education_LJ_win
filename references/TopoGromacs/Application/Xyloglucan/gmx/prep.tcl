package require topotools
mol load psf ../INPUT/xylosolv.psf pdb ../INPUT/minimize.coor
topo writegmxtop xyloglucan.top [list ../INPUT/par_all36_carb.prm ]
[atomselect top all] writepdb xylo.pdb
exit