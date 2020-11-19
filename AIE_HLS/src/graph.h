#ifndef __GRAPH_H__
#define __GRAPH_H__

#include <adf.h>
#include "include.h"
#include "kernels.h"
#include "hls_kernels.h"

using namespace adf;

class clipped : public graph {  

  private:
    kernel interpolator;
    kernel clip;
    kernel classify;
   
  public:
    port<input> in;
    port<output> out;

	
	
	

    clipped() {
      interpolator = kernel::create(fir_27t_sym_hb_2i);
      clip         = kernel::create(polar_clip);
      classify     = kernel::create(classifier);

      fabric<pl>(clip);

      connect< window<INTERPOLATOR27_INPUT_BLOCK_SIZE, INTERPOLATOR27_INPUT_MARGIN> >(in, interpolator.in[0]);

      connect< window<POLAR_CLIP_INPUT_BLOCK_SIZE>, stream >(interpolator.out[0], clip.in[0]);
   
	  connect< stream >(clip.out[0], classify.in[0]);
      connect< window<CLASSIFIER_OUTPUT_BLOCK_SIZE> >(classify.out[0], out);
       
	           std::vector<std::string> myheaders;
        myheaders.push_back("include.h");

        adf::headers(interpolator) = myheaders;
        adf::headers(classify) = myheaders;

      source(interpolator) = "kernels/interpolators/hb27_2i.cc";
      source(clip)         = "polar_clip.cpp";
      source(classify)    = "kernels/classifiers/classify.cc";

      runtime<ratio>(interpolator) = 0.8;
      runtime<ratio>(classify) = 0.8;
    };
};

#endif /* __GRAPH_H__ */
