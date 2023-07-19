#!/bin/bash                                                                                                                                                                       
#this is the submit script for computing ΔG_insert_electrostatic

cd /workingdirectory/solution/insert_charge
location=$PWD

#this is the directory containing all the LAMMPS input files
location2=$location/IFile_insert_charge

#directory to store data
rm -rf $location/director_insert_charge
mkdir $location/director_insert_charge

D=88 #number of chargecarbon-lambda combinations   
#number of line in "lamda2_charge.dat"                                                                                                                                                         

(for((i=1; i<$D+1; i++)); do

    read num Astart Astop rho lambdastart lambdastop chargehydrogen chargecarbon chargehydrogenp chargecarbonp
    #num = labbeling parameter
    #Astart = Astop = 300 kcal/mol   
    #rho = 1.0 for E_born = Aexp[(lambda-r)/rho]-C/r^6+D/r^8 of the LAMMPS Born potential
    #chargehydrogen --> equilibrium naphthalene hydrogen (partial) charge  
    #chargecarbon --> equilibrium naphthalene carbon (partial) charge (aromatic fusion carbons carry no charge)
    #chargehydrogenp --> perturbed naphthalene hydrogen (partial)charge 
    #chargecarbonp --> perturbed naphthalene carbon charge (partial) (not aromatic fusion carbons carry no charge)
    node=/scratch/insert_charge_$num-$Astart-$Astop-$rho-$lambdastart-$lambdastop-$chargecarbon-$chargehydrogen-$chargecarbonp-$chargehydrogenp
    node2=/scratch/insert_charge_$num-$Astart-$Astop-$rho-$lambdastart-$lambdastop-$chargecarbon-$chargehydrogen-$chargecarbonp-$chargehydrogenp.re 
    wd=$location/director_insert_charge/insert_charge_$num-$Astart-$Astop-$rho-$lambdastart-$lambdastop-$chargecarbon-$chargehydrogen-$chargecarbonp-$chargehydrogenp #the one in home that is created in energies.sh
    
    rm -r $wd 
    mkdir $wd

    jobid=`qsub -v num=$num,Astart=$Astart,Astop=$Astop,rho=$rho,lambdastart=$lambdastart,lambdastop=$lambdastop,chargecarbon=$chargecarbon,chargehydrogen=$chargehydrogen,chargecarbonp=$chargecarbonp,chargehydrogenp=$chargehydrogenp,location=$location,location2=$location2,node=$node,node2=$node2,wd=$wd,O=$x -N insert_charge-$num-$Astart-$Astop-$rho-$lambdastart-$lambdastop-$chargecarbon-$chargehydrogen-$chargecarbonp-$chargehydrogenp energies_insert_charge.sh`
    
    done) < $location/lamda2_charge.dat 





