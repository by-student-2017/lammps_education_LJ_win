"""
Based on the results of functionality_analysis.py (functionality.txt), determine
finalization folders and NPT folders for functionalities ranging from 3.0 - max
so that a shell script can create them
"""

import os
import sys

def main():
    # functionality value
    func = float(sys.argv[1])
    with open('functionality.txt', 'r') as f:
        lines = f.readlines()

    for i in range(1,len(lines)):
        vals = lines[i].split()
        line_func = float(vals[0])
        if line_func >= func:
            step_num = i - 1
            break

    print(step_num)
    return step_num

if __name__ == '__main__':
    main()
