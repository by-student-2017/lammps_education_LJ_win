# Auther (original, python2): Murashima @ Tohoku Univ on Dec/8/2020
# slightly modified: By Student on Dec/31/2020
# Python 3.9

import math
def lin_func(x1,x2,y1,y2,x):
    a=(y2-y1)/(x2-x1)
    b=y1-a*x1
    return a*x+b

time=[]
Gt=[]
count=0
file=open('gt.txt','r')
string=file.readline()
while string:
    string=string.strip()
    data=string.split()
    time.append(float(data[0]))
    Gt.append(float(data[1]))
    count+=1
    #print (string)
    string=file.readline()
file.close()

G1=[]
G2=[]
w=[]

for i in range(count-1):
    wi=1.0/time[count-1-i]
    G11=0.0
    G22=0.0
    t=0.0
    dt=0.01
    while time[0]>t:
        t+=dt
    
    for k in range(count-1):
        while time[k+1]>t:
            t0=t
            t1=t+dt
            Gk0=lin_func(time[k],time[k+1],Gt[k],Gt[k+1],t0)
            Gk1=lin_func(time[k],time[k+1],Gt[k],Gt[k+1],t1)
            #print(t1,Gk1)
            wk=(t1-t0)*0.5
            wit0=wi*t0
            wit1=wi*t1
            G11+=wk*(Gk0*math.sin(wit0)+Gk1*math.sin(wit1))
            G22+=wk*(Gk0*math.cos(wit0)+Gk1*math.cos(wit1))
            t=t1
    print (wi,wi*G11,wi*G22)
    w.append(wi)
    G1.append(wi*G11)
    G2.append(wi*G22)

file=open('g1g2.txt','w')
for i in range(count-1):
    line=str(w[i])+" "+str(G1[i])+" "+str(G2[i])+"\n"
    file.write(line)
file.close()

