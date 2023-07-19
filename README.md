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


## Installation (MSMPI)
1. https://rpm.lammps.org/windows/admin/64bit/index.html
2. LAMMPS-64bit-22Dec2022-MSMPI-admin.exe (https://rpm.lammps.org/windows/admin/64bit/LAMMPS-64bit-22Dec2022-MSMPI-admin.exe)
3. Microsoft MPI v10.1.2 (https://www.microsoft.com/en-us/download/details.aspx?id=100593)
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


[IFL35] F. Azough et al., (2017).
  https://doi.org/10.15125/BATH-00463
  La1-3NbO3


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


[IFL42] X. Bai et al., ACS Appl. Mater. Interfaces 10 (2018) 20368-20376.
  https://doi.org/10.1021/acsami.8b06764


[IFL43] G. Gyawali et al., J. Chem. Theory Comput. 13 (2017) 3846-3853.
  https://doi.org/10.1021/acs.jctc.7b00389


[IFL44] K. Kempfer et al., Macromolecules 52 (2019) 2736-2747.
  https://doi.org/10.1021/acs.macromol.8b02750


[IFL45] C. Li et al., Macromolecules 44 (2011) 9448-9454.
  https://doi.org/10.1021/ma201927n


[IFL46] A. Pereverzev et al., Int. J. Heat Mass Transf. 188 (2022) 122647.
  https://doi.org/10.1016/j.ijheatmasstransfer.2022.122647


[IFL47] P. M. Zeiger, https://www.diva-portal.org/smash/get/diva2:856842/FULLTEXT01.pdf


[IFL48] S. H. Jamali et al., J. Chem. Inf. Model. 59 (2019) 1290-1294.
  https://doi.org/10.1021/acs.jcim.8b00939


[IFL49] R. Beljon et al., Master (2021).
  https://pure.tue.nl/ws/portalfiles/portal/172431062/MCE_afstudeerverslag_Roos_Beljon_0959426_.pdf


[IFL50] J. E. Carpenter et al., J. Chem. Phys. 158 (2023) 074901.
  https://doi.org/10.1063/5.0131179


[IFL51] E. Crabb et al., J. Chem. Theory Comput. 16 (2020) 7255-7266.
  https://doi.org/10.1021/acs.jctc.0c00833


[IFL52] Summer Research Project Report - 2014
  https://www.researchgate.net/profile/Abhilash-Sahoo-2/publication/279200724_Molecular_Dynamics_Simulations_In_Polymers/links/558f861a08aed6ec4bf52e70/Molecular-Dynamics-Simulations-In-Polymers.pdf


[IFL53] Y. Zhang et al., J. Chem. Eng. Data 63 (2018) 3488-3502.
  https://doi.org/10.1021/acs.jced.8b00382


[IFL54] G. M. Tow et al., J. Chem. Phys. 149 (2018) 244502.
  https://doi.org/10.1063/1.5054758


[IFL55] C. M. Tenney et al., J. Chem. Eng. Data 59 (2014) 391-399.
  https://doi.org/10.1021/je400858t


[IFL56] V. Tikkanen et al., PNAS 119 (28) e2201955119.
  https://doi.org/10.1073/pnas.2201955119


[IFL57] - C. C. Walker et al., J. Chem. Phys. 152 (2020) 044903.
  https://doi.org/10.1063/1.5126213


[IFL58] J. V. Vermaas et al., J. Chem. Inf. Model. 56 (2016) 1112-1116.
  https://doi.org/10.1021/acs.jcim.6b00103


[IFL59] S. Yue et al., Mol. Syst. Des. Eng., 8 (2023) 527-537.
  https://doi.org/10.1039/D2ME00237J


[IFL60] S. Ariga et al., Phys. Chem. Chem. Phys., 24 (2022) 2567-2581.
  https://doi.org/10.1039/D1CP05393K


[IFL61] S. H. Jamali et al., J. Chem. Theory Comput. 14 (2018) 6690-6700.
  https://doi.org/10.1021/acs.jctc.8b00909


[IFL62] A. T. Kleinschmidt et al., J. Phys. Chem. B 127 (2023) 2092-2102.
  https://doi.org/10.1021/acs.jpcb.2c08843


[IFL63] S. W. Robert, (2019).
  https://core.ac.uk/download/pdf/188181601.pdf


[IFL64] E. J. Chan et al., J. Chem. Theory Comput. 14 (2018) 2165-2179.
  https://doi.org/10.1021/acs.jctc.7b01073


[IFL65] S. H. Jamali et al., J. Chem. Theory Comput. 14 (2018) 2667-2677.
  https://doi.org/10.1021/acs.jctc.8b00170


[IFL66] M. Freguson et al., Chem. Sci., 10 (2019) 2924-2929.
  https://doi.org/10.1039/C8SC04971H


[IFL67] E. J. Chan, J. Appl. Cryst. 48 (2015) 1420-1428.
  https://doi.org/10.1107/S1600576715013242


[IFL68] M. Vaezi et al., J. Chem. Phys. 153 (2020) 234702.
  https://doi.org/10.1063/5.0029490


[IFL69] S. R. Yeandel et al., J. Chem. Phys. 157 (2022) 084117.
  https://doi.org/10.1063/5.0095130


[IFL70] B. Cheng et al., Phys. Chem. Chem. Phys., 20 (2018) 28732-28740.
  https://doi.org/10.1039/C8CP04561E


[IFL71] N. V. S. Avula et al., J. Phys. Chem. Lett. 9 (2018) 3511-3516.
  https://doi.org/10.1021/acs.jpclett.8b01481


[IFL72] P. Zhao et al., J. Phys. Chem. C 125 (2021) 22747-22765.
  https://doi.org/10.1021/acs.jpcc.1c05139


[IFL73] K. Knausgard, Master Thesis (2012).
  https://ntnuopen.ntnu.no/ntnu-xmlui/handle/11250/237117
  water-graphene


[IFL74] R. Perriot et al., J. Appl. Phys. 130 (2021) 145106.
  https://doi.org/10.1063/5.0063163


[IFL75] P. Zhao et al., PEP 45 (2020) 196-222.
  https://doi.org/10.1002/prep.201900382


[IFL76] S. Townsend et al., Bachelor Thesis (2018).
  https://dspace.mit.edu/handle/1721.1/119936


[IFL77] A. S. Bowen et al., J. Chem. Theory Comput. 14 (2018) 6495-6504.
  https://doi.org/10.1021/acs.jctc.8b00742


[IFL78] A. Renganathan et al., (2021).
  https://etd.ohiolink.edu/apexprod/rws_olink/r/1501/10?clear=10&p10_accession_num=osu161922120604859
  NaCl-UCl3


[IFL79] F. Philippi et al., Phys. Chem. Chem. Phys., 24 (2022) 3144-3162.
  https://doi.org/10.1039/D1CP04592J


[IFL80] M. Hammer et al., J. Chem. Phys. 158 (2023) 104107.
  https://doi.org/10.1063/5.0137226


[IFL81] Y. Li et al., Langmuir 39 (2023) 7684-7693.
  https://doi.org/10.1021/acs.langmuir.3c00484


[IFL82] D. Penley et al., J. Chem. Eng. Data 67 (2022) 1810-1823.
  https://doi.org/10.1021/acs.jced.2c00294


[IFL83] S. Jayaraman et al., Ind. Eng. Chem. Res. 49 (2010) 559-571.
  https://doi.org/10.1021/ie9007216


[IFL84] L. Li et al., J. Chem. Phys. 149 (2018) 054102.
  https://doi.org/10.1063/1.5040366


[IFL85] B. Yang, (2020)
  "Mechanical properties of graphene-borophene heterostructures grain boundaries"
  https://www.researchgate.net/profile/Bo-Yang-183/publication/345384762_Mechanical_properties_of_graphene-borophene_heterostructures_grain_boundaries_Molecular_dynamic_modeling/links/5fa53c47a6fdcc062418b314/Mechanical-properties-of-graphene-borophene-heterostructures-grain-boundaries-Molecular-dynamic-modeling.pdf


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
# Parameters (buck  Buckingham potential)


[P1] Y.-J. Hu et al., npj Comput. Mater. 6 (2020) 25.
  https://doi.org/10.1038/s41524-020-0291-z
  Predicting densities and elastic moduli of SiO2-based glasses by machine learning
  Table 1 Effective ionic charge and Buckingham potential parameters used for MD simulations


[P2] H. Araghi et al., J. Solid State Chem. 258 (2018) 640-646.
  https://doi.org/10.1016/j.jssc.2017.11.038
  Ba0.9A0.1TiO3-δ (A: Li+, Na+, Ca2+), and BaTi0.9B0.1O3-δ (B: V3+, Cr3+, Si4+) crystals
  Table 3. Buckingham potential parameters 


[P3] Z. Zhou, Masters Thesis (2021)
  DOI: https://doi.org/10.26190/unsworks/22417
  https://unsworks.unsw.edu.au/bitstreams/cae11e0d-4892-48b8-866f-68c915988966/download
  Table. 3.1.1.1 Parameters of the Buckingham potentials for SrTiO3


[P4] P. Goj et al., Materials 14 (2021) 4326.
  https://doi.org/10.3390/ma14154326
  SrO, Sr2P2O7, Sr(PO3)2, SrFe3(PO4)3O, SrFe3(PO4)3, and SrFe2(P2O7)2 
  Table 1. Values of the Buckingham potential parameters of the i-j pair.
  

[P5] J. Won et al., J. Mater. Chem. A, 1 (2023) 9235-9245.
  DOI: 10.1039/C3TA11046J 
  Table 1 Parameters for the spline between the ZBL and the Buckingham potential used in 
  the collision cascade simulations. The units of ra and rb are Å while those of fn are Ån−1. 
  In the case of Ti–O, because the potential becomes negative within the splined region, 
  the spline is fit to an offset version of the potential and then reshifted back to the original energies


[P6] S. Ghorbanali et al., Solid State Commun. 252 (2017) 16-21.
  https://doi.org/10.1016/j.ssc.2017.01.004
  Table 1. Parameters of shell model and Buckingham potential for BaTiO3 NWs.


[P7] S. Yue et al., Phys. Chem. Chem. Phys., 24 (2022) 21440-21451.
  DOI: 10.1039/D2CP02989H 
  BaZrO3
  Table 1 Potential parameters of Buckingham


[P8] S. R. G. Balestra et al., J. Mater. Chem. A,  8 (2020) 11824-11836.
  DOI: 10.1039/D0TA03200J 
  Table 1 Fractional point charges considered in the genetic algorithm and 
  resulting force field potential parameters for CsPb(BrxI1−x)3 perovskites


[P9] S. S. I. Almishal et al., RSC Adv., 10 (2020) 44503-44511.
  10.1039/D0RA08434D
  Table 1 Coulomb–Buckingham potential model parameters of CsPbI3


[P10] Z. Lu et al., Phys. Chem. Chem. Phys., 17 (2015) 32547-32555.
  10.1039/C5CP05722A 
  Li3OCl anti-perovskite superionic conductors
  Table 1 Buckingham potential parameters


[P11] K. Sau et al., Chem. Mater. 33 (2021) 2357-2369.
  https://doi.org/10.1021/acs.chemmater.0c04473
  Li2B12H12 and LiCB11H12
  Table 1. Interionic Potential Pair Parameters Employed in the Present Studya


[P12] H. Kim et al., Doctoral Thesis (2016)
  https://scholarworks.unist.ac.kr/handle/201301/18294 -> 000003.pdf
  O-X (X=Li+, Co3+, Ni3+, Al3+, O2-)
  Table 3.2.4. Interaction parameters of short-range Buckingham potential and charge of each ion.


[P13] X. Lu et al., J. Phys. Chem. B 125 (2021) 12365-12377.
  https://doi.org/10.1021/acs.jpcb.1c07134
  0-X (X=Si2.4+, Al1.8+, B1.8+, Zr2.4+, Na0.6+, Ca1.2+, V2.4+, V3.0+, O1.2-)
  Table 2. Atomic Charges and Buckingham Potential Parameters


[P14] F. A. G. Daza et al., ACS Appl. Mater. Interfaces 11 (2019) 753-765.
  https://doi.org/10.1021/acsami.8b17217
  Table S1: Buckingham parameters for Ga- and Al-substituted LLZO prior to fine tuning. 
  The values were taken from Jalem et al. 1 for Ga-substituted LLZO, and from Pedone et al. 6 for the Al-O potential.


[P15] Y. Ji et al., Nucl. Instrum. Methods. Phys. Res. B 393 (2017) 54-58.
  https://doi.org/10.1016/j.nimb.2016.09.031
  LaPO4
  Table 1. The Buckingham potential parameters used in the simulations
  
  
[P16] K. Dai et al., Ionics volume 27 (2021) 1477-1490.
  https://doi.org/10.1007/s11581-021-03940-2
  LiFePO4
  Table 1 Interatomic potentials used for the simulation


[P17] K. Sau et al., J. Phys. Chem. C 119 (2015) 1651-1658.
  https://doi.org/10.1021/jp5094349
  monazite-type LaPO4 ceramics
  Table 1. Interionic Potential Pair Parameters Employed in the Present Study.


[P18] J. W. Che et al., Chem. Phys. Lett. 697 (2018) 48-52.
  https://doi.org/10.1016/j.cplett.2018.02.060
  La2(Zr0.7Ce0.3)2O7
  Table 1. The parameters for Coulomb-Buckingham potential in this study.


[P19] Y. Ji et al., 2018.
  https://publications.rwth-aachen.de/record/749291/files/749291.pdf
  Table 3.1: The Buckingham potential parameters used in the simulations of LnPO4 monazite (m) and xenotime (x). 


[P20] Y.-T. Lee et al., ACS Appl. Mater. Interfaces, 13 (2021) 570-579.
  https://doi.org/10.1021/acsami.0c18368
  Mn3O4 for Lithium-Ion Battery
  Table 1. Morse Potential and Buckingham Potential Parameters


[P21] A. Lanjan et al., ACS Appl. Mater. Interfaces 13 (2021) 42220-42229.
  https://doi.org/10.1021/acsami.1c12322
  Table A3. Force Field Parameters for the Primary Li2O Crystal Structure for the Buck/Coul/Long Force Field
  
  
[P22] H. Lu, Thesis or dissertation
  https://spiral.imperial.ac.uk/handle/10044/1/9499
  Table 3.1: Potential parameter sets for Li2O


[P23] S. Dahl et al., Chem. Mater. 34 (2022) 7788-7798.
  https://doi.org/10.1021/acs.chemmater.2c01246
  Table 1. Interatomic Pair Potential Parameters for LCO and Dopant–Oxygen Interactions in the Buckingham Coulomb Potential
  
  
[P24] K. Sau et al., Mater. Adv., 4 (2023) 2269-2280.
  DOI: 10.1039/D2MA00936F 
  Table 1 Inter-ionic potential parameters employed in this study


[P25] Y. Luo et al., Results Phys. 14 (2019) 102490.
  https://doi.org/10.1016/j.rinp.2019.102490
  Table 1. Interatomic potentials used for Li3V2(PO4)3 material (a) two body, (b) three body.


[P26] O. A. Restrepo et al., Solid State Commun. 354 (2022) 114914.
  https://doi.org/10.1016/j.ssc.2022.114914
  Table 1. Buckingham spinel parameters for ZnFe2O4 spinel systems


[P27] K. Sau et al., Phys. Rev. Materials 6 (2022) 04540.
  https://doi.org/10.1103/PhysRevMaterials.6.045406
  Na2LiFeTeO6
  TABLE I. Interionic potential parameters employed in this study.

[P28] K. Sau et al., J. Phys. Chem. C 119 (2015) 18030-18037.
  https://doi.org/10.1021/acs.jpcc.5b04087
  Na2Ni2TeO6
  Table 1. Interionic Potential Pair Parameters Employed in Present Study


[P29] J. F. Troncoso et al., J. Phys.: Condens. Matter 32 (2020) 045701.
  DOI 10.1088/1361-648X/ab4aa8
  PbTe
  Table 1. Potential parameters. Partial charges are...


[P30] M. J. Clarke et al., ACS Appl. Energy Mater. 4 (2021) 5094-5100.
  https://doi.org/10.1021/acsaem.1c00656
  Li-Ion Conduction in the Li3OCl Antiperovskite Solid Electrolyte
  Table S1: Buckingham potentials parameters used to model doped Li3OCl


[P31] S. Stegmaier et al., Nanomaterials 12 (2022) 2912
  https://doi.org/10.3390/nano12172912
  Table S1. Mg2+ and Buckingham ρMg-ion parameters from local optimization of Mg3(PO4)2 volume.


[P32] A. Shkatulov et al., ACS Omega 7 (2022) 16371-16379.
  https://doi.org/10.1021/acsomega.2c00095
  Table 1. Buckingham Parameters for Interactions in MgO
  
  
[P33] P. Hirel et al., Phys Chem Minerals 48, 46 (2021).
  https://doi.org/10.1007/s00269-021-01170-6
  forsterite Mg2SiO4 from 0 to 12 GPa
  (see Supplementary Information)
  Table 1: Potential energy functions and parameters for the semi-empirical potentials compared in the present study. 
  
[P34] J. Wang et al., AIP Advances 9 (2019) 015123.
  https://doi.org/10.1063/1.5078639
  TABLE I. Three sets of the Buckingham potential parameters of Cr2O3.
  
  
[P35] Y. H. Lee et al., J. Mater. Chem. C, 11 (2023) 7595-7602.
  DOI: 10.1039/D3TC00753G
  Table 2 Buckingham potential parameters for the IGZO


[P36] Z. Liu et al., Chem. Phys. Lett. 760 (2020) 137901.
  https://doi.org/10.1016/j.cplett.2020.137901
  FeO3
  Table 1. Parameters in


[P37] M. J. Ghourichaei et al., Energy Equip. Sys. 8 (2020) 45-54.
  https://www.energyequipsys.com/article_39010_a2a01635ebb5f09583c3092008801460.pdf
  Fe-O


[P38] S. Dong et al., Phys. Chem. Chem. Phys., 24 (2022) 12837-12848.
  DOI: 10.1039/D1CP05749A
  Table 1 Interatomic potential parameters for beta-Ga2O3 in this work


[P39] J. Jose et al., Journal of Applied Physics 123 (2018) 245306.
  https://doi.org/10.1063/1.5020776
  TABLE I. Potential parameters for silica


[P40] K. H. Myint, Thesis
  https://dspace.mit.edu/handle/1721.1/145130
  Table 3.1: Summary of force field parameters used in the simulations.


------------------------------------------------------------------------------
# Series
  H. Tafrishi et al., RSC Adv., 12 (2022) 14776-14807.
  10.1039/D2RA02183H
  Table 1 Molecular dynamics simulation studies of phase change materials (PCMs)
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
# Gaussian Approximation Potential for Hexagonal Boron Nitride (hBN-GAP)
  https://www.repository.cam.ac.uk/items/3301a6bd-f276-4616-babd-1d0b9279707c
  https://doi.org/10.17863/CAM.66112
------------------------------------------------------------------------------
# Finite field formalism for bulk electrolyte solutions (data set)
  https://www.repository.cam.ac.uk/items/78713a30-8b8c-4d9c-8a84-eb0185778900
  https://doi.org/10.17863/CAM.44747
------------------------------------------------------------------------------
# Research data supporting "Classical quantum friction at water-carbon interfaces"
  https://www.repository.cam.ac.uk/items/3a91176e-428c-4163-9852-dcfcd6c40627
  https://doi.org/10.17863/CAM.89536
------------------------------------------------------------------------------
# Dataset for Catalyst-Mediated Enhancement of Carbon Nanotube Textiles by Laser Irradiation: Nanoparticle Sweating and Bundle Alignment
  https://www.repository.cam.ac.uk/items/350a8d7a-6c6c-4f77-90e9-509191f67393
  https://doi.org/10.17863/CAM.65746
------------------------------------------------------------------------------
# Simulation Toolkit for Renewable Energy Advanced Materials Modeling
  https://www.osti.gov/biblio/1259315
------------------------------------------------------------------------------
# Automated Algorithms for Quantum-Level Accuracy in Atomistic Simulations: LDRD Final Report.
  https://www.osti.gov/biblio/1158668
------------------------------------------------------------------------------
# Advancing Understanding of Fission Gas Behavior in Nuclear Fuel through Leadership Class Computing
  https://www.osti.gov/biblio/1523789
------------------------------------------------------------------------------
# BFEE: A User-Friendly Graphical Interface Facilitating Absolute Binding Free-Energy Calculations
  https://doi.org/10.1021/acs.jcim.7b00695
------------------------------------------------------------------------------
# GCMC (Lecture): https://www.osti.gov/servlets/purl/1120653
------------------------------------------------------------------------------
# CavMD: Cavity Molecular Dynamics Simulations
  https://github.com/TaoELi/cavity-md-ipi
------------------------------------------------------------------------------
# Epoxy resins: https://nics.utk.edu/wp-content/uploads/sites/275/2021/08/19-Schoff-final-presentation.pdf
------------------------------------------------------------------------------
# CP2k: https://doi.org/10.1021/acs.jpcc.0c00190
------------------------------------------------------------------------------
# Interatomic Potentials Repository Project
  https://www.ctcms.nist.gov/potentials/Download/2020Workshop/Hale-Interatomic-Potentials-Repository-Project.pdf
------------------------------------------------------------------------------
# PLUMED による平均力ダイナミクス（LogMFD/TAMD/AFED）の実行 (Japanese)
  https://doi.org/10.11436/mssj.22.269
------------------------------------------------------------------------------
# 無焼成固化のための摩砕プロセスをモデル化したシリカ界面の分子動力学解析
  https://doi.org/10.2472/jsms.71.167
------------------------------------------------------------------------------