module Camara_Desinfeccion (
	
	//LCD
		CLOCK_50, //50 MHz
		LCD_RW,   //LCD Read/Write Select, 0 = Write, 1 = Read
		LCD_EN,   //LCD Enable
		LCD_RS,   //LCD Command/Data Select, 0 = Command, 1 = Data
		LCD_DATA, //LCD Data bus 8 bits
		
	//Teclado Matricial - 7 segmentos
		columnas,
		filas,
		sseg,
		anodos,
		
	//Sw para señal Arduino
		zumbador_sw,
		led_sw,
		servo180_sw,
		servo360_sw,
		zumbador_out,
		led_out,
		servo180_out,
		servo360_out,
		LEDFPGA,
	//Sensor FC-51	
		sensor,
		sensor_out
);

//LCD
input CLOCK_50;       //50 MHz
inout [7:0] LCD_DATA; //LCD Data bus 8 bits
wire [5:0] mensaje;
output LCD_RW;        //LCD Read/Write Select, 0 = Write, 1 = Read
output LCD_EN;        //LCD Enable
output LCD_RS;        //LCD Command/Data Select, 0 = Command, 1 = Data


//Teclado Matricial - 7 segmentos
input [2:0] columnas; 
output [3:0] filas;
output [0:6] sseg;
output [6:0] anodos;

//SW para señal Arduino
input zumbador_sw;
	wire zumbador_swneg = ~zumbador_sw; //Switch en logica negada se corrigen
input led_sw;
	wire led_swneg = ~led_sw;
input servo180_sw;
	wire servo180_swneg = ~servo180_sw;
input servo360_sw;
	wire servo360_swneg = ~servo360_sw;

output reg zumbador_out;
	wire zumbador;	//Almacena los valores de salida de LCD_Top lcd
output reg led_out;
	wire led;
output reg servo180_out;
	wire servo180;
output reg servo360_out;
	wire servo360;
output reg [4:0] LEDFPGA;
	reg [4:0] ledfpga_neg;	//Corrige la logica negada en los leds

//Sensor FC-51
input sensor;
	wire sensor_neg = ~sensor;
output reg sensor_out;
	wire sensor_w;


LCD_Top lcd ( .CLOCK_50(CLOCK_50), 
				  .LCD_RW(LCD_RW),
				  .LCD_EN(LCD_EN), 
				  .LCD_RS(LCD_RS),
				  .LCD_DATA(LCD_DATA),
				  .mensaje(mensaje), 
				  //
				  .zumbador_out(zumbador), 
				  .led_out(led), 
				  .servo180_out(servo180), 
				  .servo360_out(servo360),
				  .LEDFPGA(led_fpga), 
				  .sensor(sensor_neg), 
				  .sensor_out(sensor_w)
				  );
					
Teclado_Matricial tmatr ( .clk(CLOCK_50), 
								  .columnas(columnas), 
								  .filas(filas), 
								  .sseg(sseg), 
								  .anodos(anodos), 
								  .num(mensaje) 
								  );

always @(*) begin
	
	LEDFPGA <= ~ledfpga_neg; //LED's en logica negada se corrigen
	
	//Control Zumbador
	if((zumbador_swneg == 1) || (zumbador == 1)) begin 	
		zumbador_out <= 1; 		//Enciende
		ledfpga_neg[0] <= 1; 	//Led ON
	end
	else begin
		zumbador_out <= 0; 		//Apaga
		ledfpga_neg[0] <= 0; 	//Led OFF
	end

	//Control cinta led
	if((led_swneg == 1) || (led == 1)) begin 					
		led_out <= 1;
		ledfpga_neg[1] <= 1;
	end
	else begin
		led_out <= 0;
		ledfpga_neg[1] <= 0;
	end
	
	//Control servo 180°
	if((servo180_swneg == 1) || (servo180 == 1)) begin 	
		servo180_out <= 1;
		ledfpga_neg[2] <= 1;
	end
	else begin
		servo180_out <= 0;
		ledfpga_neg[2] <= 0;
	end
	
	//Control servo 360°
	if((servo360_swneg == 1) || (servo360 == 1)) begin 	
		servo360_out <= 1;
		ledfpga_neg[3] <= 1;
	end
	else begin
		servo360_out <= 0;
		ledfpga_neg[3] <= 0;
	end	
	
	//Sensor
//	if((sensor_neg == 1) || (sensor_w == 1)) begin 			
//		sensor_out <= 1;
//		ledfpga_neg[4] <= 1;
//	end
//	else begin
//		sensor_out <= 0;
//		ledfpga_neg[4] <= 0;
//	end

end									

endmodule 