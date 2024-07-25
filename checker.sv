module check1 (
input logic clk, rst,
input logic [1:0]is_operator,
input logic  [7:0] data_in,
output logic [7:0] data_out1,
output logic [7:0] data_out2,
output logic 	pop
);
logic empty ;
logic [7:0] data;
logic [7:0] data_op;
logic pop1,push1,pop2,push2;
always @(posedge clk)	begin
	if(!rst)
		begin
			data=8'h00;
			data_op=8'h00;

		end
	else	begin
		if(empty==1)
			begin
				pop1 <=0;
				pop2 <=0;
			end
		else begin
		if(is_operator ==2'b10 )
			begin
				if(data_in == 1110)
					begin
						pop1 <= 1;
						pop2 <= 1;
					end		
				else 	
					begin
						push2 <=1;
						data_op <= data_in;
													
					end
		end
			if(is_operator==2'b01)
				begin
					push1 <=1;
					data <= data_in;
				end	
			if(is_operator==2'b00)
				begin
					push1<=0;
					push2<=0;
				end
		end
	end
end

stack stack_num
(                            
.CLK(clk),      
.RST(rst),                      
.PUSH_STB(push1), 
.PUSH_DAT(data),                            
.POP_STB(pop1),
.empty(empty),
.POP_DAT(data_out1)  
);   


stack stack_op
(                            
.CLK(clk),      
.RST(rst),                      
.PUSH_STB(push2), 
.PUSH_DAT(data_op),                            
.POP_STB(pop2),  
.empty(),
.POP_DAT(data_out2)  
);   
endmodule	
				