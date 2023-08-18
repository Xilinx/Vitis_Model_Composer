#include "DDS_f5606780.h"

DDS_f5606780 g;
adf::simulation::platform<0,1> platform(
"data/o10");

adf::connect<> no0(g.out, platform.sink[0]);

#ifdef __AIESIM__
int main(void)
{
	g.init();
	g.run();
	g.end();
	return 0;
}
#endif
