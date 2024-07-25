module mux_sel(
input logic [7:0]display,
input logic [7:0]result,
input logic sel,
output logic [7:0] final_data

);
assign final_data= (sel==0)?display :result;
endmodule