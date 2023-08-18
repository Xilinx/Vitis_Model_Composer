#include "MedianFilter.h"
#define WINDOW_SIZE  3
typedef unsigned char PixelType;

#define PIX_SWAP(a,b) { PixelType temp=(a);(a)=(b);(b)=temp; }
#define PIX_SORT(a,b) { if ((a)>(b)) PIX_SWAP((a),(b)); }

PixelType OptMedian9(PixelType * p)
{
	PIX_SORT(p[1], p[2]) ; PIX_SORT(p[4], p[5]) ; PIX_SORT(p[7], p[8]) ;
	PIX_SORT(p[0], p[1]) ; PIX_SORT(p[3], p[4]) ; PIX_SORT(p[6], p[7]) ;
	PIX_SORT(p[1], p[2]) ; PIX_SORT(p[4], p[5]) ; PIX_SORT(p[7], p[8]) ;
	PIX_SORT(p[0], p[3]) ; PIX_SORT(p[5], p[8]) ; PIX_SORT(p[4], p[7]) ;
	PIX_SORT(p[3], p[6]) ; PIX_SORT(p[1], p[4]) ; PIX_SORT(p[2], p[5]) ;
	PIX_SORT(p[4], p[7]) ; PIX_SORT(p[4], p[2]) ; PIX_SORT(p[6], p[4]) ;
	PIX_SORT(p[4], p[2]) ; 
    return(p[4]) ;
}

PixelType Mean(PixelType* buffer)
{
    PixelType i, j, min;
    unsigned int sum;
    for (i = 0;i<9; i++) {
    	sum+=buffer[i];
    }
    sum/=(WINDOW_SIZE*WINDOW_SIZE);
    return sum;
}

PixelType Min(PixelType* buffer)
{
    PixelType i, j, min;
    min = buffer[0];
    for (i = 1;i<9; i++) {
        if (min>buffer[i]) min = buffer[i];
    }
    return min;
}



void MedianFilter(PixelType row1, PixelType row2, PixelType row3, PixelType* V)
{
#pragma AP PIPELINE  II=1
	/*
	 * Create a local Pixel Buffer based on WindowSize
	 */
	static PixelType pixelWindowBuffer[WINDOW_SIZE*WINDOW_SIZE];

	PixelType sortBuffer[WINDOW_SIZE*WINDOW_SIZE];

    /*
    * Each Iteration Interval Update the Pixel Buffers
    */
	for(int i = 0;i<WINDOW_SIZE;++i) {
		for(int j=0;j<(WINDOW_SIZE-1);++j) {
			pixelWindowBuffer[WINDOW_SIZE*i + (WINDOW_SIZE-j-1)] = pixelWindowBuffer[WINDOW_SIZE*i + (WINDOW_SIZE-j-1)-1];
		}
	}

    /*
     * Update the first Pixel of each row
     */
    pixelWindowBuffer[0] = row1;
    pixelWindowBuffer[3] = row2;
    pixelWindowBuffer[6] = row3;

    for(int k = 0;k<9;++k) {
    	sortBuffer[k] = pixelWindowBuffer[k];
    }

    *V = OptMedian9(sortBuffer);
}


