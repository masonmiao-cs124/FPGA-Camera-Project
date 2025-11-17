`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/15/2025 05:50:30 PM
// Design Name: 
// Module Name: sccb_control
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
        input logic clk,
        

        input logic start_fsm,
        input logic reset,

        inout wire  sda,
        output wire scl
    );

    
    enum logic [10:0] { 
        s_start,
        s_write_7,
        s_write_6,
        s_write_5,
        s_write_4,
        s_write_3,
        s_write_2,
        s_write_1,
        s_write_0,
        ack,
        s_idle
    } curr_state, next_state;

    logic [7:0] reg_addr;
    logic [7:0] reg_data;
    logic [15:0] dout;
    logic [7:0] counter;
   
    assign reg_addr = dout[15:8];
    assign reg_data = dout[7:0];

    always_comb
    begin
        next_state = s_idle;
        
        scl = 0; //when this is 0, the voltage is HIZ, pulled up!
        //sda = 0;, probably cant assign?
        reg_addr = 8'h0;
        reset = 0;

        unique case(curr_state)
            s_start:
            begin
                sda = 0;
            end
            add_1:
            begin
             
            end
            add_2:
            begin
                
            end
        endcase

        case (curr_state)
            s_idle: if (start_fsm) begin
                next_state = s_start;
            end else begin
                next_state = s_idle;
            end
            s_start: if (!sda) begin
                next_state = s_write_7;
            end
            s_ack: if (!sda) begin
                next_state = s_write_0;
            end else begin
                next_state = s_idle;
            end

        endcase
    end

    always_ff @(posedge clk)
    begin
        curr_state <= next_state;
    end

     OV7670_config_rom camera_rom(
        .clk(clk),
        .addr(addr),
        .dout()
    )

endmodule
