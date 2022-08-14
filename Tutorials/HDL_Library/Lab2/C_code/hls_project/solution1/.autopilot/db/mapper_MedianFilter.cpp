#include <systemc>
#include <vector>
#include <iostream>
#include "hls_stream.h"
#include "ap_int.h"
#include "ap_fixed.h"
using namespace std;
using namespace sc_dt;
class AESL_RUNTIME_BC {
  public:
    AESL_RUNTIME_BC(const char* name) {
      file_token.open( name);
      if (!file_token.good()) {
        cout << "Failed to open tv file " << name << endl;
        exit (1);
      }
      file_token >> mName;//[[[runtime]]]
    }
    ~AESL_RUNTIME_BC() {
      file_token.close();
    }
    int read_size () {
      int size = 0;
      file_token >> mName;//[[transaction]]
      file_token >> mName;//transaction number
      file_token >> mName;//pop_size
      size = atoi(mName.c_str());
      file_token >> mName;//[[/transaction]]
      return size;
    }
  public:
    fstream file_token;
    string mName;
};
extern "C" void MedianFilter(char, char, char, volatile void *);
extern "C" void apatb_MedianFilter_hw(char __xlx_apatb_param_row1, char __xlx_apatb_param_row2, char __xlx_apatb_param_row3, volatile void * __xlx_apatb_param_V) {
  // DUT call
  MedianFilter(__xlx_apatb_param_row1, __xlx_apatb_param_row2, __xlx_apatb_param_row3, __xlx_apatb_param_V);
}
