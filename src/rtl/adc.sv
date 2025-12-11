`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2025 06:33:33 PM
// Design Name: 
// Module Name: adc
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


//INSPIRED BY PATRICK ZHU
module adc(
    input logic clk,
    input logic reset,
    input logic VP,
    input logic VN,
    output logic [6:0] pot_out
    );

    logic [6:0] daddr_in;
    logic [15:0] do_out;
    logic drdy_out;

    assign daddr_in = 7'd3;
    
    xadc_wiz_0 xadc_inst (
        .daddr_in(daddr_in),
        .den_in(1'd1),
        .di_in(16'd0),
        .do_out(do_out),
        .drdy_out(drdy_out),
        .dwe_in(1'd0),
        .vn_in(VN),
        .vp_in(VP),
        .dclk_in(clk),
        .reset_in(reset)
    );


    always_ff @(posedge clk) begin 
        if (drdy_out) begin 
            pot_out <= do_out[15:9];
        end
    end

    

endmodule

