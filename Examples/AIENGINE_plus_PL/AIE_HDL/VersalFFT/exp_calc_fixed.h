#pragma once

#include <aie_api/aie.hpp>
#include <aie_api/aie_adf.hpp>


template<unsigned int PHASE_INDEX> 
void exp_calc_fixed(       
    adf::input_buffer<cint16> & restrict cb_input1,
    adf::output_buffer<cint16> & restrict cb_output1);