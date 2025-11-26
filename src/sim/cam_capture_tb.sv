module testbench(); //even though the testbench doesn't create any hardware, it still needs to be a module

	timeunit 10ns;	// This is the amount of time represented by #1 
	timeprecision 1ns;

	logic pclk;
    logic href;
    logic vsync;
    logic [7:0] cam_data;
    logic config_done;
    logic reset;

    logic [9:0] x_coord;
    logic [9:0] y_coord;
    logic [7:0] pixel_data;
			
	cam_capture test(.*);


	initial begin: CLOCK_INITIALIZATION
		pclk = 1;
	end 

	always begin : CLOCK_GENERATION
		#1 pclk = ~pclk;
	end

	initial begin : TEST_VECTORS
       
    
    for (int i = 0; i < 480; i++) begin
        
        repeat (640) @(posedge pclk);
    
    end


  $finish();
end


endmodule


