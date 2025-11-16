`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/15/2025 05:50:30 PM
// Design Name: 
// Module Name: sccb_master
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module sccb_control(
        //clock!, sda, scl inputs, outputs as well. 
    );

    // Minimal QVGA + YUV422 init ROM for OV7670
    localparam int NUM_REGS = 22;

    logic [15:0] cam_init_rom [0:NUM_REGS-1];

    initial begin
    // {reg_addr, reg_data}
    cam_init_rom[0]  = {8'h12, 8'h80}; // COM7: reset  (WAIT ~1–2 ms after this)
    cam_init_rom[1]  = {8'h12, 8'h14}; // COM7: QVGA + YUV

    cam_init_rom[2]  = {8'h11, 8'h01}; // CLKRC: prescaler
    cam_init_rom[3]  = {8'h0C, 8'h00}; // COM3: no DCW/scale
    cam_init_rom[4]  = {8'h3E, 8'h19}; // COM14: manual scaling, PCLK div
    cam_init_rom[5]  = {8'h8C, 8'h00}; // RGB444: disable

    cam_init_rom[6]  = {8'h17, 8'h16}; // HSTART
    cam_init_rom[7]  = {8'h18, 8'h04}; // HSTOP
    cam_init_rom[8]  = {8'h32, 8'h80}; // HREF

    cam_init_rom[9]  = {8'h19, 8'h02}; // VSTART
    cam_init_rom[10] = {8'h1A, 8'h7A}; // VSTOP
    cam_init_rom[11] = {8'h03, 8'h0A}; // VREF

    cam_init_rom[12] = {8'h70, 8'h3A}; // SCALING_XSC
    cam_init_rom[13] = {8'h71, 8'h35}; // SCALING_YSC
    cam_init_rom[14] = {8'h72, 8'h11}; // DCWCTR: 2x downsample
    cam_init_rom[15] = {8'h73, 8'hF1}; // SCALING_PCLK_DIV
    cam_init_rom[16] = {8'hA2, 8'h02}; // SCALING_PCLK_DELAY

    cam_init_rom[17] = {8'h3A, 8'h04}; // TSLB: YUYV order
    cam_init_rom[18] = {8'h15, 8'h00}; // COM10: normal sync, PCLK not inverted
    cam_init_rom[19] = {8'h3D, 8'h08}; // COM13: UV auto adjust, YUV
    cam_init_rom[20] = {8'h40, 8'hC0}; // COM15: full-range 0–255 YUV

    cam_init_rom[21] = {8'h13, 8'hE7}; // COM8: enable AGC/AWB/AEC
    end

    // // Example of how you'd get addr/data for entry `idx`:
    // logic [$clog2(NUM_REGS)-1:0] idx;
    // logic [7:0] rom_reg_addr, rom_reg_data;

    // always_comb begin
    //     rom_reg_addr = cam_init_rom[idx][15:8];
    //     rom_reg_data = cam_init_rom[idx][7:0];
    // end

    //num stsates needs to be changed
    enum logic [2:0] { 
        s_start,
        s_write_byte_one,
        s_write_byte_two,
        s_write_byte_three,
        s_idle
    } curr_state, next_state;

    always_comb
    begin
        next_state = s_idle;
        
        scl_low = 0; //when this is 0, the voltage is HIZ, pulled up!
        sda_low = 0;


        unique case(curr_state)
            s_start:
            begin
                Shift_En = 1'b0;
                Add_En = 1'b0;
                Clear_Ld_En = 1'b0;
                Subtract_En = 1'b0;
                Clear_After_Run_En = 1'b0;
            end
            add_1:
            begin
                Shift_En = 1'b0;
                Add_En = 1'b1;
                Clear_Ld_En = 1'b0;
                Subtract_En = 1'b0;
                Clear_After_Run_En = 1'b0;
            end
            add_2:
            begin
                Shift_En = 1'b0;
                Add_En = 1'b1;
                Clear_Ld_En = 1'b0;
                Subtract_En = 1'b0;
                Clear_After_Run_En = 1'b0;
            end
        endcase

        case (curr_state)
            s_start: if (E) begin
                    next_state = clear_after_run;
                end
                else if (Reset_LB_ClrA) begin
                    next_state = clear_load;
                end
                else begin
                    next_state = s_start;
                end
            shift_1: if (M) begin
                    next_state = add_2;
                end
                else begin
                    next_state = shift_2;
                end
            shift_2: if (M) begin
                    next_state = add_3;
                end
                else begin
                    next_state = shift_3;
                end     
        endcase
    end

    always_ff @(posedge Clk)
    begin
        curr_state <= next_state;
    end

endmodule
