module Dividir_digitos (clk, tiempo, mostrar_cen, mostrar_dec, mostrar_uni);

input clk;
input [8:0] tiempo;

output reg [8:0] mostrar_cen = 0;
output reg [8:0] mostrar_dec = 0;
output reg [8:0] mostrar_uni = 0;

reg [7:0] resultado = 0;		
reg [3:0] digito_cen = 0;
reg [3:0] digito_dec = 0;
reg [3:0] digito_uni = 0;

always @(*) begin

	if((tiempo >= 0) && (tiempo < 10)) begin
		resultado <= tiempo;
	end
	else if((tiempo >= 10) && (tiempo < 20)) begin
		resultado <= tiempo + 6;
	end
	else if((tiempo >= 20) && (tiempo < 30)) begin
		resultado <= tiempo + 12;
	end
	else if((tiempo >= 30) && (tiempo < 40)) begin
		resultado <= tiempo + 18;
	end
		else if((tiempo >= 40) && (tiempo < 50)) begin
		resultado <= tiempo + 24;
	end
	else begin
		resultado <= 8'b11111111;;
	end
	
	digito_uni <= resultado[3:0];
	digito_dec <= resultado[7:4];
			
	case(digito_cen)
		0: mostrar_cen <= 9'h130;
		1: mostrar_cen <= 9'h131;
		2: mostrar_cen <= 9'h132;
		3: mostrar_cen <= 9'h133;
		4: mostrar_cen <= 9'h134;
		5: mostrar_cen <= 9'h135;
		6: mostrar_cen <= 9'h136;
		7: mostrar_cen <= 9'h137;
		8: mostrar_cen <= 9'h138;
		9: mostrar_cen <= 9'h139;				
	endcase
	
	case(digito_dec)
		0: mostrar_dec <= 9'h130;
		1: mostrar_dec <= 9'h131;
		2: mostrar_dec <= 9'h132;
		3: mostrar_dec <= 9'h133;
		4: mostrar_dec <= 9'h134;
		5: mostrar_dec <= 9'h135;
		6: mostrar_dec <= 9'h136;
		7: mostrar_dec <= 9'h137;
		8: mostrar_dec <= 9'h138;
		9: mostrar_dec <= 9'h139;				
	endcase

	case(digito_uni)
		0: mostrar_uni <= 9'h130;
		1: mostrar_uni <= 9'h131;
		2: mostrar_uni <= 9'h132;
		3: mostrar_uni <= 9'h133;
		4: mostrar_uni <= 9'h134;
		5: mostrar_uni <= 9'h135;
		6: mostrar_uni <= 9'h136;
		7: mostrar_uni <= 9'h137;
		8: mostrar_uni <= 9'h138;
		9: mostrar_uni <= 9'h139;				
	endcase			
			
end	
	
endmodule 
