#!/bin/bash 

nmol=865 #total number of molecules 
nmolsolvent=864 #total number of solvent molecules 
D=18 #number of lines in "lambda2.dat"


rm -rf ./*~
rm -rf *Error*
rm -rf *Average*
rm -rf *_result
rm -rf mu*.dat 

#ΔG_insert_vdwl = integration{<dUsolute-solvent(lambda_vdwl)/dlambda_vdwl> dlambda_vdwl} for lambda_vdwl = 1.0 and lambda_vdwl = 0 
#"Average_delta.dat" --> second column is the integrand <Usolute-solvent(lambda_vdwl)> 
#so <dUsolute-solvent(lambda_vdwl)/dlambda_vdwl> = <Usolute-solvent(lambda_vdwl)/lambda_vdwl>
#obtain ΔG_insert_vdwl via quadrature method (e.g. simple trapezium/Legendre-Gauss quadrature)
#"Average_delta_Error.dat" contains (the blocking average) errors for "Average_delta.dat" --> "number nblock average error standard_deviation error_in_error"
#"mu.dat" --> free energy perturbation contributions to ΔG_insert_vdwl (add up)
#"mu_etail.dat" --> free energy perturbation contributions to ΔG_insert_vdwl_etail (add up)

echo "number nblock average error standard_deviation error_in_error" > Average_ΔError.dat
echo "label average" > Average_delta.dat
gcc blockaverage.c -o blockaverage -lm

(for((i=1; i<$D+1; i++)); do

    read num Astart Astop rho lambdastart lambdastop e13 e14 e13p e14p

    echo $num
    rm -rf ./*$num-$Astart-$Astop-$rho-$lambdastart-$lambdastop-$e13-$e14*/histogram*
    rm -rf ./*$num-$Astart-$Astop-$rho-$lambdastart-$lambdastop-$e13-$e14*/Final*
    rm -rf ./*$num-$Astart-$Astop-$rho-$lambdastart-$lambdastop-$e13-$e14*/block*

    \cp ./blockaverage ./*$num-$Astart-$Astop-$rho-$lambdastart-$lambdastop-$e13-$e14*
    \cp ./Final_a2_etailonly.sh ./*$num-$Astart-$Astop-$rho-$lambdastart-$lambdastop-$e13-$e14*
    \cp ./Final_a2.sh ./*$num-$Astart-$Astop-$rho-$lambdastart-$lambdastop-$e13-$e14*
    cd ./*$num-$Astart-$Astop-$rho-$lambdastart-$lambdastop-$e13-$e14*


    #this is to sample the vdwl TI integrand terms dUsolute-solvent/dlambda_vdwl (can refer to the input files for details) 
    awk -v a=$nmol -v NORM=$Astart '{print ($12)*2}' energies_intra2.dat > Uintra2_$Astart.dat
    awk -v a=$nmol -v NORM=$Astart '{print ($12-$10*0.5)*2}' energies3.dat > Ureal3_$Astart.dat
    paste -d' ' Uintra2_$Astart.dat Ureal3_$Astart.dat > Intra2_Real3.dat
    rm -rf Uintra2_$Astart.dat Ureal3_$Astart.dat
    awk '{print (($2)-($1))}' Intra2_Real3.dat > ΔReal3.dat
    rm -rf Intra2_Real3.dat
    ./blockaverage ΔReal3.dat
    tail -7 Error | head -1 >> ../Average_ΔError.dat
    delta=`echo $OUTPUT | awk '{s+=$1}END{print s/NR}' ΔReal3.dat`
    echo $num-$Astart-$Astop-$rho-$lambdastart-$lambdastop-$e13-$e14 $delta >> ../Average_delta.dat

    #this is to compute the FEP terms of G_insert_vdwl
    ./Final_a2.sh > here
    echo $num-$Astart-$Astop-$rho-$lambdastart-$lambdastop-$e13-$e14 > file
    cat file | tr "\n" " " >> ../mu.dat
    tail -1 here >> ../mu.dat
    #./blockaverage exp_u_sol-u_latt.dat
    #mv Error Error_mu.dat

    #this is to compute the tail corrections to G_insert_vdwl via FEP 
    ./Final_a2_etailonly.sh > here
    echo $num-$Astart-$Astop-$rho-$lambdastart-$lambdastop-$e13-$e14 > file
    cat file | tr "\n" " " >> ../mu_etail.dat
    tail -1 here >> ../mu_etail.dat
    #./blockaverage exp_u_sol-u_latt.dat
    #mv Error Error_mu_etail.dat

    cd ../
	
    done) < ./lambda2.dat
