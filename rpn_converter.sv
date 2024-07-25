module converter(	
	input wire CLK,
	input wire RST,	   
	// Input variables
	input 	wire input_stb,
	input 	wire [31:0] input_data,
	input 	wire is_input_operator,
	output 	reg input_ack,	
	// Output variables
	output reg output_stb,
	output reg	[31:0] output_data,
	output 	reg is_output_operator,
	input 	wire output_ack
);

	// Stack Variables
	reg push_stb; 	// tell stack to remember data
	reg pop_stb;	// tell stack to pop the top
	wire [2:0] pop_data; 	// data from stack 

	// States Variables
	reg [2:0] state;
	// Flag
	reg is_from_state_2;
	reg is_from_state_4;
	/*---------------------- Initialization ------------------------*/
	initial
			begin
			/*IO Registers*/
			input_ack <= 1'b0;
			output_stb <= 1'b0;
			output_data <= 32'bx;
			is_output_operator <= 1'bx;
			/*Stack Registers*/
			push_stb <= 1'b0;
			pop_stb <= 1'b0;
			/*State Registers*/
			state <= 3'b0;	
			is_from_state_2 <= 1'b0;
			is_from_state_4 <= 1'b0;
			end
always @(posedge CLK or posedge RST)
		if(RST)
			begin
			/*IO Registers*/
			input_ack <= 1'b0;
			output_stb <= 1'b0;
			output_data <= 32'bx;
			is_output_operator <= 1'bx;
			/*Stack Registers*/
			push_stb <= 1'b0;
			pop_stb <= 1'b0;
			/*State Registers*/
			state <= 3'b0;	  
			/*Flags*/
			is_from_state_2 <= 1'b0;
			is_from_state_4 <= 1'b0; 
			end
		else 
		case(state)
			0: //Check type of input after input_stb
			begin
				if(input_stb)
					begin
						/*input is an operator*/
						if(is_input_operator == 1'b1)
							begin
								if(input_data[2:0] === 3'b100) // input operator is '='
										state <= 3'd4;
								else if(pop_data[2:0] === 3'bx ) // stack empty
										begin
										push_stb <= 1'b1;
										input_ack <= 1'b1;
										state <= 3'd3;	
										end
								else 
										state <= 3'd2; // compare operators
							end
						/*input is a number*/
						else 
							begin
								output_data <= input_data;
								output_stb <= 1'b1;
								is_output_operator <= 1'b0;
								state <= 3'd1;
							end
					end
				end
				1: // Wait for output_ack from calculator
			begin
				pop_stb <= 1'b0;  	// from state 4, 2
				if (output_ack)	// testbench already got output
						begin
							output_stb <= 1'b0;
							output_data <= 32'bx;
							is_output_operator <= 1'bx;
							if(is_from_state_4 === 1'b1)
								begin
									is_from_state_4 <= 1'b0;
									state <= 3'd4; // back to state 4 (continue flushing stack)
								end
							else if(is_from_state_2 === 1'b1)
								begin
									is_from_state_2 <= 1'b0;
									state <= 3'd2;	// continue checking top stack
								end
							else 
								begin
									state <= 3'd3;
									input_ack <= 1'b1;
								end
						end
				end
				2: // Compare operators
				begin
					if(input_data[1] >= pop_data[1])
						// if the input operator has lower pririty, top out stack
						begin
							output_data <= pop_data;		
							pop_stb <= 1'b1;
							state <= 3'd1;
							is_from_state_2 <= 1'b1;
							is_output_operator <= 1'b1;
							output_stb <= 1'b1;
						end
					else
						// When the input operator has higher priority than stack
						begin
							push_stb <= 1'b1;
							input_ack <= 1'b1;
							state <= 3'd3;	
						end
				end
				3: // End of States (delay input_ack)
					begin
						input_ack <= 1'b0;
						push_stb <= 1'b0;
						state <= 3'd0;
					end
				4: // Flush the stack before push "=" or empty before push new stack
					begin
						if(pop_data[2:0] === 3'bx)
						 // the stack is alaready empty
							begin
								state <= 3'd1;
								output_data <= input_data;
								output_stb <= 1'b1;
								is_output_operator <= 1'b1;
							end
						else // While the stack is not empty
							begin
								output_data <= pop_data;		
								pop_stb <= 1'b1;
								state <= 3'd1;
								is_from_state_4 <= 1'b1;
								is_output_operator <= 1'b1;
								output_stb <= 1'b1;
							end

					end
			endcase
			
	stack #(
	.WIDTH(3),
	.DEPTH(20)
	) operator_stack(
	.CLK(CLK),
	.RST(RST),
	.PUSH_STB(push_stb),
	.PUSH_DAT(input_data[2:0]),
	.POP_STB(pop_stb),
	.POP_DAT(pop_data)
	);
endmodule