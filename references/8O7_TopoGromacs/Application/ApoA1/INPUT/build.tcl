package require psfgen
topology ../../toppar/top_all36_lipid.rtf
topology ../../toppar/top_all36_prot.rtf
topology ../../toppar/top_water_ions.inp

mol new apoa1.pdb
set lip [atomselect top "lipid"]
$lip set segname LIP
set resid 1
foreach residue [lsort -unique [$lip get residue]] {
	set sel [atomselect top "residue $residue"]
	$sel set resid $resid
	$sel delete
	incr resid
}
$lip writepdb lipid.pdb
set prot [atomselect top "segname PRO1"]
$prot writepdb p1.pdb
set prot [atomselect top "segname PRO2"]
$prot writepdb p2.pdb
set wat [atomselect top "water"]
set resid 0
set counter 1
foreach residue [lsort -unique [$wat get residue]] {
	set sel [atomselect top "residue $residue"]
	$sel set resid $resid
	$sel set segname WAT$counter
	$sel delete
	incr resid
	if {$resid == 10000} {
		incr counter
		set resid 0
	}
}
for {set i 1} { $i <= $counter } { incr i } {
	set wat [atomselect top "segname WAT$i"]
	$wat writepdb wat$i.pdb
}

segment P1 {
	pdb p1.pdb
}
coordpdb p1.pdb P1
segment P2 {
	pdb p2.pdb
}
coordpdb p2.pdb P2
segment LIP {
	pdb lipid.pdb
}
coordpdb lipid.pdb LIP
for {set i 1} { $i <= $counter } { incr i } {
	segment WAT$i {
		pdb wat$i.pdb
		auto none
	}
	coordpdb wat$i.pdb WAT$i
	rm wat$i.pdb
}
rm p1.pdb
rm p2.pdb
rm lipid.pdb
guesscoord
writepdb apoa1_36.pdb
writepsf apoa1_36.psf
exit