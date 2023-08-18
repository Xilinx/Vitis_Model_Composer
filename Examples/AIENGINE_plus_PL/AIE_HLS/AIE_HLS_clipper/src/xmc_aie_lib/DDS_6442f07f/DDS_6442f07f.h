#ifndef _DDS_6442F07F_GRAPH_H_
#define _DDS_6442F07F_GRAPH_H_

#include <adf.h>
#include "dds_mixer_graph.hpp"


class DDS_6442f07f : public adf::graph
{
public:
	adf::port<output> out;

	const uint32_t phaseIncr = 0;

	const uint32_t initPhaseOffset = 0;


	xf::dsp::aie::mixer::dds_mixer::dds_mixer_graph<cint16, 32, 0, 0, 1> sg;


	DDS_6442f07f() : sg(phaseIncr, initPhaseOffset)
	{

		adf::kernel *sg_kernels = sg.getKernels();

		for (int i=0; i<1; i++) {
			adf::runtime<ratio>(sg_kernels[i]) = 0.4125;
		}


		adf::connect<> net_o0(sg.out[0] , out);

	}
};


#endif //ifndef _DDS_6442F07F_GRAPH_H_
