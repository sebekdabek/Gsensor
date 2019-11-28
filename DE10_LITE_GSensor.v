// ============================================================================
// Copyright (c) 2016 by Terasic Technologies Inc.
// ============================================================================
//
// Permission:
//
//   Terasic grants permission to use and modify this code for use
//   in synthesis for all Terasic Development Boards and Altera Development 
//   Kits made by Terasic.  Other use of this code, including the selling 
//   ,duplication, or modification of any portion is strictly prohibited.
//
// Disclaimer:
//
//   This VHDL/Verilog or C/C++ source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods.  Terasic provides no warranty regarding the use 
//   or functionality of this code.
//
// ============================================================================
//           
//  Terasic Technologies Inc
//  9F., No.176, Sec.2, Gongdao 5th Rd, East Dist, Hsinchu City, 30070. Taiwan
//  
//  
//                     web: http://www.terasic.com/  
//                     email: support@terasic.com
//
// ============================================================================
//Date:  Wed May 11 09:51:57 2016
// ============================================================================

module DE10_LITE_GSensor(

	//////////// CLOCK //////////
	input 		          		ADC_CLK_10,
	input 		          		MAX10_CLK1_50,
	input 		          		MAX10_CLK2_50,

	//////////// SDRAM //////////
	output		    [12:0]		DRAM_ADDR,
	output		     [1:0]		DRAM_BA,
	output		          		DRAM_CAS_N,
	output		          		DRAM_CKE,
	output		          		DRAM_CLK,
	output		          		DRAM_CS_N,
	inout 		    [15:0]		DRAM_DQ,
	output		          		DRAM_LDQM,
	output		          		DRAM_RAS_N,
	output		          		DRAM_UDQM,
	output		          		DRAM_WE_N,

	//////////// KEY //////////
	input 		     [1:0]		KEY,

	//////////// LED //////////
	output		     [9:0]		LEDR,

		//////////// SEG7 //////////
	output		     [7:0]		HEX0,
	output		     [7:0]		HEX1,
	output		     [7:0]		HEX2,
	output		     [7:0]		HEX3,
	output		     [7:0]		HEX4,
	output		     [7:0]		HEX5,
	
	//////////// SW //////////
	input 		     [9:0]		SW,

	//////////// VGA //////////
	output		     [3:0]		VGA_B,
	output		     [3:0]		VGA_G,
	output		          		VGA_HS,
	output		     [3:0]		VGA_R,
	output		          		VGA_VS,

	//////////// Accelerometer //////////
	output		          		GSENSOR_CS_N,
	input 		     [2:1]		GSENSOR_INT,
	output		          		GSENSOR_SCLK,
	inout 		          		GSENSOR_SDI,
	inout 		          		GSENSOR_SDO,

	//////////// Arduino //////////
	inout 		    [15:0]		ARDUINO_IO,
	inout 		          		ARDUINO_RESET_N
);

//=======================================================
//  REG/WIRE declarations
//=======================================================
wire	        dly_rst;
wire	        spi_clk, spi_clk_out;
wire	[15:0]  data_x;
reg  [15:0]  zero;

//=======================================================
//  Structural coding
//=======================================================


always@(negedge KEY[1])
	zero<=data_x;
	
//	Reset opoznienie
reset_delay	u_reset_delay	(	
            .iRSTN(KEY[0]),
            .iCLK(MAX10_CLK1_50),
            .oRST(dly_rst));

//  PLL            
spi_pll     u_spi_pll	(
            .areset(dly_rst),
            .inclk0(MAX10_CLK1_50),
            .c0(spi_clk),      // 2MHz
            .c1(spi_clk_out)); // 2MHz phase shift 

//  Initial Setting and Data Read Back konfiguracja i obsluga magistali SPI
spi_ee_config u_spi_ee_config (			
						.iRSTN(!dly_rst), // reset, ogolny reset wchodzi do kazdego bloczku														
						.iSPI_CLK(spi_clk),								
						.iSPI_CLK_OUT(spi_clk_out),	// dwa zegary z czego jeden przesuniety fazowo, jeden zegar dla magistrali a druga przesunieta o ulamek fazy jest logika bloczku. 						
						.iG_INT2(GSENSOR_INT[1]),    // sygnal przerwania (ale nie wykorzystywany jako taki), sygnal gotowosci     
						.oDATA_L(data_x[7:0]), 
						.oDATA_H(data_x[15:8]),
						.SPI_SDIO(GSENSOR_SDI), // wyjscie z FPGA wejscie do sensora (wejscie-wyjscie) nie wykorzystujemy, ale musi byc
						.oSPI_CSN(GSENSOR_CS_N), // SS - chip select
						.oSPI_CLK(GSENSOR_SCLK)); // zegar wysylany do gsensora zegar magistrali SPI
			
//	LED
led_driver u_led_driver	(	
						.iRSTN(!dly_rst),
						.iCLK(MAX10_CLK1_50),
						.iDIG(data_x[9:0]-zero[9:0]),
						.iG_INT2(GSENSOR_INT[1]),            
						.oLED(LEDR));

// 7SEG
led7_driver u_led7_driver	(	
						.iRSTN(!dly_rst),
						.iCLK(MAX10_CLK1_50),
						.iDIG(data_x[9:0]-zero[9:0]),
						.iG_INT2(GSENSOR_INT[1]),            
						.oHEX0(HEX0),
						.oHEX1(HEX1),
						.oHEX2(HEX2),
						.oHEX3(HEX3),
						.oHEX4(HEX4),
						.oHEX5(HEX5));




endmodule
