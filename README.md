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


[IFL31] K. V. Lee et al., American Journal of Physics 88 (2020) 401-422.
  https://doi.org/10.1119/10.0000654


[IFL32] Large biomolecular simulation on HPC platforms
  II. DL POLY, Gromacs, LAMMPS and NAMD
  https://www.researchgate.net/profile/Hannes-Loeffler/publication/315786259_Large_biomolecular_simulation_on_HPC_platforms_II_DL_POLY_Gromacs_LAMMPS_and_NAMD/links/58e4c9a1aca2727858c55b1d/Large-biomolecular-simulation-on-HPC-platforms-II-DL-POLY-Gromacs-LAMMPS-and-NAMD.pdf


[IFL33] M. Gupta et al., Appl. Phys. Lett. 116, 103704 (2020).
  https://doi.org/10.1063/1.5139961


[IFL34] D. T. S. Ranathunga et al., Langmuir 36 (2020) 7383–7391.
  https://doi.org/10.1021/acs.langmuir.0c00915


[IFL35] F. Azough et al., https://doi.org/10.15125/BATH-00463.
  Sr1-xLa2x/3TiO3 


[IFL36] H. Liu et al., Chem. Phys. Chem. 13 (2012) 1701-1707.
  https://doi.org/10.1002/cphc.201200016


[IFL37] B. Cheng et al., https://core.ac.uk/download/pdf/148017767.pdf


[IFL38] J. L. Aragones et al., J. Chem. Phys. 137 (2012) 146101.
  https://doi.org/10.1063/1.4758700


[IFL39] C. J. Leverant et al., J. Chem. Theory Comput. 19 (2023) 3054-3062.
  https://doi.org/10.1021/acs.jctc.2c01040


[IFL40] C. D. Daub et al., CS Earth Space Chem. 6 (2022) 2446-2452.
  https://doi.org/10.1021/acsearthspacechem.2c00159


[IFL41] M. Hammer et al., J. Chem. Phys. 158 (2023) 104107.
  https://doi.org/10.1063/5.0137226


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


[IFG1] A. Jagusiak et al., J. Mol. Liq. 279 (2019) 640-648.
  https://doi.org/10.1016/j.molliq.2019.02.012


[IFX1] T. Nakamura et al., Chem. Theory, Comput. 190 (2015) 120-128.
  https://doi.org/10.1016/j.cpc.2014.11.017
------------------------------------------------------------------------------
# Structure


[S1] N. Sakhavand et al., ACS Appl. Mater. Interfaces 7 (2015) 18312-18319.
  https://doi.org/10.1021/acsami.5b03967


[S2] M. Agrawal et al., J. Phys. Chem. Lett. 10 (2019) 7823-7830.
  https://doi.org/10.1021/acs.jpclett.9b03119


[S3] R. Thyagarajan et al., Chem. Mater. 32 (2020) 8020-8033.
  https://doi.org/10.1021/acs.chemmater.0c03057


[S4] K. Li et al., J. Chem. Phys. 154 (2021) 184505.
  https://doi.org/10.1063/5.0046073


[S5] R. DeVane et al., J. Phys. Chem. B 114 (2010) 16364–16372.
  https://doi.org/10.1021/jp1070264
------------------------------------------------------------------------------
# Input File Creation for the Molecular Dynamics Program LAMMPS.
  https://www.osti.gov/biblio/1230587
------------------------------------------------------------------------------
# Electron-phonon dynamics for LAMMPS
  https://www.osti.gov/biblio/1488434
------------------------------------------------------------------------------
# Sensitivity Analysis and Uncertainty Quantification for the LAMMPS Molecular Dynamics Simulation Code
  https://www.osti.gov/biblio/1372820
------------------------------------------------------------------------------
# LAVA
  https://www.osti.gov/biblio/1872392
------------------------------------------------------------------------------
# Hydrodynamic forces implemented into LAMMPS through a lattice-Boltzmann fluid
  https://doi.org/10.1016/j.cpc.2013.03.024
------------------------------------------------------------------------------
# SpecTAD
  https://www.osti.gov/biblio/1404911
------------------------------------------------------------------------------
# Coarse-Grained Reactive Molecular Dynamics Simulations of Heterogeneities in Shocked Energetic Materials (LDRD Final Report)
  https://www.osti.gov/biblio/1733244
------------------------------------------------------------------------------
# Research data supporting 'Theoretical prediction of thermal polarisation'
  https://www.repository.cam.ac.uk/items/96675177-1b90-4fa3-918a-bff9e9e9e1e5
  https://doi.org/10.17863/CAM.22951
------------------------------------------------------------------------------
# Research data supporting "Numerical Evidence for Thermally Induced Monopoles"
  https://www.repository.cam.ac.uk/items/b172fdb0-aed8-427d-be58-3d400dfee80c
  https://doi.org/10.17863/CAM.8607
------------------------------------------------------------------------------
# Stabilization of AgI’s polar surfaces by the aqueous environment, and its implications for ice formation (data set)
  https://www.repository.cam.ac.uk/items/40aa2d96-6b55-4b3d-acb0-409a183966b3
  https://doi.org/10.17863/CAM.43502
------------------------------------------------------------------------------
# Research data supporting 'Physics-driven coarse-grained model for biomolecular phase separation with near-quantitative accuracy'
  https://www.repository.cam.ac.uk/items/35c30a45-f343-4fa2-bf85-6aa2984d1169
  https://doi.org/10.17863/CAM.69854
------------------------------------------------------------------------------
# GCMC (Lecture): https://www.osti.gov/servlets/purl/1120653
------------------------------------------------------------------------------