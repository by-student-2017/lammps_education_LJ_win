import os
import sys

# Fix LAMMPS datafile by replacing the header (all coefficients and coefficient types)

def main():
    in_file = sys.argv[1]
    ref_file = './../ref.lmps'

    with open(in_file, 'r') as f:
        lines = f.readlines()

    with open(ref_file, 'r') as f:
        ref_lines = f.readlines()[17:]

    end_head_flag = False
    ref_head_flag = False
    i = 0
    with open(in_file, 'w') as f:
        f.write(lines[0])
        f.write(lines[1])
        f.write(lines[2])
        f.write(lines[4])
        f.write(lines[6])
        f.write(lines[8])
        f.write(lines[10])
        f.write(lines[1])
        f.write(lines[3])
        f.write(lines[5])
        f.write(lines[7])
        f.write(lines[9])
        f.write(lines[11])
        f.write(lines[12])
        f.write(lines[13])
        f.write(lines[14])
        f.write(lines[15])
        f.write(lines[16])
        lines = lines[17:]
        while ref_head_flag is False:
            f.write(ref_lines[i])
            if ref_lines[i+1] == 'Atoms\n':
                ref_head_flag = True
            i += 1
        for line in lines:
            if end_head_flag is False:
                pass
                if line == 'Atoms # full\n':
                    end_head_flag = True
                    f.write(line)
            else:
                f.write(line)

if __name__ == '__main__':
    main()
