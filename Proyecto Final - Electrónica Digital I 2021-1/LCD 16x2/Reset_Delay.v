module Reset_Delay(iCLK, oRESET, clk1hz);

input iCLK;
output reg oRESET;
output reg clk1hz;
reg [19:0] Cont;
reg [27:0] count_1;

always@(posedge iCLK) begin

	if(Cont!=20'hFFFFF) begin   //21ms 
		Cont <= Cont + 1;
		oRESET <= 1'b0;
	end
	 
   else
		oRESET <= 1'b1;

//Divisor de frecuencia a 1Hz
	if(count_1 < 'd25_000_000)begin // 1Hz
		count_1 <= count_1 + 1;
		end
	else begin
		count_1 <= 0;
		clk1hz = !clk1hz;
		end

end	

endmodule
