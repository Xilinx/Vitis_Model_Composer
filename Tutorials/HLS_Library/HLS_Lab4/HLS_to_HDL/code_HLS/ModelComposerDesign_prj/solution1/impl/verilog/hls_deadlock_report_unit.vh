   
    parameter PROC_NUM = 11;
    parameter ST_IDLE = 3'b000;
    parameter ST_FILTER_FAKE = 3'b001;
    parameter ST_DL_DETECTED = 3'b010;
    parameter ST_DL_REPORT = 3'b100;
   

    reg [2:0] CS_fsm;
    reg [2:0] NS_fsm;
    reg [PROC_NUM - 1:0] dl_detect_reg;
    reg [PROC_NUM - 1:0] dl_done_reg;
    reg [PROC_NUM - 1:0] origin_reg;
    reg [PROC_NUM - 1:0] dl_in_vec_reg;
    reg [31:0] dl_keep_cnt;
    integer i;
    integer fp;

    // FSM State machine
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            CS_fsm <= ST_IDLE;
        end
        else begin
            CS_fsm <= NS_fsm;
        end
    end
    always @ (CS_fsm or dl_in_vec or dl_detect_reg or dl_done_reg or dl_in_vec or origin_reg or dl_keep_cnt) begin
        case (CS_fsm)
            ST_IDLE : begin
                if (|dl_in_vec) begin
                    NS_fsm = ST_FILTER_FAKE;
                end
                else begin
                    NS_fsm = ST_IDLE;
                end
            end
            ST_FILTER_FAKE: begin
                if (dl_keep_cnt >= 32'd1000) begin
                    NS_fsm = ST_DL_DETECTED;
                end
                else if (dl_detect_reg != (dl_detect_reg & dl_in_vec)) begin
                    NS_fsm = ST_IDLE;
                end
                else begin
                    NS_fsm = ST_FILTER_FAKE;
                end
            end
            ST_DL_DETECTED: begin
                // has unreported deadlock cycle
                if (dl_detect_reg != dl_done_reg) begin
                    NS_fsm = ST_DL_REPORT;
                end
                else begin
                    NS_fsm = ST_DL_DETECTED;
                end
            end
            ST_DL_REPORT: begin
                if (|(dl_in_vec & origin_reg)) begin
                    NS_fsm = ST_DL_DETECTED;
                end
                else begin
                    NS_fsm = ST_DL_REPORT;
                end
            end
            default: NS_fsm = ST_IDLE;
        endcase
    end

    // dl_detect_reg record the procs that first detect deadlock
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            dl_detect_reg <= 'b0;
        end
        else begin
            if (CS_fsm == ST_IDLE) begin
                dl_detect_reg <= dl_in_vec;
            end
        end
    end

    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            dl_keep_cnt <= 32'h0;
        end
        else begin
            if (CS_fsm == ST_FILTER_FAKE && (dl_detect_reg == (dl_detect_reg & dl_in_vec))) begin
                dl_keep_cnt <= dl_keep_cnt + 32'h1;
            end
            else if (CS_fsm == ST_FILTER_FAKE && (dl_detect_reg != (dl_detect_reg & dl_in_vec))) begin
                dl_keep_cnt <= 32'h0;
            end
        end
    end

    // dl_detect_out keeps in high after deadlock detected
    assign dl_detect_out = (|dl_detect_reg) && (CS_fsm == ST_DL_DETECTED || CS_fsm == ST_DL_REPORT);

    // dl_done_reg record the cycles has been reported
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            dl_done_reg <= 'b0;
        end
        else begin
            if ((CS_fsm == ST_DL_REPORT) && (|(dl_in_vec & dl_detect_reg) == 'b1)) begin
                dl_done_reg <= dl_done_reg | dl_in_vec;
            end
        end
    end

    // clear token once a cycle is done
    assign token_clear = (CS_fsm == ST_DL_REPORT) ? ((|(dl_in_vec & origin_reg)) ? 'b1 : 'b0) : 'b0;

    // origin_reg record the current cycle start id
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            origin_reg <= 'b0;
        end
        else begin
            if (CS_fsm == ST_DL_DETECTED) begin
                origin_reg <= origin;
            end
        end
    end
   
    // origin will be valid for only one cycle
    wire [PROC_NUM*PROC_NUM - 1:0] origin_tmp;
    assign origin_tmp[PROC_NUM - 1:0] = (dl_detect_reg[0] & ~dl_done_reg[0]) ? 'b1 : 'b0;
    genvar j;
    generate
    for(j = 1;j < PROC_NUM;j = j + 1) begin: F1
        assign origin_tmp[j*PROC_NUM +: PROC_NUM] = (dl_detect_reg[j] & ~dl_done_reg[j]) ? ('b1 << j) : origin_tmp[(j - 1)*PROC_NUM +: PROC_NUM];
    end
    endgenerate
    always @ (CS_fsm or origin_tmp) begin
        if (CS_fsm == ST_DL_DETECTED) begin
            origin = origin_tmp[(PROC_NUM - 1)*PROC_NUM +: PROC_NUM];
        end
        else begin
            origin = 'b0;
        end
    end

    
    // dl_in_vec_reg record the current cycle dl_in_vec
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            dl_in_vec_reg <= 'b0;
        end
        else begin
            if (CS_fsm == ST_DL_DETECTED) begin
                dl_in_vec_reg <= origin;
            end
            else if (CS_fsm == ST_DL_REPORT) begin
                dl_in_vec_reg <= dl_in_vec;
            end
        end
    end
    
    // find_df_deadlock to report the deadlock
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            find_df_deadlock <= 1'b0;
        end
        else begin
            if (CS_fsm == ST_DL_DETECTED && dl_detect_reg == dl_done_reg) begin
                find_df_deadlock <= 1'b1;
            end
            else if (CS_fsm == ST_IDLE) begin
                find_df_deadlock <= 1'b0;
            end
        end
    end
    
    // get the first valid proc index in dl vector
    function integer proc_index(input [PROC_NUM - 1:0] dl_vec);
        begin
            proc_index = 0;
            for (i = 0; i < PROC_NUM; i = i + 1) begin
                if (dl_vec[i]) begin
                    proc_index = i;
                end
            end
        end
    endfunction

    // get the proc path based on dl vector
    function [888:0] proc_path(input [PROC_NUM - 1:0] dl_vec);
        integer index;
        begin
            index = proc_index(dl_vec);
            case (index)
                0 : begin
                    proc_path = "ModelComposerDesign.readStream_unsigned_char_U0";
                end
                1 : begin
                    proc_path = "ModelComposerDesign.SobelFilter_XMC_120_160_1_U0";
                end
                2 : begin
                    proc_path = "ModelComposerDesign.SobelFilter_XMC_120_160_1_U0.SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_94_1_proc7_U0";
                end
                3 : begin
                    proc_path = "ModelComposerDesign.SobelFilter_XMC_120_160_1_U0.Sobel_0_3_0_2_120_160_1_false_U0";
                end
                4 : begin
                    proc_path = "ModelComposerDesign.SobelFilter_XMC_120_160_1_U0.SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0";
                end
                5 : begin
                    proc_path = "ModelComposerDesign.GradientMag_XMC_120_160_1_U0";
                end
                6 : begin
                    proc_path = "ModelComposerDesign.GradientMag_XMC_120_160_1_U0.GradientMag_XMC_120_160_1_Loop_VITIS_LOOP_93_1_proc9_U0";
                end
                7 : begin
                    proc_path = "ModelComposerDesign.GradientMag_XMC_120_160_1_U0.xFMagnitudeKernel_2_2_120_160_3_3_1_5_5_160_2_U0";
                end
                8 : begin
                    proc_path = "ModelComposerDesign.GradientMag_XMC_120_160_1_U0.GradientMag_XMC_120_160_1_Loop_VITIS_LOOP_106_3_proc10_U0";
                end
                9 : begin
                    proc_path = "ModelComposerDesign.p31_U0";
                end
                10 : begin
                    proc_path = "ModelComposerDesign.writeStream_bool_U0";
                end
                default : begin
                    proc_path = "unknown";
                end
            endcase
        end
    endfunction

    // print the headlines of deadlock detection
    task print_dl_head;
        begin
            $display("\n//////////////////////////////////////////////////////////////////////////////");
            $display("// ERROR!!! DEADLOCK DETECTED at %0t ns! SIMULATION WILL BE STOPPED! //", $time);
            $display("//////////////////////////////////////////////////////////////////////////////");
            fp = $fopen("deadlock_db.dat", "w");
        end
    endtask

    // print the start of a cycle
    task print_cycle_start(input reg [888:0] proc_path, input integer cycle_id);
        begin
            $display("/////////////////////////");
            $display("// Dependence cycle %0d:", cycle_id);
            $display("// (1): Process: %0s", proc_path);
            $fdisplay(fp, "Dependence_Cycle_ID %0d", cycle_id);
            $fdisplay(fp, "Dependence_Process_ID 1");
            $fdisplay(fp, "Dependence_Process_path %0s", proc_path);
        end
    endtask

    // print the end of deadlock detection
    task print_dl_end(input integer num, input integer record_time);
        begin
            $display("////////////////////////////////////////////////////////////////////////");
            $display("// Totally %0d cycles detected!", num);
            $display("////////////////////////////////////////////////////////////////////////");
            $display("// ERROR!!! DEADLOCK DETECTED at %0t ns! SIMULATION WILL BE STOPPED! //", record_time);
            $display("//////////////////////////////////////////////////////////////////////////////");
            $fdisplay(fp, "Dependence_Cycle_Number %0d", num);
            $fclose(fp);
        end
    endtask

    // print one proc component in the cycle
    task print_cycle_proc_comp(input reg [888:0] proc_path, input integer cycle_comp_id);
        begin
            $display("// (%0d): Process: %0s", cycle_comp_id, proc_path);
            $fdisplay(fp, "Dependence_Process_ID %0d", cycle_comp_id);
            $fdisplay(fp, "Dependence_Process_path %0s", proc_path);
        end
    endtask

    // print one channel component in the cycle
    task print_cycle_chan_comp(input [PROC_NUM - 1:0] dl_vec1, input [PROC_NUM - 1:0] dl_vec2);
        reg [984:0] chan_path;
        integer index1;
        integer index2;
        begin
            index1 = proc_index(dl_vec1);
            index2 = proc_index(dl_vec2);
            case (index1)
                0 : begin
                    case(index2)
                    1: begin
                        if (~readStream_unsigned_char_U0.Image_in_adapter_out1_blk_n) begin
                            if (~Image_in_adapter_out1_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'ModelComposerDesign.Image_in_adapter_out1_U' written by process 'ModelComposerDesign.SobelFilter_XMC_120_160_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path ModelComposerDesign.Image_in_adapter_out1_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~Image_in_adapter_out1_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'ModelComposerDesign.Image_in_adapter_out1_U' read by process 'ModelComposerDesign.SobelFilter_XMC_120_160_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path ModelComposerDesign.Image_in_adapter_out1_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~start_for_SobelFilter_XMC_120_160_1_U0_U.if_full_n & readStream_unsigned_char_U0.ap_start & ~readStream_unsigned_char_U0.real_start & (trans_in_cnt_0 == trans_out_cnt_0) & ~start_for_SobelFilter_XMC_120_160_1_U0_U.if_read) begin
                            $display("//      Blocked by full output start propagation FIFO 'ModelComposerDesign.start_for_SobelFilter_XMC_120_160_1_U0_U' read by process 'ModelComposerDesign.SobelFilter_XMC_120_160_1_U0',");
                        end
                    end
                    2: begin
                        if (~readStream_unsigned_char_U0.Image_in_adapter_out1_blk_n) begin
                            if (~Image_in_adapter_out1_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'ModelComposerDesign.Image_in_adapter_out1_U' written by process 'ModelComposerDesign.SobelFilter_XMC_120_160_1_U0.SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_94_1_proc7_U0'");
                                $fdisplay(fp, "Dependence_Channel_path ModelComposerDesign.Image_in_adapter_out1_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~Image_in_adapter_out1_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'ModelComposerDesign.Image_in_adapter_out1_U' read by process 'ModelComposerDesign.SobelFilter_XMC_120_160_1_U0.SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_94_1_proc7_U0'");
                                $fdisplay(fp, "Dependence_Channel_path ModelComposerDesign.Image_in_adapter_out1_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    endcase
                end
                1 : begin
                    case(index2)
                    0: begin
                        if (~SobelFilter_XMC_120_160_1_U0.SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_94_1_proc7_U0.Image_in_adapter_out1_blk_n) begin
                            if (~Image_in_adapter_out1_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'ModelComposerDesign.Image_in_adapter_out1_U' written by process 'ModelComposerDesign.readStream_unsigned_char_U0'");
                                $fdisplay(fp, "Dependence_Channel_path ModelComposerDesign.Image_in_adapter_out1_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~Image_in_adapter_out1_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'ModelComposerDesign.Image_in_adapter_out1_U' read by process 'ModelComposerDesign.readStream_unsigned_char_U0'");
                                $fdisplay(fp, "Dependence_Channel_path ModelComposerDesign.Image_in_adapter_out1_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~start_for_SobelFilter_XMC_120_160_1_U0_U.if_empty_n & SobelFilter_XMC_120_160_1_U0.ap_idle & ~start_for_SobelFilter_XMC_120_160_1_U0_U.if_write) begin
                            $display("//      Blocked by missing 'ap_start' from start propagation FIFO 'ModelComposerDesign.start_for_SobelFilter_XMC_120_160_1_U0_U' written by process 'ModelComposerDesign.readStream_unsigned_char_U0',");
                        end
                    end
                    5: begin
                        if (~SobelFilter_XMC_120_160_1_U0.SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0.SobelFilter_XMC_out1_i_blk_n) begin
                            if (~SobelFilter_XMC_out1_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'ModelComposerDesign.SobelFilter_XMC_out1_U' written by process 'ModelComposerDesign.GradientMag_XMC_120_160_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path ModelComposerDesign.SobelFilter_XMC_out1_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~SobelFilter_XMC_out1_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'ModelComposerDesign.SobelFilter_XMC_out1_U' read by process 'ModelComposerDesign.GradientMag_XMC_120_160_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path ModelComposerDesign.SobelFilter_XMC_out1_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~SobelFilter_XMC_120_160_1_U0.SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0.SobelFilter_XMC_out2_i_blk_n) begin
                            if (~SobelFilter_XMC_out2_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'ModelComposerDesign.SobelFilter_XMC_out2_U' written by process 'ModelComposerDesign.GradientMag_XMC_120_160_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path ModelComposerDesign.SobelFilter_XMC_out2_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~SobelFilter_XMC_out2_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'ModelComposerDesign.SobelFilter_XMC_out2_U' read by process 'ModelComposerDesign.GradientMag_XMC_120_160_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path ModelComposerDesign.SobelFilter_XMC_out2_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~start_for_GradientMag_XMC_120_160_1_U0_U.if_full_n & SobelFilter_XMC_120_160_1_U0.ap_start & ~SobelFilter_XMC_120_160_1_U0.real_start & (trans_in_cnt_3 == trans_out_cnt_3) & ~start_for_GradientMag_XMC_120_160_1_U0_U.if_read) begin
                            $display("//      Blocked by full output start propagation FIFO 'ModelComposerDesign.start_for_GradientMag_XMC_120_160_1_U0_U' read by process 'ModelComposerDesign.GradientMag_XMC_120_160_1_U0',");
                        end
                    end
                    6: begin
                        if (~SobelFilter_XMC_120_160_1_U0.SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0.SobelFilter_XMC_out1_i_blk_n) begin
                            if (~SobelFilter_XMC_out1_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'ModelComposerDesign.SobelFilter_XMC_out1_U' written by process 'ModelComposerDesign.GradientMag_XMC_120_160_1_U0.GradientMag_XMC_120_160_1_Loop_VITIS_LOOP_93_1_proc9_U0'");
                                $fdisplay(fp, "Dependence_Channel_path ModelComposerDesign.SobelFilter_XMC_out1_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~SobelFilter_XMC_out1_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'ModelComposerDesign.SobelFilter_XMC_out1_U' read by process 'ModelComposerDesign.GradientMag_XMC_120_160_1_U0.GradientMag_XMC_120_160_1_Loop_VITIS_LOOP_93_1_proc9_U0'");
                                $fdisplay(fp, "Dependence_Channel_path ModelComposerDesign.SobelFilter_XMC_out1_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~SobelFilter_XMC_120_160_1_U0.SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0.SobelFilter_XMC_out2_i_blk_n) begin
                            if (~SobelFilter_XMC_out2_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'ModelComposerDesign.SobelFilter_XMC_out2_U' written by process 'ModelComposerDesign.GradientMag_XMC_120_160_1_U0.GradientMag_XMC_120_160_1_Loop_VITIS_LOOP_93_1_proc9_U0'");
                                $fdisplay(fp, "Dependence_Channel_path ModelComposerDesign.SobelFilter_XMC_out2_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~SobelFilter_XMC_out2_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'ModelComposerDesign.SobelFilter_XMC_out2_U' read by process 'ModelComposerDesign.GradientMag_XMC_120_160_1_U0.GradientMag_XMC_120_160_1_Loop_VITIS_LOOP_93_1_proc9_U0'");
                                $fdisplay(fp, "Dependence_Channel_path ModelComposerDesign.SobelFilter_XMC_out2_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    endcase
                end
                2 : begin
                    case(index2)
                    0: begin
                        if (~SobelFilter_XMC_120_160_1_U0.SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_94_1_proc7_U0.Image_in_adapter_out1_blk_n) begin
                            if (~Image_in_adapter_out1_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'ModelComposerDesign.Image_in_adapter_out1_U' written by process 'ModelComposerDesign.readStream_unsigned_char_U0'");
                                $fdisplay(fp, "Dependence_Channel_path ModelComposerDesign.Image_in_adapter_out1_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~Image_in_adapter_out1_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'ModelComposerDesign.Image_in_adapter_out1_U' read by process 'ModelComposerDesign.readStream_unsigned_char_U0'");
                                $fdisplay(fp, "Dependence_Channel_path ModelComposerDesign.Image_in_adapter_out1_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    3: begin
                        if (~SobelFilter_XMC_120_160_1_U0.SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_94_1_proc7_U0.src_obj_data_blk_n) begin
                            if (~SobelFilter_XMC_120_160_1_U0.src_obj_data_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'ModelComposerDesign.SobelFilter_XMC_120_160_1_U0.src_obj_data_U' written by process 'ModelComposerDesign.SobelFilter_XMC_120_160_1_U0.Sobel_0_3_0_2_120_160_1_false_U0'");
                                $fdisplay(fp, "Dependence_Channel_path ModelComposerDesign.SobelFilter_XMC_120_160_1_U0.src_obj_data_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~SobelFilter_XMC_120_160_1_U0.src_obj_data_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'ModelComposerDesign.SobelFilter_XMC_120_160_1_U0.src_obj_data_U' read by process 'ModelComposerDesign.SobelFilter_XMC_120_160_1_U0.Sobel_0_3_0_2_120_160_1_false_U0'");
                                $fdisplay(fp, "Dependence_Channel_path ModelComposerDesign.SobelFilter_XMC_120_160_1_U0.src_obj_data_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~SobelFilter_XMC_120_160_1_U0.start_for_Sobel_0_3_0_2_120_160_1_false_U0_U.if_full_n & SobelFilter_XMC_120_160_1_U0.SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_94_1_proc7_U0.ap_start & ~SobelFilter_XMC_120_160_1_U0.SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_94_1_proc7_U0.real_start & (trans_in_cnt_1 == trans_out_cnt_1) & ~SobelFilter_XMC_120_160_1_U0.start_for_Sobel_0_3_0_2_120_160_1_false_U0_U.if_read) begin
                            $display("//      Blocked by full output start propagation FIFO 'ModelComposerDesign.SobelFilter_XMC_120_160_1_U0.start_for_Sobel_0_3_0_2_120_160_1_false_U0_U' read by process 'ModelComposerDesign.SobelFilter_XMC_120_160_1_U0.Sobel_0_3_0_2_120_160_1_false_U0',");
                        end
                    end
                    endcase
                end
                3 : begin
                    case(index2)
                    2: begin
                        if (~SobelFilter_XMC_120_160_1_U0.Sobel_0_3_0_2_120_160_1_false_U0.grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_s_fu_16.grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144.src_obj_456_blk_n) begin
                            if (~SobelFilter_XMC_120_160_1_U0.src_obj_data_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'ModelComposerDesign.SobelFilter_XMC_120_160_1_U0.src_obj_data_U' written by process 'ModelComposerDesign.SobelFilter_XMC_120_160_1_U0.SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_94_1_proc7_U0'");
                                $fdisplay(fp, "Dependence_Channel_path ModelComposerDesign.SobelFilter_XMC_120_160_1_U0.src_obj_data_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~SobelFilter_XMC_120_160_1_U0.src_obj_data_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'ModelComposerDesign.SobelFilter_XMC_120_160_1_U0.src_obj_data_U' read by process 'ModelComposerDesign.SobelFilter_XMC_120_160_1_U0.SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_94_1_proc7_U0'");
                                $fdisplay(fp, "Dependence_Channel_path ModelComposerDesign.SobelFilter_XMC_120_160_1_U0.src_obj_data_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    4: begin
                        if (~SobelFilter_XMC_120_160_1_U0.Sobel_0_3_0_2_120_160_1_false_U0.grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_s_fu_16.grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144.dstx_obj_457_blk_n) begin
                            if (~SobelFilter_XMC_120_160_1_U0.dstx_obj_data_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'ModelComposerDesign.SobelFilter_XMC_120_160_1_U0.dstx_obj_data_U' written by process 'ModelComposerDesign.SobelFilter_XMC_120_160_1_U0.SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0'");
                                $fdisplay(fp, "Dependence_Channel_path ModelComposerDesign.SobelFilter_XMC_120_160_1_U0.dstx_obj_data_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~SobelFilter_XMC_120_160_1_U0.dstx_obj_data_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'ModelComposerDesign.SobelFilter_XMC_120_160_1_U0.dstx_obj_data_U' read by process 'ModelComposerDesign.SobelFilter_XMC_120_160_1_U0.SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0'");
                                $fdisplay(fp, "Dependence_Channel_path ModelComposerDesign.SobelFilter_XMC_120_160_1_U0.dstx_obj_data_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~SobelFilter_XMC_120_160_1_U0.start_for_SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0_U.if_full_n & SobelFilter_XMC_120_160_1_U0.Sobel_0_3_0_2_120_160_1_false_U0.ap_start & ~SobelFilter_XMC_120_160_1_U0.Sobel_0_3_0_2_120_160_1_false_U0.real_start & (trans_in_cnt_2 == trans_out_cnt_2) & ~SobelFilter_XMC_120_160_1_U0.start_for_SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0_U.if_read) begin
                            $display("//      Blocked by full output start propagation FIFO 'ModelComposerDesign.SobelFilter_XMC_120_160_1_U0.dsty_obj_data_U' read by process 'ModelComposerDesign.SobelFilter_XMC_120_160_1_U0.SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0',");
                        end
                    end
                    endcase
                end
                4 : begin
                    case(index2)
                    3: begin
                        if (~SobelFilter_XMC_120_160_1_U0.SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0.dstx_obj_data_blk_n) begin
                            if (~SobelFilter_XMC_120_160_1_U0.dstx_obj_data_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'ModelComposerDesign.SobelFilter_XMC_120_160_1_U0.dstx_obj_data_U' written by process 'ModelComposerDesign.SobelFilter_XMC_120_160_1_U0.Sobel_0_3_0_2_120_160_1_false_U0'");
                                $fdisplay(fp, "Dependence_Channel_path ModelComposerDesign.SobelFilter_XMC_120_160_1_U0.dstx_obj_data_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~SobelFilter_XMC_120_160_1_U0.dstx_obj_data_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'ModelComposerDesign.SobelFilter_XMC_120_160_1_U0.dstx_obj_data_U' read by process 'ModelComposerDesign.SobelFilter_XMC_120_160_1_U0.Sobel_0_3_0_2_120_160_1_false_U0'");
                                $fdisplay(fp, "Dependence_Channel_path ModelComposerDesign.SobelFilter_XMC_120_160_1_U0.dstx_obj_data_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~SobelFilter_XMC_120_160_1_U0.SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0.dsty_obj_data_blk_n) begin
                            if (~SobelFilter_XMC_120_160_1_U0.dsty_obj_data_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'ModelComposerDesign.SobelFilter_XMC_120_160_1_U0.dsty_obj_data_U' written by process 'ModelComposerDesign.SobelFilter_XMC_120_160_1_U0.Sobel_0_3_0_2_120_160_1_false_U0'");
                                $fdisplay(fp, "Dependence_Channel_path ModelComposerDesign.SobelFilter_XMC_120_160_1_U0.dsty_obj_data_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~SobelFilter_XMC_120_160_1_U0.dsty_obj_data_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'ModelComposerDesign.SobelFilter_XMC_120_160_1_U0.dsty_obj_data_U' read by process 'ModelComposerDesign.SobelFilter_XMC_120_160_1_U0.Sobel_0_3_0_2_120_160_1_false_U0'");
                                $fdisplay(fp, "Dependence_Channel_path ModelComposerDesign.SobelFilter_XMC_120_160_1_U0.dsty_obj_data_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~SobelFilter_XMC_120_160_1_U0.start_for_SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0_U.if_empty_n & SobelFilter_XMC_120_160_1_U0.SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0.ap_idle & ~SobelFilter_XMC_120_160_1_U0.start_for_SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0_U.if_write) begin
                            $display("//      Blocked by missing 'ap_start' from start propagation FIFO 'ModelComposerDesign.SobelFilter_XMC_120_160_1_U0.start_for_SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0_U' written by process 'ModelComposerDesign.SobelFilter_XMC_120_160_1_U0.Sobel_0_3_0_2_120_160_1_false_U0',");
                        end
                    end
                    5: begin
                        if (~SobelFilter_XMC_120_160_1_U0.SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0.SobelFilter_XMC_out1_i_blk_n) begin
                            if (~SobelFilter_XMC_out1_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'ModelComposerDesign.SobelFilter_XMC_out1_U' written by process 'ModelComposerDesign.GradientMag_XMC_120_160_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path ModelComposerDesign.SobelFilter_XMC_out1_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~SobelFilter_XMC_out1_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'ModelComposerDesign.SobelFilter_XMC_out1_U' read by process 'ModelComposerDesign.GradientMag_XMC_120_160_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path ModelComposerDesign.SobelFilter_XMC_out1_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~SobelFilter_XMC_120_160_1_U0.SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0.SobelFilter_XMC_out2_i_blk_n) begin
                            if (~SobelFilter_XMC_out2_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'ModelComposerDesign.SobelFilter_XMC_out2_U' written by process 'ModelComposerDesign.GradientMag_XMC_120_160_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path ModelComposerDesign.SobelFilter_XMC_out2_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~SobelFilter_XMC_out2_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'ModelComposerDesign.SobelFilter_XMC_out2_U' read by process 'ModelComposerDesign.GradientMag_XMC_120_160_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path ModelComposerDesign.SobelFilter_XMC_out2_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    6: begin
                        if (~SobelFilter_XMC_120_160_1_U0.SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0.SobelFilter_XMC_out1_i_blk_n) begin
                            if (~SobelFilter_XMC_out1_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'ModelComposerDesign.SobelFilter_XMC_out1_U' written by process 'ModelComposerDesign.GradientMag_XMC_120_160_1_U0.GradientMag_XMC_120_160_1_Loop_VITIS_LOOP_93_1_proc9_U0'");
                                $fdisplay(fp, "Dependence_Channel_path ModelComposerDesign.SobelFilter_XMC_out1_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~SobelFilter_XMC_out1_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'ModelComposerDesign.SobelFilter_XMC_out1_U' read by process 'ModelComposerDesign.GradientMag_XMC_120_160_1_U0.GradientMag_XMC_120_160_1_Loop_VITIS_LOOP_93_1_proc9_U0'");
                                $fdisplay(fp, "Dependence_Channel_path ModelComposerDesign.SobelFilter_XMC_out1_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~SobelFilter_XMC_120_160_1_U0.SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0.SobelFilter_XMC_out2_i_blk_n) begin
                            if (~SobelFilter_XMC_out2_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'ModelComposerDesign.SobelFilter_XMC_out2_U' written by process 'ModelComposerDesign.GradientMag_XMC_120_160_1_U0.GradientMag_XMC_120_160_1_Loop_VITIS_LOOP_93_1_proc9_U0'");
                                $fdisplay(fp, "Dependence_Channel_path ModelComposerDesign.SobelFilter_XMC_out2_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~SobelFilter_XMC_out2_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'ModelComposerDesign.SobelFilter_XMC_out2_U' read by process 'ModelComposerDesign.GradientMag_XMC_120_160_1_U0.GradientMag_XMC_120_160_1_Loop_VITIS_LOOP_93_1_proc9_U0'");
                                $fdisplay(fp, "Dependence_Channel_path ModelComposerDesign.SobelFilter_XMC_out2_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    endcase
                end
                5 : begin
                    case(index2)
                    1: begin
                        if (~GradientMag_XMC_120_160_1_U0.GradientMag_XMC_120_160_1_Loop_VITIS_LOOP_93_1_proc9_U0.SobelFilter_XMC_out1_i_blk_n) begin
                            if (~SobelFilter_XMC_out1_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'ModelComposerDesign.SobelFilter_XMC_out1_U' written by process 'ModelComposerDesign.SobelFilter_XMC_120_160_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path ModelComposerDesign.SobelFilter_XMC_out1_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~SobelFilter_XMC_out1_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'ModelComposerDesign.SobelFilter_XMC_out1_U' read by process 'ModelComposerDesign.SobelFilter_XMC_120_160_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path ModelComposerDesign.SobelFilter_XMC_out1_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~GradientMag_XMC_120_160_1_U0.GradientMag_XMC_120_160_1_Loop_VITIS_LOOP_93_1_proc9_U0.SobelFilter_XMC_out2_i_blk_n) begin
                            if (~SobelFilter_XMC_out2_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'ModelComposerDesign.SobelFilter_XMC_out2_U' written by process 'ModelComposerDesign.SobelFilter_XMC_120_160_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path ModelComposerDesign.SobelFilter_XMC_out2_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~SobelFilter_XMC_out2_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'ModelComposerDesign.SobelFilter_XMC_out2_U' read by process 'ModelComposerDesign.SobelFilter_XMC_120_160_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path ModelComposerDesign.SobelFilter_XMC_out2_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~start_for_GradientMag_XMC_120_160_1_U0_U.if_empty_n & GradientMag_XMC_120_160_1_U0.ap_idle & ~start_for_GradientMag_XMC_120_160_1_U0_U.if_write) begin
                            $display("//      Blocked by missing 'ap_start' from start propagation FIFO 'ModelComposerDesign.start_for_GradientMag_XMC_120_160_1_U0_U' written by process 'ModelComposerDesign.SobelFilter_XMC_120_160_1_U0',");
                        end
                    end
                    4: begin
                        if (~GradientMag_XMC_120_160_1_U0.GradientMag_XMC_120_160_1_Loop_VITIS_LOOP_93_1_proc9_U0.SobelFilter_XMC_out1_i_blk_n) begin
                            if (~SobelFilter_XMC_out1_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'ModelComposerDesign.SobelFilter_XMC_out1_U' written by process 'ModelComposerDesign.SobelFilter_XMC_120_160_1_U0.SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0'");
                                $fdisplay(fp, "Dependence_Channel_path ModelComposerDesign.SobelFilter_XMC_out1_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~SobelFilter_XMC_out1_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'ModelComposerDesign.SobelFilter_XMC_out1_U' read by process 'ModelComposerDesign.SobelFilter_XMC_120_160_1_U0.SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0'");
                                $fdisplay(fp, "Dependence_Channel_path ModelComposerDesign.SobelFilter_XMC_out1_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~GradientMag_XMC_120_160_1_U0.GradientMag_XMC_120_160_1_Loop_VITIS_LOOP_93_1_proc9_U0.SobelFilter_XMC_out2_i_blk_n) begin
                            if (~SobelFilter_XMC_out2_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'ModelComposerDesign.SobelFilter_XMC_out2_U' written by process 'ModelComposerDesign.SobelFilter_XMC_120_160_1_U0.SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0'");
                                $fdisplay(fp, "Dependence_Channel_path ModelComposerDesign.SobelFilter_XMC_out2_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~SobelFilter_XMC_out2_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'ModelComposerDesign.SobelFilter_XMC_out2_U' read by process 'ModelComposerDesign.SobelFilter_XMC_120_160_1_U0.SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0'");
                                $fdisplay(fp, "Dependence_Channel_path ModelComposerDesign.SobelFilter_XMC_out2_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    9: begin
                        if (~GradientMag_XMC_120_160_1_U0.GradientMag_XMC_120_160_1_Loop_VITIS_LOOP_106_3_proc10_U0.GradientMag_XMC_out1_i_blk_n) begin
                            if (~GradientMag_XMC_out1_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'ModelComposerDesign.GradientMag_XMC_out1_U' written by process 'ModelComposerDesign.p31_U0'");
                                $fdisplay(fp, "Dependence_Channel_path ModelComposerDesign.GradientMag_XMC_out1_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~GradientMag_XMC_out1_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'ModelComposerDesign.GradientMag_XMC_out1_U' read by process 'ModelComposerDesign.p31_U0'");
                                $fdisplay(fp, "Dependence_Channel_path ModelComposerDesign.GradientMag_XMC_out1_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~start_for_p31_U0_U.if_full_n & GradientMag_XMC_120_160_1_U0.ap_start & ~GradientMag_XMC_120_160_1_U0.real_start & (trans_in_cnt_6 == trans_out_cnt_6) & ~start_for_p31_U0_U.if_read) begin
                            $display("//      Blocked by full output start propagation FIFO 'ModelComposerDesign.start_for_p31_U0_U' read by process 'ModelComposerDesign.p31_U0',");
                        end
                    end
                    endcase
                end
                6 : begin
                    case(index2)
                    1: begin
                        if (~GradientMag_XMC_120_160_1_U0.GradientMag_XMC_120_160_1_Loop_VITIS_LOOP_93_1_proc9_U0.SobelFilter_XMC_out1_i_blk_n) begin
                            if (~SobelFilter_XMC_out1_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'ModelComposerDesign.SobelFilter_XMC_out1_U' written by process 'ModelComposerDesign.SobelFilter_XMC_120_160_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path ModelComposerDesign.SobelFilter_XMC_out1_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~SobelFilter_XMC_out1_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'ModelComposerDesign.SobelFilter_XMC_out1_U' read by process 'ModelComposerDesign.SobelFilter_XMC_120_160_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path ModelComposerDesign.SobelFilter_XMC_out1_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~GradientMag_XMC_120_160_1_U0.GradientMag_XMC_120_160_1_Loop_VITIS_LOOP_93_1_proc9_U0.SobelFilter_XMC_out2_i_blk_n) begin
                            if (~SobelFilter_XMC_out2_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'ModelComposerDesign.SobelFilter_XMC_out2_U' written by process 'ModelComposerDesign.SobelFilter_XMC_120_160_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path ModelComposerDesign.SobelFilter_XMC_out2_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~SobelFilter_XMC_out2_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'ModelComposerDesign.SobelFilter_XMC_out2_U' read by process 'ModelComposerDesign.SobelFilter_XMC_120_160_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path ModelComposerDesign.SobelFilter_XMC_out2_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    4: begin
                        if (~GradientMag_XMC_120_160_1_U0.GradientMag_XMC_120_160_1_Loop_VITIS_LOOP_93_1_proc9_U0.SobelFilter_XMC_out1_i_blk_n) begin
                            if (~SobelFilter_XMC_out1_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'ModelComposerDesign.SobelFilter_XMC_out1_U' written by process 'ModelComposerDesign.SobelFilter_XMC_120_160_1_U0.SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0'");
                                $fdisplay(fp, "Dependence_Channel_path ModelComposerDesign.SobelFilter_XMC_out1_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~SobelFilter_XMC_out1_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'ModelComposerDesign.SobelFilter_XMC_out1_U' read by process 'ModelComposerDesign.SobelFilter_XMC_120_160_1_U0.SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0'");
                                $fdisplay(fp, "Dependence_Channel_path ModelComposerDesign.SobelFilter_XMC_out1_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~GradientMag_XMC_120_160_1_U0.GradientMag_XMC_120_160_1_Loop_VITIS_LOOP_93_1_proc9_U0.SobelFilter_XMC_out2_i_blk_n) begin
                            if (~SobelFilter_XMC_out2_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'ModelComposerDesign.SobelFilter_XMC_out2_U' written by process 'ModelComposerDesign.SobelFilter_XMC_120_160_1_U0.SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0'");
                                $fdisplay(fp, "Dependence_Channel_path ModelComposerDesign.SobelFilter_XMC_out2_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~SobelFilter_XMC_out2_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'ModelComposerDesign.SobelFilter_XMC_out2_U' read by process 'ModelComposerDesign.SobelFilter_XMC_120_160_1_U0.SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0'");
                                $fdisplay(fp, "Dependence_Channel_path ModelComposerDesign.SobelFilter_XMC_out2_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    7: begin
                        if (~GradientMag_XMC_120_160_1_U0.GradientMag_XMC_120_160_1_Loop_VITIS_LOOP_93_1_proc9_U0.srcX_obj_data_blk_n) begin
                            if (~GradientMag_XMC_120_160_1_U0.srcX_obj_data_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'ModelComposerDesign.GradientMag_XMC_120_160_1_U0.srcX_obj_data_U' written by process 'ModelComposerDesign.GradientMag_XMC_120_160_1_U0.xFMagnitudeKernel_2_2_120_160_3_3_1_5_5_160_2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path ModelComposerDesign.GradientMag_XMC_120_160_1_U0.srcX_obj_data_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~GradientMag_XMC_120_160_1_U0.srcX_obj_data_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'ModelComposerDesign.GradientMag_XMC_120_160_1_U0.srcX_obj_data_U' read by process 'ModelComposerDesign.GradientMag_XMC_120_160_1_U0.xFMagnitudeKernel_2_2_120_160_3_3_1_5_5_160_2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path ModelComposerDesign.GradientMag_XMC_120_160_1_U0.srcX_obj_data_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~GradientMag_XMC_120_160_1_U0.GradientMag_XMC_120_160_1_Loop_VITIS_LOOP_93_1_proc9_U0.srcY_obj_data_blk_n) begin
                            if (~GradientMag_XMC_120_160_1_U0.srcY_obj_data_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'ModelComposerDesign.GradientMag_XMC_120_160_1_U0.srcY_obj_data_U' written by process 'ModelComposerDesign.GradientMag_XMC_120_160_1_U0.xFMagnitudeKernel_2_2_120_160_3_3_1_5_5_160_2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path ModelComposerDesign.GradientMag_XMC_120_160_1_U0.srcY_obj_data_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~GradientMag_XMC_120_160_1_U0.srcY_obj_data_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'ModelComposerDesign.GradientMag_XMC_120_160_1_U0.srcY_obj_data_U' read by process 'ModelComposerDesign.GradientMag_XMC_120_160_1_U0.xFMagnitudeKernel_2_2_120_160_3_3_1_5_5_160_2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path ModelComposerDesign.GradientMag_XMC_120_160_1_U0.srcY_obj_data_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~GradientMag_XMC_120_160_1_U0.start_for_xFMagnitudeKernel_2_2_120_160_3_3_1_5_5_160_2_U0_U.if_full_n & GradientMag_XMC_120_160_1_U0.GradientMag_XMC_120_160_1_Loop_VITIS_LOOP_93_1_proc9_U0.ap_start & ~GradientMag_XMC_120_160_1_U0.GradientMag_XMC_120_160_1_Loop_VITIS_LOOP_93_1_proc9_U0.real_start & (trans_in_cnt_4 == trans_out_cnt_4) & ~GradientMag_XMC_120_160_1_U0.start_for_xFMagnitudeKernel_2_2_120_160_3_3_1_5_5_160_2_U0_U.if_read) begin
                            $display("//      Blocked by full output start propagation FIFO 'ModelComposerDesign.GradientMag_XMC_120_160_1_U0.start_for_xFMagnitudeKernel_2_2_120_160_3_3_1_5_5_160_2_U0_U' read by process 'ModelComposerDesign.GradientMag_XMC_120_160_1_U0.xFMagnitudeKernel_2_2_120_160_3_3_1_5_5_160_2_U0',");
                        end
                    end
                    endcase
                end
                7 : begin
                    case(index2)
                    6: begin
                        if (~GradientMag_XMC_120_160_1_U0.xFMagnitudeKernel_2_2_120_160_3_3_1_5_5_160_2_U0.grp_xFMagnitudeKernel_2_2_120_160_3_3_1_5_5_160_2_Pipeline_colLoop_fu_38.srcX_obj_449_blk_n) begin
                            if (~GradientMag_XMC_120_160_1_U0.srcX_obj_data_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'ModelComposerDesign.GradientMag_XMC_120_160_1_U0.srcX_obj_data_U' written by process 'ModelComposerDesign.GradientMag_XMC_120_160_1_U0.GradientMag_XMC_120_160_1_Loop_VITIS_LOOP_93_1_proc9_U0'");
                                $fdisplay(fp, "Dependence_Channel_path ModelComposerDesign.GradientMag_XMC_120_160_1_U0.srcX_obj_data_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~GradientMag_XMC_120_160_1_U0.srcX_obj_data_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'ModelComposerDesign.GradientMag_XMC_120_160_1_U0.srcX_obj_data_U' read by process 'ModelComposerDesign.GradientMag_XMC_120_160_1_U0.GradientMag_XMC_120_160_1_Loop_VITIS_LOOP_93_1_proc9_U0'");
                                $fdisplay(fp, "Dependence_Channel_path ModelComposerDesign.GradientMag_XMC_120_160_1_U0.srcX_obj_data_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~GradientMag_XMC_120_160_1_U0.xFMagnitudeKernel_2_2_120_160_3_3_1_5_5_160_2_U0.grp_xFMagnitudeKernel_2_2_120_160_3_3_1_5_5_160_2_Pipeline_colLoop_fu_38.srcY_obj_450_blk_n) begin
                            if (~GradientMag_XMC_120_160_1_U0.srcY_obj_data_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'ModelComposerDesign.GradientMag_XMC_120_160_1_U0.srcY_obj_data_U' written by process 'ModelComposerDesign.GradientMag_XMC_120_160_1_U0.GradientMag_XMC_120_160_1_Loop_VITIS_LOOP_93_1_proc9_U0'");
                                $fdisplay(fp, "Dependence_Channel_path ModelComposerDesign.GradientMag_XMC_120_160_1_U0.srcY_obj_data_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~GradientMag_XMC_120_160_1_U0.srcY_obj_data_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'ModelComposerDesign.GradientMag_XMC_120_160_1_U0.srcY_obj_data_U' read by process 'ModelComposerDesign.GradientMag_XMC_120_160_1_U0.GradientMag_XMC_120_160_1_Loop_VITIS_LOOP_93_1_proc9_U0'");
                                $fdisplay(fp, "Dependence_Channel_path ModelComposerDesign.GradientMag_XMC_120_160_1_U0.srcY_obj_data_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~GradientMag_XMC_120_160_1_U0.start_for_xFMagnitudeKernel_2_2_120_160_3_3_1_5_5_160_2_U0_U.if_empty_n & GradientMag_XMC_120_160_1_U0.xFMagnitudeKernel_2_2_120_160_3_3_1_5_5_160_2_U0.ap_idle & ~GradientMag_XMC_120_160_1_U0.start_for_xFMagnitudeKernel_2_2_120_160_3_3_1_5_5_160_2_U0_U.if_write) begin
                            $display("//      Blocked by missing 'ap_start' from start propagation FIFO 'ModelComposerDesign.GradientMag_XMC_120_160_1_U0.start_for_xFMagnitudeKernel_2_2_120_160_3_3_1_5_5_160_2_U0_U' written by process 'ModelComposerDesign.GradientMag_XMC_120_160_1_U0.GradientMag_XMC_120_160_1_Loop_VITIS_LOOP_93_1_proc9_U0',");
                        end
                    end
                    8: begin
                        if (~GradientMag_XMC_120_160_1_U0.xFMagnitudeKernel_2_2_120_160_3_3_1_5_5_160_2_U0.grp_xFMagnitudeKernel_2_2_120_160_3_3_1_5_5_160_2_Pipeline_colLoop_fu_38.dst_obj_451_blk_n) begin
                            if (~GradientMag_XMC_120_160_1_U0.dst_obj_data_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'ModelComposerDesign.GradientMag_XMC_120_160_1_U0.dst_obj_data_U' written by process 'ModelComposerDesign.GradientMag_XMC_120_160_1_U0.GradientMag_XMC_120_160_1_Loop_VITIS_LOOP_106_3_proc10_U0'");
                                $fdisplay(fp, "Dependence_Channel_path ModelComposerDesign.GradientMag_XMC_120_160_1_U0.dst_obj_data_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~GradientMag_XMC_120_160_1_U0.dst_obj_data_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'ModelComposerDesign.GradientMag_XMC_120_160_1_U0.dst_obj_data_U' read by process 'ModelComposerDesign.GradientMag_XMC_120_160_1_U0.GradientMag_XMC_120_160_1_Loop_VITIS_LOOP_106_3_proc10_U0'");
                                $fdisplay(fp, "Dependence_Channel_path ModelComposerDesign.GradientMag_XMC_120_160_1_U0.dst_obj_data_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~GradientMag_XMC_120_160_1_U0.start_for_GradientMag_XMC_120_160_1_Loop_VITIS_LOOP_106_3_proc10_U0_U.if_full_n & GradientMag_XMC_120_160_1_U0.xFMagnitudeKernel_2_2_120_160_3_3_1_5_5_160_2_U0.ap_start & ~GradientMag_XMC_120_160_1_U0.xFMagnitudeKernel_2_2_120_160_3_3_1_5_5_160_2_U0.real_start & (trans_in_cnt_5 == trans_out_cnt_5) & ~GradientMag_XMC_120_160_1_U0.start_for_GradientMag_XMC_120_160_1_Loop_VITIS_LOOP_106_3_proc10_U0_U.if_read) begin
                            $display("//      Blocked by full output start propagation FIFO 'ModelComposerDesign.GradientMag_XMC_120_160_1_U0.start_for_GradientMag_XMC_120_160_1_Loop_VITIS_LOOP_106_3_proc10_U0_U' read by process 'ModelComposerDesign.GradientMag_XMC_120_160_1_U0.GradientMag_XMC_120_160_1_Loop_VITIS_LOOP_106_3_proc10_U0',");
                        end
                    end
                    endcase
                end
                8 : begin
                    case(index2)
                    7: begin
                        if (~GradientMag_XMC_120_160_1_U0.GradientMag_XMC_120_160_1_Loop_VITIS_LOOP_106_3_proc10_U0.dst_obj_data_blk_n) begin
                            if (~GradientMag_XMC_120_160_1_U0.dst_obj_data_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'ModelComposerDesign.GradientMag_XMC_120_160_1_U0.dst_obj_data_U' written by process 'ModelComposerDesign.GradientMag_XMC_120_160_1_U0.xFMagnitudeKernel_2_2_120_160_3_3_1_5_5_160_2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path ModelComposerDesign.GradientMag_XMC_120_160_1_U0.dst_obj_data_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~GradientMag_XMC_120_160_1_U0.dst_obj_data_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'ModelComposerDesign.GradientMag_XMC_120_160_1_U0.dst_obj_data_U' read by process 'ModelComposerDesign.GradientMag_XMC_120_160_1_U0.xFMagnitudeKernel_2_2_120_160_3_3_1_5_5_160_2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path ModelComposerDesign.GradientMag_XMC_120_160_1_U0.dst_obj_data_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~GradientMag_XMC_120_160_1_U0.start_for_GradientMag_XMC_120_160_1_Loop_VITIS_LOOP_106_3_proc10_U0_U.if_empty_n & GradientMag_XMC_120_160_1_U0.GradientMag_XMC_120_160_1_Loop_VITIS_LOOP_106_3_proc10_U0.ap_idle & ~GradientMag_XMC_120_160_1_U0.start_for_GradientMag_XMC_120_160_1_Loop_VITIS_LOOP_106_3_proc10_U0_U.if_write) begin
                            $display("//      Blocked by missing 'ap_start' from start propagation FIFO 'ModelComposerDesign.GradientMag_XMC_120_160_1_U0.start_for_GradientMag_XMC_120_160_1_Loop_VITIS_LOOP_106_3_proc10_U0_U' written by process 'ModelComposerDesign.GradientMag_XMC_120_160_1_U0.xFMagnitudeKernel_2_2_120_160_3_3_1_5_5_160_2_U0',");
                        end
                    end
                    9: begin
                        if (~GradientMag_XMC_120_160_1_U0.GradientMag_XMC_120_160_1_Loop_VITIS_LOOP_106_3_proc10_U0.GradientMag_XMC_out1_i_blk_n) begin
                            if (~GradientMag_XMC_out1_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'ModelComposerDesign.GradientMag_XMC_out1_U' written by process 'ModelComposerDesign.p31_U0'");
                                $fdisplay(fp, "Dependence_Channel_path ModelComposerDesign.GradientMag_XMC_out1_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~GradientMag_XMC_out1_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'ModelComposerDesign.GradientMag_XMC_out1_U' read by process 'ModelComposerDesign.p31_U0'");
                                $fdisplay(fp, "Dependence_Channel_path ModelComposerDesign.GradientMag_XMC_out1_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    endcase
                end
                9 : begin
                    case(index2)
                    5: begin
                        if (~p31_U0.GradientMag_XMC_out1_i_blk_n) begin
                            if (~GradientMag_XMC_out1_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'ModelComposerDesign.GradientMag_XMC_out1_U' written by process 'ModelComposerDesign.GradientMag_XMC_120_160_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path ModelComposerDesign.GradientMag_XMC_out1_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~GradientMag_XMC_out1_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'ModelComposerDesign.GradientMag_XMC_out1_U' read by process 'ModelComposerDesign.GradientMag_XMC_120_160_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path ModelComposerDesign.GradientMag_XMC_out1_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~start_for_p31_U0_U.if_empty_n & p31_U0.ap_idle & ~start_for_p31_U0_U.if_write) begin
                            $display("//      Blocked by missing 'ap_start' from start propagation FIFO 'ModelComposerDesign.start_for_p31_U0_U' written by process 'ModelComposerDesign.GradientMag_XMC_120_160_1_U0',");
                        end
                    end
                    8: begin
                        if (~p31_U0.GradientMag_XMC_out1_i_blk_n) begin
                            if (~GradientMag_XMC_out1_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'ModelComposerDesign.GradientMag_XMC_out1_U' written by process 'ModelComposerDesign.GradientMag_XMC_120_160_1_U0.GradientMag_XMC_120_160_1_Loop_VITIS_LOOP_106_3_proc10_U0'");
                                $fdisplay(fp, "Dependence_Channel_path ModelComposerDesign.GradientMag_XMC_out1_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~GradientMag_XMC_out1_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'ModelComposerDesign.GradientMag_XMC_out1_U' read by process 'ModelComposerDesign.GradientMag_XMC_120_160_1_U0.GradientMag_XMC_120_160_1_Loop_VITIS_LOOP_106_3_proc10_U0'");
                                $fdisplay(fp, "Dependence_Channel_path ModelComposerDesign.GradientMag_XMC_out1_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    10: begin
                        if (~p31_U0.ModelComposerDesign_core_Edge_out_blk_n) begin
                            if (~ModelComposerDesign_core_Edge_out_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'ModelComposerDesign.ModelComposerDesign_core_Edge_out_U' written by process 'ModelComposerDesign.writeStream_bool_U0'");
                                $fdisplay(fp, "Dependence_Channel_path ModelComposerDesign.ModelComposerDesign_core_Edge_out_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~ModelComposerDesign_core_Edge_out_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'ModelComposerDesign.ModelComposerDesign_core_Edge_out_U' read by process 'ModelComposerDesign.writeStream_bool_U0'");
                                $fdisplay(fp, "Dependence_Channel_path ModelComposerDesign.ModelComposerDesign_core_Edge_out_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~start_for_writeStream_bool_U0_U.if_full_n & p31_U0.ap_start & ~p31_U0.real_start & (trans_in_cnt_7 == trans_out_cnt_7) & ~start_for_writeStream_bool_U0_U.if_read) begin
                            $display("//      Blocked by full output start propagation FIFO 'ModelComposerDesign.start_for_writeStream_bool_U0_U' read by process 'ModelComposerDesign.writeStream_bool_U0',");
                        end
                    end
                    endcase
                end
                10 : begin
                    case(index2)
                    9: begin
                        if (~writeStream_bool_U0.ModelComposerDesign_core_Edge_out_blk_n) begin
                            if (~ModelComposerDesign_core_Edge_out_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'ModelComposerDesign.ModelComposerDesign_core_Edge_out_U' written by process 'ModelComposerDesign.p31_U0'");
                                $fdisplay(fp, "Dependence_Channel_path ModelComposerDesign.ModelComposerDesign_core_Edge_out_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~ModelComposerDesign_core_Edge_out_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'ModelComposerDesign.ModelComposerDesign_core_Edge_out_U' read by process 'ModelComposerDesign.p31_U0'");
                                $fdisplay(fp, "Dependence_Channel_path ModelComposerDesign.ModelComposerDesign_core_Edge_out_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~start_for_writeStream_bool_U0_U.if_empty_n & writeStream_bool_U0.ap_idle & ~start_for_writeStream_bool_U0_U.if_write) begin
                            $display("//      Blocked by missing 'ap_start' from start propagation FIFO 'ModelComposerDesign.start_for_writeStream_bool_U0_U' written by process 'ModelComposerDesign.p31_U0',");
                        end
                    end
                    endcase
                end
            endcase
        end
    endtask

    // report
    initial begin : report_deadlock
        integer cycle_id;
        integer cycle_comp_id;
        integer record_time;
        wait (dl_reset == 1);
        cycle_id = 1;
        record_time = 0;
        while (1) begin
            @ (negedge dl_clock);
            case (CS_fsm)
                ST_DL_DETECTED: begin
                    cycle_comp_id = 2;
                    if (dl_detect_reg != dl_done_reg) begin
                        if (dl_done_reg == 'b0) begin
                            print_dl_head;
                            record_time = $time;
                        end
                        print_cycle_start(proc_path(origin), cycle_id);
                        cycle_id = cycle_id + 1;
                    end
                    else begin
                        print_dl_end((cycle_id - 1),record_time);
                        @(negedge dl_clock);
                        @(negedge dl_clock);
                        $finish;
                    end
                end
                ST_DL_REPORT: begin
                    if ((|(dl_in_vec)) & ~(|(dl_in_vec & origin_reg))) begin
                        print_cycle_chan_comp(dl_in_vec_reg, dl_in_vec);
                        print_cycle_proc_comp(proc_path(dl_in_vec), cycle_comp_id);
                        cycle_comp_id = cycle_comp_id + 1;
                    end
                    else begin
                        print_cycle_chan_comp(dl_in_vec_reg, dl_in_vec);
                    end
                end
            endcase
        end
    end
 
