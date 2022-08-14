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
#define AUTOTB_TVIN_row1 "../tv/cdatafile/c.MedianFilter.autotvin_row1.dat"
#define AUTOTB_TVOUT_row1 "../tv/cdatafile/c.MedianFilter.autotvout_row1.dat"
// wrapc file define:
#define AUTOTB_TVIN_row2 "../tv/cdatafile/c.MedianFilter.autotvin_row2.dat"
#define AUTOTB_TVOUT_row2 "../tv/cdatafile/c.MedianFilter.autotvout_row2.dat"
// wrapc file define:
#define AUTOTB_TVIN_row3 "../tv/cdatafile/c.MedianFilter.autotvin_row3.dat"
#define AUTOTB_TVOUT_row3 "../tv/cdatafile/c.MedianFilter.autotvout_row3.dat"
// wrapc file define:
#define AUTOTB_TVIN_V "../tv/cdatafile/c.MedianFilter.autotvin_V.dat"
#define AUTOTB_TVOUT_V "../tv/cdatafile/c.MedianFilter.autotvout_V.dat"

#define INTER_TCL "../tv/cdatafile/ref.tcl"

// tvout file define:
#define AUTOTB_TVOUT_PC_row1 "../tv/rtldatafile/rtl.MedianFilter.autotvout_row1.dat"
// tvout file define:
#define AUTOTB_TVOUT_PC_row2 "../tv/rtldatafile/rtl.MedianFilter.autotvout_row2.dat"
// tvout file define:
#define AUTOTB_TVOUT_PC_row3 "../tv/rtldatafile/rtl.MedianFilter.autotvout_row3.dat"
// tvout file define:
#define AUTOTB_TVOUT_PC_V "../tv/rtldatafile/rtl.MedianFilter.autotvout_V.dat"

class INTER_TCL_FILE {
  public:
INTER_TCL_FILE(const char* name) {
  mName = name; 
  row1_depth = 0;
  row2_depth = 0;
  row3_depth = 0;
  V_depth = 0;
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
  total_list << "{row1 " << row1_depth << "}\n";
  total_list << "{row2 " << row2_depth << "}\n";
  total_list << "{row3 " << row3_depth << "}\n";
  total_list << "{V " << V_depth << "}\n";
  return total_list.str();
}
void set_num (int num , int* class_num) {
  (*class_num) = (*class_num) > num ? (*class_num) : num;
}
void set_string(std::string list, std::string* class_list) {
  (*class_list) = list;
}
  public:
    int row1_depth;
    int row2_depth;
    int row3_depth;
    int V_depth;
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
extern "C" void MedianFilter_hw_stub_wrapper(char, char, char, volatile void *);

extern "C" void apatb_MedianFilter_hw(char __xlx_apatb_param_row1, char __xlx_apatb_param_row2, char __xlx_apatb_param_row3, volatile void * __xlx_apatb_param_V) {
  refine_signal_handler();
  fstream wrapc_switch_file_token;
  wrapc_switch_file_token.open(".hls_cosim_wrapc_switch.log");
  int AESL_i;
  if (wrapc_switch_file_token.good())
  {

    CodeState = ENTER_WRAPC_PC;
    static unsigned AESL_transaction_pc = 0;
    string AESL_token;
    string AESL_num;{
      static ifstream rtl_tv_out_file;
      if (!rtl_tv_out_file.is_open()) {
        rtl_tv_out_file.open(AUTOTB_TVOUT_PC_V);
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
          std::vector<sc_bv<8> > V_pc_buffer(1);
          int i = 0;

          rtl_tv_out_file >> AESL_token; //data
          while (AESL_token != "[[/transaction]]"){

            RTLOutputCheckAndReplacement(AESL_token, "V");
  
            // push token into output port buffer
            if (AESL_token != "") {
              V_pc_buffer[i] = AESL_token.c_str();;
              i++;
            }
  
            rtl_tv_out_file >> AESL_token; //data or [[/transaction]]
            if (AESL_token == "[[[/runtime]]]" || rtl_tv_out_file.eof())
              exit(1);
          }
          if (i > 0) {
            ((char*)__xlx_apatb_param_V)[0] = V_pc_buffer[0].to_int64();
          }
        } // end transaction
      } // end file is good
    } // end post check logic bolck
  
    AESL_transaction_pc++;
    return ;
  }
static unsigned AESL_transaction;
static AESL_FILE_HANDLER aesl_fh;
static INTER_TCL_FILE tcl_file(INTER_TCL);
std::vector<char> __xlx_sprintf_buffer(1024);
CodeState = ENTER_WRAPC;
//row1
aesl_fh.touch(AUTOTB_TVIN_row1);
aesl_fh.touch(AUTOTB_TVOUT_row1);
//row2
aesl_fh.touch(AUTOTB_TVIN_row2);
aesl_fh.touch(AUTOTB_TVOUT_row2);
//row3
aesl_fh.touch(AUTOTB_TVIN_row3);
aesl_fh.touch(AUTOTB_TVOUT_row3);
//V
aesl_fh.touch(AUTOTB_TVIN_V);
aesl_fh.touch(AUTOTB_TVOUT_V);
CodeState = DUMP_INPUTS;
// print row1 Transactions
{
  sprintf(__xlx_sprintf_buffer.data(), "[[transaction]] %d\n", AESL_transaction);
  aesl_fh.write(AUTOTB_TVIN_row1, __xlx_sprintf_buffer.data());
  {
    sc_bv<8> __xlx_tmp_lv = *((char*)&__xlx_apatb_param_row1);

    sprintf(__xlx_sprintf_buffer.data(), "%s\n", __xlx_tmp_lv.to_string(SC_HEX).c_str());
    aesl_fh.write(AUTOTB_TVIN_row1, __xlx_sprintf_buffer.data()); 
  }
  tcl_file.set_num(1, &tcl_file.row1_depth);
  sprintf(__xlx_sprintf_buffer.data(), "[[/transaction]] \n");
  aesl_fh.write(AUTOTB_TVIN_row1, __xlx_sprintf_buffer.data());
}
// print row2 Transactions
{
  sprintf(__xlx_sprintf_buffer.data(), "[[transaction]] %d\n", AESL_transaction);
  aesl_fh.write(AUTOTB_TVIN_row2, __xlx_sprintf_buffer.data());
  {
    sc_bv<8> __xlx_tmp_lv = *((char*)&__xlx_apatb_param_row2);

    sprintf(__xlx_sprintf_buffer.data(), "%s\n", __xlx_tmp_lv.to_string(SC_HEX).c_str());
    aesl_fh.write(AUTOTB_TVIN_row2, __xlx_sprintf_buffer.data()); 
  }
  tcl_file.set_num(1, &tcl_file.row2_depth);
  sprintf(__xlx_sprintf_buffer.data(), "[[/transaction]] \n");
  aesl_fh.write(AUTOTB_TVIN_row2, __xlx_sprintf_buffer.data());
}
// print row3 Transactions
{
  sprintf(__xlx_sprintf_buffer.data(), "[[transaction]] %d\n", AESL_transaction);
  aesl_fh.write(AUTOTB_TVIN_row3, __xlx_sprintf_buffer.data());
  {
    sc_bv<8> __xlx_tmp_lv = *((char*)&__xlx_apatb_param_row3);

    sprintf(__xlx_sprintf_buffer.data(), "%s\n", __xlx_tmp_lv.to_string(SC_HEX).c_str());
    aesl_fh.write(AUTOTB_TVIN_row3, __xlx_sprintf_buffer.data()); 
  }
  tcl_file.set_num(1, &tcl_file.row3_depth);
  sprintf(__xlx_sprintf_buffer.data(), "[[/transaction]] \n");
  aesl_fh.write(AUTOTB_TVIN_row3, __xlx_sprintf_buffer.data());
}
// print V Transactions
{
  sprintf(__xlx_sprintf_buffer.data(), "[[transaction]] %d\n", AESL_transaction);
  aesl_fh.write(AUTOTB_TVIN_V, __xlx_sprintf_buffer.data());
  {
    sc_bv<8> __xlx_tmp_lv = *((char*)__xlx_apatb_param_V);

    sprintf(__xlx_sprintf_buffer.data(), "%s\n", __xlx_tmp_lv.to_string(SC_HEX).c_str());
    aesl_fh.write(AUTOTB_TVIN_V, __xlx_sprintf_buffer.data()); 
  }
  tcl_file.set_num(1, &tcl_file.V_depth);
  sprintf(__xlx_sprintf_buffer.data(), "[[/transaction]] \n");
  aesl_fh.write(AUTOTB_TVIN_V, __xlx_sprintf_buffer.data());
}
CodeState = CALL_C_DUT;
MedianFilter_hw_stub_wrapper(__xlx_apatb_param_row1, __xlx_apatb_param_row2, __xlx_apatb_param_row3, __xlx_apatb_param_V);
CodeState = DUMP_OUTPUTS;
// print V Transactions
{
  sprintf(__xlx_sprintf_buffer.data(), "[[transaction]] %d\n", AESL_transaction);
  aesl_fh.write(AUTOTB_TVOUT_V, __xlx_sprintf_buffer.data());
  {
    sc_bv<8> __xlx_tmp_lv = *((char*)__xlx_apatb_param_V);

    sprintf(__xlx_sprintf_buffer.data(), "%s\n", __xlx_tmp_lv.to_string(SC_HEX).c_str());
    aesl_fh.write(AUTOTB_TVOUT_V, __xlx_sprintf_buffer.data()); 
  }
  tcl_file.set_num(1, &tcl_file.V_depth);
  sprintf(__xlx_sprintf_buffer.data(), "[[/transaction]] \n");
  aesl_fh.write(AUTOTB_TVOUT_V, __xlx_sprintf_buffer.data());
}
CodeState = DELETE_CHAR_BUFFERS;
AESL_transaction++;
tcl_file.set_num(AESL_transaction , &tcl_file.trans_num);
}
