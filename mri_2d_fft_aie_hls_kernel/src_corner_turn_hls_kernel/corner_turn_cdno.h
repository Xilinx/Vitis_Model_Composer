// *****************************************************************************
// File: pccfr_pl_pds_itr12.h
// 
/// This file has the declaration of the overload of the HLS PL kernel function
/// for use in the graph code. Note that we do not provide a definition for this
/// function. Its purpose is to allow the Cardano tools to determine the
/// direction of hls::stream ports.
///
/// Do not use this header with Vitis HLS.
// *****************************************************************************
#ifndef _CORNER_TURN_
#define _CORNER_TURN_

#include "hls_stream.h"
#include "ap_int.h"
#include "adf.h"

void
CornerTurn_func(cardano::dir::in<hls::stream<ap_axis<64,0,0,0> > &>in1,
		   cardano::dir::out<hls::stream<ap_axis<64,0,0,0> > &>out1);


#endif // ifndef _CORNER_TURN_
