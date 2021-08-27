module Teclado_Matricial(clk, columnas, filas, sseg, anodos, num);

input clk;
input [2:0] columnas; 

output [3:0] filas;
output reg [0:6] sseg;
output reg [6:0] anodos;

reg [3:0] contador = 0;
reg [5:0] numSseg = 0;

output [5:0] num;
wire [0:6] ssegDig1;
wire clk05khz;
wire clk1khz;

	Divisor_Frecuencia div(clk, clk05khz, clk1khz);

	Barrido_Filas bar(clk05khz, filas);

	Comparador com(clk1khz, filas, columnas, num);

	bcd2sseg display(numSseg, ssegDig1);

always @(posedge clk1khz)begin
	contador <= contador + 2'b01;

	if(contador == 1) begin
		contador <= 0;
	end

	case(contador)	
		3'b000: begin numSseg <= num; sseg <= ssegDig1; 
						  anodos <= 7'b11_11_110; end	
	endcase
end


endmodule 