

#ifndef __DETECT_H__
#define __DETECT_H__

#pragma once

#include <aie_api/aie_adf.hpp>
#include <aie_api/aie.hpp>
#include <aie_api/utils.hpp>

namespace SingleWindow{
    template<int NUMSAMPLES, int AVERAGE>
    class detect_SingleWindow{
        private:                
        aie::vector<int16,8> pWin;
        aie::vector<int32,8> mWin0, mWin1, pWinZero;
        aie::accum<acc48,8> accWin0;
        alignas(aie::vector_decl_align) int32 buffer0[NUMSAMPLES];
        alignas(aie::vector_decl_align) int32 buffer1[NUMSAMPLES];
        int count;
        bool mode, prevmode;
        int m_bit_avg;
        public:
        detect_SingleWindow(){
            detect_init();
        };
        void detect(input_window_int16* __restrict iwinPower,
                    output_window_int32* __restrict owinDetect);
        void detect_init();
        static void registerKernelClass()
        {
            REGISTER_FUNCTION(detect_SingleWindow::detect);
        };
    };
}

#endif