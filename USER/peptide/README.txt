If you get bogus, large energies on timestep 0 when you run this
example in.peptide, you likely have a machine/compiler problem with
the pair_style "long" potentials which use Coulombic tabling by
default.

See the "Additional build tips" sub-section of the manual in
Section_start.html in the "Making LAMMPS" section for details and
suggestions on how to work around this issue.


Ovito v.3.0.0-dev791
---------- ---------- ---------- ---------- ---------- ---------- 
A. transparecy
1. click cfg file (or drag&drop cfg on Ovito.
2. Add modification -> Selection -> Select type -> check HH and OH
3. Add modification -> Modification -> Compute property
  -> Output poroperty [Transparency] -> check "Compute only for selected elements"
  -> Expression [0.9]
4. Add modification -> Selection -> Select type

B. delete atom
1. click cfg file (or drag&drop cfg on Ovito.
2. Add modification -> Selection -> Select type -> check C, H, N, O and S
3. Add modification -> Selection -> Expand selection -> Cutoff distance [5]
4. Add modification -> Selection -> Invert selection
5. Add modification -> Modification -> Delete selected
---------- ---------- ---------- ---------- ---------- ---------- 