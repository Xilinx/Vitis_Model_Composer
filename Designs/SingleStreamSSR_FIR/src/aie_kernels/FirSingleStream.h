#pragma once

#include <adf.h>

namespace SingleStream {


template<int NSamples,int ShiftAcc,int Delay>
class FIR_MultiKernel_cout {
private:
	alignas(32) cint16 weights[8];
	alignas(32) cint16 delay_line[16];
    bool InitCall;

public:
	FIR_MultiKernel_cout(const cint16 (&taps)[8])
	{
        InitCall = true;
		for(int i=0;i<8;i++) weights[i] = taps[i];
		for(int i=0;i<16;i++) delay_line[i] = (cint16){0,0};
	};

	void filter(input_stream_cint16*  sin,output_stream_cacc48*  cout);

	static void registerKernelClass()
	{
		REGISTER_FUNCTION(FIR_MultiKernel_cout::filter);
	};
};


template<int NSamples,int ShiftAcc,int Delay>
class FIR_MultiKernel_cincout {
private:
	alignas(32) cint16 weights[8];
	alignas(32) cint16 delay_line[16];
    bool InitCall;

public:
	FIR_MultiKernel_cincout(const cint16 (&taps)[8])
	{
        InitCall = true;
		for(int i=0;i<8;i++) weights[i] = taps[i];
		for(int i=0;i<16;i++) delay_line[i] = (cint16){0,0};
	};

	void filter(input_stream_cint16*  sin,input_stream_cacc48*  cin,output_stream_cacc48*  cout);

	static void registerKernelClass()
	{
		REGISTER_FUNCTION(FIR_MultiKernel_cincout::filter);
	};
};


template<int NSamples,int ShiftAcc,int Delay>
class FIR_MultiKernel_cin {
private:
	alignas(32) cint16 weights[8];
	alignas(32) cint16 delay_line[16];
    bool InitCall;


public:
	FIR_MultiKernel_cin(const cint16 (&taps)[8])
	{
        InitCall = true;
		for(int i=0;i<8;i++) weights[i] = taps[i];
		for(int i=0;i<16;i++) delay_line[i] = (cint16){0,0};
	};

	void filter(input_stream_cint16*  sin,input_stream_cacc48*  cin,output_stream_cint16*  sout);

	static void registerKernelClass()
	{
		REGISTER_FUNCTION(FIR_MultiKernel_cin::filter);
	};
};


template<int Delay>
void FIRinit();



}
