module Divisor_Frecuencia(clk, clk05khz, clk1khz);

input clk;
output reg clk05khz = 0;
output reg clk1khz = 0;

reg [27:0] count_2;
reg [27:0] count_3;


always @ (posedge clk)begin
		
	if(count_2 < 'd50_000)begin //05kHz
		count_2 <= count_2 + 1;
		end
	else begin
		count_2 <= 0;
		clk05khz = !clk05khz;
		end			
		
	if(count_3 < 'd25_000)begin //1kHz
		count_3 <= count_3 + 1;
		end
	else begin
		count_3 <= 0;
		clk1khz = !clk1khz;
		end	

end
	
endmodule 	