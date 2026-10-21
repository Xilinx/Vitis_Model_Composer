#include "idft_output_unpack_ssr4.h"

namespace {

using namespace idft_output_unpack;

void unpack_rank(stream_t &input, sample_t samples[kBinsPerRank]) {
#pragma HLS INLINE
#pragma HLS ARRAY_PARTITION variable=samples complete

  const axis_t word = input.read();

  for (unsigned index = 0; index < kBinsPerRank; ++index) {
#pragma HLS UNROLL
    samples[index] = word(32 * index + 31, 32 * index);
  }

  // The library pads the coefficients to CEIL(TP_POINT_SIZE, TP_SSR * 8) = 32,
  // so each rank emits kBinsPerRank real bins followed by kPadWordsPerRank
  // words of zeroed padding bins that must be drained to stay in step.
  for (unsigned pad = 0; pad < kPadWordsPerRank; ++pad) {
#pragma HLS UNROLL
    input.read();
  }
}

void write_hop(
    const sample_t ranks[kNumRanks][kBinsPerRank],
    stream_t hops[8],
    unsigned parity) {
#pragma HLS INLINE
#pragma HLS ARRAY_PARTITION variable=ranks complete dim=0

  for (unsigned group = 0; group < kNumGroups; ++group) {
#pragma HLS UNROLL
    axis_t word = 0;
    for (unsigned offset = 0; offset < 4; ++offset) {
#pragma HLS UNROLL
      const unsigned bin = 4 * group + offset;
      const unsigned rank = bin % kNumRanks;
      const unsigned rank_index = bin / kNumRanks;
      const sample_t value = ranks[rank][rank_index];
      word(32 * offset + 31, 32 * offset) = value;
    }
    hops[2 * group + parity].write(word);
  }
}

void process_half(
    stream_t ranks[kNumRanks],
    stream_t hops[8]) {
#pragma HLS INLINE

 HALF_HOP_LOOP: for (unsigned hop = 0; hop < kNumHopsPerHalf; ++hop) {
#pragma HLS PIPELINE
    sample_t rank_samples[kNumRanks][kBinsPerRank];
#pragma HLS ARRAY_PARTITION variable=rank_samples complete dim=0

    for (unsigned rank = 0; rank < kNumRanks; ++rank) {
#pragma HLS UNROLL
      unpack_rank(ranks[rank], rank_samples[rank]);
    }

    write_hop(rank_samples, hops, hop & 1);
  }
}

}  // namespace

void idft_output_unpack_kernel(
    idft_output_unpack::stream_t half0[4],
    idft_output_unpack::stream_t half1[4],
    idft_output_unpack::stream_t hops[8]) {
#pragma HLS INTERFACE mode=ap_ctrl_none port=return

  using namespace idft_output_unpack;

  // Preserve the concatenation order of the Simulink implementation:
  // all half-0 hops precede all half-1 hops on each output stream.
  // Columns are [even0, odd0, even1, odd1, even2, odd2, even3, odd3].
  process_half(half0, hops);
  process_half(half1, hops);
}
