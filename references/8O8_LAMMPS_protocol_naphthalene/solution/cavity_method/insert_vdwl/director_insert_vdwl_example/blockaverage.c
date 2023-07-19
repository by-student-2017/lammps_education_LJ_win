#include <stdio.h>
#include <stdlib.h>
#include <math.h>

//
void block(double *A, int *N) //N is the number of total BLOCK
{
  int i;
  for (i=0;i<(*N)/2;i++){
    A[i]=0.5*(A[2*i]+A[2*i+1]);
  }
  for (i=(*N)/2;i<(*N);i++){
    A[i]=0.0;
    (*N)=(*N)/2;
  }
}


//compute mean, 2nd moment and 4th moment of the array A
void moments(double *A,int N,double *m,double *s2,double *s4)
{
  int i;
  double ss=0.0,ssss=0.0;

  *m=0.0;
  for (i=0;i<N;i++){
    *m=*m+A[i]; // so m is order 1 of A
    ss+=A[i]*A[i];//s order 2 
    ssss+=A[i]*A[i]*A[i]*A[i]; // ssss order 4
  }

  *m=*m/N;ss=ss/N;ssss=ssss/N;
  *s2=ss-(*m)*(*m);
  *s4=ssss-(*m)*(*m)*(*m)*(*m);
}

//main function
int main(int argc, char *argv[])
{
  int i=0,j=0;
  int ch;
  int count=0;
  int N=0;
  int M=0;
  int factor=100000;
  double *A;
  double *B;
  double m,s2,s4,av,sav,e;
  FILE* read;
  FILE *fp2;
  FILE *fp;
  char error[10000];
  char Filename2[N];


  //open argument to read 
  if (argc != 2 || !(read = fopen(argv[1], "r")))
    {
      printf("enter a file as the argument\n");
      return -1;
    }

  //to count the number of lines in the file 
  while (!feof(read)){
    ch=fgetc(read);
    if (ch=='\n'){
      count++;
      //      printf("count=%d\n",count);
    }
  }
  N=count;
  M=N;
  printf("count=%d N=%d\n",count,N);
  fclose(read); //1st time close 


  read=fopen(argv[1], "r"); //2nd time open
  B=malloc(sizeof(double)*N);
  for(i=0;i<N;i++){
    fscanf(read,"%lf\n",&B[i]);
  }
  fclose(read); //2nd time close 

  
  fp2=fopen("error.dat","w+");
  if (fp2==NULL) {printf("no such file\n");}
  for (i=0;i<N;i++){ // repeat for 1000 rows excluding the 1st row
    fprintf(fp2,"%lf\n",B[i]*factor);
  }
  fclose(fp2);

  
  A=malloc(sizeof(double)*N);
  fp2=fopen("error.dat","r");
  for(i=0;i<N;i++){
    fscanf(fp2,"%lf",&A[i]);
    //printf("%lf\n",A[i]); 
  }
  fclose(fp2);


  //write out the error info 
  sprintf(error,"Error");
  fp=fopen(error,"w");
  j=0;
  double stdev=0;
  while(j<12){
    moments(A,N,&m,&s2,&s4);    
    stdev=sqrt(s2);
    av=sqrt(s2/(N-1));
    sav=av/sqrt(2*(N-1));
    j++; // first is one 
    fprintf(fp,"%d %d %.8lf %.8lf %.8lf %.8lf\n",N,M/N,m/factor,av/factor,stdev/factor,sav/factor);
    //    printf("A0 is %lf\tA1000 is %lf\n", A[0],A[1000]);
    block(A,&N);
    }
  fclose(fp);
  return 0;
}
