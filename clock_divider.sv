module Clock_divider(
    
input logic clock_in, 
output logic clock_05hz, 
output logic clock_1hz
); 
reg[27:0] counter1=28'd0;
reg[27:0] counter2=28'd0;
parameter DIVISOR_05HZ = 28'd10000000;
parameter DIVISOR_1HZ =  28'd50;

always @(posedge clock_in)
begin
 counter1 <= counter1 + 28'd1;
 if(counter1>=(DIVISOR_05HZ-1))
  counter1 <= 28'd0;
 clock_05hz <= (counter1<DIVISOR_05HZ/2)?1'b1:1'b0;
end

always @(posedge clock_in)
begin
 counter2 <= counter2 + 28'd1;
 if(counter2>=(DIVISOR_1HZ-1))
  counter2 <= 28'd0;
 clock_1hz <= (counter2<DIVISOR_1HZ/2)?1'b1:1'b0;
end
endmodule