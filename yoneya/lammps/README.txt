------------------------------------------------------------------------------
¡ lammps + other code [O1]
(Edit: 21/Jun/2022)

  Installation (ubuntu 20.04 LTS)
1. sudo apt update
2. sudo apt -y install dos2unix python3-pip libgfortran4 libgfortran5 liblapack3 gfortran g++
3. sudo apt -y install lammps
4. which lmp
ž moltemplate
5. wget https://github.com/makoto-yoneya/makoto-yoneya.github.io/raw/master/LAMMPS-organics/install_moltemplate.sh
6. sh install_moltemplate.sh
ž packmol and atomsk
7. wget https://github.com/makoto-yoneya/makoto-yoneya.github.io/raw/master/LAMMPS-organics/install_packmol-atomsk.sh
8. sed -i s/b0.10.6/b0.11.2/ install_packmol-atomsk.sh
9. sh install_packmol-atomsk.sh
10. which packmol
11. which atomsk
ž mol22lt.pl and antechamber (AmberTools20)
12. wget https://github.com/makoto-yoneya/makoto-yoneya.github.io/raw/master/LAMMPS-organics/install_WSLmisc.sh
13. sh install_WSLmisc.sh
14. cat $HOME/.bashrc
  (Check if the following display is obtained.)
-----
# MDonWSL
set -o notify
export PATH=$HOME/bin:$PATH
export AMBERHOME=$HOME/opt/amber20
export PATH=$AMBERHOME/bin:$PATH
export MTHOME=$HOME/opt/moltemplate/moltemplate
export PATH=$MTHOME/scripts:$PATH
-----
15. bash

ž ChemSketch (Freeware Version) (windows10)
ž VMD (windows10 or ubuntu 20.04 LTS)

  Usage
ž windows 10
1. ChemSketch (on windows10)
  (Procedure after drawing the molecule you want to calculate )
  a) ACD/Labs -> 3D Viewer -> ChemSketch (left bottom side)
  b) copy to 3D Viewer (left bottom side)
  c) Tools -> 3D optimization
  d) copy to chemsketch -> structure -> yes
  e) File -> Export... -> MDL mofiles (*.mol) -> bpy.mol (on Desktop folder)
  f) File -> exit -> no
ž ubuntu 20.04 LTS
2. cp /mnt/c/Users/inukai/Desktop/bpy.mol ./
3. antechamber -fi mdl -i bpy.mol -fo pdb -o bpy.pdb -dr no
  (MDL-mol file -> pdb file)
4. vi bpy-128.txt
----- (put 128 molecules into 45x45x45 A) -----
tolerance 2.0
add_box_sides 2.0

structure bpy.pdb
  number 128
  inside box 0. 0. 0. 45. 45. 45.
end structure

output bpy-128.pdb
----- ----- ----- ----- ----- ----- ----- ----- -----
5. packmol < bpy-128.txt
6. "C:\Program Files (x86)\VMD\vmd.exe" \\wsl$\ubuntu-20.04\home\username\bpy-128.pdb
  pbc box
  {or (echo "user add key b {pbc box -color green}" >> vmd.rc) (and b)}
  (please, replace username with your username)
  ¦ (command prompt on windows 10)
7. antechamber -fi mdl -i bpy.mol -fo mol2 -o bpy.mol2 -at gaff -c gas -rn bpy -dr no
  (MDL-mol file -> sybyl-mol2 file)
8. mol22lt.pl < bpy.mol2 > bpy.lt
9. vi system.txt
-----
import "gaff.lt"
import "bpy.lt"
BPY = new bpy [128]
-----
10. moltemplate.sh -atomstyle full -pdb bpy-128.pdb system.txt
11. unix2dos -n system.in em.txt
12. vi em.txt
--------- --------- --------- --------- --------- --------- --------- --------- 
# ----------------- Init Section -----------------
include "system.in.init"

# ----------------- Atom Definition Section -----------------
read_data "system.data"

# ----------------- Settings Section -----------------
include "system.in.settings"
thermo_style    custom step etotal
thermo          10

# ----------------- Run Section -----------------
# The lines above define the system you want to simulate.
# What you do next is up to you.
# Typically a user would minimize and equilibrate
# the system using commands similar to the following:
#  ----   examples   ----
#
#  -- minimize --
  minimize 1.0e-5 1.0e-7 1000 10000
# (Note: Some fixes, for example "shake", interfere with the minimize command,
#        You can use the "unfix" command to disable them before minimization.)
#  -- declare time step for normal MD --
# timestep 1.0
#  -- run at constant pressure (Nose-Hoover)--
# fix   fxnpt all npt temp 300.0 300.0 100.0 iso 1.0 1.0 1000.0 drag 1.0
#  -- ALTERNATELY, run at constant volume (Nose-Hoover) --
# fix   fxnvt all nvt temp 300.0 300.0 500.0 tchain 1
#  -- ALTERNATELY, run at constant volume using Langevin dynamics. --
#  -- (This is good for sparse CG polymers in implicit solvent.)   --
# fix fxLAN all langevin 300.0 300.0 5000 48279
# fix fxNVE all nve  #(needed by fix langevin)
#  -- Now, finally run the simulation --
# run   50000
#  ---- (end of examples) ----

write_data bpy-128_min.lmp
--------- --------- --------- --------- --------- --------- --------- --------- 
13. lmp < em.txt
  (please check: open bpy-128_min.lmp on Ovito)
14. atomsk bpy-128_min.lmp pdb
  (In my case it doesn't convert well for some reason !!!)
15. "C:\Program Files (x86)\VMD\vmd.exe" \\wsl$\ubuntu-20.04\home\username\bpy-128_min.pdb
  (please, replace username with your username)
  ¦ (command prompt on windows 10)
16. unix2dos -n system.in su.txt
17. vi su.txt
--------- --------- --------- --------- --------- --------- --------- ---------
# ----------------- Init Section -----------------
include "system.in.init"

# ----------------- Atom Definition Section -----------------
read_data bpy-128_min.lmp

# ----------------- Settings Section -----------------
include "system.in.settings"
thermo_style    custom step etotal temp press
thermo          10
velocity        all create 300 4928459 dist gaussian

# ----------------- Run Section -----------------
# The lines above define the system you want to simulate.
# What you do next is up to you.
# Typically a user would minimize and equilibrate
# the system using commands similar to the following:
#  ----   examples   ----
#
#  -- minimize --
# minimize 1.0e-5 1.0e-7 1000 10000
# (Note: Some fixes, for example "shake", interfere with the minimize command,
#        You can use the "unfix" command to disable them before minimization.)
#  -- declare time step for normal MD --
  timestep 1.0
#  -- run at constant pressure (Nose-Hoover)--
# fix   fxnpt all npt temp 300.0 300.0 100.0 iso 1.0 1.0 1000.0 drag 1.0
#  -- ALTERNATELY, run at constant volume (Nose-Hoover) --
  fix   fxnvt all nvt temp 300.0 300.0 500.0 tchain 1
#  -- ALTERNATELY, run at constant volume using Langevin dynamics. --
#  -- (This is good for sparse CG polymers in implicit solvent.)   --
# fix fxLAN all langevin 300.0 300.0 5000 48279
# fix fxNVE all nve  #(needed by fix langevin)
#  -- Now, finally run the simulation --
  run   5000
#  ---- (end of examples) ----

write_data bpy-128_su.lmp
--------- --------- --------- --------- --------- --------- --------- ---------
18. lmp < su.txt
  (please check: open bpy-128_su.lmp on Ovito)
19. unix2dos -n system.in md.txt
20. vi md.txt
--------- --------- --------- --------- --------- --------- --------- ---------
# ----------------- Init Section -----------------
include "system.in.init"

# ----------------- Atom Definition Section -----------------
read_data bpy-128_su.lmp

# ----------------- Settings Section -----------------
include "system.in.settings"
thermo_style    custom step etotal temp press
thermo          10
dump            1 all xtc 10 bpy-128_md.xtc
dump_modify     1 unwrap yes

# ----------------- Run Section -----------------
# The lines above define the system you want to simulate.
# What you do next is up to you.
# Typically a user would minimize and equilibrate
# the system using commands similar to the following:
#  ----   examples   ----
#
#  -- minimize --
# minimize 1.0e-5 1.0e-7 1000 10000
# (Note: Some fixes, for example "shake", interfere with the minimize command,
#        You can use the "unfix" command to disable them before minimization.)
#  -- declare time step for normal MD --
  timestep 1.0
#  -- run at constant pressure (Nose-Hoover)--
  fix   fxnpt all npt temp 300.0 300.0 100.0 iso 1.0 1.0 1000.0 drag 1.0
#  -- ALTERNATELY, run at constant volume (Nose-Hoover) --
# fix   fxnvt all nvt temp 300.0 300.0 500.0 tchain 1
#  -- ALTERNATELY, run at constant volume using Langevin dynamics. --
#  -- (This is good for sparse CG polymers in implicit solvent.)   --
# fix fxLAN all langevin 300.0 300.0 5000 48279
# fix fxNVE all nve  #(needed by fix langevin)
#  -- Now, finally run the simulation --
  run   5000
#  ---- (end of examples) ----

write_data bpy-128_md.lmp
--------- --------- --------- --------- --------- --------- --------- ---------
20. lmp < md.txt
  (please check: open bpy-128_md.lmp on Ovito)
21. cp bpy-128_md.lmp /mnt/c/Users/username/Desktop/
  (please, replace username with your username)
22. cp bpy-128_md.xtc /mnt/c/Users/username/Desktop/
  (please, change username with your username)
ž command prompt on windows 10
23. cd Desktop
24. notepad lmp2psf.txt
--------- --------- --------- --------- --------- --------- --------- ---------
package require topotools
topo readlammpsdata bpy-128_md.lmp full
topo guessatom lammps data
animate write psf bpy-128_md.psf
quit
--------- --------- --------- --------- --------- --------- --------- ---------
25. "C:\Program Files (x86)\VMD\vmd.exe" -dispdev text -e lmp2psf.txt
26. "C:\Program Files (x86)\VMD\vmd.exe" bpy-128_md.psf bpy-128_md.xtc
27. pbc box -color green -width 1
¦ GAFF = general AMBER force field (charge: H, C, N, O, P, S and halogen)
¦ "-c gas" = Gastiger method (charge)
¦ packmol: First randomly placed initial structure

ž files
A) system.data : lammps data file (coordinate)
B) system.in : lammps script file (conditions)
C) system.in.init : initial settings of force field (GAFF)
D) system.in.settings : force field parameter file

  Ovito (lmp -> xyz file)
1. open bpy-128_md.lmp on Ovito.
2. File -> Export File -> XYZ file
3. [Move up] and [Move down]
  [check] Mass
  [check] Position.X
  [check] Position.Y
  [check] Position.Z
4. replace mass with atomic symbol.
5. open *.xyz on VMD, VESTA or Avogadro.

  RESP charge from Gaussian (no check)
  (RESP = Restrained Electro Static Potential)
1. antechamber -fi mdl -i bpy.mol -fo gcrt -o bpy.com -dr no
2. g09 bpy.com
3. antechamber -fi gout -i bpy.log -fo mol2 -o bpy.mol2 -at gaff -c resp -dr no
  (bpy.log -> Sybyl-mol2)
4. mol22lt.pl < bpy.mol2 > bpy.lt
5. vi system.txt
-----
import "gaff.lt"
import "bpy.lt"
BPY = new bpy [128]
-----
6. moltemplate.sh -atomstyle full -pdb bpy-128.pdb system.txt
7. unix2dos -n system.in em.txt
8. vi em.txt
9. lmp < em.txt

  References
[O1] https://makoto-yoneya.github.io/LAMMPS-organics/
  https://makoto-yoneya.github.io/
[O2] https://wiki.akionux.net/index.php/LAMMPS%2BPackmol%2BMoltemplate%2BOPLS-AA%E3%81%A7%E6%BA%B6%E6%B6%B2%E3%81%AEMD
[O3] https://www1.gifu-u.ac.jp/~ysr_labo/share/WSL_ubuntu.html
[C1] https://gitlab.msu.edu/vermaasj/PuReMD/-/blob/master/tools/lmp2pdb.awk
[C2] https://github.com/scottie33/amorphous_polymer_lammps/blob/master/lmp2pdb.py 
[A1] https://qiita.com/Ag_smith/items/430e9efb32a855d4c511
[A2] https://morita-rikuri.blogspot.com/2020/11/gamess-resp.html
  GAMESS-US: antechamber -fi mol2 -i ligand_resp.mol2 -fo prepi -o ligand.prep -nc 0
  antechamber package (ambermd.org)
[A3] https://pablito-playground.readthedocs.io/en/latest/tutorials/qmmm_amber_cpmd/RESP_charges.html
[A4] http://archive.ambermd.org/200812/att-0116/resp_fit.htm
[A5] https://ambermd.org/Questions/resp.html
[A6] https://ambermd.org/tutorials/advanced/tutorial1/section1.htm
[A7] https://computational-chemistry.com/top/blog/2016/09/14/antechamber_input/
[VMD1 https://mumeiyamibito.0am.jp/%E5%88%86%E5%AD%90%E3%82%B7%E3%83%9F%E3%83%A5%E3%83%AC%E3%83%BC%E3%82%B7%E3%83%A7%E3%83%B3%E9%96%A2%E9%80%A3/vmd

  uninstall
1. sudo apt remove lammps
2. sudo dpkg -r packmol
3. sudo dpkg -r atomsk
------------------------------------------------------------------------------

