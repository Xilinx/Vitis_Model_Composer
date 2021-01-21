#include "matrix_mult_graph.hpp"

// instantiate cardano dataflow graph
xf::dsp::aie::blas::matrix_mult::matrix_mult_graph<cint16, cint16, 8, 16, 24, 0, 0, ROW_MAJOR, COL_MAJOR, ROW_MAJOR> mygraph;

// connect dataflow graph to simulation platform
// To generate input and expected_output data files,
// select 'Create and execute testbench' option on the Model Composer Hub block.
adf::simulation::platform<2,1> platform("~", "~", "~");
adf::connect<> net1(platform.src[0], mygraph.inA);
adf::connect<> net2(platform.src[1], mygraph.inB);
adf::connect<> net3(mygraph.out, platform.sink[0]);

// initialize and run the dataflow graph
#ifdef __AIESIM__
int main(void) {
   mygraph.init();
   mygraph.run();
   mygraph.end();
   return 0;
}
#endif
