gnuplot pre_gt.plt
find "  i" < pre_gt.txt > gt.txt
gnuplot gt.plt
python g1g2.py
gnuplot g1g2.plt

