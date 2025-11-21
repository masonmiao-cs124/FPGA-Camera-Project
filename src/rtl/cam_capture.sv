`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/20/2025 05:50:30 PM
// Design Name: 
// Module Name: cam_capture
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


module cam_capture(
        input logic pclk,
        input logic href
        input logic vsync,
        input logic [7:0] cam_data,
        input logic config_done,
        input logic reset,

        output logic [9:0] x_coord,
        output logic [8:0] y_coord,
        output logic [7:0] pixel_data
    );


    enum logic { 
        s_idle,
        s_write
    } curr_state, next_state;

    logic [9:0] x_coord_next;
    logic [8:0] y_coord_next;


   



    always_comb
        begin
        x_coord_next = x_coord;
        y_coord_next = y_coord;


        unique case(curr_state)
            s_idle:

                
            s_write:
                

        endcase

        //STATE TRANSITIONS
        case (curr_state)
           s_idle:
                next_state = (~config_done || ~href) ? s_idle : s_write;
           s_write:
                next_state = href ? s_write : s_idle;
        endcase
    end

    //SEQUENTIAL LOGIC
    always_ff @(posedge clk)
    begin
        if (reset) begin 
            curr_state <= s_idle;
        end else begin
            curr_state <= next_state;
        end
    end

endmodule
