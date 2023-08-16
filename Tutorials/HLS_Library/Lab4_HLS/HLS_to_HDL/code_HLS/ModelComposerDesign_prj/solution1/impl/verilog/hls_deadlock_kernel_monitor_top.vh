
wire kernel_monitor_reset;
wire kernel_monitor_clock;
assign kernel_monitor_reset = ~ap_rst_n;
assign kernel_monitor_clock = ap_clk;
wire [1:0] axis_block_sigs;
wire [13:0] inst_idle_sigs;
wire [10:0] inst_block_sigs;
wire kernel_block;

assign axis_block_sigs[0] = ~readStream_unsigned_char_U0.Image_in_TDATA_blk_n;
assign axis_block_sigs[1] = ~writeStream_bool_U0.Edge_out_TDATA_blk_n;

assign inst_idle_sigs[0] = readStream_unsigned_char_U0.ap_idle;
assign inst_block_sigs[0] = (readStream_unsigned_char_U0.ap_done & ~readStream_unsigned_char_U0.ap_continue) | ~readStream_unsigned_char_U0.Image_in_adapter_out1_blk_n;
assign inst_idle_sigs[1] = SobelFilter_XMC_120_160_1_U0.ap_idle;
assign inst_block_sigs[1] = (SobelFilter_XMC_120_160_1_U0.ap_done & ~SobelFilter_XMC_120_160_1_U0.ap_continue) | ~SobelFilter_XMC_120_160_1_U0.SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_94_1_proc7_U0.Image_in_adapter_out1_blk_n | ~SobelFilter_XMC_120_160_1_U0.SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0.SobelFilter_XMC_out1_i_blk_n | ~SobelFilter_XMC_120_160_1_U0.SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0.SobelFilter_XMC_out2_i_blk_n;
assign inst_idle_sigs[2] = GradientMag_XMC_120_160_1_U0.ap_idle;
assign inst_block_sigs[2] = (GradientMag_XMC_120_160_1_U0.ap_done & ~GradientMag_XMC_120_160_1_U0.ap_continue) | ~GradientMag_XMC_120_160_1_U0.GradientMag_XMC_120_160_1_Loop_VITIS_LOOP_93_1_proc9_U0.SobelFilter_XMC_out1_i_blk_n | ~GradientMag_XMC_120_160_1_U0.GradientMag_XMC_120_160_1_Loop_VITIS_LOOP_93_1_proc9_U0.SobelFilter_XMC_out2_i_blk_n | ~GradientMag_XMC_120_160_1_U0.GradientMag_XMC_120_160_1_Loop_VITIS_LOOP_106_3_proc10_U0.GradientMag_XMC_out1_i_blk_n;
assign inst_idle_sigs[3] = p31_U0.ap_idle;
assign inst_block_sigs[3] = (p31_U0.ap_done & ~p31_U0.ap_continue) | ~p31_U0.GradientMag_XMC_out1_i_blk_n | ~p31_U0.ModelComposerDesign_core_Edge_out_blk_n;
assign inst_idle_sigs[4] = writeStream_bool_U0.ap_idle;
assign inst_block_sigs[4] = (writeStream_bool_U0.ap_done & ~writeStream_bool_U0.ap_continue) | ~writeStream_bool_U0.ModelComposerDesign_core_Edge_out_blk_n;
assign inst_idle_sigs[5] = SobelFilter_XMC_120_160_1_U0.SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_94_1_proc7_U0.ap_idle;
assign inst_block_sigs[5] = (SobelFilter_XMC_120_160_1_U0.SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_94_1_proc7_U0.ap_done & ~SobelFilter_XMC_120_160_1_U0.SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_94_1_proc7_U0.ap_continue);
assign inst_idle_sigs[6] = SobelFilter_XMC_120_160_1_U0.Sobel_0_3_0_2_120_160_1_false_U0.ap_idle;
assign inst_block_sigs[6] = (SobelFilter_XMC_120_160_1_U0.Sobel_0_3_0_2_120_160_1_false_U0.ap_done & ~SobelFilter_XMC_120_160_1_U0.Sobel_0_3_0_2_120_160_1_false_U0.ap_continue);
assign inst_idle_sigs[7] = SobelFilter_XMC_120_160_1_U0.SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0.ap_idle;
assign inst_block_sigs[7] = (SobelFilter_XMC_120_160_1_U0.SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0.ap_done & ~SobelFilter_XMC_120_160_1_U0.SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0.ap_continue);
assign inst_idle_sigs[8] = GradientMag_XMC_120_160_1_U0.GradientMag_XMC_120_160_1_Loop_VITIS_LOOP_93_1_proc9_U0.ap_idle;
assign inst_block_sigs[8] = (GradientMag_XMC_120_160_1_U0.GradientMag_XMC_120_160_1_Loop_VITIS_LOOP_93_1_proc9_U0.ap_done & ~GradientMag_XMC_120_160_1_U0.GradientMag_XMC_120_160_1_Loop_VITIS_LOOP_93_1_proc9_U0.ap_continue);
assign inst_idle_sigs[9] = GradientMag_XMC_120_160_1_U0.xFMagnitudeKernel_2_2_120_160_3_3_1_5_5_160_2_U0.ap_idle;
assign inst_block_sigs[9] = (GradientMag_XMC_120_160_1_U0.xFMagnitudeKernel_2_2_120_160_3_3_1_5_5_160_2_U0.ap_done & ~GradientMag_XMC_120_160_1_U0.xFMagnitudeKernel_2_2_120_160_3_3_1_5_5_160_2_U0.ap_continue);
assign inst_idle_sigs[10] = GradientMag_XMC_120_160_1_U0.GradientMag_XMC_120_160_1_Loop_VITIS_LOOP_106_3_proc10_U0.ap_idle;
assign inst_block_sigs[10] = (GradientMag_XMC_120_160_1_U0.GradientMag_XMC_120_160_1_Loop_VITIS_LOOP_106_3_proc10_U0.ap_done & ~GradientMag_XMC_120_160_1_U0.GradientMag_XMC_120_160_1_Loop_VITIS_LOOP_106_3_proc10_U0.ap_continue);

assign inst_idle_sigs[11] = 1'b0;
assign inst_idle_sigs[12] = readStream_unsigned_char_U0.ap_idle;
assign inst_idle_sigs[13] = writeStream_bool_U0.ap_idle;

hls_deadlock_idx0_monitor hls_deadlock_idx0_monitor_U (
    .clock(kernel_monitor_clock),
    .reset(kernel_monitor_reset),
    .axis_block_sigs(axis_block_sigs),
    .inst_idle_sigs(inst_idle_sigs),
    .inst_block_sigs(inst_block_sigs),
    .block(kernel_block)
);

always @ (kernel_block or kernel_monitor_reset) begin
    if (kernel_block == 1'b1 && kernel_monitor_reset == 1'b0) begin
        find_kernel_block = 1'b1;
    end
    else begin
        find_kernel_block = 1'b0;
    end
end
