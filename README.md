# lammps_education_LJ_win


## Note: This is test version. (Please, you would develop them)


The elements in the input and output are tentative.


The Kremer-Grest model is used in macromolecules.


## lammps (windows 10 (64 bit))


## Installation
1. LAMMPS Windows Installer Repository (http://packages.lammps.org/windows.html) > their own download area > 64bit
  (https://rpm.lammps.org/windows/admin/64bit/index.html)
2. LAMMPS-64bit-18Jun2019.exe (https://rpm.lammps.org/windows/admin/64bit/LAMMPS-64bit-18Jun2019.exe)


## gnuplot and Ovito
* gnuplot (http://www.gnuplot.info/)
  http://www.yamamo10.jp/yamamoto/comp/gnuplot/inst_win/index.php
* Ovito (https://www.ovito.org/windows-downloads/)


## Usage
1. click run.bat
2. cfg folder > click *.cfg


## I recommend to see Dr. T. Murashima's homepage (Japanese) and github (English).
* Murashima, Takahiro: http://www.cmpt.phys.tohoku.ac.jp/~murasima/
* https://github.com/t-murash/lammps-hands-on
* https://github.com/t-murash/USER-UEFEX
* https://github.com/t-murash/USER-PPA


------------------------------------------------------------------------------
# References


[LJ1] lammps seminar, University of Hyogo


[LJ2] https://github.com/t-murash/lammps-hands-on/tree/master/04deform


[LJ3] http://www.cmpt.phys.tohoku.ac.jp/~murasima/


  https://github.com/t-murash/lammps-hands-on


  https://github.com/t-murash/USER-UEFEX


------------------------------------------------------------------------------
# Input file


## LJ


[IFL1] P. G. Boyd et al., J. Phys. Chem. Lett. 8 (2017) 357-363.
  https://doi.org/10.1021/acs.jpclett.6b02532 (MOF)


[IFL2] K. Banlusan et al., J. Phys. Chem. C 119 (2015) 25845-25852.
  https://doi.org/10.1021/acs.jpcc.5b05446 (MOF)


[IFL3] M. Witman et al., J. Phys. Chem. Lett. 10 (2019) 5929-5934.
  https://doi.org/10.1021/acs.jpclett.9b02449 (MOF)


[IFL4] J. P. Ruffley et al., J. Phys. Chem. C 124 (2020) 19873.
  https://doi.org/10.1021/acs.jpcc.0c07650 (MOF)


[IFL5] R. Anderson et al., Chem. Mater, 32 (2020) 8106-8119.
  https://doi.org/10.1021/acs.chemmater.0c00744 (MOF)


[IFL6] A. v. Wedelstedt et al., J. Chem. Inf. Model. 62 (2022) 1154-1159.
  https://doi.org/10.1021/acs.jcim.2c00158 (input file of MOF on Lammps and CP2k code)


[IFL7] J. J. Wardzala et al., J. Phys. Chem. C 124 (2020) 28469-28478.
  https://doi.org/10.1021/acs.jpcc.0c07040 (MOF)


[IFL8] M. C. Oliver et al., J. Phys. Chem. C 127 (2023) 6503-6514.
  https://doi.org/10.1021/acs.jpcc.2c08695 (MOF)


[IFL9] H. Xu et al., J. Chem. Theory Comput. 18 (2022) 2826-2835.
  https://doi.org/10.1021/acs.jctc.2c00094 (MOF)
  https://archive.materialscloud.org/record/2022.37


[IFL10] J. M. Findley et al., J. Phys. Chem. C 125 (2021) 8418-8429.
  https://doi.org/10.1021/acs.jpcc.1c00943 (input file of MOF on Lammps and RASPA code)


[IFL11] A. S. S. Daou et al., J. Phys. Chem. C 125 (2021) 5296-5305.
  https://doi.org/10.1021/acs.jpcc.0c09952 (input file of MOF on Lammps and RASPA code)


[IFL12] Z. Zhu et al., ACS Omega 7 (2022) 37640-37653.
  https://doi.org/10.1021/acsomega.2c04517 (input file of MOF on Lammps and RASPA code)


[IFL13] T. Weng et al., J. Phys. Chem. A 123 (2019) 3000-3012.
  https://doi.org/10.1021/acs.jpca.8b12311 (ZIF-8)


[IFL14] S. Wang et al., J. Chem. Theory Comput. 17 (2021) 5198-5213.
  https://doi.org/10.1021/acs.jctc.0c01132 (Zeolite)


[IFL15] P. Saidi et al., J. Phys. Chem. C 124 (2020) 26864-26873.
  https://doi.org/10.1021/acs.jpcc.0c08817 (GO)


[IFL17] M. Deffner et al., J. Chem. Theory Comput. 19 (2023) 992-1002.
  https://doi.org/10.1021/acs.jctc.2c00648


[IFL18] W. A. Pisani et al., Ind. Eng. Chem. Res. 60 (2021) 13604-13613.
  https://doi.org/10.1021/acs.iecr.1c02440


[IFL19] K. Goloviznina et al., J. Chem. Theory Comput. 17 (2021) 1606-1617.
  https://doi.org/10.1021/acs.jctc.0c01002


[IFL20] C. Han et al., J. Phys. Chem. C 124 (2020) 20203-20212.
  https://doi.org/10.1021/acs.jpcc.0c05942


[IFL21] S. Sharma et al., J. Phys. Chem. A 124 (2020) 7832-7842.
  https://doi.org/10.1021/acs.jpca.0c06721


[IFL22] E. Braun et al., J. Chem. Theory Comput. 14 (2018) 5262-5272.
  https://doi.org/10.1021/acs.jctc.8b00446


[IFL23] Y. Chen et al., J. Phys. Chem. B 125 (2021) 8193-8204.
  https://doi.org/10.1021/acs.jpcb.1c01966


[IFL24] Y. Zhang et al., J. Phys. Chem. B 124 (2020) 5251-5264.
  https://doi.org/10.1021/acs.jpcb.0c04058


[IFL25] C. M. Tenney et al., J. Phys. Chem. C 117 (2013) 24673-24684.
  https://doi.org/10.1021/jp4039122


[IFL26] S. K. Achar et al., J. Phys. Chem. C 125 (2021) 14874-14882.
  https://doi.org/10.1021/acs.jpcc.1c01411


[IFL27] S.-P. Fu et al., Comput. Phys. Commun. 210 (2017) 193-203.
  https://doi.org/10.1016/j.cpc.2016.09.018


[IFL28] C. Luo et al., Comput. Phys. Commun. 180 (2009)  1382-1391.
  https://doi.org/10.1016/j.cpc.2009.01.028


[IFL29] L. J. Abbott et al., Theor Chem Acc 132 (2013) 1334.
  https://doi.org/10.1007/s00214-013-1334-z


[IFL30] N.-G. Rim et al., ACS Biomater. Sci. Eng. 3 (2017) 1542–1556.
  https://doi.org/10.1021/acsbiomaterials.7b00292


## Other

[IFM1] P. Malakar et al., ACS Appl. Nano Mater. 5 (2022) 16489-16499.
  https://doi.org/10.1021/acsanm.2c03564 (lammps input file)


[IFM2] S. K. Achar et al., J. Chem. Theory Comput. 18 (2022) 3593-3606.
  https://doi.org/10.1021/acs.jctc.2c00010


[IFM3] M. Qamar et al., J. Chem. Theory, Comput. XXX (2023) XXX-XXXX.
  https://doi.org/10.1021/acs.jctc.2c01149


[IFM4] Y. A. Zulueta et al., Inorg. Chem. 59 (2020) 11841-11846.
  https://doi.org/10.1021/acs.inorgchem.0c01923 (Transition-Metal-Doped Li2SnO3)


[IFR1] M. L. Urquiza et al., ACS Nano 15 (2021) 12945-12954.
  https://doi.org/10.1021/acsnano.1c01466 (HfO2)


[IFU1] A guide to the SPH-USER package
  https://bioweb.pasteur.fr/docs/modules/lammps/30Oct14/USER/sph/SPH_LAMMPS_userguide.pdf
------------------------------------------------------------------------------
# Structure


[S1] N. Sakhavand et al., ACS Appl. Mater. Interfaces 7 (2015) 18312-18319.
  https://doi.org/10.1021/acsami.5b03967


[S2] M. Agrawal et al., J. Phys. Chem. Lett. 10 (2019) 7823-7830.
  https://doi.org/10.1021/acs.jpclett.9b03119


[S3] R. Thyagarajan et al., Chem. Mater. 32 (2020) 8020-8033.
  https://doi.org/10.1021/acs.chemmater.0c03057
------------------------------------------------------------------------------
# Input File Creation for the Molecular Dynamics Program LAMMPS.
  https://www.osti.gov/biblio/1230587
------------------------------------------------------------------------------