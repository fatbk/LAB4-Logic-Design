module alu(
input clk, rst,
input logic [7:0] operator,
input logic [7:0] a,b,
input logic pop,
output logic [7:0] output_data

);
reg [7:0] rega,regb;
logic [1:0] state;
initial begin
	state = 2'b00;
	output_data =8'h00;
	end
always @(posedge clk)
	begin
		if(!rst)
			begin
				state <= 2'b00;
				output_data =8'h00;
			end
		else 
			begin
				if(pop)
				begin
					case (state)
					   2'b00:
					   begin
					    state<=2'b01;
					    end
						
						2'b01:
						
						begin
						
						  if(operator ==8'h0a)
							begin
								output_data <=a+b;
								
							end
							state<=2'b10;
						end
						2'b10:
						
						begin
						
						
						  if(operator ==8'h0a)
							begin
								output_data <=a + b;
							end
						
						
							state<=2'b11;
						end
						2'b11:
						  begin
						     
						  if(operator ==8'h0a)
							begin
								output_data <=output_data + a;
							end
						
							end
						endcase
				end
			end
		end
endmodule














		
				