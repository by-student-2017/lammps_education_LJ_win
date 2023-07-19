# This geometry is based off of the prism water geometry reported in:
# Structural Studies of the Water Hexamer
# Gina Hincapie, Nancy Acelas, Marcela Castano, Jorge David and Albeiro Restrepo
# Journal of Physical Chemistry A, 2010
# DOI: 10.1021/jp103683m
#

package require psfgen
set data [list O 0.89740000 -1.28511100 1.37567400 H 0.93366000 -1.62024900 0.46129100 H 1.53842400 -0.56327000 1.32598100 O -1.55921800 -0.24177800 1.42347400 H -2.06410200 -0.50196600 2.19746400 H -0.67765600 -0.67864600 1.52523700 O 2.09078900 0.98445200 -0.04569300 H 1.25856800 1.49842100 -0.01864600 H 2.78821600 1.64209800 -0.09388600 O -0.44703200 2.02126000 0.01211400 H -0.90399800 1.53998500 0.71690900 H -0.91108100 1.70047200 -0.77105600 O -1.77668100 -0.21141100 -1.35117600 H -2.56069800 -0.51617900 -1.81406100 H -1.94980100 -0.38724200 -0.40953000 O 0.92440000 -1.33940500 -1.43239500 H 0.04462600 -0.99239900 -1.63526700 H 1.46658100 -0.54508700 -1.34041000]
puts $data
resetpsf
topology top_water_ions.str

segment WAT {
	for { set i 1 } { $i <= 6 } { incr i } {
		residue $i TIP3
	}
	first NONE
	last NONE
}
for { set i 1 } { $i <= 6 } { incr i } {
	puts [lrange $data [expr {1 + 12 * ($i-1)}] [expr {3 + 12 * ($i-1)}]]
	coord WAT $i OH2 [lrange $data [expr {1 + 12 * ($i-1)}] [expr {3 + 12 * ($i-1)}]]
	coord WAT $i H1 [lrange $data [expr {5 + 12 * ($i-1)}] [expr {7 + 12 * ($i-1)}]]
	coord WAT $i H2 [lrange $data [expr {9 + 12 * ($i-1)}] [expr {11 + 12 * ($i-1)}]]
}
writepsf waterhexamer.psf
writepdb waterhexamer.pdb

resetpsf
#This is a cage conformation
set data [ list O -0.61663800 -1.01709300 -1.42595600 H -0.48199700 -1.68747900 -2.10024200 H -0.10522200 -1.33088600 -0.65758600 O 0.71421100 -1.32594900 1.02378500 H 0.17850400 -0.56002400 1.36552800 H 0.64413800 -2.00496200 1.69948000 O 2.83951700 0.01127500 -0.23955200 H 3.65774900 0.13196100 0.24666000 H 2.29497900 -0.56139100 0.32455400 O -0.68983300 0.84373600 1.54471800 H -0.28085500 1.37899700 0.84044400 H -1.59264600 0.71192100 1.21534400 O -2.88022200 -0.00526300 -0.03950300 H -3.53060900 0.46348300 -0.56656200 H -2.26705000 -0.39104600 -0.68464400 O 0.60542900 1.68080900 -0.81328200 H 0.19797400 1.01354700 -1.37809900 H 1.50533400 1.33575100 -0.70655300]
segment WAT {
	for { set i 1 } { $i <= 6 } { incr i } {
		residue $i TIP3
	}
	first NONE
	last NONE
}
for { set i 1 } { $i <= 6 } { incr i } {
	puts [lrange $data [expr {1 + 12 * ($i-1)}] [expr {3 + 12 * ($i-1)}]]
	coord WAT $i OH2 [lrange $data [expr {1 + 12 * ($i-1)}] [expr {3 + 12 * ($i-1)}]]
	coord WAT $i H1 [lrange $data [expr {5 + 12 * ($i-1)}] [expr {7 + 12 * ($i-1)}]]
	coord WAT $i H2 [lrange $data [expr {9 + 12 * ($i-1)}] [expr {11 + 12 * ($i-1)}]]
}
writepdb waterhexamer-cage.pdb

resetpsf
#This is a prism/book. They have been reordered to match the order of the prism
set data [ list  \
O -1.39932500 1.61321800 -0.62078500 H -0.42896500 1.69288100 -0.65405000 H -1.72549500 2.33507000  -1.16257900 \
O -2.23736100 -1.07534800 -0.59133900  H -2.66435500 -1.32906700 -1.41191900  H -2.02717700 -0.13260000 -0.70095000 \
O 1.36101400 1.57004400 -0.28159400 H 1.75422200 0.71750500 -0.58466600 H 2.02907800 2.23588300 -0.46060300 \
O 2.08619300  -0.90482100 -0.97681600 H 2.90861400  -1.38199800 -0.84801700 H 1.41961700  -1.39472600 -0.43624700 \
O 0.18010800  -1.92394300 0.58860600 H 0.11055600  -1.26008500 1.29363000 H -0.68741400 -1.85289600 0.15756200 \
O -0.02781100 0.52399700 2.05893000 H 0.51382500 1.04465100 1.44949700 H -0.90505700 0.90020300 1.94232600 ]
segment WAT {
	for { set i 1 } { $i <= 6 } { incr i } {
		residue $i TIP3
	}
	first NONE
	last NONE
}
for { set i 1 } { $i <= 6 } { incr i } {
	puts [lrange $data [expr {1 + 12 * ($i-1)}] [expr {3 + 12 * ($i-1)}]]
	coord WAT $i OH2 [lrange $data [expr {1 + 12 * ($i-1)}] [expr {3 + 12 * ($i-1)}]]
	coord WAT $i H1 [lrange $data [expr {5 + 12 * ($i-1)}] [expr {7 + 12 * ($i-1)}]]
	coord WAT $i H2 [lrange $data [expr {9 + 12 * ($i-1)}] [expr {11 + 12 * ($i-1)}]]
}
writepdb waterhexamer-prismbook.pdb
exit