#include "MedianFilter.h"
#include "stdio.h"
int main()
{
    unsigned char R = 1;
    unsigned char G = 1;
    unsigned char B = 1;
    int i = 0;
    unsigned char v = 0;
    for (i=0;i<(9);++i){
    	MedianFilter(R,G,B,&v);
    	printf("v:%d\n",v);
    }
    return 0;
}
