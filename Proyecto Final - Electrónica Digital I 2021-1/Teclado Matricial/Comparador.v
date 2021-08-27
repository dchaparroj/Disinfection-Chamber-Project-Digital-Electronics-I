module Comparador(clk1k, filas, columnas, num);
input clk1k; 
input [3:0] filas; 
input [2:0] columnas; 

reg [2:0] regcolumnas1 = 0;
reg [2:0] regcolumnas2 = 0;
reg [4:0] contador = 0;

output reg [5:0] num = 0;

always@(posedge clk1k) begin
	
	if(columnas == 3'b000) begin
		
		contador <= contador +1;
		case(contador)
		'd0: num <= 'd41;
		default: begin regcolumnas2 <= regcolumnas1; contador <= 1; end
		endcase
	end
	
	
	if ((columnas == 3'b100) || (columnas == 3'b010) || (columnas == 3'b001)) begin
		regcolumnas1 <= columnas;
	
		// primera columna 
		if((regcolumnas1 == 3'b100) || (regcolumnas2 == 3'b100)) begin
			case(filas)
				'b1000: begin num <= 'd1;  end
				'b0100: begin num <= 'd4;  end
				'b0010: begin num <= 'd7;  end
				'b0001: begin num <= 'ha;  end // Es el *
			endcase
			
		end
			  
		// segunda columna  
		if((regcolumnas1 == 3'b010) || (regcolumnas2 == 3'b010)) begin
			case(filas)
				'b1000: num <= 'd2;
				'b0100: num <= 'd5;
				'b0010: num <= 'd8;
				'b0001: num <= 'd0;
			endcase
		end

		// tercera columna  	  
		if((regcolumnas1 == 3'b001) && (regcolumnas2 == 3'b001)) begin
			case(filas)
				'b1000: num <= 'd3;
				'b0100: num <= 'd6;
				'b0010: num <= 'd9;
				'b0001: num <= 'hb; // Es el #
			endcase
		end
	
	end
	
end

endmodule 