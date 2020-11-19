#include <adf.h>

class SineGen
{
private:
    uint32 freq;
    uint32 phase;    
    uint32 numSamples;

public:
    SineGen();  
    void generate(int16 scale, output_window_cint16* out);
    
    //user needs to write this function to register necessary info
    static void registerKernelClass()
    {
        REGISTER_FUNCTION(SineGen::generate);    
    }
};