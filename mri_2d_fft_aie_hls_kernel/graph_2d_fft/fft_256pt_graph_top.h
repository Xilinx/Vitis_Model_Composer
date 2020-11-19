#ifndef __FFT_256PT_GRAPH_
#define __FFT_256PT_GRAPH_
#include "fft_256pt_graph.h"
#include <adf.h>

using namespace adf;

class fft_256pt_graph_top : public graph {

	public:
	        port<input> top_in;
	        port<output> top_out;


	fft_256pt_graph_top() {
		fft_256pt_graph fft_subgraph;
		source(fft_subgraph.fft) = "fft_256pt_dit.c";
		runtime<ratio>(fft_subgraph.fft) = 0.9;

		connect<> (top_in,fft_subgraph.in);
		connect<> (fft_subgraph.out,top_out);	

	}
};
#endif


