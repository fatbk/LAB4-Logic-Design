module register(
input logic clk,rst,
input logic [7:0] data_in,
output logic [7:0] data_o

);

always @(posedge clk)
	begin
		if(!rst)
			begin
				data_o <= 8'h00;
			end
		else 
			begin
				data_o <= data_in;
			end
	end
	endmodule