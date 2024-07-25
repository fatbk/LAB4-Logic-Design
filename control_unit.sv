																						    module control_unit(
input logic [3:0] sw,
input logic clk,rst,
input logic key0,
output logic start,
output  logic[7:0] data_o1,data_o2,
output logic [7:0] display,
output logic sel,
output logic led1,led2
);
logic empty;
logic [7:0] data1,data2;
logic push1,pop1,push2,pop2;
logic [3:0] state;
logic is_minus;
initial 
	begin
	  start<=0;
		state <= 4'b000;
		data1<=8'd0;
		data2<=8'd0;
		
		is_minus<=0;
	end
always @(posedge clk) begin
	if(!rst)
		begin
			state <= 4'b000;
			display <=8'h00;
			sel<=0;
			led1<=0;
			led2<=0;
			is_minus<=0;
			
		end
	else
		begin
	case(state)
		4'b0000:
			begin
			   sel<=0;
				push1<=0;
				push2<=0;
				pop1<=0;
				pop2<=0;
				start<=0;
				led1<=0;
			        led2<=0;
				display<= display;
				if((sw<4'd10) && key0==0 && is_minus==0)//"+"
					begin	
						state <= 4'b0001;
					end
				if((sw<4'd10) && key0==0 && is_minus==1)//"-"
					begin	
						state <= 4'b0111;
					end
				if( sw ==4'd10 &&key0==0)//"+"
					begin	
						state <= 4'b0011;
					end
				if( sw ==4'd11 &&key0==0)//"-"
					begin	
						state <= 4'b0110;
					end

					if(sw== 4'd14 && key0==0)// "="
						begin
							state <= 4'b0100;
						end
					if((sw ==1100 || sw ==1101 || sw ==1111 )&& key0==0 )// "null"
						begin
							state <= 4'b0101;
						end
				       
					end
				
		4'b0001:
			begin
				data1<= {4'b0000,sw};
				
				display<={4'b0000,sw};
				sel<=0;
				push1<=0;
				push2<=0;
				led1<=1;
			   led2<=0;
				state <=4'b0010;	
				
					
			end
		4'b0010:
			begin
			if(sw < 1010 && key0 == 0)//number
						begin
						
				data1 <= {data1[3:0],sw};
				display<= {data1[3:0],sw};
				sel<=0;
				push1<= 1;
				push2<= 0;
				led1<=1;
				led2<=1;
				state <=4'b0000;
				end
			end
		4'b0011:
			begin
				data2<= {4'b0000,sw};
				display<=display;
				push1<= 0;
				push2<= 1;
				led1 <= 1;
				led2<=1;
				state<=4'b0000;
			end
		4'b0100:
			begin
				start <=(empty==1)?0:1;
				pop1<= 1;
				pop2<= 1;
				led1<=0;
			        led2<=0;
			        sel<= 1;
			end
		4'b0101:
			begin
				state <=4'b0000;
			end
		4'b0110:begin
			data2<= 8'h0a;
				display<=display;
				push1<= 0;
				push2<= 1;
				led1 <= 1;
				led2<=1;
				is_minus <=1;
				state<=3'b000;
			end	
		4'b0111:begin
			
				data1<= {4'b0000,sw};
				display<={4'b0000,sw};
				sel<=0;
				push1<=0;
				push2<=0;
				led1<=1;
			   	led2<=0;
				state <=4'b1000;	
			end
		4'b1000:
			begin
				if(sw < 1010 && key0 == 0)//number
						begin
						
				data1 <= {data1[3:0],sw};
				display<= {data1[3:0],sw};		
				is_minus<= 1;
				state <=4'b1001;
				end
			end
		4'b1001:
			begin
				state <=4'b0000;
				data1<=~data1 + 1 ;
				push1<= 1;
				push2<= 0;
				led1<=1;
				led2<=1;
				sel<=0;
				is_minus <= 0;
			end
		endcase
end
end
stack  stack_num(                            
.CLK(clk),      
.RST(rst),          
.RST2(rst),             
.PUSH_STB(push1), 
.PUSH_DAT(data1),                            
.POP_STB(pop1),  
.POP_DAT(data_o1),  
.empty(empty)
);           



stack stack_op(                            
.CLK(clk),      
.RST(rst),
.RST2(rst),                       
.PUSH_STB(push2), 
.PUSH_DAT(data2),                            
.POP_STB(pop2),  
.POP_DAT(data_o2),  
.empty()
);       

endmodule












