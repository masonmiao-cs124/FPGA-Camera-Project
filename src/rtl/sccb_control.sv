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
        s_write_7_2,
        s_write_7_3,


        s_write_6,
        s_write_6_2,
        s_write_6_3,
      
      
        s_write_5,
        s_write_5_2,
        s_write_5_3,

        s_write_4,
        s_write_4_2,
        s_write_4_3,

        s_write_3,
        s_write_3_2,
        s_write_3_3,

        s_write_2,
        s_write_2_2,
        s_write_2_3,

        s_write_1,
        s_write_1_2,
        s_write_1_3,

        s_write_0,
        s_write_0_2,
        s_write_0_3,

        ack,
        s_idle
    } curr_state, next_state;

    logic [7:0] reg_addr;
    logic [7:0] reg_data;
    logic [15:0] dout;
    logic [7:0] counter;

    logic addr_or_data; //not doing anything with this rn
    

    assign reg_addr = dout[15:8];
    assign reg_data = dout[7:0];

    always_comb
    begin
        if (reset) begin
        addr_or_data = 0; // sets it to read only the addr
        end
        next_state = s_idle;
        
        scl = 1; 
        //sda = 0;, probably cant assign?
        reg_addr = 8'h0;
        reset = 0;

        unique case(curr_state)
            s_start:
            begin
                sda = 0;
            end
            s_write_7:
            begin
                scl = 0;
                if (~addr_or_data)begin
                sda = reg_addr[7];
                end
                else begin
                sda = reg_data[7];
                end
            end
            s_write_7_2:
            begin
                scl = 1;
            end
            s_write_7_3:
            begin
                scl = 0;
            end

            s_write_6:
            begin
                scl = 0;
                if (~addr_or_data)begin
                sda = reg_addr[6];
                end
                else begin
                sda = reg_data[6];
                end
            end
            s_write_6_2:
            begin
                scl = 1;
            end
            s_write_6_3:
            begin
                scl = 0;
            end

            s_write_5:
            begin
                scl = 0;
                if (~addr_or_data)begin
                sda = reg_addr[5];
                end
                else begin
                sda = reg_data[5];
                end
            end
            s_write_5_2:
            begin
                scl = 1;
            end
            s_write_5_3:
            begin
                scl = 0;
            end


            s_write_4:
            begin
                scl = 0;
                if (~addr_or_data)begin
                sda = reg_addr[4];
                end
                else begin
                sda = reg_data[4];
                end
            end
            s_write_4_2:
            begin
                scl = 1;
            end
            s_write_4_3:
            begin
                scl = 0;
            end


            s_write_3:
            begin
                scl = 0;
                if (~addr_or_data)begin
                sda = reg_addr[3];
                end
                else begin
                sda = reg_data[3];
                end
            end
            s_write_3_2:
            begin
                scl = 1;
            end
            s_write_3_3:
            begin
                scl = 0;
            end


            s_write_2:
            begin
                scl = 0;
                if (~addr_or_data)begin
                sda = reg_addr[2];
                end
                else begin
                sda = reg_data[2];
                end
            end
            s_write_2_2:
            begin
                scl = 1;
            end
            s_write_2_3:
            begin
                scl = 0;
            end


            s_write_1:
            begin
                scl = 0;
                if (~addr_or_data)begin
                sda = reg_addr[1];
                end
                else begin
                sda = reg_data[1];
                end
            end
            s_write_1_2:
            begin
                scl = 1;
            end
            s_write_1_3:
            begin
                scl = 0;
            end

            s_write_0:
            begin
                scl = 0;
                if (~addr_or_data)begin
                sda = reg_addr[0];
                end
                else begin
                sda = reg_data[0];
                end
            end
            s_write_0_2:
            begin
                scl = 1;
            end
            s_write_0_3:
            begin
                scl = 0;
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
            s_write_7: begin
                next_state = s_write_7_2; 
            end
            s_write_7_2: begin
                next_state = s_write_7_3;
            end
            s_write_7_3: begin
                next_state = s_write_6;
            end
            s_write_6: begin
                next_state = s_write_6_2; 
            end
            s_write_6_2: begin
                next_state = s_write_6_3;
            end
            s_write_6_3: begin
                next_state = s_write_5;
            end
            s_write_5: begin
                next_state = s_write_5_2; 
            end
            s_write_5_2: begin
                next_state = s_write_5_3;
            end
            s_write_5_3: begin
                next_state = s_write_4;
            end
            s_write_4: begin
                next_state = s_write_4_2; 
            end
            s_write_4_2: begin
                next_state = s_write_4_3;
            end
            s_write_4_3: begin
                next_state = s_write_3;
            end
            s_write_3: begin
                next_state = s_write_3_2; 
            end
            s_write_3_2: begin
                next_state = s_write_3_3;
            end
            s_write_3_3: begin
                next_state = s_write_2;
            end
            s_write_2: begin
                next_state = s_write_2_2; 
            end
            s_write_2_2: begin
                next_state = s_write_2_3;
            end
            s_write_2_3: begin
                next_state = s_write_1;
            end
            s_write_1: begin
                next_state = s_write_1_2; 
            end
            s_write_1_2: begin
                next_state = s_write_1_3;
            end
            s_write_1_3: begin
                next_state = s_write_0;
            end
            s_write_0: begin
                next_state = s_write_0_2; 
            end
            s_write_0_2: begin
                next_state = s_write_0_3;
            end
            s_write_0_3: begin
                next_state = s_ack;
            end


            s_ack: if (!sda) begin
                addr_or_data = ~addr_or_data;
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
        .dout(dout)
    )

endmodule
