#pragma once

#include <ap_int.h>
#include <hls_stream.h>

namespace idft_output_unpack {

static constexpr unsigned kNumHopsPerHalf = 256;
static constexpr unsigned kNumRanks = 4;
static constexpr unsigned kBinsPerRank = 4;
static constexpr unsigned kPadWordsPerRank = 1;
static constexpr unsigned kNumGroups = 4;

using sample_t = ap_uint<32>;
using axis_t = ap_uint<128>;
using stream_t = hls::stream<axis_t>;

}  // namespace idft_output_unpack

void idft_output_unpack_kernel(
    idft_output_unpack::stream_t half0[4],
    idft_output_unpack::stream_t half1[4],
    idft_output_unpack::stream_t hops[8]);
