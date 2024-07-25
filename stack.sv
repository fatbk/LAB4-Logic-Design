module stack	  
#( 
// default: 32-bits data with 100 layers of stack. 
parameter WIDTH = 8,
parameter DEPTH = 8
)
(                            
input  logic        CLK,      
input  logic        RST,RST2,                      
input  logic        PUSH_STB, 
input  logic [WIDTH-1:0] PUSH_DAT,                            
input  logic        POP_STB,  
output logic [WIDTH-1:0] POP_DAT,  
output logic empty
);                
integer i;       
reg    	[DEPTH-1:0] ptr;
reg		[WIDTH-1:0] stack[0:DEPTH-1];
initial 
	begin
		ptr= 0;
	end   
assign empty = (ptr==8'hff)?1:0;
always@(posedge CLK )
begin
 if(!RST)begin 
	ptr<=0;
				
			end
 else if(PUSH_STB)
  ptr <= ptr + 1;  
 else if(POP_STB && !empty)
  ptr <= ptr - 1;
end
always@(posedge CLK ) begin
if(!RST2)begin 
		for(i=0; i< DEPTH-1;i=i+1)
				begin
						stack[i]<= 8'h00;
				end
				
			end
	if(PUSH_STB)
			stack[ptr] <= PUSH_DAT;
	if(POP_STB)
			POP_DAT <= stack[ptr];
	end
endmodule