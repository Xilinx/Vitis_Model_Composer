///////////////////////////////////////////////////////////////////////////
// Copyright 2020 Xilinx
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
///////////////////////////////////////////////////////////////////////////


#include <systemc>
#include <iostream>
#include <cstdlib>
#include <cstddef>
#include <stdint.h>
#include "SysCFileHandler.h"
#include "ap_int.h"
#include "ap_fixed.h"
#include <complex>
#include <stdbool.h>
#include "autopilot_cbe.h"
#include "hls_stream.h"
#include "hls_half.h"
#include "hls_signal_handler.h"

using namespace std;
using namespace sc_core;
using namespace sc_dt;

// wrapc file define:
#define AUTOTB_TVIN_in_sample_V_data_V "../tv/cdatafile/c.polar_clip.autotvin_in_sample_V_data_V.dat"
#define AUTOTB_TVOUT_in_sample_V_data_V "../tv/cdatafile/c.polar_clip.autotvout_in_sample_V_data_V.dat"
#define AUTOTB_TVIN_in_sample_V_keep_V "../tv/cdatafile/c.polar_clip.autotvin_in_sample_V_keep_V.dat"
#define AUTOTB_TVOUT_in_sample_V_keep_V "../tv/cdatafile/c.polar_clip.autotvout_in_sample_V_keep_V.dat"
#define AUTOTB_TVIN_in_sample_V_strb_V "../tv/cdatafile/c.polar_clip.autotvin_in_sample_V_strb_V.dat"
#define AUTOTB_TVOUT_in_sample_V_strb_V "../tv/cdatafile/c.polar_clip.autotvout_in_sample_V_strb_V.dat"
#define AUTOTB_TVIN_in_sample_V_last_V "../tv/cdatafile/c.polar_clip.autotvin_in_sample_V_last_V.dat"
#define AUTOTB_TVOUT_in_sample_V_last_V "../tv/cdatafile/c.polar_clip.autotvout_in_sample_V_last_V.dat"
#define WRAPC_STREAM_SIZE_IN_in_sample_V_data_V "../tv/stream_size/stream_size_in_in_sample_V_data_V.dat"
#define WRAPC_STREAM_INGRESS_STATUS_in_sample_V_data_V "../tv/stream_size/stream_ingress_status_in_sample_V_data_V.dat"
#define WRAPC_STREAM_SIZE_IN_in_sample_V_keep_V "../tv/stream_size/stream_size_in_in_sample_V_keep_V.dat"
#define WRAPC_STREAM_INGRESS_STATUS_in_sample_V_keep_V "../tv/stream_size/stream_ingress_status_in_sample_V_keep_V.dat"
#define WRAPC_STREAM_SIZE_IN_in_sample_V_strb_V "../tv/stream_size/stream_size_in_in_sample_V_strb_V.dat"
#define WRAPC_STREAM_INGRESS_STATUS_in_sample_V_strb_V "../tv/stream_size/stream_ingress_status_in_sample_V_strb_V.dat"
#define WRAPC_STREAM_SIZE_IN_in_sample_V_last_V "../tv/stream_size/stream_size_in_in_sample_V_last_V.dat"
#define WRAPC_STREAM_INGRESS_STATUS_in_sample_V_last_V "../tv/stream_size/stream_ingress_status_in_sample_V_last_V.dat"
// wrapc file define:
#define AUTOTB_TVIN_out_sample_V_data_V "../tv/cdatafile/c.polar_clip.autotvin_out_sample_V_data_V.dat"
#define AUTOTB_TVOUT_out_sample_V_data_V "../tv/cdatafile/c.polar_clip.autotvout_out_sample_V_data_V.dat"
#define AUTOTB_TVIN_out_sample_V_keep_V "../tv/cdatafile/c.polar_clip.autotvin_out_sample_V_keep_V.dat"
#define AUTOTB_TVOUT_out_sample_V_keep_V "../tv/cdatafile/c.polar_clip.autotvout_out_sample_V_keep_V.dat"
#define AUTOTB_TVIN_out_sample_V_strb_V "../tv/cdatafile/c.polar_clip.autotvin_out_sample_V_strb_V.dat"
#define AUTOTB_TVOUT_out_sample_V_strb_V "../tv/cdatafile/c.polar_clip.autotvout_out_sample_V_strb_V.dat"
#define AUTOTB_TVIN_out_sample_V_last_V "../tv/cdatafile/c.polar_clip.autotvin_out_sample_V_last_V.dat"
#define AUTOTB_TVOUT_out_sample_V_last_V "../tv/cdatafile/c.polar_clip.autotvout_out_sample_V_last_V.dat"
#define WRAPC_STREAM_SIZE_OUT_out_sample_V_data_V "../tv/stream_size/stream_size_out_out_sample_V_data_V.dat"
#define WRAPC_STREAM_EGRESS_STATUS_out_sample_V_data_V "../tv/stream_size/stream_egress_status_out_sample_V_data_V.dat"
#define WRAPC_STREAM_SIZE_OUT_out_sample_V_keep_V "../tv/stream_size/stream_size_out_out_sample_V_keep_V.dat"
#define WRAPC_STREAM_EGRESS_STATUS_out_sample_V_keep_V "../tv/stream_size/stream_egress_status_out_sample_V_keep_V.dat"
#define WRAPC_STREAM_SIZE_OUT_out_sample_V_strb_V "../tv/stream_size/stream_size_out_out_sample_V_strb_V.dat"
#define WRAPC_STREAM_EGRESS_STATUS_out_sample_V_strb_V "../tv/stream_size/stream_egress_status_out_sample_V_strb_V.dat"
#define WRAPC_STREAM_SIZE_OUT_out_sample_V_last_V "../tv/stream_size/stream_size_out_out_sample_V_last_V.dat"
#define WRAPC_STREAM_EGRESS_STATUS_out_sample_V_last_V "../tv/stream_size/stream_egress_status_out_sample_V_last_V.dat"

#define INTER_TCL "../tv/cdatafile/ref.tcl"

// tvout file define:
#define AUTOTB_TVOUT_PC_in_sample_V_data_V "../tv/rtldatafile/rtl.polar_clip.autotvout_in_sample_V_data_V.dat"
#define AUTOTB_TVOUT_PC_in_sample_V_keep_V "../tv/rtldatafile/rtl.polar_clip.autotvout_in_sample_V_keep_V.dat"
#define AUTOTB_TVOUT_PC_in_sample_V_strb_V "../tv/rtldatafile/rtl.polar_clip.autotvout_in_sample_V_strb_V.dat"
#define AUTOTB_TVOUT_PC_in_sample_V_last_V "../tv/rtldatafile/rtl.polar_clip.autotvout_in_sample_V_last_V.dat"
// tvout file define:
#define AUTOTB_TVOUT_PC_out_sample_V_data_V "../tv/rtldatafile/rtl.polar_clip.autotvout_out_sample_V_data_V.dat"
#define AUTOTB_TVOUT_PC_out_sample_V_keep_V "../tv/rtldatafile/rtl.polar_clip.autotvout_out_sample_V_keep_V.dat"
#define AUTOTB_TVOUT_PC_out_sample_V_strb_V "../tv/rtldatafile/rtl.polar_clip.autotvout_out_sample_V_strb_V.dat"
#define AUTOTB_TVOUT_PC_out_sample_V_last_V "../tv/rtldatafile/rtl.polar_clip.autotvout_out_sample_V_last_V.dat"

class INTER_TCL_FILE {
  public:
INTER_TCL_FILE(const char* name) {
  mName = name; 
  in_sample_V_data_V_depth = 0;
  in_sample_V_keep_V_depth = 0;
  in_sample_V_strb_V_depth = 0;
  in_sample_V_last_V_depth = 0;
  out_sample_V_data_V_depth = 0;
  out_sample_V_keep_V_depth = 0;
  out_sample_V_strb_V_depth = 0;
  out_sample_V_last_V_depth = 0;
  trans_num =0;
}
~INTER_TCL_FILE() {
  mFile.open(mName);
  if (!mFile.good()) {
    cout << "Failed to open file ref.tcl" << endl;
    exit (1); 
  }
  string total_list = get_depth_list();
  mFile << "set depth_list {\n";
  mFile << total_list;
  mFile << "}\n";
  mFile << "set trans_num "<<trans_num<<endl;
  mFile.close();
}
string get_depth_list () {
  stringstream total_list;
  total_list << "{in_sample_V_data_V " << in_sample_V_data_V_depth << "}\n";
  total_list << "{in_sample_V_keep_V " << in_sample_V_keep_V_depth << "}\n";
  total_list << "{in_sample_V_strb_V " << in_sample_V_strb_V_depth << "}\n";
  total_list << "{in_sample_V_last_V " << in_sample_V_last_V_depth << "}\n";
  total_list << "{out_sample_V_data_V " << out_sample_V_data_V_depth << "}\n";
  total_list << "{out_sample_V_keep_V " << out_sample_V_keep_V_depth << "}\n";
  total_list << "{out_sample_V_strb_V " << out_sample_V_strb_V_depth << "}\n";
  total_list << "{out_sample_V_last_V " << out_sample_V_last_V_depth << "}\n";
  return total_list.str();
}
void set_num (int num , int* class_num) {
  (*class_num) = (*class_num) > num ? (*class_num) : num;
}
  public:
    int in_sample_V_data_V_depth;
    int in_sample_V_keep_V_depth;
    int in_sample_V_strb_V_depth;
    int in_sample_V_last_V_depth;
    int out_sample_V_data_V_depth;
    int out_sample_V_keep_V_depth;
    int out_sample_V_strb_V_depth;
    int out_sample_V_last_V_depth;
    int trans_num;
  private:
    ofstream mFile;
    const char* mName;
};

static void RTLOutputCheckAndReplacement(std::string &AESL_token, std::string PortName) {
  bool no_x = false;
  bool err = false;

  no_x = false;
  // search and replace 'X' with '0' from the 3rd char of token
  while (!no_x) {
    size_t x_found = AESL_token.find('X', 0);
    if (x_found != string::npos) {
      if (!err) { 
        cerr << "WARNING: [SIM 212-201] RTL produces unknown value 'X' on port" 
             << PortName << ", possible cause: There are uninitialized variables in the C design."
             << endl; 
        err = true;
      }
      AESL_token.replace(x_found, 1, "0");
    } else
      no_x = true;
  }
  no_x = false;
  // search and replace 'x' with '0' from the 3rd char of token
  while (!no_x) {
    size_t x_found = AESL_token.find('x', 2);
    if (x_found != string::npos) {
      if (!err) { 
        cerr << "WARNING: [SIM 212-201] RTL produces unknown value 'x' on port" 
             << PortName << ", possible cause: There are uninitialized variables in the C design."
             << endl; 
        err = true;
      }
      AESL_token.replace(x_found, 1, "0");
    } else
      no_x = true;
  }
}
struct __cosim_s8__ { char data[8]; };
extern "C" void polar_clip_hw_stub(volatile void *, volatile void *);

extern "C" void apatb_polar_clip_hw(volatile void * __xlx_apatb_param_in_sample, volatile void * __xlx_apatb_param_out_sample) {
  refine_signal_handler();
  fstream wrapc_switch_file_token;
  wrapc_switch_file_token.open(".hls_cosim_wrapc_switch.log");
  int AESL_i;
  if (wrapc_switch_file_token.good())
  {

    CodeState = ENTER_WRAPC_PC;
    static unsigned AESL_transaction_pc = 0;
    string AESL_token;
    string AESL_num;long __xlx_apatb_param_in_sample_stream_buf_final_size;
{
      static ifstream rtl_tv_out_file;
      if (!rtl_tv_out_file.is_open()) {
        rtl_tv_out_file.open(WRAPC_STREAM_SIZE_IN_in_sample_V_data_V);
        if (rtl_tv_out_file.good()) {
          rtl_tv_out_file >> AESL_token;
          if (AESL_token != "[[[runtime]]]")
            exit(1);
        }
      }
  
      if (rtl_tv_out_file.good()) {
        rtl_tv_out_file >> AESL_token; 
        rtl_tv_out_file >> AESL_num;  // transaction number
        if (AESL_token != "[[transaction]]") {
          cerr << "Unexpected token: " << AESL_token << endl;
          exit(1);
        }
        if (atoi(AESL_num.c_str()) == AESL_transaction_pc) {
          rtl_tv_out_file >> AESL_token; //data
          while (AESL_token != "[[/transaction]]"){__xlx_apatb_param_in_sample_stream_buf_final_size = atoi(AESL_token.c_str());

            rtl_tv_out_file >> AESL_token; //data or [[/transaction]]
            if (AESL_token == "[[[/runtime]]]" || rtl_tv_out_file.eof())
              exit(1);
          }
        } // end transaction
      } // end file is good
    } // end post check logic bolck
  for (long i = 0; i < __xlx_apatb_param_in_sample_stream_buf_final_size; ++i)((hls::stream<__cosim_s8__>*)__xlx_apatb_param_in_sample)->read();
{sc_bv<64> xlx_stream_out_sample_pc_buffer;
unsigned xlx_stream_out_sample_size;

          std::vector<sc_bv<64> > out_sample_V_data_V_pc_buffer_Copy;
{
      static ifstream rtl_tv_out_file;
      if (!rtl_tv_out_file.is_open()) {
        rtl_tv_out_file.open(AUTOTB_TVOUT_PC_out_sample_V_data_V);
        if (rtl_tv_out_file.good()) {
          rtl_tv_out_file >> AESL_token;
          if (AESL_token != "[[[runtime]]]")
            exit(1);
        }
      }
  
      if (rtl_tv_out_file.good()) {
        rtl_tv_out_file >> AESL_token; 
        rtl_tv_out_file >> AESL_num;  // transaction number
        if (AESL_token != "[[transaction]]") {
          cerr << "Unexpected token: " << AESL_token << endl;
          exit(1);
        }
        if (atoi(AESL_num.c_str()) == AESL_transaction_pc) {
          std::vector<sc_bv<64> > out_sample_V_data_V_pc_buffer;
          int i = 0;

          rtl_tv_out_file >> AESL_token; //data
          while (AESL_token != "[[/transaction]]"){

            RTLOutputCheckAndReplacement(AESL_token, "out_sample");
  
            // push token into output port buffer
            if (AESL_token != "") {
              out_sample_V_data_V_pc_buffer.push_back(AESL_token.c_str());
              i++;
            }
  
            rtl_tv_out_file >> AESL_token; //data or [[/transaction]]
            if (AESL_token == "[[[/runtime]]]" || rtl_tv_out_file.eof())
              exit(1);
          }
          if (i > 0) {xlx_stream_out_sample_size=out_sample_V_data_V_pc_buffer.size();
out_sample_V_data_V_pc_buffer_Copy=out_sample_V_data_V_pc_buffer;
}
        } // end transaction
      } // end file is good
    } // end post check logic bolck
  
          std::vector<sc_bv<64> > out_sample_V_keep_V_pc_buffer_Copy;
{
      static ifstream rtl_tv_out_file;
      if (!rtl_tv_out_file.is_open()) {
        rtl_tv_out_file.open(AUTOTB_TVOUT_PC_out_sample_V_keep_V);
        if (rtl_tv_out_file.good()) {
          rtl_tv_out_file >> AESL_token;
          if (AESL_token != "[[[runtime]]]")
            exit(1);
        }
      }
  
      if (rtl_tv_out_file.good()) {
        rtl_tv_out_file >> AESL_token; 
        rtl_tv_out_file >> AESL_num;  // transaction number
        if (AESL_token != "[[transaction]]") {
          cerr << "Unexpected token: " << AESL_token << endl;
          exit(1);
        }
        if (atoi(AESL_num.c_str()) == AESL_transaction_pc) {
          std::vector<sc_bv<64> > out_sample_V_keep_V_pc_buffer;
          int i = 0;

          rtl_tv_out_file >> AESL_token; //data
          while (AESL_token != "[[/transaction]]"){

            RTLOutputCheckAndReplacement(AESL_token, "out_sample");
  
            // push token into output port buffer
            if (AESL_token != "") {
              out_sample_V_keep_V_pc_buffer.push_back(AESL_token.c_str());
              i++;
            }
  
            rtl_tv_out_file >> AESL_token; //data or [[/transaction]]
            if (AESL_token == "[[[/runtime]]]" || rtl_tv_out_file.eof())
              exit(1);
          }
          if (i > 0) {xlx_stream_out_sample_size=out_sample_V_keep_V_pc_buffer.size();
out_sample_V_keep_V_pc_buffer_Copy=out_sample_V_keep_V_pc_buffer;
}
        } // end transaction
      } // end file is good
    } // end post check logic bolck
  
          std::vector<sc_bv<64> > out_sample_V_strb_V_pc_buffer_Copy;
{
      static ifstream rtl_tv_out_file;
      if (!rtl_tv_out_file.is_open()) {
        rtl_tv_out_file.open(AUTOTB_TVOUT_PC_out_sample_V_strb_V);
        if (rtl_tv_out_file.good()) {
          rtl_tv_out_file >> AESL_token;
          if (AESL_token != "[[[runtime]]]")
            exit(1);
        }
      }
  
      if (rtl_tv_out_file.good()) {
        rtl_tv_out_file >> AESL_token; 
        rtl_tv_out_file >> AESL_num;  // transaction number
        if (AESL_token != "[[transaction]]") {
          cerr << "Unexpected token: " << AESL_token << endl;
          exit(1);
        }
        if (atoi(AESL_num.c_str()) == AESL_transaction_pc) {
          std::vector<sc_bv<64> > out_sample_V_strb_V_pc_buffer;
          int i = 0;

          rtl_tv_out_file >> AESL_token; //data
          while (AESL_token != "[[/transaction]]"){

            RTLOutputCheckAndReplacement(AESL_token, "out_sample");
  
            // push token into output port buffer
            if (AESL_token != "") {
              out_sample_V_strb_V_pc_buffer.push_back(AESL_token.c_str());
              i++;
            }
  
            rtl_tv_out_file >> AESL_token; //data or [[/transaction]]
            if (AESL_token == "[[[/runtime]]]" || rtl_tv_out_file.eof())
              exit(1);
          }
          if (i > 0) {xlx_stream_out_sample_size=out_sample_V_strb_V_pc_buffer.size();
out_sample_V_strb_V_pc_buffer_Copy=out_sample_V_strb_V_pc_buffer;
}
        } // end transaction
      } // end file is good
    } // end post check logic bolck
  
          std::vector<sc_bv<64> > out_sample_V_last_V_pc_buffer_Copy;
{
      static ifstream rtl_tv_out_file;
      if (!rtl_tv_out_file.is_open()) {
        rtl_tv_out_file.open(AUTOTB_TVOUT_PC_out_sample_V_last_V);
        if (rtl_tv_out_file.good()) {
          rtl_tv_out_file >> AESL_token;
          if (AESL_token != "[[[runtime]]]")
            exit(1);
        }
      }
  
      if (rtl_tv_out_file.good()) {
        rtl_tv_out_file >> AESL_token; 
        rtl_tv_out_file >> AESL_num;  // transaction number
        if (AESL_token != "[[transaction]]") {
          cerr << "Unexpected token: " << AESL_token << endl;
          exit(1);
        }
        if (atoi(AESL_num.c_str()) == AESL_transaction_pc) {
          std::vector<sc_bv<64> > out_sample_V_last_V_pc_buffer;
          int i = 0;

          rtl_tv_out_file >> AESL_token; //data
          while (AESL_token != "[[/transaction]]"){

            RTLOutputCheckAndReplacement(AESL_token, "out_sample");
  
            // push token into output port buffer
            if (AESL_token != "") {
              out_sample_V_last_V_pc_buffer.push_back(AESL_token.c_str());
              i++;
            }
  
            rtl_tv_out_file >> AESL_token; //data or [[/transaction]]
            if (AESL_token == "[[[/runtime]]]" || rtl_tv_out_file.eof())
              exit(1);
          }
          if (i > 0) {xlx_stream_out_sample_size=out_sample_V_last_V_pc_buffer.size();
out_sample_V_last_V_pc_buffer_Copy=out_sample_V_last_V_pc_buffer;
}
        } // end transaction
      } // end file is good
    } // end post check logic bolck
  for (int j = 0, e = xlx_stream_out_sample_size; j != e; ++j) {
xlx_stream_out_sample_pc_buffer.range(31, 0) = out_sample_V_data_V_pc_buffer_Copy[j];
xlx_stream_out_sample_pc_buffer.range(39, 32) = out_sample_V_keep_V_pc_buffer_Copy[j];
xlx_stream_out_sample_pc_buffer.range(47, 40) = out_sample_V_strb_V_pc_buffer_Copy[j];
xlx_stream_out_sample_pc_buffer.range(63, 48) = out_sample_V_last_V_pc_buffer_Copy[j];
__cosim_s8__ xlx_stream_elt;
((long long*)&xlx_stream_elt)[0] = xlx_stream_out_sample_pc_buffer.to_int64();
((hls::stream<__cosim_s8__>*)__xlx_apatb_param_out_sample)->write(xlx_stream_elt);
}}
    AESL_transaction_pc++;
    return ;
  }
static unsigned AESL_transaction;
static AESL_FILE_HANDLER aesl_fh;
static INTER_TCL_FILE tcl_file(INTER_TCL);
std::vector<char> __xlx_sprintf_buffer(1024);
CodeState = ENTER_WRAPC;
//in_sample
aesl_fh.touch(AUTOTB_TVIN_in_sample_V_data_V);
aesl_fh.touch(AUTOTB_TVOUT_in_sample_V_data_V);
aesl_fh.touch(AUTOTB_TVIN_in_sample_V_keep_V);
aesl_fh.touch(AUTOTB_TVOUT_in_sample_V_keep_V);
aesl_fh.touch(AUTOTB_TVIN_in_sample_V_strb_V);
aesl_fh.touch(AUTOTB_TVOUT_in_sample_V_strb_V);
aesl_fh.touch(AUTOTB_TVIN_in_sample_V_last_V);
aesl_fh.touch(AUTOTB_TVOUT_in_sample_V_last_V);
aesl_fh.touch(WRAPC_STREAM_SIZE_IN_in_sample_V_data_V);
aesl_fh.touch(WRAPC_STREAM_INGRESS_STATUS_in_sample_V_data_V);
aesl_fh.touch(WRAPC_STREAM_SIZE_IN_in_sample_V_keep_V);
aesl_fh.touch(WRAPC_STREAM_INGRESS_STATUS_in_sample_V_keep_V);
aesl_fh.touch(WRAPC_STREAM_SIZE_IN_in_sample_V_strb_V);
aesl_fh.touch(WRAPC_STREAM_INGRESS_STATUS_in_sample_V_strb_V);
aesl_fh.touch(WRAPC_STREAM_SIZE_IN_in_sample_V_last_V);
aesl_fh.touch(WRAPC_STREAM_INGRESS_STATUS_in_sample_V_last_V);
//out_sample
aesl_fh.touch(AUTOTB_TVIN_out_sample_V_data_V);
aesl_fh.touch(AUTOTB_TVOUT_out_sample_V_data_V);
aesl_fh.touch(AUTOTB_TVIN_out_sample_V_keep_V);
aesl_fh.touch(AUTOTB_TVOUT_out_sample_V_keep_V);
aesl_fh.touch(AUTOTB_TVIN_out_sample_V_strb_V);
aesl_fh.touch(AUTOTB_TVOUT_out_sample_V_strb_V);
aesl_fh.touch(AUTOTB_TVIN_out_sample_V_last_V);
aesl_fh.touch(AUTOTB_TVOUT_out_sample_V_last_V);
aesl_fh.touch(WRAPC_STREAM_SIZE_OUT_out_sample_V_data_V);
aesl_fh.touch(WRAPC_STREAM_EGRESS_STATUS_out_sample_V_data_V);
aesl_fh.touch(WRAPC_STREAM_SIZE_OUT_out_sample_V_keep_V);
aesl_fh.touch(WRAPC_STREAM_EGRESS_STATUS_out_sample_V_keep_V);
aesl_fh.touch(WRAPC_STREAM_SIZE_OUT_out_sample_V_strb_V);
aesl_fh.touch(WRAPC_STREAM_EGRESS_STATUS_out_sample_V_strb_V);
aesl_fh.touch(WRAPC_STREAM_SIZE_OUT_out_sample_V_last_V);
aesl_fh.touch(WRAPC_STREAM_EGRESS_STATUS_out_sample_V_last_V);
CodeState = DUMP_INPUTS;
std::vector<__cosim_s8__> __xlx_apatb_param_in_sample_stream_buf;
{
  while (!((hls::stream<__cosim_s8__>*)__xlx_apatb_param_in_sample)->empty())
    __xlx_apatb_param_in_sample_stream_buf.push_back(((hls::stream<__cosim_s8__>*)__xlx_apatb_param_in_sample)->read());
  for (int i = 0; i < __xlx_apatb_param_in_sample_stream_buf.size(); ++i)
    ((hls::stream<__cosim_s8__>*)__xlx_apatb_param_in_sample)->write(__xlx_apatb_param_in_sample_stream_buf[i]);
  }
long __xlx_apatb_param_in_sample_stream_buf_size = ((hls::stream<__cosim_s8__>*)__xlx_apatb_param_in_sample)->size();
std::vector<__cosim_s8__> __xlx_apatb_param_out_sample_stream_buf;
long __xlx_apatb_param_out_sample_stream_buf_size = ((hls::stream<__cosim_s8__>*)__xlx_apatb_param_out_sample)->size();
CodeState = CALL_C_DUT;
polar_clip_hw_stub(__xlx_apatb_param_in_sample, __xlx_apatb_param_out_sample);
CodeState = DUMP_OUTPUTS;
long __xlx_apatb_param_in_sample_stream_buf_final_size = __xlx_apatb_param_in_sample_stream_buf_size - ((hls::stream<__cosim_s8__>*)__xlx_apatb_param_in_sample)->size();

  sprintf(__xlx_sprintf_buffer.data(), "[[transaction]] %d\n", AESL_transaction);
  aesl_fh.write(AUTOTB_TVIN_in_sample_V_data_V, __xlx_sprintf_buffer.data());
  
  sprintf(__xlx_sprintf_buffer.data(), "[[transaction]] %d\n", AESL_transaction);
  aesl_fh.write(AUTOTB_TVIN_in_sample_V_keep_V, __xlx_sprintf_buffer.data());
  
  sprintf(__xlx_sprintf_buffer.data(), "[[transaction]] %d\n", AESL_transaction);
  aesl_fh.write(AUTOTB_TVIN_in_sample_V_strb_V, __xlx_sprintf_buffer.data());
  
  sprintf(__xlx_sprintf_buffer.data(), "[[transaction]] %d\n", AESL_transaction);
  aesl_fh.write(AUTOTB_TVIN_in_sample_V_last_V, __xlx_sprintf_buffer.data());
  for (int j = 0, e = __xlx_apatb_param_in_sample_stream_buf_final_size; j != e; ++j) {
sc_bv<64> __xlx_tmp_lv = ((long long*)&__xlx_apatb_param_in_sample_stream_buf[j])[0];
sc_bv<32> __xlx_tmp_0_lv = __xlx_tmp_lv.range(31, 0);
sprintf(__xlx_sprintf_buffer.data(), "%s\n", __xlx_tmp_0_lv.to_string(SC_HEX).c_str());
aesl_fh.write(AUTOTB_TVIN_in_sample_V_data_V, __xlx_sprintf_buffer.data());
sc_bv<8> __xlx_tmp_1_lv = __xlx_tmp_lv.range(39, 32);
sprintf(__xlx_sprintf_buffer.data(), "%s\n", __xlx_tmp_1_lv.to_string(SC_HEX).c_str());
aesl_fh.write(AUTOTB_TVIN_in_sample_V_keep_V, __xlx_sprintf_buffer.data());
sc_bv<8> __xlx_tmp_2_lv = __xlx_tmp_lv.range(47, 40);
sprintf(__xlx_sprintf_buffer.data(), "%s\n", __xlx_tmp_2_lv.to_string(SC_HEX).c_str());
aesl_fh.write(AUTOTB_TVIN_in_sample_V_strb_V, __xlx_sprintf_buffer.data());
sc_bv<16> __xlx_tmp_3_lv = __xlx_tmp_lv.range(63, 48);
sprintf(__xlx_sprintf_buffer.data(), "%s\n", __xlx_tmp_3_lv.to_string(SC_HEX).c_str());
aesl_fh.write(AUTOTB_TVIN_in_sample_V_last_V, __xlx_sprintf_buffer.data());
}
tcl_file.set_num(__xlx_apatb_param_in_sample_stream_buf_final_size, &tcl_file.in_sample_V_data_V_depth);

  sprintf(__xlx_sprintf_buffer.data(), "[[/transaction]] \n");
  aesl_fh.write(AUTOTB_TVIN_in_sample_V_data_V, __xlx_sprintf_buffer.data());
tcl_file.set_num(__xlx_apatb_param_in_sample_stream_buf_final_size, &tcl_file.in_sample_V_keep_V_depth);

  sprintf(__xlx_sprintf_buffer.data(), "[[/transaction]] \n");
  aesl_fh.write(AUTOTB_TVIN_in_sample_V_keep_V, __xlx_sprintf_buffer.data());
tcl_file.set_num(__xlx_apatb_param_in_sample_stream_buf_final_size, &tcl_file.in_sample_V_strb_V_depth);

  sprintf(__xlx_sprintf_buffer.data(), "[[/transaction]] \n");
  aesl_fh.write(AUTOTB_TVIN_in_sample_V_strb_V, __xlx_sprintf_buffer.data());
tcl_file.set_num(__xlx_apatb_param_in_sample_stream_buf_final_size, &tcl_file.in_sample_V_last_V_depth);

  sprintf(__xlx_sprintf_buffer.data(), "[[/transaction]] \n");
  aesl_fh.write(AUTOTB_TVIN_in_sample_V_last_V, __xlx_sprintf_buffer.data());

// dump stream ingress status to file

// dump stream ingress status to file
{
  sprintf(__xlx_sprintf_buffer.data(), "[[transaction]] %d\n", AESL_transaction);
  aesl_fh.write(WRAPC_STREAM_INGRESS_STATUS_in_sample_V_data_V, __xlx_sprintf_buffer.data());
  if (__xlx_apatb_param_in_sample_stream_buf_final_size > 0) {
  long in_sample_V_data_V_stream_ingress_size = __xlx_apatb_param_in_sample_stream_buf_size;
sprintf(__xlx_sprintf_buffer.data(), "%d\n", in_sample_V_data_V_stream_ingress_size);
 aesl_fh.write(WRAPC_STREAM_INGRESS_STATUS_in_sample_V_data_V, __xlx_sprintf_buffer.data());
  for (int j = 0, e = __xlx_apatb_param_in_sample_stream_buf_final_size; j != e; j++) {
    in_sample_V_data_V_stream_ingress_size--;
sprintf(__xlx_sprintf_buffer.data(), "%d\n", in_sample_V_data_V_stream_ingress_size);
 aesl_fh.write(WRAPC_STREAM_INGRESS_STATUS_in_sample_V_data_V, __xlx_sprintf_buffer.data());
  }
} else {
  long in_sample_V_data_V_stream_ingress_size = 0;
sprintf(__xlx_sprintf_buffer.data(), "%d\n", in_sample_V_data_V_stream_ingress_size);
 aesl_fh.write(WRAPC_STREAM_INGRESS_STATUS_in_sample_V_data_V, __xlx_sprintf_buffer.data());
}

  sprintf(__xlx_sprintf_buffer.data(), "[[/transaction]] \n");
  aesl_fh.write(WRAPC_STREAM_INGRESS_STATUS_in_sample_V_data_V, __xlx_sprintf_buffer.data());
}
// dump stream ingress status to file
{
  sprintf(__xlx_sprintf_buffer.data(), "[[transaction]] %d\n", AESL_transaction);
  aesl_fh.write(WRAPC_STREAM_INGRESS_STATUS_in_sample_V_keep_V, __xlx_sprintf_buffer.data());
  if (__xlx_apatb_param_in_sample_stream_buf_final_size > 0) {
  long in_sample_V_keep_V_stream_ingress_size = __xlx_apatb_param_in_sample_stream_buf_size;
sprintf(__xlx_sprintf_buffer.data(), "%d\n", in_sample_V_keep_V_stream_ingress_size);
 aesl_fh.write(WRAPC_STREAM_INGRESS_STATUS_in_sample_V_keep_V, __xlx_sprintf_buffer.data());
  for (int j = 0, e = __xlx_apatb_param_in_sample_stream_buf_final_size; j != e; j++) {
    in_sample_V_keep_V_stream_ingress_size--;
sprintf(__xlx_sprintf_buffer.data(), "%d\n", in_sample_V_keep_V_stream_ingress_size);
 aesl_fh.write(WRAPC_STREAM_INGRESS_STATUS_in_sample_V_keep_V, __xlx_sprintf_buffer.data());
  }
} else {
  long in_sample_V_keep_V_stream_ingress_size = 0;
sprintf(__xlx_sprintf_buffer.data(), "%d\n", in_sample_V_keep_V_stream_ingress_size);
 aesl_fh.write(WRAPC_STREAM_INGRESS_STATUS_in_sample_V_keep_V, __xlx_sprintf_buffer.data());
}

  sprintf(__xlx_sprintf_buffer.data(), "[[/transaction]] \n");
  aesl_fh.write(WRAPC_STREAM_INGRESS_STATUS_in_sample_V_keep_V, __xlx_sprintf_buffer.data());
}
// dump stream ingress status to file
{
  sprintf(__xlx_sprintf_buffer.data(), "[[transaction]] %d\n", AESL_transaction);
  aesl_fh.write(WRAPC_STREAM_INGRESS_STATUS_in_sample_V_strb_V, __xlx_sprintf_buffer.data());
  if (__xlx_apatb_param_in_sample_stream_buf_final_size > 0) {
  long in_sample_V_strb_V_stream_ingress_size = __xlx_apatb_param_in_sample_stream_buf_size;
sprintf(__xlx_sprintf_buffer.data(), "%d\n", in_sample_V_strb_V_stream_ingress_size);
 aesl_fh.write(WRAPC_STREAM_INGRESS_STATUS_in_sample_V_strb_V, __xlx_sprintf_buffer.data());
  for (int j = 0, e = __xlx_apatb_param_in_sample_stream_buf_final_size; j != e; j++) {
    in_sample_V_strb_V_stream_ingress_size--;
sprintf(__xlx_sprintf_buffer.data(), "%d\n", in_sample_V_strb_V_stream_ingress_size);
 aesl_fh.write(WRAPC_STREAM_INGRESS_STATUS_in_sample_V_strb_V, __xlx_sprintf_buffer.data());
  }
} else {
  long in_sample_V_strb_V_stream_ingress_size = 0;
sprintf(__xlx_sprintf_buffer.data(), "%d\n", in_sample_V_strb_V_stream_ingress_size);
 aesl_fh.write(WRAPC_STREAM_INGRESS_STATUS_in_sample_V_strb_V, __xlx_sprintf_buffer.data());
}

  sprintf(__xlx_sprintf_buffer.data(), "[[/transaction]] \n");
  aesl_fh.write(WRAPC_STREAM_INGRESS_STATUS_in_sample_V_strb_V, __xlx_sprintf_buffer.data());
}
// dump stream ingress status to file
{
  sprintf(__xlx_sprintf_buffer.data(), "[[transaction]] %d\n", AESL_transaction);
  aesl_fh.write(WRAPC_STREAM_INGRESS_STATUS_in_sample_V_last_V, __xlx_sprintf_buffer.data());
  if (__xlx_apatb_param_in_sample_stream_buf_final_size > 0) {
  long in_sample_V_last_V_stream_ingress_size = __xlx_apatb_param_in_sample_stream_buf_size;
sprintf(__xlx_sprintf_buffer.data(), "%d\n", in_sample_V_last_V_stream_ingress_size);
 aesl_fh.write(WRAPC_STREAM_INGRESS_STATUS_in_sample_V_last_V, __xlx_sprintf_buffer.data());
  for (int j = 0, e = __xlx_apatb_param_in_sample_stream_buf_final_size; j != e; j++) {
    in_sample_V_last_V_stream_ingress_size--;
sprintf(__xlx_sprintf_buffer.data(), "%d\n", in_sample_V_last_V_stream_ingress_size);
 aesl_fh.write(WRAPC_STREAM_INGRESS_STATUS_in_sample_V_last_V, __xlx_sprintf_buffer.data());
  }
} else {
  long in_sample_V_last_V_stream_ingress_size = 0;
sprintf(__xlx_sprintf_buffer.data(), "%d\n", in_sample_V_last_V_stream_ingress_size);
 aesl_fh.write(WRAPC_STREAM_INGRESS_STATUS_in_sample_V_last_V, __xlx_sprintf_buffer.data());
}

  sprintf(__xlx_sprintf_buffer.data(), "[[/transaction]] \n");
  aesl_fh.write(WRAPC_STREAM_INGRESS_STATUS_in_sample_V_last_V, __xlx_sprintf_buffer.data());
}{
  sprintf(__xlx_sprintf_buffer.data(), "[[transaction]] %d\n", AESL_transaction);
  aesl_fh.write(WRAPC_STREAM_SIZE_IN_in_sample_V_data_V, __xlx_sprintf_buffer.data());
  sprintf(__xlx_sprintf_buffer.data(), "%d\n", __xlx_apatb_param_in_sample_stream_buf_final_size);
 aesl_fh.write(WRAPC_STREAM_SIZE_IN_in_sample_V_data_V, __xlx_sprintf_buffer.data());

  sprintf(__xlx_sprintf_buffer.data(), "[[/transaction]] \n");
  aesl_fh.write(WRAPC_STREAM_SIZE_IN_in_sample_V_data_V, __xlx_sprintf_buffer.data());
}{
  sprintf(__xlx_sprintf_buffer.data(), "[[transaction]] %d\n", AESL_transaction);
  aesl_fh.write(WRAPC_STREAM_SIZE_IN_in_sample_V_keep_V, __xlx_sprintf_buffer.data());
  sprintf(__xlx_sprintf_buffer.data(), "%d\n", __xlx_apatb_param_in_sample_stream_buf_final_size);
 aesl_fh.write(WRAPC_STREAM_SIZE_IN_in_sample_V_keep_V, __xlx_sprintf_buffer.data());

  sprintf(__xlx_sprintf_buffer.data(), "[[/transaction]] \n");
  aesl_fh.write(WRAPC_STREAM_SIZE_IN_in_sample_V_keep_V, __xlx_sprintf_buffer.data());
}{
  sprintf(__xlx_sprintf_buffer.data(), "[[transaction]] %d\n", AESL_transaction);
  aesl_fh.write(WRAPC_STREAM_SIZE_IN_in_sample_V_strb_V, __xlx_sprintf_buffer.data());
  sprintf(__xlx_sprintf_buffer.data(), "%d\n", __xlx_apatb_param_in_sample_stream_buf_final_size);
 aesl_fh.write(WRAPC_STREAM_SIZE_IN_in_sample_V_strb_V, __xlx_sprintf_buffer.data());

  sprintf(__xlx_sprintf_buffer.data(), "[[/transaction]] \n");
  aesl_fh.write(WRAPC_STREAM_SIZE_IN_in_sample_V_strb_V, __xlx_sprintf_buffer.data());
}{
  sprintf(__xlx_sprintf_buffer.data(), "[[transaction]] %d\n", AESL_transaction);
  aesl_fh.write(WRAPC_STREAM_SIZE_IN_in_sample_V_last_V, __xlx_sprintf_buffer.data());
  sprintf(__xlx_sprintf_buffer.data(), "%d\n", __xlx_apatb_param_in_sample_stream_buf_final_size);
 aesl_fh.write(WRAPC_STREAM_SIZE_IN_in_sample_V_last_V, __xlx_sprintf_buffer.data());

  sprintf(__xlx_sprintf_buffer.data(), "[[/transaction]] \n");
  aesl_fh.write(WRAPC_STREAM_SIZE_IN_in_sample_V_last_V, __xlx_sprintf_buffer.data());
}
//********************** dump C output stream *******************
long __xlx_apatb_param_out_sample_stream_buf_final_size = ((hls::stream<__cosim_s8__>*)__xlx_apatb_param_out_sample)->size() - __xlx_apatb_param_out_sample_stream_buf_size;
{
  while (!((hls::stream<__cosim_s8__>*)__xlx_apatb_param_out_sample)->empty())
    __xlx_apatb_param_out_sample_stream_buf.push_back(((hls::stream<__cosim_s8__>*)__xlx_apatb_param_out_sample)->read());
  for (int i = 0; i < __xlx_apatb_param_out_sample_stream_buf.size(); ++i)
    ((hls::stream<__cosim_s8__>*)__xlx_apatb_param_out_sample)->write(__xlx_apatb_param_out_sample_stream_buf[i]);
  }

  sprintf(__xlx_sprintf_buffer.data(), "[[transaction]] %d\n", AESL_transaction);
  aesl_fh.write(AUTOTB_TVOUT_out_sample_V_data_V, __xlx_sprintf_buffer.data());
  
  sprintf(__xlx_sprintf_buffer.data(), "[[transaction]] %d\n", AESL_transaction);
  aesl_fh.write(AUTOTB_TVOUT_out_sample_V_keep_V, __xlx_sprintf_buffer.data());
  
  sprintf(__xlx_sprintf_buffer.data(), "[[transaction]] %d\n", AESL_transaction);
  aesl_fh.write(AUTOTB_TVOUT_out_sample_V_strb_V, __xlx_sprintf_buffer.data());
  
  sprintf(__xlx_sprintf_buffer.data(), "[[transaction]] %d\n", AESL_transaction);
  aesl_fh.write(AUTOTB_TVOUT_out_sample_V_last_V, __xlx_sprintf_buffer.data());
  for (int j = 0, e = __xlx_apatb_param_out_sample_stream_buf_final_size; j != e; ++j) {
sc_bv<64> __xlx_tmp_lv = ((long long*)&__xlx_apatb_param_out_sample_stream_buf[__xlx_apatb_param_out_sample_stream_buf_size+j])[0];
sc_bv<32> __xlx_tmp_0_lv = __xlx_tmp_lv.range(31, 0);
sprintf(__xlx_sprintf_buffer.data(), "%s\n", __xlx_tmp_0_lv.to_string(SC_HEX).c_str());
aesl_fh.write(AUTOTB_TVOUT_out_sample_V_data_V, __xlx_sprintf_buffer.data());
sc_bv<8> __xlx_tmp_1_lv = __xlx_tmp_lv.range(39, 32);
sprintf(__xlx_sprintf_buffer.data(), "%s\n", __xlx_tmp_1_lv.to_string(SC_HEX).c_str());
aesl_fh.write(AUTOTB_TVOUT_out_sample_V_keep_V, __xlx_sprintf_buffer.data());
sc_bv<8> __xlx_tmp_2_lv = __xlx_tmp_lv.range(47, 40);
sprintf(__xlx_sprintf_buffer.data(), "%s\n", __xlx_tmp_2_lv.to_string(SC_HEX).c_str());
aesl_fh.write(AUTOTB_TVOUT_out_sample_V_strb_V, __xlx_sprintf_buffer.data());
sc_bv<16> __xlx_tmp_3_lv = __xlx_tmp_lv.range(63, 48);
sprintf(__xlx_sprintf_buffer.data(), "%s\n", __xlx_tmp_3_lv.to_string(SC_HEX).c_str());
aesl_fh.write(AUTOTB_TVOUT_out_sample_V_last_V, __xlx_sprintf_buffer.data());
}
tcl_file.set_num(__xlx_apatb_param_out_sample_stream_buf_final_size, &tcl_file.out_sample_V_data_V_depth);

  sprintf(__xlx_sprintf_buffer.data(), "[[/transaction]] \n");
  aesl_fh.write(AUTOTB_TVOUT_out_sample_V_data_V, __xlx_sprintf_buffer.data());
tcl_file.set_num(__xlx_apatb_param_out_sample_stream_buf_final_size, &tcl_file.out_sample_V_keep_V_depth);

  sprintf(__xlx_sprintf_buffer.data(), "[[/transaction]] \n");
  aesl_fh.write(AUTOTB_TVOUT_out_sample_V_keep_V, __xlx_sprintf_buffer.data());
tcl_file.set_num(__xlx_apatb_param_out_sample_stream_buf_final_size, &tcl_file.out_sample_V_strb_V_depth);

  sprintf(__xlx_sprintf_buffer.data(), "[[/transaction]] \n");
  aesl_fh.write(AUTOTB_TVOUT_out_sample_V_strb_V, __xlx_sprintf_buffer.data());
tcl_file.set_num(__xlx_apatb_param_out_sample_stream_buf_final_size, &tcl_file.out_sample_V_last_V_depth);

  sprintf(__xlx_sprintf_buffer.data(), "[[/transaction]] \n");
  aesl_fh.write(AUTOTB_TVOUT_out_sample_V_last_V, __xlx_sprintf_buffer.data());
{
  sprintf(__xlx_sprintf_buffer.data(), "[[transaction]] %d\n", AESL_transaction);
  aesl_fh.write(WRAPC_STREAM_SIZE_OUT_out_sample_V_data_V, __xlx_sprintf_buffer.data());
  sprintf(__xlx_sprintf_buffer.data(), "%d\n", __xlx_apatb_param_out_sample_stream_buf_final_size);
 aesl_fh.write(WRAPC_STREAM_SIZE_OUT_out_sample_V_data_V, __xlx_sprintf_buffer.data());

  sprintf(__xlx_sprintf_buffer.data(), "[[/transaction]] \n");
  aesl_fh.write(WRAPC_STREAM_SIZE_OUT_out_sample_V_data_V, __xlx_sprintf_buffer.data());
}{
  sprintf(__xlx_sprintf_buffer.data(), "[[transaction]] %d\n", AESL_transaction);
  aesl_fh.write(WRAPC_STREAM_SIZE_OUT_out_sample_V_keep_V, __xlx_sprintf_buffer.data());
  sprintf(__xlx_sprintf_buffer.data(), "%d\n", __xlx_apatb_param_out_sample_stream_buf_final_size);
 aesl_fh.write(WRAPC_STREAM_SIZE_OUT_out_sample_V_keep_V, __xlx_sprintf_buffer.data());

  sprintf(__xlx_sprintf_buffer.data(), "[[/transaction]] \n");
  aesl_fh.write(WRAPC_STREAM_SIZE_OUT_out_sample_V_keep_V, __xlx_sprintf_buffer.data());
}{
  sprintf(__xlx_sprintf_buffer.data(), "[[transaction]] %d\n", AESL_transaction);
  aesl_fh.write(WRAPC_STREAM_SIZE_OUT_out_sample_V_strb_V, __xlx_sprintf_buffer.data());
  sprintf(__xlx_sprintf_buffer.data(), "%d\n", __xlx_apatb_param_out_sample_stream_buf_final_size);
 aesl_fh.write(WRAPC_STREAM_SIZE_OUT_out_sample_V_strb_V, __xlx_sprintf_buffer.data());

  sprintf(__xlx_sprintf_buffer.data(), "[[/transaction]] \n");
  aesl_fh.write(WRAPC_STREAM_SIZE_OUT_out_sample_V_strb_V, __xlx_sprintf_buffer.data());
}{
  sprintf(__xlx_sprintf_buffer.data(), "[[transaction]] %d\n", AESL_transaction);
  aesl_fh.write(WRAPC_STREAM_SIZE_OUT_out_sample_V_last_V, __xlx_sprintf_buffer.data());
  sprintf(__xlx_sprintf_buffer.data(), "%d\n", __xlx_apatb_param_out_sample_stream_buf_final_size);
 aesl_fh.write(WRAPC_STREAM_SIZE_OUT_out_sample_V_last_V, __xlx_sprintf_buffer.data());

  sprintf(__xlx_sprintf_buffer.data(), "[[/transaction]] \n");
  aesl_fh.write(WRAPC_STREAM_SIZE_OUT_out_sample_V_last_V, __xlx_sprintf_buffer.data());
}CodeState = DELETE_CHAR_BUFFERS;
AESL_transaction++;
tcl_file.set_num(AESL_transaction , &tcl_file.trans_num);
}