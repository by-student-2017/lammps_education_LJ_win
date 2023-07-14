package require solvate

set mid [mol load psf xyloglucan.psf pdb xyloglucan.pdb]
set all [atomselect $mid "all"]
$all moveby [vecscale -1 [measure center $all]]
$all move [transaxis z -25]
$all move [transaxis y 20]
$all writepdb reorient.pdb
solvate xyloglucan.psf reorient.pdb -minmax [list [list -35 -35 -35] [list 35 35 35]] -o xylosolv
exit