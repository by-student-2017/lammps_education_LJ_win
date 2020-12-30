#!/usr/bin/gnuplot
# Auther (original): Murashima @ Tohoku Univ on Dec/8/2020
# slightly modified: By Student on Dec/31/2020

#-----High molecular settings-----
# conditions on in.lmp
N=10            # = nch on in1.lmp. 10 = data1_10.in, 5 = data1_5.in (step1)
M=10*10*10      # = n, number of replicate on in2.lmp. (step2)
Density=0.85    # rho
Temperature=1.0
#
#tau_R=N*N # for Rouse function. tau_R is N*N order.
tau_R=300  # maybe, depend on "exbond index 16" (step3) settings, too.

#-----main process-----

set terminal win font "Arial,12"

set format x "10^{%L}"
set format y "10^{%L}"

set xlabel "Time [{/Symbol t}]"
set ylabel "Relaxation modulus [{/Symbol e/s^3}]"
set logscale
set xrange [1.0e-2:1.0e+6]
set yrange [1.0e-4:]

Volume=N*M/Density
Coefficient=Density*Temperature/N

Rouse(t,p)=(p>=1 ? Rouse(t,p-1)+Coefficient*exp(-2.0*t*p**2/(tau_R)) :0.0)

### Equation (7.31) p. 226 in Doi-Edwards. 

V_T=Volume/Temperature

set size square

#p Rouse(x,10) t 'Rouse' w l lw 2 lc rgb "magenta",\
#'corr.long.5.dat' u 1:( V_T*( ($2+$3+$4)/6.0+($5+$6+$7)/24.0 ) ) t 'corr.long.dat' w lp lw 2 lc rgb "dark-violet",\
#'corr.long.6.dat' u 1:( V_T*( ($2+$3+$4)/6.0+($5+$6+$7)/24.0 ) ) t 'corr.long.6.dat' w lp lw 2 lc rgb "sea-green",\
#'corr.long.7.dat' u 1:( V_T*( ($2+$3+$4)/6.0+($5+$6+$7)/24.0 ) ) t 'corr.long.7.dat' w lp lw 2 lc rgb "blue",\
#'corr.long.8.dat' u 1:( V_T*( ($2+$3+$4)/6.0+($5+$6+$7)/24.0 ) ) t 'corr.long.8.dat' w lp lw 2 lc rgb "dark-violet",\
#
### Ramirez et al, J. Chem. Phys. 133 (2010) 154103.
p Rouse(x,10) t 'Rouse' w l lw 2 lc rgb "magenta",\
'corr.long.5.dat' u 1:( V_T*( ($2+$3+$4)/5.0+($5+$6+$7)/30.0 ) ) t 'corr.long.5.dat' w lp lw 2 lc rgb "dark-violet" #,\
#'corr.long.6.dat' u 1:( V_T*( ($2+$3+$4)/5.0+($5+$6+$7)/30.0 ) ) t 'corr.long.6.dat' w lp lw 2 lc rgb "sea-green",\
#'corr.long.7.dat' u 1:( V_T*( ($2+$3+$4)/5.0+($5+$6+$7)/30.0 ) ) t 'corr.long.7.dat' w lp lw 2 lc rgb "blue",\
#'corr.long.8.dat' u 1:( V_T*( ($2+$3+$4)/5.0+($5+$6+$7)/30.0 ) ) t 'corr.long.8.dat' w lp lw 2 lc rgb "dark-violet"

#pause -1

set terminal postscript enhanced color eps "Arial,24"
set output "corr.long.eps"
replot

set terminal png
set output "corr.long.png"
replot

set terminal postscript color enhanced lw 2
set out "corr.long.ps"
replot