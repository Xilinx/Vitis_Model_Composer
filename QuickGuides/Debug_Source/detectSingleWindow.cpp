
#include "detectSingleWindow.h"
template<int NUMSAMPLES, int AVERAGE>
void SingleWindow::detect_SingleWindow<NUMSAMPLES,AVERAGE>::detect(input_window_int16* __restrict iwinPower,
                                                                    output_window_int32* __restrict owinDetect)
{
    count++;
    if (count % AVERAGE ==0)
    {
        prevmode = false;
        mode = !mode;
        count = 1;
    }

    auto mem0in = aie::cbegin_vector_circular<8,NUMSAMPLES>(buffer0);
    auto mem1in = aie::cbegin_vector_circular<8,NUMSAMPLES>(buffer1);
    auto mem0out = aie::begin_vector_circular<8,NUMSAMPLES>(buffer0);
    auto mem1out = aie::begin_vector_circular<8,NUMSAMPLES>(buffer1);

    for (size_t ctr=0; ctr<NUMSAMPLES/8; ctr++)
        chess_prepare_for_pipelining
        chess_loop_range(NUMSAMPLES/8,)
    {
        pWin = window_readincr_v<8>(iwinPower);
        if (mode)
        {
            mWin0 = *mem0in;
            accWin0.from_vector(mWin0,0);
            accWin0 = aie::add(accWin0, pWin);
            *mem0out = accWin0.to_vector<int32>(0);           
            if (count == 1 && !prevmode)
            {
                mWin1 = *mem1in;
                mWin1 = aie::downshift(mWin1,m_bit_avg);
                window_writeincr(owinDetect, mWin1);
                (*mem1out) = pWinZero;
            }
        } else {
            mWin1 = *mem1in;
            accWin0.from_vector(mWin1,0);
            accWin0 = aie::add(accWin0, pWin);
            *mem1out = accWin0.to_vector<int32>(0);          
            if (count == 1 && !prevmode)
            {
                mWin0 = *mem0in;
                mWin0 = aie::downshift(mWin0,m_bit_avg); 
                window_writeincr(owinDetect, mWin0);
                (*mem0out) = pWinZero;
            }
        }
        mem1out++;
        mem0out++;
        mem0in++;
        mem1in++;
    }
}

template<int NUMSAMPLES, int AVERAGE>
void SingleWindow::detect_SingleWindow<NUMSAMPLES,AVERAGE>::detect_init()
{
    count = 0;
    mode = true;
    prevmode = mode;
    pWinZero = aie::zeros<int32,8>();
    pWin = aie::zeros<int16,8>();
    int num = AVERAGE;
    int exponent =0;

    while (num % 2 ==0)
    {
        num = num >> 1;
        exponent++;
    }
    m_bit_avg = exponent;

    // Clear the buffers being used to accumulate
    auto clearMem0 = aie::begin_vector_circular<8,NUMSAMPLES>(buffer0);
    auto clearMem1 = aie::begin_vector_circular<8,NUMSAMPLES>(buffer1);

    for (int ctr=0; ctr < NUMSAMPLES/8; ctr++)
    {
        *clearMem0 = pWinZero;
        *clearMem1 = pWinZero;
    }
}