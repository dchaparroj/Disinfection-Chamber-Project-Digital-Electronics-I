module LCD_Top (
	
	//LCD
		CLOCK_50, //50 MHz
		LCD_RW,   //LCD Read/Write Select, 0 = Write, 1 = Read
		LCD_EN,   //LCD Enable
		LCD_RS,   //LCD Command/Data Select, 0 = Command, 1 = Data
		LCD_DATA, //LCD Data bus 8 bits
		mensaje,

	//Señal Arduino OUT
		zumbador_out,
		led_out,
		servo180_out,
		servo360_out,
		LEDFPGA,
		sensor,
		sensor_out
		
		);

//LCD
input CLOCK_50;       //50 MHz
inout [7:0] LCD_DATA; //LCD Data bus 8 bits
input [5:0] mensaje;
output LCD_RW;        //LCD Read/Write Select, 0 = Write, 1 = Read
output LCD_EN;        //LCD Enable
output LCD_RS;        //LCD Command/Data Select, 0 = Command, 1 = Data

reg [8:0] Mostrar_10 = "H"; //Reg para caracteres LCD 16x2
reg [8:0] Mostrar_11 = "O";
reg [8:0] Mostrar_12 = "L";
reg [8:0] Mostrar_13 = "A";
reg [8:0] Mostrar_14 = " ";
reg [8:0] Mostrar_15 = "M";
reg [8:0] Mostrar_16 = "U";
reg [8:0] Mostrar_17 = "N";
reg [8:0] Mostrar_18 = "D";
reg [8:0] Mostrar_19 = "O";
reg [8:0] Mostrar_110 = " ";
reg [8:0] Mostrar_111 = "L";
reg [8:0] Mostrar_112 = "I";
reg [8:0] Mostrar_113 = "N";
reg [8:0] Mostrar_114 = "E";
reg [8:0] Mostrar_115 = "1";
reg [8:0] Mostrar_20 = "P";
reg [8:0] Mostrar_21 = "R";
reg [8:0] Mostrar_22 = "U";
reg [8:0] Mostrar_23 = "E";
reg [8:0] Mostrar_24 = "B";
reg [8:0] Mostrar_25 = "A";
reg [8:0] Mostrar_26 = " ";
reg [8:0] Mostrar_27 = "L";
reg [8:0] Mostrar_28 = "I";
reg [8:0] Mostrar_29 = "N";
reg [8:0] Mostrar_210 = "E";
reg [8:0] Mostrar_211 = "A";
reg [8:0] Mostrar_212 = " ";
reg [8:0] Mostrar_213 = "2";
reg [8:0] Mostrar_214 = " ";
reg [8:0] Mostrar_215 = " ";  
wire DLY_RST;


// Menú

parameter INICIO = 'b0000,
			 INGRESAR = 'b0001,
          ADVERTENCIA = 'b0010,
          SELECCION = 'b0011,
          ORGANICO = 'b0100,
			 INORGANICO = 'b0101,
			 FINALIZO = 'b0110,
			 ABRIR = 'b0111,
			 CERRAR = 'b1000;
			 
reg [3:0] status;
reg [8:0] tiempo = 999;		 
reg [1:0] organico_time = 0;
reg [1:0] inorganico_time = 0;	
reg inicio = 0;
reg parar = 0;	
wire clk1hz;
wire [8:0] mostrar_cen;
wire [8:0] mostrar_dec;
wire [8:0] mostrar_uni;

//Señal Arduino
output reg zumbador_out = 0;
output reg led_out = 0;
output reg servo180_out = 0;
output reg servo360_out = 0;
output reg [4:0] LEDFPGA  = 0;
input sensor;
output reg sensor_out = 0;


Reset_Delay r0 ( .iCLK(CLOCK_50), .oRESET(DLY_RST), .clk1hz(clk1hz));

Dividir_digitos dig ( .clk(CLOCK_50), 
							 .tiempo(tiempo), 
							 .mostrar_cen(mostrar_cen), 
							 .mostrar_dec(mostrar_dec), 
							 .mostrar_uni(mostrar_uni) 
							 );

//Contador para LCD
always @ (posedge clk1hz)begin
	
	//Tiempo organico
	if(organico_time == 2'b01) begin 
		tiempo <= 11;
	end
	//Tiempo inorganico	
	else if(inorganico_time == 2'b01) begin 
		tiempo <= 9;
	end
	
	//Contador descendente
	if((inicio == 2'b01) && (tiempo > 0)) begin
		tiempo <= tiempo - 2'b01;
	end

	else if(parar == 2'b01) begin
		tiempo <= tiempo;
	end		
			
end


//Asignacion de caracteres LCD 16x2 según "mensaje"
//Finite State Machine

always @ (posedge CLOCK_50)begin

	case(status)

		INICIO: begin
			//00000000000000000000000000000000 //32 casillas
			//Cabina de desinfeccion 1.abrir
			Mostrar_10<=9'h143;//C
			Mostrar_11<=9'h141;//A
			Mostrar_12<=9'h142;//B
			Mostrar_13<=9'h149;//I
			Mostrar_14<=9'h14E;//N
			Mostrar_15<=9'h141;//A
			Mostrar_16<=9'h120;//ESP
			Mostrar_17<=9'h144;//D
			Mostrar_18<=9'h145;//E
			Mostrar_19<=9'h120;//ESP
			Mostrar_110<=9'h144;//D
			Mostrar_111<=9'h145;//E
			Mostrar_112<=9'h153;//S
			Mostrar_113<=9'h149;//I
			Mostrar_114<=9'h14E;//N
			Mostrar_115<=9'h146;//F
			Mostrar_20<=9'h145;//E
			Mostrar_21<=9'h143;//C
			Mostrar_22<=9'h143;//C
			Mostrar_23<=9'h149;//I
			Mostrar_24<=9'h14F;//O
			Mostrar_25<=9'h14E;//N
			Mostrar_26<=9'h120;//ESP
			Mostrar_27<=9'h131;//1
			Mostrar_28<=9'h12E;//.
			Mostrar_29<=9'h141;//A
			Mostrar_210<=9'h142;//B
			Mostrar_211<=9'h152;//R
			Mostrar_212<=9'h149;//I
			Mostrar_213<=9'h152;//R
			Mostrar_214<=9'h120;//ESP
			Mostrar_215<=9'h120;//ESP
			
			zumbador_out <= 0;
				LEDFPGA [0] <= 0;
			led_out <= 0;
				LEDFPGA [1] <= 0;
			servo180_out = 0;
				LEDFPGA [2] <= 0;
			servo360_out <= 0;
				LEDFPGA [3] <= 0;
			sensor_out <= 0;
				LEDFPGA [4] <= 0;
			
			if(mensaje == 1) begin
				status <= INGRESAR;
			end		
		
		end
		
		INGRESAR: begin
			//00000000000000000000000000000000 //32 casillas
			//Ingrese el objeto 3.sig 0.salir
			Mostrar_10<=9'h149;//I
			Mostrar_11<=9'h14E;//N
			Mostrar_12<=9'h147;//G
			Mostrar_13<=9'h152;//R
			Mostrar_14<=9'h145;//E
			Mostrar_15<=9'h153;//S
			Mostrar_16<=9'h145;//E
			Mostrar_17<=9'h120;//ESP
			Mostrar_18<=9'h145;//E
			Mostrar_19<=9'h14C;//L
			Mostrar_110<=9'h120;//ESP
			Mostrar_111<=9'h14F;//O
			Mostrar_112<=9'h142;//B
			Mostrar_113<=9'h14A;//J
			Mostrar_114<=9'h145;//E
			Mostrar_115<=9'h154;//T
			Mostrar_20<=9'h14F;//O
			Mostrar_21<=9'h120;//ESP
			Mostrar_22<=9'h132;//2
			Mostrar_23<=9'h12E;//.
			Mostrar_24<=9'h153;//S
			Mostrar_25<=9'h149;//I
			Mostrar_26<=9'h147;//G
			Mostrar_27<=9'h120;//ESP
			Mostrar_28<=9'h130;//0
			Mostrar_29<=9'h12E;//.
			Mostrar_210<=9'h153;//S
			Mostrar_211<=9'h141;//A
			Mostrar_212<=9'h14C;//L
			Mostrar_213<=9'h149;//I
			Mostrar_214<=9'h152;//R
			Mostrar_215<=9'h120;//ESP		
		
			zumbador_out <= 0;
				LEDFPGA [0] <= 0;
			led_out <= 0;
				LEDFPGA [1] <= 0;
			servo180_out = 1;
				LEDFPGA [2] <= 1;
			servo360_out <= 0;
				LEDFPGA [3] <= 0;
			sensor_out <= 0;
				LEDFPGA [4] <= 0;		
		
			if ((mensaje == 2) && (sensor == 0)) begin
				status <= ADVERTENCIA;
			end
			else if ((mensaje == 2) && (sensor == 1)) begin
				status <= SELECCION;
			end			
			else if (mensaje == 0) begin
				status <= CERRAR; //INICIO
			end
			
		end
		
      ADVERTENCIA: begin
			//00000000000000000000000000000000 //32 casillas
			//¡¡Ingrese el objeto!! 3.cerrar
			Mostrar_10<=9'h121;//!
			Mostrar_11<=9'h121;//!
			Mostrar_12<=9'h149;//I
			Mostrar_13<=9'h14E;//N
			Mostrar_14<=9'h147;//G
			Mostrar_15<=9'h152;//R
			Mostrar_16<=9'h145;//E
			Mostrar_17<=9'h153;//S
			Mostrar_18<=9'h145;//E
			Mostrar_19<=9'h120;//ESP
			Mostrar_110<=9'h145;//E
			Mostrar_111<=9'h14C;//L
			Mostrar_112<=9'h120;//ESP
			Mostrar_113<=9'h14F;//O
			Mostrar_114<=9'h142;//B
			Mostrar_115<=9'h14A;//J
			Mostrar_20<=9'h145;//E
			Mostrar_21<=9'h154;//T
			Mostrar_22<=9'h14F;//O
			Mostrar_23<=9'h121;//!
			Mostrar_24<=9'h121;//!
			Mostrar_25<=9'h120;//ESP
			Mostrar_26<=9'h133;//3
			Mostrar_27<=9'h12E;//.
			Mostrar_28<=9'h143;//C
			Mostrar_29<=9'h145;//E
			Mostrar_210<=9'h152;//R
			Mostrar_211<=9'h152;//R
			Mostrar_212<=9'h141;//A
			Mostrar_213<=9'h152;//R
			Mostrar_214<=9'h120;//ESP
			Mostrar_215<=9'h120;//ESP		
		
			zumbador_out <= 1;
				LEDFPGA [0] <= 1;
			led_out <= 0;
				LEDFPGA [1] <= 0;
			servo180_out = 1;
				LEDFPGA [2] <= 1;
			servo360_out <= 0;
				LEDFPGA [3] <= 0;
			sensor_out <= 0;
				LEDFPGA [4] <= 0;			
		
			if((mensaje == 3) && (sensor == 1)) begin
				status <= SELECCION;
			end
			else if (mensaje == 0) begin
				status <= CERRAR; //INICIO
			end		
		
		end

      SELECCION: begin
			//00000000000000000000000000000000 //32 casillas
			//4.organico 5.inorganico 0.salir
			Mostrar_10<=9'h134;//4
			Mostrar_11<=9'h12E;//.
			Mostrar_12<=9'h14F;//O
			Mostrar_13<=9'h152;//R
			Mostrar_14<=9'h147;//G
			Mostrar_15<=9'h141;//A
			Mostrar_16<=9'h14E;//N
			Mostrar_17<=9'h149;//I
			Mostrar_18<=9'h143;//C
			Mostrar_19<=9'h14F;//O
			Mostrar_110<=9'h120;//ESP
			Mostrar_111<=9'h135;//5
			Mostrar_112<=9'h12E;//.
			Mostrar_113<=9'h149;//I
			Mostrar_114<=9'h14E;//N
			Mostrar_115<=9'h14F;//O
			Mostrar_20<=9'h152;//R
			Mostrar_21<=9'h147;//G
			Mostrar_22<=9'h141;//A
			Mostrar_23<=9'h14E;//N
			Mostrar_24<=9'h149;//I
			Mostrar_25<=9'h143;//C
			Mostrar_26<=9'h14F;//O
			Mostrar_27<=9'h120;//ESP
			Mostrar_28<=9'h130;//0
			Mostrar_29<=9'h12E;//.
			Mostrar_210<=9'h153;//S
			Mostrar_211<=9'h141;//A
			Mostrar_212<=9'h14C;//L
			Mostrar_213<=9'h149;//I
			Mostrar_214<=9'h152;//R
			Mostrar_215<=9'h120;//ESP			
			
			zumbador_out <= 0;
				LEDFPGA [0] <= 0;
			led_out <= 0;
				LEDFPGA [1] <= 0;
			servo180_out = 0;
				LEDFPGA [2] <= 0;
			servo360_out <= 0;
				LEDFPGA [3] <= 0;
			sensor_out <= 0;
				LEDFPGA [4] <= 0;			
			
			if(mensaje == 4) begin
				status <= ORGANICO;
			end
			else if (mensaje == 5) begin
				status <= INORGANICO;
			end
			else if (mensaje == 0) begin
				status <= CERRAR; //INICIO
			end		
			
		end
		
      ORGANICO: begin
			//00000000000000000000000000000000 //32 casillas
			//0:35 1.iniciar 2.parar 3.salir		
			Mostrar_10<=9'h120;//ESP
			Mostrar_11<=mostrar_cen;//0
			Mostrar_12<=mostrar_dec;//3
			Mostrar_13<=mostrar_uni;//5
			Mostrar_14<=9'h120;//ESP
			Mostrar_15<=9'h131;//1
			Mostrar_16<=9'h12E;//.
			Mostrar_17<=9'h149;//I
			Mostrar_18<=9'h14E;//N
			Mostrar_19<=9'h149;//I
			Mostrar_110<=9'h143;//C
			Mostrar_111<=9'h149;//I
			Mostrar_112<=9'h141;//A
			Mostrar_113<=9'h152;//R
			Mostrar_114<=9'h120;//ESP
			Mostrar_115<=9'h120;//ESP
			Mostrar_20<=9'h132;//2
			Mostrar_21<=9'h12E;//.
			Mostrar_22<=9'h150;//P
			Mostrar_23<=9'h141;//A
			Mostrar_24<=9'h152;//R
			Mostrar_25<=9'h141;//A
			Mostrar_26<=9'h152;//R
			Mostrar_27<=9'h120;//ESP
			Mostrar_28<=9'h130;//0
			Mostrar_29<=9'h12E;//.
			Mostrar_210<=9'h153;//S
			Mostrar_211<=9'h141;//A
			Mostrar_212<=9'h14C;//L
			Mostrar_213<=9'h149;//I
			Mostrar_214<=9'h152;//R
			Mostrar_215<=9'h120;//ESP			
			
			organico_time <= 2'b01;
			inorganico_time <= 2'b00;
			
			zumbador_out <= 0;
				LEDFPGA [0] <= 0;
			led_out <= 0;
				LEDFPGA [1] <= 0;
			servo180_out = 0;
				LEDFPGA [2] <= 0;
			servo360_out <= 0;
				LEDFPGA [3] <= 0;
			sensor_out <= 0;
				LEDFPGA [4] <= 0;	
			
			if(mensaje == 1) begin
				inicio <= 2'b01;
				parar <= 2'b00;
				led_out <= 1;
					LEDFPGA [1] <= 1;
				servo360_out <= 1;
					LEDFPGA [3] <= 1;	
			end
			else if(mensaje == 2) begin
				inicio <= 2'b00;
				parar <= 2'b01;
				led_out <= 0;
					LEDFPGA [1] <= 0;
				servo360_out <= 0;
					LEDFPGA [3] <= 0;	
			end			
//			else if(mensaje == 6) begin
//				status <= FINALIZO;
//			end
			else if (mensaje == 0) begin
				status <= CERRAR; //INICIO
			end	
			if((mostrar_cen == 9'h130) && (mostrar_dec == 9'h130) 
														&& (mostrar_uni == 9'h130)) begin
				status <= FINALIZO;
			end
		end
		
		INORGANICO: begin
			//00000000000000000000000000000000 //32 casillas
			//1:57 1.iniciar 2.parar 3.salir	6		
			Mostrar_10<=9'h120;//ESP
			Mostrar_11<=mostrar_cen;//0
			Mostrar_12<=mostrar_dec;//5
			Mostrar_13<=mostrar_uni;//7
			Mostrar_14<=9'h120;//ESP
			Mostrar_15<=9'h131;//1
			Mostrar_16<=9'h12E;//.
			Mostrar_17<=9'h149;//I
			Mostrar_18<=9'h14E;//N
			Mostrar_19<=9'h149;//I
			Mostrar_110<=9'h143;//C
			Mostrar_111<=9'h149;//I
			Mostrar_112<=9'h141;//A
			Mostrar_113<=9'h152;//R
			Mostrar_114<=9'h120;//ESP
			Mostrar_115<=9'h120;//ESP
			Mostrar_20<=9'h132;//2
			Mostrar_21<=9'h12E;//.
			Mostrar_22<=9'h150;//P
			Mostrar_23<=9'h141;//A
			Mostrar_24<=9'h152;//R
			Mostrar_25<=9'h141;//A
			Mostrar_26<=9'h152;//R
			Mostrar_27<=9'h120;//ESP
			Mostrar_28<=9'h130;//0
			Mostrar_29<=9'h12E;//.
			Mostrar_210<=9'h153;//S
			Mostrar_211<=9'h141;//A
			Mostrar_212<=9'h14C;//L
			Mostrar_213<=9'h149;//I
			Mostrar_214<=9'h152;//R
			Mostrar_215<=9'h120;//ESP			

			organico_time <= 2'b00;
			inorganico_time <= 2'b01;			
			
			zumbador_out <= 0;
				LEDFPGA [0] <= 0;
			led_out <= 0;
				LEDFPGA [1] <= 0;
			servo180_out = 0;
				LEDFPGA [2] <= 0;
			servo360_out <= 0;
				LEDFPGA [3] <= 0;
			sensor_out <= 0;
				LEDFPGA [4] <= 0;	
			
			if(mensaje == 1) begin
				inicio <= 2'b01;
				parar <= 2'b00;
				led_out <= 1;
					LEDFPGA [1] <= 1;
				servo360_out <= 1;
					LEDFPGA [3] <= 1;	
			end
			else if(mensaje == 2) begin
				inicio <= 2'b00;
				parar <= 2'b01;
				led_out <= 0;
					LEDFPGA [1] <= 0;
				servo360_out <= 0;
					LEDFPGA [3] <= 0;	
			end
//			else if(mensaje == 6) begin
//				status <= FINALIZO;
//			end
			else if (mensaje == 0) begin
				status <= CERRAR; //INICIO
			end	
			if((mostrar_cen == 9'h130) && (mostrar_dec == 9'h130) 
														&& (mostrar_uni == 9'h130)) begin
				status <= FINALIZO;
			end			
		
		end
		
		FINALIZO: begin
			//00000000000000000000000000000000 //32 casillas
			//El desinfectado termino 7.abrir		
			Mostrar_10<=9'h145;//E
			Mostrar_11<=9'h14C;//L
			Mostrar_12<=9'h120;//ESP
			Mostrar_13<=9'h144;//D
			Mostrar_14<=9'h145;//E
			Mostrar_15<=9'h153;//S
			Mostrar_16<=9'h149;//I
			Mostrar_17<=9'h14E;//N
			Mostrar_18<=9'h146;//F
			Mostrar_19<=9'h145;//E
			Mostrar_110<=9'h143;//C
			Mostrar_111<=9'h154;//T
			Mostrar_112<=9'h141;//A
			Mostrar_113<=9'h144;//D
			Mostrar_114<=9'h14F;//O
			Mostrar_115<=9'h120;//ESP
			Mostrar_20<=9'h154;//T
			Mostrar_21<=9'h145;//E
			Mostrar_22<=9'h152;//R
			Mostrar_23<=9'h14D;//M
			Mostrar_24<=9'h149;//I
			Mostrar_25<=9'h14E;//N
			Mostrar_26<=9'h14F;//O
			Mostrar_27<=9'h120;//ESP
			Mostrar_28<=9'h137;//7
			Mostrar_29<=9'h12E;//.
			Mostrar_210<=9'h141;//A
			Mostrar_211<=9'h142;//B
			Mostrar_212<=9'h152;//R
			Mostrar_213<=9'h149;//I
			Mostrar_214<=9'h152;//R
			Mostrar_215<=9'h120;//ESP		
		
			zumbador_out <= 1;
				LEDFPGA [0] <= 1;
			led_out <= 0;
				LEDFPGA [1] <= 0;
			servo180_out = 0;
				LEDFPGA [2] <= 0;
			servo360_out <= 0;
				LEDFPGA [3] <= 0;
			sensor_out <= 0;
				LEDFPGA [4] <= 0;		
		
			if(mensaje == 7) begin
				status <= ABRIR;
			end
			else if (mensaje == 0) begin
				status <= CERRAR; //INICIO
			end		
		
		end
		
		ABRIR: begin
			//00000000000000000000000000000000 //32 casillas
			//Presione 8.cerrar puerta	
			Mostrar_10<=9'h150;//P
			Mostrar_11<=9'h152;//R
			Mostrar_12<=9'h145;//E
			Mostrar_13<=9'h153;//S
			Mostrar_14<=9'h149;//I
			Mostrar_15<=9'h14F;//O
			Mostrar_16<=9'h14E;//N
			Mostrar_17<=9'h145;//E
			Mostrar_18<=9'h120;//ESP
			Mostrar_19<=9'h120;//ESP
			Mostrar_110<=9'h120;//ESP
			Mostrar_111<=9'h120;//ESP
			Mostrar_112<=9'h120;//ESP
			Mostrar_113<=9'h120;//ESP
			Mostrar_114<=9'h120;//ESP
			Mostrar_115<=9'h120;//ESP
			Mostrar_20<=9'h138;//8
			Mostrar_21<=9'h12E;//.
			Mostrar_22<=9'h143;//C
			Mostrar_23<=9'h145;//E
			Mostrar_24<=9'h152;//R
			Mostrar_25<=9'h152;//R
			Mostrar_26<=9'h141;//A
			Mostrar_27<=9'h152;//R
			Mostrar_28<=9'h120;//ESP
			Mostrar_29<=9'h150;//P
			Mostrar_210<=9'h155;//U
			Mostrar_211<=9'h145;//E
			Mostrar_212<=9'h152;//R
			Mostrar_213<=9'h154;//T
			Mostrar_214<=9'h141;//A
			Mostrar_215<=9'h120;//ESP		
		
			zumbador_out <= 0;
				LEDFPGA [0] <= 0;
			led_out <= 0;
				LEDFPGA [1] <= 0;
			servo180_out = 1;
				LEDFPGA [2] <= 1;
			servo360_out <= 0;
				LEDFPGA [3] <= 0;
			sensor_out <= 0;
				LEDFPGA [4] <= 0;		
		
			if(mensaje == 8) begin
				status <= CERRAR;
			end
			else if (mensaje == 0) begin
				status <= CERRAR; //INICIO
			end		
		
		end
		
		CERRAR: begin
			//00000000000000000000000000000000 //32 casillas
			//Gracias por desinfectar 9.salir
			Mostrar_10<=9'h147;//G
			Mostrar_11<=9'h152;//R
			Mostrar_12<=9'h141;//A
			Mostrar_13<=9'h143;//C
			Mostrar_14<=9'h149;//I
			Mostrar_15<=9'h141;//A
			Mostrar_16<=9'h153;//S
			Mostrar_17<=9'h120;//ESP
			Mostrar_18<=9'h150;//P
			Mostrar_19<=9'h14F;//O
			Mostrar_110<=9'h152;//R
			Mostrar_111<=9'h120;//ESP
			Mostrar_112<=9'h144;//D
			Mostrar_113<=9'h145;//E
			Mostrar_114<=9'h153;//S
			Mostrar_115<=9'h149;//I
			Mostrar_20<=9'h14E;//N
			Mostrar_21<=9'h146;//F
			Mostrar_22<=9'h145;//E
			Mostrar_23<=9'h143;//C
			Mostrar_24<=9'h154;//T
			Mostrar_25<=9'h141;//A
			Mostrar_26<=9'h152;//R
			Mostrar_27<=9'h120;//ESP
			Mostrar_28<=9'h139;//9
			Mostrar_29<=9'h12E;//.
			Mostrar_210<=9'h153;//S
			Mostrar_211<=9'h141;//A
			Mostrar_212<=9'h14C;//L
			Mostrar_213<=9'h149;//I
			Mostrar_214<=9'h152;//R
			Mostrar_215<=9'h120;//ESP		
			
			inicio <= 2'b00;
			parar <= 2'b00;			
				
			zumbador_out <= 0;
				LEDFPGA [0] <= 0;
			led_out <= 0;
				LEDFPGA [1] <= 0;
			servo180_out = 0;
				LEDFPGA [2] <= 0;
			servo360_out <= 0;
				LEDFPGA [3] <= 0;
			sensor_out <= 0;
				LEDFPGA [4] <= 0;				
				
			if(mensaje == 9) begin
				status <= INICIO;
			end		
			else if (mensaje == 0) begin
				status <= INICIO;
			end
		
		end
		
	endcase

end

LCD_TEST u5 (//Host Side
				.iCLK(CLOCK_50),
				.iRST_N(DLY_RST),
				 //LCD Side
				.LCD_DATA(LCD_DATA),
				.LCD_RW(LCD_RW),
				.LCD_EN(LCD_EN),
				.LCD_RS(LCD_RS),   
				.Mostrar_10(Mostrar_10),
				.Mostrar_11(Mostrar_11),
				.Mostrar_12(Mostrar_12),
				.Mostrar_13(Mostrar_13),
				.Mostrar_14(Mostrar_14),
				.Mostrar_15(Mostrar_15),
				.Mostrar_16(Mostrar_16),
				.Mostrar_17(Mostrar_17),
				.Mostrar_18(Mostrar_18),
				.Mostrar_19(Mostrar_19),
				.Mostrar_110(Mostrar_110),
				.Mostrar_111(Mostrar_111),
				.Mostrar_112(Mostrar_112),
				.Mostrar_113(Mostrar_113),
				.Mostrar_114(Mostrar_114),
				.Mostrar_115(Mostrar_115),
				.Mostrar_20(Mostrar_20),
				.Mostrar_21(Mostrar_21),
				.Mostrar_22(Mostrar_22),
				.Mostrar_23(Mostrar_23),
				.Mostrar_24(Mostrar_24),
				.Mostrar_25(Mostrar_25),
				.Mostrar_26(Mostrar_26),
				.Mostrar_27(Mostrar_27),
				.Mostrar_28(Mostrar_28),
				.Mostrar_29(Mostrar_29),
				.Mostrar_210(Mostrar_210),
				.Mostrar_211(Mostrar_211),
				.Mostrar_212(Mostrar_212),
				.Mostrar_213(Mostrar_213),
				.Mostrar_214(Mostrar_214),
				.Mostrar_215(Mostrar_215)
				);

endmodule 