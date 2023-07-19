//this is to analyse data using histogram 
#include <stdio.h>
#include <stdlib.h>
#include <math.h>


int main(int argc, char *argv[]){

  int ch; //to count lines 
  int i,j,k,l,m;
  int Nbin=100; //number of bins between min and max
  int N;   
  int bin;
  int count=0;  //number of lines in the file 
  int g[Nbin];
  double mean=0;
  double max;
  double min;
  double range; //max-min
  double delta; //range/Nbin
  double *A;
  double B;
  FILE* read;
  FILE* record;
  FILE* write;
  FILE* write2;


  //zero the bin
  for (k=1;k<=Nbin;k++){
    g[k]=0;
  } 
 
  
  if (argc != 2 || !(read = fopen(argv[1], "r")))
   {
     printf("enter a file as the argument\n");
     return -1;
    }


  while (!feof(read)){
    ch=fgetc(read);
    if (ch=='\n'){
      count++;
    }
  }
  N=count;
  printf("count=%d N=%d\n",count,N);
  fclose(read);  //1st time close


  read=fopen(argv[1], "r");
  write=fopen("G_Sumofmsd2.dat","w");
  write2=fopen("InG_Sumofmsd2.dat","w");
  record=fopen("record_Sumofmsd2.dat","w");

  
  //to find the max and min from the data 
  A=malloc(sizeof(double)*N);
  for (i=0;i<N;i++){
    fscanf(read,"%lf\n",&A[i]);
    //fscanf(read,"%*lf %*lf %*lf %*lf %*lf %*lf %*lf %*lf %*lf %*lf %*lf %*lf %*lf %lf %*lf %*lf\n",&A[i]);  

    mean=mean+A[i];

    //initiate max and min as the first element 
    if (i==0){
      min=A[i];
      max=A[i];
    }
    else{
      if (A[i]>max){
	max=A[i];
      }
      else{max=max;}

      if (A[i]<min){
        min=A[i];
      }      
      else{min=min;}
    }
    
    fprintf(record,"i=%d A=%lf\t",i,A[i]);
    fprintf(record,"max=%lf min=%lf\n",max,min);    
    //printf("i=%d A=%lf\n",i,A[i]);                                                                                                    
  }
  mean=mean/N;
  fclose(read); //second time close


  read=fopen(argv[1], "r");  
  range=max-min; //positive
  delta=range/Nbin; //positive
  fprintf(record,"range=%lf delta=%lf\n",range,delta);
  fprintf(record,"mean=%lf min=%lf min+delta*Nbin=%lf\n",mean,min,min+delta*Nbin);
  fclose(record); // first time close     



  //Add each element to the correct bin
  double test=0;
  for (j=0;j<N;j++){
    
    test=(A[j]-min)/delta;
    bin=floor((A[j]-min)/delta);


    if (test==bin) {
      bin=(int)(bin);
    }
    else {
      bin=(int)(bin+1.0); //bin is integer and floor() returns downward integer in the form of a double    
    }

    if(bin<=Nbin){
      g[bin]+=1; //bin would be from 1 to 100
    }     
    else{
      //      printf("bin=%d j=%d (A[j]-min)/delta=%d\n",bin,j,(A[j]-min)/delta);  
    }
  } 


  //sum up the <=Nbin from bin_1 to bin_100
  for (l=1;l<=Nbin;l++){  

    double countdIn=(double)count;
    int total_old=0;
    int total=0;
    
    for (m=1;m<=l;m++){
 
      total_old+=g[m-1];
      total=total+g[m];
      //total=g[l]; this produce the same G.dat as k loop
      
    }
    
    //    printf("total=%d for Nbin=%d\n",total,l); 
    fprintf(write2,"%d %.8lf %lf %lf\n",l,min+(l-1)*delta,total/countdIn,total_old/countdIn);
    fprintf(write2,"%d %.8lf %lf %lf\n",l,min+(l-1)*delta+delta*0.5,total/countdIn,total_old/countdIn);
    fprintf(write2,"%d %.8lf %lf %lf\n",l,min+(l-1)*delta+delta,total/countdIn,total_old/countdIn);
  
  }


  double countd=(double)count;
  //Build histogram from the bin
  fprintf(write,"Nbin Value Number\n");
  for (k=1;k<=Nbin;k++){
    fprintf(write,"%d %.8lf %lf\n",k,min+(k-1)*delta,g[k]/countd);
    fprintf(write,"%d %.8lf %lf\n",k,min+(k-1)*delta+delta*0.5,g[k]/countd);
    fprintf(write,"%d %.8lf %lf\n",k,min+(k-1)*delta+delta,g[k]/countd);
  }

  
  free(A);
  fclose(read); //third time close
  fclose(write);
  fclose(write2);

  return 0;
}
