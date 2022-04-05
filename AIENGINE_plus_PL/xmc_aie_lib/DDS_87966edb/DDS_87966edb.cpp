#include "DDS_87966edb.h"

DDS_87966edb g;
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
