------------------------------------------------------------------------------
■ Gromacs + other code [G1, G2]
(Edit: 24/Jan/2022)

□ Installation (Gromacs (version 2018.1))
(ubuntu 18.04 LTS)
1. sudo apt update
2. sudo apt -y install libgfortran3
3. sudo apt -y install gromacs
4. which gmx
  (/usr/bin/gmx)
◇ mol22lt.pl and antechamber (AmberTools20)
5. wget https://github.com/makoto-yoneya/makoto-yoneya.github.io/raw/master/MDforPOLYMERS/install_WSLgmx.sh
6. sh install_WSLgmx.sh
7. sh install_WSLgmx.sh
  (one more for environment settings)
8. cat $HOME/.bashrc
----- (Check if the following display is obtained.)
# MDonWSL
set -o notify
export PATH=$HOME/bin:$PATH
export AMBERHOME=$HOME/opt/amber20
export PATH=$AMBERHOME/bin:$PATH
-----
9. bash

◇ Openbabel (Open Babel 2.3.2)
1. sudo apt update
2. sudo apt -y install openbabel

◇ topolbuild (topolbuild1_3.tgz)
(http://www.gromacs.org/Downloads/User_contributions/Other_software)
1. sudo apt update
2. sudo apt -y install g++ make
3. tar xvf topolbuild1_3.tgz
4. cd topolbuild1_3/src
5. make
6. cp topolbuild $HOME/bin/
※ AMBER, OPLS all-atom, GROMOS united-atom, etc

◇ ChemSketch (Freeware Version 2021.1.3 (C25E41)) (windows10)
◇ VMD 1.9.4a48 (windows10 or ubuntu 18.04 LTS)
------------------------------------------------------------------------------
■ tutorial-1 [G1]

◆ step 1. Creating a multimer structure file
◇ windows 10
1. ChemSketch (on windows10)
  (Procedure after drawing the molecule you want to calculate )
  a) ACD/Labs -> 3D Viewer -> ChemSketch (left bottom side)
  b) copy to 3D Viewer (left bottom side)
  c) Tools -> 3D optimization
  d) copy to chemsketch -> structure -> yes
  e) File -> Export... -> MDL mofiles (*.mol) -> bpy.mol (on Desktop folder)
  f) File -> exit -> no
◇ ubuntu 18.04 LTS
2. mkdir tutorial-1
3. cd tutorial-1
4. cp /mnt/c/Users/username/Desktop/bpy-aa.mol ./
  (please, replace username with your username.)
5. babel -imol bpy-aa.mol -omol2 bpy-aa.mol2 --title bpy-aa
6. echo "@<TRIPOS>" >> bpy-aa.mol2
7. topolbuild -n bpy-aa -dir ~/topolbuild1_3/ -ff gaff -purge 0
 -----(you can get following files,)
・bpy-aa.gro : Single molecule coordinates
・ffbpy-aanb.itp : Force field
・bpy-aa.top : Topology
・ffbpy-aa.itp : Force field
------
8. gmx insert-molecules -ci bpy-aa.gro -nmol 128 -box 5 5 5 -o bpy-aa-128.gro
9. "C:\Program Files (x86)\VMD\vmd.exe" \\wsl$\ubuntu-18.04\home\username\tutorial-1\bpy-aa-128.gro
  (※ command prompt on windows10) (please, replase username with your username.)
10. pbc box -color green -width 1
  (※ command prompt on windows10)

◆ step 2.1. Energy minimization calculation
◇ ubuntu 18.04 LTS
1. echo integrator=steep > em.mdp
2. echo nsteps=100 >> em.mdp
3. cp bpy-aa.top bpy-aa.txt
4. vi bpy-aa.txt
-----(before) (Last line)
  bpy-aa           1
-----
-----(after) (same as "-nmol value")
  bpy-aa           128
-----
5. mv bpy-aa.txt topol.top
6. cp ~/topolbuild1_3/water_and_ions/ffusernb.itp ./
7. cp ~/topolbuild1_3/water_and_ions/gaff_spce.itp ./
8. cp ~/topolbuild1_3/water_and_ions/ions_gaff.itp ./
9. gmx grompp -c bpy-aa-128.gro -o bpy-aa-128_em1.tpr -f em.mdp
10. gmx mdrun -deffnm bpy-aa-128_em1 -v
----(Implicitly used files)
・bpy-aa-128_em1.tpr: binary topology file
・bpy-aa-128_em1.gro: output file (coordinate) 
etc
----
11. less mdout.mdp
12. less *.log
13. "C:\Program Files (x86)\VMD\vmd.exe" \\wsl$\ubuntu-18.04\home\username\tutorial-1\bpy-aa-128_em1.gro
  (※ command prompt on windows10) (please, replase username with your username.)
14. pbc box -color green -width 1
  (※ command prompt on windows10)

◆ step 2.2. 1st MD calculation
◇ ubuntu 18.04 LTS
1. vi su.txt 
-----
integrator          =  md  
dt                  =  0.00025  
nsteps              =  500  
tcoupl              =  v-rescale  
tc-grps             =  SYSTEM  
tau_t               =  0.002  
ref_t               =  200.0  
gen_vel             =  yes  
gen_temp            =  200.0  
-----
2. mv su.txt su.mdp
3. gmx grompp -c bpy-aa-128_em1 -o bpy-aa-128_su1 -f su
4. gmx mdrun -deffnm bpy-aa-128_su1 -v

◆ step 2.3. 2nd MD calculation
◇ ubuntu 18.04 LTS
1. vi md.txt
-----
integrator          =  md  
dt                  =  0.0005  
nsteps              =  2000  
nstxtcout           =  10  
tcoupl              =  v-rescale  
tc-grps             =  SYSTEM  
tau_t               =  0.03  
ref_t               =  300.0
-----
2. mv md.txt grompp.mdp
3. gmx grompp -c bpy-aa-128_su1 -o bpy-aa-128_md1
4. gmx mdrun -deffnm bpy-aa-128_md1
◇ animation on VMD
5. echo 0 | gmx trjconv -s bpy-aa-128_md1.tpr -f bpy-aa-128_md1.xtc -o bpy-aa-128_md1mod.xtc -pbc mol
6. cp bpy-aa-128_md1.gro /mnt/c/Users/username/Desktop/
7. cp bpy-aa-128_md1mod.xtc /mnt/c/Users/username/Desktop/
◇ command prompt on windows 10
8. cd Desktop
9. "C:\Program Files (x86)\VMD\vmd.exe" bpy-aa-128_md1.gro bpy-aa-128_md1mod.xtc
10. pbc box -color green -width 1

□ default name
・grompp.mdp
・topol.top
--------- --------- --------- --------- --------- --------- --------- --------- 
□ Appendix: Example of adding water as a solvent
(After 8 of ◆ step 2.1. Energy minimization calculation)
9. gmx solvate -cp bpy-aa-128.gro -cs spc216.gro -o bpy-aa-128spc.gro
  (e.g., you can see "Number of SOL molecules:   3082")
10. vi topol.top
-----(before) (Last line)
  bpy-aa           128
-----
-----(after) ("Number of SOL molecules:   3082")
  bpy-aa           128
  SOL               3082
-----
◇ (Do the same for "bpy-aa-128" as "bpy-aa-128spc".)
11. gmx grompp -c bpy-aa-128spc.gro -o bpy-aa-128spc_em1.tpr -f em.mdp
12. gmx mdrun -deffnm bpy-aa-128spc_em1 -v
13. "C:\Program Files (x86)\VMD\vmd.exe" \\wsl$\ubuntu-18.04\home\username\tutorial-1\bpy-aa-128spc_em1.gro
  (※ command prompt on windows10) (please, replase username with your username.)
14. pbc box -color green -width 1
  (※ command prompt on windows10)

◆ step 2.2. 1st MD calculation
◇ ubuntu 18.04 LTS
1. vi su.txt 
-----
integrator          =  md  
dt                  =  0.00025  
nsteps              =  500  
tcoupl              =  v-rescale  
tc-grps             =  SYSTEM  
tau_t               =  0.002  
ref_t               =  200.0  
gen_vel             =  yes  
gen_temp            =  200.0  
-----
2. mv su.txt su.mdp
3. gmx grompp -c bpy-aa-128spc_em1 -o bpy-aa-128spc_su1 -f su
4. gmx mdrun -deffnm bpy-aa-128spc_su1 -v

◆ step 2.3. 2nd MD calculation
◇ ubuntu 18.04 LTS
1. vi md.txt
-----
integrator          =  md  
dt                  =  0.0005  
nsteps              =  2000  
nstxtcout           =  10  
tcoupl              =  v-rescale  
tc-grps             =  SYSTEM  
tau_t               =  0.03  
ref_t               =  300.0
-----
2. mv md.txt grompp.mdp
3. gmx grompp -c bpy-aa-128spc_su1 -o bpy-aa-128spc_md1
4. gmx mdrun -deffnm bpy-aa-128spc_md1
◇ animation on VMD
5. echo 0 | gmx trjconv -s bpy-aa-128spc_md1.tpr -f bpy-aa-128spc_md1.xtc -o bpy-aa-128spc_md1mod.xtc -pbc mol
6. cp bpy-aa-128spc_md1.gro /mnt/c/Users/username/Desktop/
7. cp bpy-aa-128spc_md1mod.xtc /mnt/c/Users/username/Desktop/
◇ command prompt on windows 10
8. cd Desktop
9. "C:\Program Files (x86)\VMD\vmd.exe" bpy-aa-128spc_md1.gro bpy-aa-128spc_md1mod.xtc
10. pbc box -color green -width 1
------------------------------------------------------------------------------
■ tutorial-2 [G2]

◆ step 1. Creating a multimer structure file
◇ windows 10
1. ChemSketch (on windows10)
  (Procedure after drawing the molecule you want to calculate )
  a) Edit -> Select All
  b) Tools -> Show/Hide Atom Numbers
  c) ACD/Labs -> 3D Viewer -> ChemSketch (left bottom side)
  d) copy to 3D Viewer (left bottom side)
  e) Tools -> 3D optimization
  f) copy to chemsketch -> structure -> yes
  g) File -> Export... -> MDL mofiles (*.mol) -> mlla.mol (on Desktop folder)
  h) File -> exit -> no
  (make Trimer and save "3lla.mol")
◇ ubuntu 18.04 LTS
2. mkdir tutorial-2
3. cd tutorial-2
4. cp /mnt/c/Users/username/Desktop/3lla.mol ./
  (please, replace username with your username.)
5. antechamber -fi mdl -i 3lla.mol -fo mol2 -o 3lla.mol2 -at gaff -c gas -rn LLA -dr no
  (MDL-mol file -> mol2 file)
6. mol22rtp.pl < 3lla.mol2 > 3lla.rtp
  (mol2 file -> rtp file)
7. rtp2tmer.pl --n_term_id 7 --c_term_id 29 < 3lla.rtp > lla.rtp
  (or rtp2tmer.pl -n 7 -c 29 < 3lla.rtp > lla.rtp)
8. rtp2hdb.pl < lla.rtp > lla.hdb
  (Definition of residues corresponding to polylactic acid monomers.)
9. antechamber -fi mdl -i 3lla.mol -fo pdb -o 3lla.pdb -rn LLA -dr no
  (mol file -> pdb file)
10. pdb2tmer.pl --n_term_id 7 --c_term_id 29 < 3lla.pdb > 3lla_4pdb2gmx.pdb
  (or pdb2tmer.pl -n 7 -c 29 < 3lla.pdb > 3lla_4pdb2gmx.pdb)
11. gmx make_ndx -f 3lla_4pdb2gmx.pdb
  (making  index.ndx file)
  (Creating a structure file of a dimer that is a translational symmetry unit from a trimer.)
  a) a 1
  b) a 1 13
  c) r 1 2
  d) q
12. gmx editconf -f 3lla_4pdb2gmx.pdb -o 3lla_4pdb2gmx-princ.pdb -n index.ndx -princ
  (The main chain direction of the trimer is the X-axis direction.)
  Select a group for determining the system size: a_1_13
  Select a group for determining the orientation: a_1_13
  Select a group for output: System
13. gmx editconf -f 3lla_4pdb2gmx-princ.pdb -o 3lla_4pdb2gmx-orig.pdb -n index.ndx -center 0 0 0
  (Shift the leftmost atom 1 in the main chain excluding the terminal hydrogen of the trimer molecule to the coordinate origin.)
  Select a group for determining the system size: a_1
  Select a group for output: System
14. less 3lla_4pdb2gmx-orig.pdb
  (check less 3lla_4pdb2gmx-orig.pdb file)
  Note 1: you can see "ATOM      1  O1  LLAn    1       0.000   0.000   0.000  1.00  0.00           O". This means "The x, y, z coordinate values of the atom at index 1 are 0.000 0.000 0.000".
  Note 2: The number in the 5th column of the ATOM entry row represents the residue number, and residues 1-2 correspond to the dimer whose translational symmetry unit is.
  Note 3: Since the main chain is in the x-axis direction, the x-coordinate value of the first atom of residue 3 (6.194 units is Angstrom in this example) corresponds to the translational period distance.
15. gmx editconf -f 3lla_4pdb2gmx-orig.pdb -o 2lla.pdb -n index.ndx -noc -box 0.6194 1 1
  (Create a structure file of a dimer that is a translational symmetry unit. Add box information of length 0.6194 nm (= 6.194 Angstrom), 1 nm, 1 nm in x, y, z direction.)
  Select a group for output: r_1_2
  (Corresponds to residue 1-2 corresponding to the dimer which is a translational symmetry unit.)
16. gmx genconf -f 2lla.pdb -o 60lla.pdb -nbox 30 1 1
  (Create a structure file (60lla.pdb) of 60-mer by translating the dimer with "-nbox 30 1 1" for 30 boxes in the x direction. Structure file of 60-mer (60lla.pdb).)
17. "C:\Program Files (x86)\VMD\vmd.exe" \\wsl$\ubuntu-18.04\home\username\tutorial-2\60lla.pdb
  (※ command prompt on windows10) (please, replase username with your username.)
18. cn-term.pl < 60lla.pdb > 60lla_4pdb2gmx.pdb
  (The 60-mer structure file does not have the terminal residues set correctly. Therefore, create a structure file (60lla_4pdb2gmx.pdb) with the first and last residues set as the terminal residues.)
※ GAFF = general AMBER force field (charge: H, C, N, O, P, S and halogen)
※ "-c gas" = Gastiger method (charge)
※ "-rn LLA" = Residue name LLA
※ The rtp file is a file obtained by extracting atom and bond information from the mol2 file.
※ "7" and "29" are the indexes of the leftmost and rightmost atoms (in pdb2tmer.pl).

◆ step 2. Creating a GAFF parameter file for GROMACS
(Create a system topology file using the GROMACS command pdb2gmx from the multimer molecular structure (pdb) file and the monomer (residue) topology file.)
1. mkdir gaff.ff
2. cd gaff.ff
3. pwd
4. ambdat2gmx.pl < $AMBERHOME/dat/leap/parm/gaff.dat
  (The GAFF parameter file corresponding to pdb2gmx is created in this gaff.ff directory (converted from the GAFF parameter file gaff.dat in AMBER format).)
5. ls -l
-----
atomtypes.atp
ffbonded.itp
ffnonbonded.itp
forcefield.doc
forcefield.itp
-----
6. ln -s ../lla.rtp ../lla.hdb ./
  (The monomer (residue) topology file (lla.rtp) and the hydrogen database file (lla.hdb) should also be placed in this gaff.ff directory (folder).)
7. ls -l
8. cd ..

◆ step 3. Creating a topology file
(Create a system-level topology file from the multimer molecular structure (pdb) file and the monomer (residue) topology file using the GROMACS command pdb2gmx.)
1. gmx pdb2gmx -f 60lla_4pdb2gmx.pdb -o 60lla.gro -ff gaff -water none
  Note 1: The "60lla.gro" is an output structure file, which is the input structure file 60lla_4pdb2gmx.pdb with terminal hydrogen added and converted to the standard GROMACS coordinate file format (* .gro format).
  Note 2: The option "-ff gaff" specifies to use the GAFF parameter created above in gaff.ff.
  Note 3: The option "-water none" specifies that model information for water molecules commonly used as solvents should not be added to the topology file.
2. parmchk2 -f mol2 -i 3lla.mol2 -o 3lla.frcmod
  (Insufficient parameters and valid parameter candidate values are output to 3lla.frcmod.)
3. frcmod2gmx.pl < 3lla.frcmod
4. (check files)
  less frcmod_atomtypes.atp
  less frcmod_ffbonded.itp
  less frcmod_ffnonbonded.itp
  (Note: In my case, the contents of "frcmod_atomtypes.atp" were empty.)
5. vi topol.top
----(before)
; Include forcefield parameters
#include "./gaff.ff/forcefield.itp"
[ moleculetype ]
; Name            nrexcl
Other               3
----
----(after)
; Include forcefield parameters
#include "./gaff.ff/forcefield.itp"
#include "./frcmod_ffbonded.itp"
[ moleculetype ]
; Name            nrexcl
Other               3
----
--------- --------- --------- --------- --------- --------- --------- 
◇ Note
・The above creates a topology file topol.top (default name).
・To briefly explain the contents of this topology file, Other in the [molecule type] entry is the name of this molecular model, and Other is the name given by pdb2gmx in his default, so it is better to change it to an appropriate name.
・In the next [atoms] entry, information such as atomic type, point charge, mass, etc. for each atomic number of the 60-mer model of polyamide 4 is described for all atoms.
・After that, each entry of [bonds], [pairs], [angles], [dihedrals] contains the bonds, 1-4 intramolecular interaction pairs, and bond angles contained in this 60-mer model. , The atomic indexes that make up the dihedral angle are listed.
--------- --------- --------- --------- --------- --------- --------- 

◆ step 4.1. Simulation of multimers
(Energy minimization calculation)
1. echo integrator=steep > em.mdp
2. echo nsteps=100 >> em.mdp
3. echo pbc=no >> em.mdp
4. echo cutoff-scheme=group >> em.mdp
5. gmx grompp -c 60lla.gro -o 60lla_em1.tpr -f em.mdp
6. gmx mdrun -deffnm 60lla_em1 -v
  (use 60lla_em1.tpr and 60lla_em1.gro)
7. "C:\Program Files (x86)\VMD\vmd.exe" \\wsl$\ubuntu-18.04\home\username\tutorial-2\60lla_em1.gro
  (※ command prompt on windows10) (please, replase username with your username.)
--------- --------- --------- --------- --------- --------- --------- 
◇ Note (for energy minimization calculation)
1. Initial structure file (default extension .gro)
2. MD calculation parameter file (file name of extension .mdp default is grompp.mdp)
3. Topology file (file name of extension .top default is topol.top)
The above three input files are converted into one binary topology file (extension .tpr) by the preprocessor program grompp.
◇ Note (for topol.top)
  When changing the number of molecules from 1, it is necessary to change the last line of the topology file to the number corresponding to the number of molecules in the system.
--------- --------- --------- --------- --------- --------- --------- 

◆ step 4.2. Simulation of multimers
(1st MD calculation)
1. vi su.txt
-----
integrator          =  md
dt                  =  0.00025
nsteps              =  4000
pbc                 =  no
cutoff-scheme       =  group
tcoupl              =  v-rescale
tc-grps             =  SYSTEM
tau_t               =  0.002
ref_t               =  200.0
gen_vel             =  yes
gen_temp            =  200.0
-----
2. cp su.txt su.mdp
  (original method: ln -s su.txt su.mdp)
3. gmx grompp -c 60lla_em1 -o 60lla_su1 -f su
4. gmx mdrun -deffnm 60lla_su1 -v

◆ step 4.3. Simulation of multimers
(2nd MD calculation)
1. vi grompp.txt
-----
integrator          =  md
dt                  =  0.0005
nsteps              =  20000
nstxtcout           =  10
pbc                 =  no
cutoff-scheme       =  group
tcoupl              =  v-rescale
tc-grps             =  SYSTEM
tau_t               =  0.03
ref_t               =  300.0
-----
2. cp grompp.txt grompp.mdp
  (original method: ln -s grompp.txt grompp.mdp)
3. gmx grompp -c 60lla_su1 -o 60lla_md1
4. gmx mdrun -deffnm 60lla_md1
5. cp 60lla_md1.gro /mnt/c/Users/username/Desktop/
6. cp 60lla_md1.xtc /mnt/c/Users/username/Desktop/
◇ command prompt on windows 10
7. cd Desktop
8. "C:\Program Files (x86)\VMD\vmd.exe" 60lla_md1.gro 60lla_md1.xtc

□ RESP charge from Gaussian (no check)
  (RESP = Restrained Electro Static Potential)
1. antechamber -fi mdl -i 3lla.mol -fo gcrt -o 3lla.com -dr no
2. g09 3lla.com
3. antechamber -fi gout -i 3lla.log -fo mol2 -o 3lla.mol2 -at gaff -c resp -dr no
  (3lla.log -> Sybyl-mol2)
4. mol22rtp.pl < 3lla.mol2 > 3lla.rtp
  (mol2 file -> rtp file)
-----------------------------------------------------------------------
■ References

[G1] GROMACSと連携ソフトウエアによる分子動力学計算 updated (makoto-yoneya.github.io)
  https://makoto-yoneya.github.io/MDforPRIMERS/
[G2] GROMACSと連携ソフトウエアによる分子動力学計算（合成高分子） (makoto-yoneya.github.io)
  https://makoto-yoneya.github.io/MDforPOLYMERS/
[G3] Gallery(2018) - GO WATANABE PERSONAL SITE (go-watanabe.com)
[RM1] RMC++ downloads (szfki.hu)
  https://www.szfki.hu/~nphys/rmc++/downloads.html
-----------------------------------------------------------------------
□ uninstall gromacs code
1. sudo apt remove gromacs
-----------------------------------------------------------------------