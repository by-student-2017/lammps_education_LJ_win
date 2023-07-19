import os
import sys

# Fix LAMMPS datafile by replacing the header (all coefficients and coefficient types)

def main():
    in_file = sys.argv[1]
    ref_file = './../ref.lmps'

    with open(in_file, 'r') as f:
        lines = f.readlines()

    with open(ref_file, 'r') as f:
        ref_lines = f.readlines()[18:]

    end_head_flag = False
    ref_head_flag = False
    i = 0
    with open(in_file, 'w') as f:
        for j in range(18):
            f.write(lines[j])
        lines = lines[18:]
        while ref_head_flag is False:
            f.write(ref_lines[i])
            if ref_lines[i+1] == 'Atoms\n':
                ref_head_flag = True
            i += 1
        for line in lines:
            if end_head_flag is False:
                pass
                if line == 'Atoms # full\n' or line == 'Atoms\n':
                    end_head_flag = True
                    f.write(line)
            else:
                f.write(line)

if __name__ == '__main__':
    main()
