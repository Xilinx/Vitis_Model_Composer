#pragma once
#include <aie_api/aie.hpp>
#include <aie_api/aie_adf.hpp>

// floating point using scalar processor sincos table
template<unsigned int phase_index> 
void exp_calc_float(       
    adf::input_buffer<cfloat> & restrict cb_input0,
    adf::output_buffer<cfloat> & restrict cb_output0);

template<unsigned int PHASE_INDEX> 
void exp_calc_float_lookup(       
    adf::input_buffer<cfloat> & restrict cb_input1,
    output_stream<cfloat> * restrict cb_output1);
