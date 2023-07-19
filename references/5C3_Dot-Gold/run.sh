#!/bin/bash 

# input & output
export INPUT=in
export OUTPUT=out
export ncore=24
export dist=125.5

export eps_au=1.2
export eps_qd=6.0
export eps_x=6.0
export sig_au=15.8
export sig_qd=7.0
export sig_x=7.0
export del_au=4.2561
export const1=7.8572
export const2=16.2757

# Load Intel,impi & LAMMPS
module load intel/2018.1.163  impi/2018.1.163  lammps/16Mar18
export EXE=lmp_intel_impi

#equilibration

mkdir equi
cd equi

cat >single.mol<<EOF
bumpy

13 atoms

Coords

1  0 0 0
2  -34.29468 0 -34.29468
3  -34.29468 -34.29468 0
4  0 -34.29468 -34.29468
5  34.29468 0 34.29468
6  34.29468 34.29468 0
7  0 34.29468 34.29468
8  0 34.29468 -34.29468
9  34.29468 -34.29468 0
10 34.29468 0 -34.29468
11 -34.29468 34.29468 0
12 -34.29468 0 34.29468
13 0 -34.29468 34.29468

Types

1 1
2 2
3 2
4 2
5 2
6 2
7 2
8 2
9 2
10 2
11 2
12 2
13 2
EOF

del_qd=$(echo "scale=4; $dist-$const1" | bc)
del_x=$(echo "scale=4; ($dist+22.0)/2.0-$const1" | bc)
cut_qd=$(echo "scale=4; $sig_qd*3" | bc)
cut_au=$(echo "scale=4; $sig_au*3" | bc)
cut_x=$(echo "scale=4; $sig_x*3" | bc)
cut_qd_wca=$(echo "scale=4; $sig_qd*1.22462" | bc)
cut_au_wca=$(echo "scale=4; $sig_au*1.22462" | bc)
cut_x_wca=$(echo "scale=4; $sig_x*1.22462" | bc)

cat >$INPUT <<!
units           real
atom_style      molecular
boundary        p p p
lattice         fcc 200.0
region          box block 0 6 0 6 0 6 units lattice
molecule        nc single.mol
create_box      2 box
create_atoms    0 box mol nc 12345
mass            1 100.0000
mass            2 10.00000
pair_style      lj/expand 17.5
pair_coeff      1 1  $eps_qd $sig_qd $del_qd $cut_qd
pair_coeff      2 2  $eps_au $sig_au $del_au $cut_au_wca
pair_coeff      1 2  $eps_x $sig_x $del_x $cut_x_wca
pair_modify     shift yes
neigh_modify    exclude molecule/intra all
thermo_style    custom step temp press ke pe etotal enthalpy lx ly lz
thermo          10000
restart         1000000 restart.*
timestep        10.0
fix             1 all rigid/nph/small molecule iso 0.5 0.0 100000.0
fix             temp all langevin 300.0 300.0 10000.0 12345 zero yes
dump            1 all custom 2000 equi.lammpstrj id mol type xu yu zu
dump_modify     1 sort id
run             1000000
write_data      equi.data nocoeff
!

mpirun -np $ncore $EXE < $INPUT > $OUTPUT

cp restart.1000000 ../restart1.file
cd ../

#decreasing dist.
mkdir down
cp restart1.file down
cd down

for dist in $(seq 125.5 -0.5 105)
do
mkdir $dist
cp restart1.file $dist/
cd $dist

del_qd=$(echo "scale=4; $dist-$const1" | bc)
del_x=$(echo "scale=4; ($dist+22.0)/2.0-$const1" | bc)
cut_qd=$(echo "scale=4; $sig_qd*3" | bc)
cut_au=$(echo "scale=4; $sig_au*3" | bc)
cut_x=$(echo "scale=4; $sig_x*3" | bc)
cut_qd_wca=$(echo "scale=4; $sig_qd*1.122462" | bc)
cut_au_wca=$(echo "scale=4; $sig_au*1.122462" | bc)
cut_x_wca=$(echo "scale=4; $sig_x*1.122462" | bc)

cat >$INPUT <<!
units		real
atom_style	molecular
boundary	p p p
read_restart    restart1.file
reset_timestep  0
mass  		1 100.0000
mass  		2 10.00000
pair_style	lj/expand 25
pair_coeff      1 1  $eps_qd $sig_qd $del_qd $cut_qd
pair_coeff      2 2  $eps_au $sig_au $del_au $cut_au
pair_coeff      1 2  $eps_x $sig_x $del_x $cut_x_wca
pair_modify	shift yes
neigh_modify	exclude molecule/intra all
thermo_style	custom step temp press ke pe etotal enthalpy lx ly lz
thermo 		2000
restart 	1000000 restart.*
timestep     	10.0
fix		1 all rigid/nph/small molecule aniso 0.0 0.0 100000.0 
fix		temp all langevin 300.0 300.0 10000.0 12345 zero yes
dump		1 all custom 2000 pos.lammpstrj id mol type xu yu zu
dump_modify	1 sort id
run 		1000000
!
mpirun -np $ncore $EXE < $INPUT > $OUTPUT

cp restart.1000000 ../restart1.file
cd ../
done

cp restart1.file ../restart2.file

cd ../

#increasing dist
mkdir up
cp restart2.file up
cd up

for dist in $(seq 105 0.5 125.5)
do
mkdir $dist
cp restart2.file $dist/
cd $dist

del_qd=$(echo "scale=4; $dist-$const1" | bc)
del_x=$(echo "scale=4; ($dist+22.0)/2.0-$const1" | bc)
cut_qd=$(echo "scale=4; $sig_qd*3" | bc)
cut_au=$(echo "scale=4; $sig_au*3" | bc)
cut_x=$(echo "scale=4; $sig_x*3" | bc)
cut_qd_wca=$(echo "scale=4; $sig_qd*1.122462" | bc)
cut_au_wca=$(echo "scale=4; $sig_au*1.122462" | bc)
cut_x_wca=$(echo "scale=4; $sig_x*1.122462" | bc)

cat >$INPUT <<!
units		real
atom_style	molecular
boundary	p p p
read_restart    restart2.file
reset_timestep  0
mass  		1 100.0000
mass  		2 10.00000
pair_style	lj/expand 25
pair_coeff      1 1  $eps_qd $sig_qd $del_qd $cut_qd
pair_coeff      2 2  $eps_au $sig_au $del_au $cut_au
pair_coeff      1 2  $eps_x $sig_x $del_x $cut_x_wca
pair_modify	shift yes
neigh_modify	exclude molecule/intra all
thermo_style	custom step temp press ke pe etotal enthalpy lx ly lz
thermo 		2000
restart 	1000000 restart.*
timestep     	10.0
fix		1 all rigid/nph/small molecule aniso 0.0 0.0 100000.0 
fix		temp all langevin 300.0 300.0 10000.0 12345 zero yes
dump		1 all custom 2000 pos.lammpstrj id mol type xu yu zu
dump_modify	1 sort id
run 		1000000
write_data      equi.data nocoeff
!
mpirun -np $ncore $EXE < $INPUT > $OUTPUT

cp restart.1000000 ../restart2.file
cd ../
done
