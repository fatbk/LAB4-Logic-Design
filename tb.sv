`timescale 1ns / 1ps

module ChipInterface_tb;

// Inputs
reg CLK_50;
reg [3:0] SW;
reg [1:0] KEY;

// Outputs
wire [6:0] HEX5, HEX4, HEX3, HEX2, HEX1, HEX0;

// Instantiate the module under test
ChipInterface dut (
    .CLOCK_50(CLK_50),
    .SW(SW),
    .KEY(KEY),
    .HEX5(HEX5),
    .HEX4(HEX4),
    .HEX3(HEX3),
    .HEX2(HEX2),
    .HEX1(HEX1),
    .HEX0(HEX0)
);

initial begin
    // Initialize inputs
	#0    CLK_50 = 0;
	forever #10 CLK_50 = ~CLK_50;
	end
// Test stimulus
initial begin
	#100; //11
	     SW = 4'b0000;
   	   KEY[1] = 1;
      	KEY[0] =1;
//13
        #100; 
        SW = 4'b0001;
        KEY[0] = 1; 
	
       #10 KEY[0]=0;
      #40 KEY[0]=1;
      #10
	SW =4'b0011;	
	 KEY[0]=0;
      #20 KEY[0]=1;
      
    #100; // -

    SW = 4'b1011;
    KEY[0] = 0;
	#30 ;
	KEY[0]=1;
	
	

//11	
        #100; 
        SW = 4'b0001;
        KEY[0] = 1; 
	
       #10 KEY[0]=0;
      #40 KEY[0]=1;
      #10 KEY[0]=0;
      #20 KEY[0]=1;
//-      
      #100; 

    SW = 4'b1011;
    KEY[0] = 0;
	#30 ;
	KEY[0]=1;
	
//1
 
        #100; 
        SW = 4'b0000;
        KEY[0] = 1; 
	
       #10 KEY[0]=0;
      #40 KEY[0]=1;
      #10
	SW = 4'b0001;	
	 KEY[0]=0;
      #20 KEY[0]=1;
 
       
      
 //=     
	#100; 
        SW = 4'b1110;
        KEY[0] = 1;
    	#10 KEY[0]=0;
    	
end	

endmodule
