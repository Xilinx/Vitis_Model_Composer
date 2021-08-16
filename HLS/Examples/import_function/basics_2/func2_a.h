// 67d7842dbbe25473c3c32b93c0da8047785f30d78e8a024de1b57352245f9689
// In this example, we create a block with Vector Input and 
//Scalar output. Note the pointer variable used for output port

#include <stdint.h>

void func2_a(const int array[4], int *out)
{
    int productOfElements = 1;
    
    for (int i = 0; i < 4; i++) {
        productOfElements = productOfElements * array[i];
    }
    *out = productOfElements;
 }
