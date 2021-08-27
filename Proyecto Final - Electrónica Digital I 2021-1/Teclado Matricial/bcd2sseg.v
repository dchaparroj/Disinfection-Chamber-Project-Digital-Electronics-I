module bcd2sseg(BCD, SevenSeg1);

input [5:0] BCD;
output reg [0:6] SevenSeg1 = 0;

reg [5:0] dig1 = 0;

always @(*) begin
	
	dig1 <= BCD[5:0];
	
	case(dig1)
				             //abcdefg
		'd00: SevenSeg1 <= 7'b0000001; //b0000 h0
		'd01: SevenSeg1 <= 7'b1001111; //b0001 h1
		'd02: SevenSeg1 <= 7'b0010010; //b0010 h2
		'd03: SevenSeg1 <= 7'b0000110; //b0011 h3
		'd04: SevenSeg1 <= 7'b1001100; //b0100 h4
		'd05: SevenSeg1 <= 7'b0100100; //b0101 h5
		'd06: SevenSeg1 <= 7'b0100000; //b0110 h6
		'd07: SevenSeg1 <= 7'b0001111; //b0111 h7					
		'd08: SevenSeg1 <= 7'b0000000; //b1000 h8
		'd09: SevenSeg1 <= 7'b0001100; //b1001 h9
	default:
		      SevenSeg1 <= 7'b1111111;
	endcase
	
end

endmodule 