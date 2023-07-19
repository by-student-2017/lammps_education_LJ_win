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
  char a[200],b[200],c[200],d[200];
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
  //printf("count=%d N=%d\n",count,N);
  fclose(read);  //1st time close


  read=fopen(argv[1], "r");

  //to find the max and min from the data 
  A=malloc(sizeof(double)*N);
  for (i=0;i<N;i++){

    fscanf(read,"%s %s %s %s %lf\n",a,b,c,d,&A[i]);
    //printf("a=%s b=%s c=%s d=%s A=%lf\n",a,b,c,d,A[i]);
    printf("%.10lf\n",A[i]);

  }
  fclose(read); //second time close


  
  
  free(A);
  return 0;
}
