#include <adf.h>
#include <aie_api/aie.hpp>

// Example of a function with int16 real input and real cascade output.
void myCascade(input_stream_int16 *sin, output_stream_acc48* cout) {

    v8acc48 acc = undef_v8acc48();
    aie::vector<int16,8> vin;

    vin = readincr_v8(sin);
    acc=aie::mul((int16)16,vin);

    writeincr_v8(cout, acc);
    
}


// Example of a function with int16 complex input and complex cascade output.
void myCascade_c(input_stream_cint16 *sin, output_stream_cacc48* cout) {

    v4cacc48 acc = undef_v4cacc48();
    aie::vector<cint16,4> vin;

    vin = readincr_v4(sin);
    acc=aie::mul((cint16){16,0},vin);

    writeincr_v4(cout, acc);
    
}