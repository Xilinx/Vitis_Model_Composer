// 67d7842dbbe25473c3c32b93c0da8047785f30d78e8a024de1b57352245f9689
// This example shows how model composer supports overloading of function
// with same number of input/output arguments. The following defines two 
// forms of a function.

#include <stdint.h>
#include <ap_fixed.h>

int16_t func7_c(int16_t var) {
    if(var < 0)
        var = -var;
     return var;
}

ap_fixed<16,10> func7_c(ap_fixed<16,10> var) {
    if(var < 0.0)
        var = -var;
    return var;
}