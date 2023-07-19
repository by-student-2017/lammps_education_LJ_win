//this is to analyse data using histogram 
#include <stdio.h>
#include <stdlib.h>
#include <math.h>


int main(int argc, char *argv[]){

  int ch; //to count lines 
  int ch2;
  int i,j,k,l,m;
  int Nbin=100; //number of bins between min and max
  int N;   
  int N2;
  int *bin;
  int count=0;  //number of lines in the file 
  int count2=0;
  int g[Nbin];
  int Nmolecule=240;
  int replicateint=0;
  double test;
  double replicate=0;
  double *max;
  double *min;
  double *range; //max-min
  double *delta; //range/Nbin
  double **A;
  double **C;
  double **D;
  double **E;
  double **TAIL;
  double *tail;
  double *a;
  double *c;
  double *d;
  double *e;
  double *mean;
  double *sum;
  double B;
  FILE* read;
  FILE* read2;
  FILE* read3;
  FILE* record;
  FILE* meanrecord;
  FILE* recordfinal;
  FILE* write;
  FILE* write2;


  //zero the bin
  for (k=1;k<=Nbin;k++){
    g[k]=0;
  } 
  /////////////////////////


  //if there is no argument
  if (argc != 3)
   {
     printf("enter two file as the argument real single2\n");
     return -1;
    }
  /////////////////////////


  read = fopen(argv[1], "r"); //single
  read2 = fopen(argv[2], "r"); //real

  //count no. of lines in the argument
  while (!feof(read)){
    ch=fgetc(read);
    if (ch=='\n'){
      count++;
    }
  }
  N=count;
  fclose(read);  //1st time close
  
  while (!feof(read2)){
    ch2=fgetc(read2);
    if (ch2=='\n'){
      count2++;
    }
  }
  N2=count2;
  fclose(read2);
  printf("Nmolecule=%d\n",Nmolecule);

  replicate=N/Nmolecule;  
  replicateint=(int)replicate;
  printf("count=%d N=%d count2=%d N2=%d replicate=%lf=%d\n",count,N,count2,N2,replicate,replicateint);
  /////////////////////////
  
  int Ni=0;
  if(replicateint>Nmolecule){Ni=replicateint;}
  else{Ni=Nmolecule;}
  int Nj=Ni;
  int Nij=Ni*Nj;
  printf("Ni=%d Nj=%d\n",Ni,Nj);



  /////////////////////////
  read=fopen(argv[1], "r");
  read2=fopen(argv[2], "r");
  write=fopen("G_per_molecule_E-Esingle2_5_vdwl_equi","w");
  write2=fopen("InG_per_molecule_E-Esingle2_5_vdwl_equi","w");
  record=fopen("record_per_molecule_E-Esingle2_5_vdwl_equi","w");
  meanrecord=fopen("mean_replicate_etotal_single2_5_vdwl_equi.dat","w");
  recordfinal=fopen("Elattice_vdwl_equi.dat","w");
  /////////////////////////

  //assign space for evdwl_equi, ecoul and elong and sum of these three
  A=malloc(sizeof(double)*Nij);
  E=malloc(sizeof(double)*Nij);
  C=malloc(sizeof(double)*Nij);
  D=malloc(sizeof(double)*Nij);
  TAIL=malloc(sizeof(double)*Nij);

  a=malloc(sizeof(double)*Ni);
  e=malloc(sizeof(double)*Ni);
  c=malloc(sizeof(double)*Ni);
  d=malloc(sizeof(double)*Ni);
  tail=malloc(sizeof(double)*Ni);

  mean=malloc(sizeof(double)*Ni);
  sum=malloc(sizeof(double)*Ni);
  min=malloc(sizeof(double)*Ni);
  max=malloc(sizeof(double)*Ni);
  range=malloc(sizeof(double)*Ni);
  delta=malloc(sizeof(double)*Ni);
     
  for(i = 0; i < Nj; i++)
    {
      A[i] = malloc(Nj * sizeof(double));
      C[i] = malloc(Nj * sizeof(double));
      D[i] = malloc(Nj * sizeof(double));
      E[i] = malloc(Nj * sizeof(double));
      TAIL[i] = malloc(Nj * sizeof(double));
    }
  ///////////////////////////////////////////////////


  
  //to record all the data for Nmolecule*replicate;
  fprintf(meanrecord,"replicate\tmean_single2\tsum_single2\tetotal\n");
  //fprintf(recordfinal,"replicate\tper_molecule==>etotal-sum_of_single2\n");
  for (i=0;i<Ni;i++){
    
    //this is real total system 
    if (i<replicateint){
      fscanf(read2,"%*lf %*lf %*lf %*lf %lf %lf %lf %lf %*lf %*lf %*lf %*lf %*lf %*lf %*lf %*lf %*lf %*lf %*lf %*lf %*lf %*lf %*lf %*lf %*lf %*lf %*lf %*lf %*lf %*lf %*lf\n",&c[i],&tail[i],&d[i],&e[i]);
      a[i]=c[i]-tail[i];
	//printf("i=%d a[i]=%lf\n",i,a[i]);   
    }
    else{a[i]=0;}
    
    //this is all the single2 in the system for each replicate
    for (j=0;j<Nj;j++){  
      if(j< Nmolecule){
	  fscanf(read,"%*lf %*lf %*lf %*lf %lf %lf %lf %lf %*lf %*lf %*lf %*lf %*lf %*lf %*lf %*lf %*lf %*lf %*lf %*lf %*lf %*lf %*lf %*lf %*lf %*lf %*lf %*lf %*lf %*lf %*lf\n",&C[i][j],&TAIL[i][j],&D[i][j],&E[i][j]);
	  A[i][j]=C[i][j]-TAIL[i][j];
	  
	  if(i==replicateint-1){ //first replicate for 240 molecule
	    printf("i=%d j=%d A[i][j]=%lf a[i]=%lf\n",i,j,A[i][j],a[i]);
	  }
	  else{}
	}
      else{A[i][j]=0;}
	  
      mean[i]=mean[i]+A[i][j];
      sum[i]=sum[i]+A[i][j];
      
      //initiate max[i] and min[i] as the first vdwl_equiment 
      if (j==0){
	min[i]=A[i][j];
	max[i]=A[i][j];
      }
      else{
	if (A[i][j]>max[i]){
	  max[i]=A[i][j];
	}
	else{max[i]=max[i];}
	if (A[i][j]<min[i]){
	  min[i]=A[i][j];
	}
	else{min[i]=min[i];}
      }
      //fprintf(record,"%d %lf\n",i,A[i][j]);
      //fprintf(record,"i=%d A=%lf\t",i,A[i][j]);
      //fprintf(record,"max[i]=%lf min[i]=%lf\n",max[i],min[i]);
    }
    mean[i]=mean[i]/Nmolecule;
    sum[i]=sum[i];
    //fprintf(meanrecord,"i=%d mean[i]=%lf\n",i,mean[i]);
    fprintf(meanrecord,"%d\t%lf\t%lf\t%lf\n",i,mean[i],sum[i],a[i]); 
    fprintf(recordfinal,"%i\t%lf\n",i,(a[i]-sum[i])/Nmolecule);
    range[i]=max[i]-min[i]; //positive
    delta[i]=range[i]/Nbin; //positive 
    //fprintf(record,"i=%d range=%lf delta=%lf\n",i,range[i],delta[i]);
    //fprintf(record,"i=%d mean=%lf min=%lf min+delta*Nbin=%lf\n",i,mean[i],min[i],min[i]+delta[i]*Nbin);
  }
  fclose(read);
  fclose(read2);
  //fclose(read3);
  fclose(record); // first time close 
  fclose(meanrecord);
  
  
  free(A);
  free(C);
  free(D);
  free(E);
  free(a);
  free(c);
  free(d);
  free(e);
  free(tail);
  free(TAIL);
  free(min);
  free(max);
  free(range);
  free(delta);
  free(mean);
  free(sum);
  fclose(write);
  fclose(write2);
  
  return 0;
}
