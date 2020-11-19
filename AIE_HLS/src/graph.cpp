#include "graph.h"

PLIO *in0 = new PLIO("DataIn1", adf::plio_32_bits,"data/input.txt");
PLIO *out0 = new PLIO("DataOut1",adf::plio_32_bits, "data/output.txt");

 


simulation::platform<1,1> platform(in0, out0);

clipped clipgraph;

connect<> net0(platform.src[0], clipgraph.in);

connect<> net1(clipgraph.out, platform.sink[0]);


int main(int argc, char ** argv) {
	clipgraph.init();
    clipgraph.run();
    clipgraph.end();
    return 0;
}
