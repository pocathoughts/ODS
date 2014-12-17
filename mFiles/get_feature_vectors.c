#include "mex.h"
#include "math.h"

/* This MEX function will make feature vectors from local intensity regions
 * in an image. Compile with "mex get_feature_vectors.c".
 *
 * F = get_feature_vectors(Iin,x,y,Rsizes)
 * Inputs,
 *      Iin : Input image gray scale or RGB (or more colors)
 *      x,y : Coordinate in the image
 *      Rsizes : The size of the local intensity patch [sizex, sizey]
 *
 * Outputs,
 *      A matrix with the intensity feature vectors, first feature
 *          vector is F(:,1);
 *
 * Function is written by D.Kroon University of Twente (July 2009)
 *
 */

/* Convert 2D matrix index to 1D index, with boundary clamp*/
int mindex2(int x, int y, int sizx, int sizy) {
    if(x<0) { x=0; }
    if(y<0) { y=0; }
    if(x>(sizx-1)) { x=sizx-1; }
    if(y>(sizy-1)) { y=sizy-1; }
    return y*sizx+x;
}

__inline double pow2(double val){ return val*val;}

void get_local_feature_vector(int ix, int iy, double *Iin, int *Iin_dims, int *Ipatch_dims, double *FeatureVectorOut) {
    /* Local image intensity patch to feature vector */
    int rgb, jx, jy, jx_off, jy_off, indexmask=0, indeximage;
    
    jx_off=-Ipatch_dims[0]/2; jy_off=-Ipatch_dims[1]/2;
    /* Loop trhough all mask positions */
    for(rgb=0; rgb<Iin_dims[2]; rgb++) {
        for (jy=0; jy<Ipatch_dims[1]; jy++) {
            for (jx=0; jx<Ipatch_dims[0]; jx++) {
                indeximage = mindex2(ix+jx+jx_off, iy+jy+jy_off, Iin_dims[0], Iin_dims[1]);
                FeatureVectorOut[indexmask]=Iin[indeximage+rgb*(Iin_dims[0]*Iin_dims[1])]; indexmask++;
            }
        }
    }
}

/* The matlab mex function */
void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[] ) {
    double *Iin, *x, *y, *FeatureVectors, *Ipatch_dims_d;
    
    /* Dimensions of in and outputs */
    const mwSize *Iin_dims_const;
    int Iin_dims[3]={1, 1, 1};
    int Ipatch_dims[2];
    int Fout_dims[2];
    
    /* Loop variables */
    int i;
    
    /* Number of coordinates */
    int number_xy;
    
    /* Check for proper number of arguments. */
    if(nrhs!=4) {
        mexErrMsgTxt("4 inputs are required.");
    } else if(nlhs!=1) {
        mexErrMsgTxt("One output required");
    }
    
    /* Check inputs are of type Double */
    if(!(mxIsDouble(prhs[0])&&mxIsDouble(prhs[1])&&mxIsDouble(prhs[2])&&mxIsDouble(prhs[3]))) {
        mexErrMsgTxt("Inputs must be double");
    }
    
    /* Get the sizes of the image */
    Iin_dims_const = mxGetDimensions(prhs[0]);
    Iin_dims[0]=(int)Iin_dims_const[0];
    Iin_dims[1]=(int)Iin_dims_const[1];
    if(mxGetNumberOfDimensions(prhs[0])==3) {
        Iin_dims[2]=(int)Iin_dims_const[2];
    }
    
    /* Assign pointers to input. */
    Iin=mxGetPr(prhs[0]);
    x=mxGetPr(prhs[1]);
    y=mxGetPr(prhs[2]);
    Ipatch_dims_d=mxGetPr(prhs[3]);
    
    /* Get size of feature vector image region */
    Ipatch_dims[0]=(int)Ipatch_dims_d[0];
    Ipatch_dims[1]=(int)Ipatch_dims_d[1];
    
    /* Get number of coordinates */
    number_xy= (int)mxGetN(prhs[1])*(int)mxGetM(prhs[1]);
    
    /* Initialize output featurevectors */
    Fout_dims[0]=Ipatch_dims[0]*Ipatch_dims[1]*Iin_dims[2];
    Fout_dims[1]=number_xy;
    plhs[0] = mxCreateNumericArray(2, Fout_dims, mxDOUBLE_CLASS, mxREAL);
    
    /* Assign pointer to output. */
    FeatureVectors = mxGetPr(plhs[0]);
    
    /* Loop through all image positions */
    for (i=0; i<number_xy; i++) {
        get_local_feature_vector((int)x[i]-1, (int)y[i]-1, Iin, Iin_dims, Ipatch_dims, &FeatureVectors[i*(Ipatch_dims[0]*Ipatch_dims[1]*Iin_dims[2])]);
    }
}