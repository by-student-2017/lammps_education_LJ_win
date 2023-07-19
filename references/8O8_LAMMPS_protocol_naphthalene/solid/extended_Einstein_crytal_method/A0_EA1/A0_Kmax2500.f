      !this script calculates the analytic A0 in the extended Einstein crystal method
      !Kmax is in kT/Å^2 for the harmonic equation u = Kmax*(r-r0)^2 = 0.5*kmax*(r-r0)^2--> Kmax=4221.640615 kT/Å^2 = 2500 kcalmol-1/Å^2
      !kmax = 5000 kcalmol-1/Å^2  for the harmornic equation u = 0.5kmax(r-r0)^2
      !Note that kmax = 2*Kmax
      !both kmax and Kmax are used in this work because: 
      !for "fix spring/self" in LAMMPS, the spring energy equation is u = 0.5*kmax*r^2 so 0.5*kmax = Kmax in u = Kmax*(r-r0)^2 
      !this is why we need to use k between kmin=0 and kmax = 5000 kcalmol-1/Å^2 for K between Kmin = 0 and Kmax = 2500 kcalmol-1/Å^2 during computing ΔA0 and ΔA2
      !landa is the de Broglie wavelength that is equated to be 1Å for both the solution and solid
      !this code is based upon the code from reference 38:
      !J. L. Aragones, C. Valeriani, and C. Vega, J. Chem. Phys. 137, 146101 (2012).
      !Note: Free Energy Calculations for Atomic Solids through the Einstein Crystal/molecule Methodology Using GROMACS and LAMMPS
       pi=acos(-1.000)
       Kmax=4221.640615
       landa=1.
       x1=3./2.*(1.)
       x2=alog(Kmax/pi)
       a0=x1*x2
       write(6,*) "A_0/(NkT)=",a0
       stop
       end

