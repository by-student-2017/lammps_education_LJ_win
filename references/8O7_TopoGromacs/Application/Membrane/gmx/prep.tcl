package require topotools
package require pbctools
mol load psf ../charmm-gui/step5_assembly.xplor.psf pdb ../charmm-gui/minimized.pdb
topo writegmxtop memb.top [list ../../toppar/par_all36_prot.prm ../../toppar/par_all36_lipid.prm ../../toppar/par_sodnbfix.prm ../../toppar/par_water_ions.prm ../../toppar/par_all36_na.prm ../../toppar/par_all36_na_additions.prm ]
pbc set [list 111.067 111.067 163.506 90 90 90]
pbc wrap -now -compound fragment -centersel "protein" -center com
[atomselect top "all"] writepdb minimizedrecentered.pdb
exit