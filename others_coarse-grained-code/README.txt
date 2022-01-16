[FE1] C. Luo et al., Comp. Phys. Comm. 180 (2009) 1382-1391.
  https://doi.org/10.1016/j.cpc.2009.01.028
  Code: https://data.mendeley.com/datasets/w6ct8yrn2z/1
  w6ct8yrn2z-1.zip (GPLv3)
[FE2] S.-P. Fu et al., Comp. Phys. Comm. 210 (2017) 193-203.
  https://doi.org/10.1016/j.cpc.2016.09.018
  Code: https://data.mendeley.com/datasets/4v53nkv5hc/1
  4v53nkv5hc-1.zip (GPLv3)
[FE3] M. Mahaud et al., Communications in Computational Physics, Global Science Press, 2018, 24 (3), pp.885-898.
  https://hal.archives-ouvertes.fr/hal-01803207/document
  https://www.global-sci.com/intro/article_detail/cicp/12285.html
  Code: http://michel.perez.net.free.fr/fix_rlp.zip
  fix_rlp.zip (GPL 2.0 GNU's GPL)
----------------------------------------------------------------------------
lammps-cgpva-code [FE1]
Installation (Ubuntu 18.04 LTS)
1. sudo apt update
2. sudo apt -y install unzip mpich g++ fftw-dev
3. unzip w6ct8yrn2z-1.zip
4. tar zxvf aede_v1_0.tar.gz
5. cd ~/lammps-cgpva-code
6. tar zxvf lammps-24Sept07.tar.gz
7. tar zxvf lammps-cgpva.tar.gz
8. cp -r $HOME/lammps-cgpva/* $HOME/lammps-24Sept07/src
9. cd ~/lammps-24Sept07/src
10. gedit change_box.cpp
-----before (Line 20)
#include "error.h"
-----
-----after
#include "error.h"
#include <string.h>
-----
11. make debian

Test
1. cd ~/lammps-cgpva-code
2. tar zxvf test.tar.gz
3. cd test
4. mpirun -np 2 ~/lammps-24Sept07/src/lmp_debian < test.in
----------------------------------------------------------------------------
Installation (Ubuntu 18.04 LTS) [FE2]
(https://download.lammps.org/tars/)
1. sudo apt update
2. sudo apt -y install unzip mpich g++ fftw-dev
3. wget https://download.lammps.org/tars/lammps-30Jul2016.tar.gz
4. tar zxvf lammps-30Jul2016.tar.gz
5. unzip 4v53nkv5hc-1.zip
6. tar zxvf fluidmembrane.tar.gz
7. cp ./fluidmembrane/*.h ./lammps-30Jul16/src
8. cp ./fluidmembrane/*.cpp ./lammps-30Jul16/src
9. cd ~/lammps-30Jul16/src
10. make yes-PERI
11. make yes-ASPHERE
12. make mpi
¦ lammps-14May2016 may also be OK.
¦ make yes-MOLECULE

make data file (MATLAB code)
1. sudo apt install octave
2. octave
3. run ("create_rbc_with_water.m")
4. quit
  (you can get "read_data.rbc_D50AA9m12_N21702_W_water_d0_water")
¦ Octave, Scilab, FreeMat, SciPy

  run
1. cd ~/fluidmembrane
2. mpirun -np 2 ~/lammps-30Jul16/src/lmp_mpi < in_example

  VMD 1.9.1
1. vmd
2. File -> New Molecule... -> Filename: dump.rbc_D...
3. Graphics -> Representations...
  Selected Atoms [type 1 2 3 4 5]
  Drawing Method [VDW]
  Sphere Scale 0.5
  Sphere Resolution 12
----------------------------------------------------------------------------
Near Lammps 7 january 2014 version [FE3]
Installation (Ubuntu 18.04 LTS)
(https://download.lammps.org/tars/)
1. sudo apt update
2. sudo apt -y install unzip mpich g++ fftw-dev
3. wget https://download.lammps.org/tars/lammps-1Feb2014.tar.gz
4. tar zxvf lammps-1Feb2014.tar.gz
5. unzip fix_rlp.zip
6. cp ./fix_rlp/rlp7jan14/fix_rlp.h ./lammps-1Feb14/src
7. cp ./fix_rlp/rlp7jan14/fix_rlp.cpp ./lammps-1Feb14/src
8. cp ./fix_rlp/fix_rlp.txt ./lammps-1Feb14/doc/src
9. cp ./fix_rlp/fix_rlp.html ./lammps-1Feb14/doc/html 
10. cd ~/lammps-1Feb14/src
11. make stubs
12. make serial
run
1. cd fix_rlp
2. ~/lammps-1Feb14/src/lmp_serial < test_input.dat
----------------------------------------------------------------------------
Near Lammps 15 april 2016 version [FE3]
Installation (Ubuntu 18.04 LTS)
(https://download.lammps.org/tars/)
1. sudo apt update
2. sudo apt -y install unzip mpich g++ fftw-dev
3. wget https://download.lammps.org/tars/lammps-14May2016.tar.gz
4. tar zxvf lammps-14May2016.tar.gz
5. unzip fix_rlp.zip
6. cp ./fix_rlp/rlp15apr16/fix_rlp.h ./lammps-14May16/src
7. cp ./fix_rlp/rlp15apr16/fix_rlp.cpp ./lammps-14May16/src
8. cp ./fix_rlp/fix_rlp.txt ./lammps-14May16/doc/src
9. cp ./fix_rlp/fix_rlp.html ./lammps-14May16/doc/html 
10. cd ~/lammps-14May16/src
11. make mpi
run
1. cd fix_rlp
2. mpirun -np 2 ~/lammps-14May16/src/lmp_mpi < test_input.dat
----------------------------------------------------------------------------
LAMMPS-3SPN2 [DN1] 
Installation (Ubuntu 18.04 LTS)
(https://download.lammps.org/tars/)
1. sudo apt update
2. sudo apt -y install unzip mpich g++ fftw-dev
3. wget https://download.lammps.org/tars/lammps-7Aug2019.tar.gz
4. tar zxvf lammps-7Aug2019.tar.gz
5. git clone https://github.com/depablogroup/LAMMPS-3SPN2.git
6. mv LAMMPS-3SPN2 USER-3SPN2
7. cp -r $HOME/USER-3SPN2 $HOME/lammps-7Aug19/src
8. cd ~/lammps-7Aug19/src
9. cd STUBS
10. make
11. cd ..
12. make yes-MOLECULE
13. make yes-CLASS2
14. make yes-USER-3SPN2
15. make serial

compiling "icnf.exe"
1. cd ~/USER-3SPN2/DSIM_ICNF
2. make

run
1. cd ~/USER-3SPN2/examples
2. cd adna
3. ../../DSIM_ICNF/icnf.exe ../seq 2 1 . 0
4. ~/lammps-7Aug19/src/lmp_serial < adna.in

manual
1. sudo apt -y install evince
2. cd ~/USER-3SPN2
----------------------------------------------------------------------------
USER-UEFEX (https://github.com/t-murash/USER-UEFEX)
(Edit: Jan/10/2022)

Installation (Ubuntu 18.04 LTS)
1. sudo apt update
2. sudo apt -y install unzip mpich g++ fftw-dev
3. wget https://download.lammps.org/tars/lammps-29Sep2021.tar.gz
4. tar xvf lammps-29Sep2021.tar.gz
5. git clone https://github.com/t-murash/USER-UEFEX.git
6. cp -r $HOME/USER-UEFEX/UEFEX $HOME/lammps-29Sep2021/src/.
7. cd ~/lammps-29Sep2021/src
8. make yes-molecule
9. make yes-uef
10. make yes-uefex
11. make mpi mode=static

Usage
1. cd ~/USER-UEFEX/examples
2. mpirun -np 2 ~/lammps-29Sep2021/src/lmp_mpi < in.chain.uefex.eng
------------------------------------------------------------------------------