package require topotools
package require pbctools
mol load psf ../CHARMM/5dfr_solv.xplor.psf pdb ../CHARMM/minimized.pdb
topo writegmxtop dhfr.top [list ../../toppar/par_all36_prot.prm ../../toppar/par_all36_carb.prm]
pbc set [list 62.23 62.23 62.23 90 90 90]
pbc wrap -now -compound fragment -centersel "protein" -center com
[atomselect top "all"] writepdb minimizedrecentered.pdb
exit