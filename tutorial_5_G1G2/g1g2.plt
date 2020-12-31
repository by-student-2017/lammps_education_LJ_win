#!/usr/bin/gnuplot
# Auther (original): Murashima @ Tohoku Univ on Dec/8/2020

set format x "10^{%L}"
set format y "10^{%L}"

set xlabel "Frequency [{/Symbol t}^{-1}]"
set ylabel "Storage modulus, Loss modulus [{/Symbol e/s^3}]"
set logscale
set xrange [1.0e-3:1.0e+1]
set yrange [1.0e-3:]
N=10
M=1000
Density=0.85
Volume=N*M/Density
Temperature=1.0
Coefficient=Density*Temperature/N
tau_R=100

#Rouse(t,p)=(p>=1 ? Rouse(t,p-1)+Coefficient*exp(-2.0*t*p**2/(tau_R)) :0.0)

G1Rouse(w,p)=(p>=1 ? G1Rouse(w,p-1)+Coefficient*( (w*tau_R/(2.0*p**2))**2 )/ (1.0 + (w*tau_R/(2.0*p**2))**2 )   :0.0)

G2Rouse(w,p)=(p>=1 ? G2Rouse(w,p-1)+Coefficient*( (w*tau_R/(2.0*p**2)) )/ (1.0 +  (w*tau_R/(2.0*p**2))**2 )  :0.0)

### Equation (7.31) p. 226 in Doi-Edwards. 

set size square
set key left top

p \
'g1g2.txt' u 1:2 t "G'" w lp lt 1 lc rgb "red",\
'g1g2.txt' u 1:3 t "G''" w lp lt 1 lc rgb "sea-green",\
G1Rouse(x,10) t "G' (Rouse)" w l lw 2 lt 1 lc rgb "magenta",\
G2Rouse(x,10) t "G'' (Rouse)" w l lw 2 lt 1 lc rgb "blue"

#pause -1

set terminal postscript enhanced color eps "Arial,24"
set output "g1g2.eps"
replot

set terminal png
set output "g1g2.png"
replot

