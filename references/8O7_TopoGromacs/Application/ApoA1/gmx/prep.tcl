package require topotools
package require pbctools
mol load psf ../INPUT/apoa1_36.psf pdb ../INPUT/minimized.pdb
topo writegmxtop apoa1.top [list ../../toppar/par_all36_prot.prm ../../toppar/par_all36_lipid.prm ../../toppar/par_water_ions.prm ]
pbc set [list 108.8612 108.8612 77.758 90 90 90]
pbc wrap -now -compound fragment -centersel "protein" -center com
[atomselect top "all"] writepdb minimizedrecentered.pdb
exit