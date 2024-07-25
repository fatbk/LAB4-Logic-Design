module reg_start(
input logic clk,rst,
input logic data,
output logic data_o
);
always @(posedge clk)
	begin
		if(!rst)
			begin
				data_o<=0;
			end
		else begin
			data_o <= data;
			end
	end
endmodule