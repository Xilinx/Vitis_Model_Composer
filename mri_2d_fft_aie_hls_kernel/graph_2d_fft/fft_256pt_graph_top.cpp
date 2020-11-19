#include "fft_256pt_graph_top.h"

fft_256pt_graph_top mygraph;
simulation::platform<1,1> platform(
   "data/i1.txt",
   "data/o1.txt");
connect<> net1(platform.src[0], mygraph.top_in);
connect<> net2(mygraph.top_out, platform.sink[0]);

int main(void) {
  mygraph.init();
  mygraph.run();
  mygraph.end();
  return 0;
}
