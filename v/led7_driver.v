module led7_driver (iRSTN, iCLK, iDIG, iG_INT2, oHEX0, oHEX1, oHEX2, oHEX3, oHEX4, oHEX5);
input				       iRSTN;
input				       iCLK;
input		    [9:0]  iDIG;
input		           iG_INT2;
output	   [7:0]  oHEX0;
output	   [7:0]  oHEX1;
output	   [7:0]  oHEX2;
output	   [7:0]  oHEX3;
output	   [7:0]  oHEX4;
output	   [7:0]  oHEX5;

//=======================================================
//  REG/WIRE declarations
//=======================================================
reg [15:0] iTEMP; // 
reg [15:0] iDEG;
reg [3:0] N1;
reg [3:0] N2;
reg [3:0] N3;
reg [3:0] N4;
reg [3:0] N5;
reg [3:0] N6;

//=======================================================
//  Structural coding
//=======================================================

// output, input params
// inserting values from modules param1 to param2 variables
SEG7_LUT	u0	(	oHEX0,N1	);
SEG7_LUT	u1	(	oHEX1,N2	);
SEG7_LUT	u2	(	oHEX2,N3	);
SEG7_LUT	u3	(	oHEX3,N4	);
SEG7_LUT	u4	(	oHEX4,N5	);
SEG7_LUT	u5	(	oHEX5,N6	);

always@(posedge iCLK or negedge iRSTN)
	if (!iRSTN)
	begin
	end
	else
	begin
		if (iDIG<512) // tutaj liczba na pewno jest dodatnia
		begin
			iTEMP=iDIG;
			if (iTEMP>3)
			begin // dot at bottom
				N4<=11; // small box on the right
				N5<=10; // zero box in the middle
				N6<=10; // zero box on the left
			end
		end
		else
		begin
			iTEMP=1024-iDIG;
			if (iTEMP>3)
			begin
				N4<=10; //
				N5<=10; // 
				N6<=11; // 
			end
		end
		
		if (iTEMP<=3)
		begin
			N4<=10;
			N5<=11;
			N6<=10;		
		end;
		
		// Stopnie
		iDEG<=(90*iTEMP)/255; 
		
		// First digit 
		N1<=iDEG % 10;
		
		// Second digit on the 7segm 
		if (iDEG>=10)
			N2<=(iDEG / 10) % 10;
		else
			N2<=10;	
			
		N3<=10;
		
	end		
	
	assign oHEX0[7]=1;
	assign oHEX1[7]=1;
	assign oHEX2[7]=1;
	assign oHEX3[7]=1;
	assign oHEX4[7]=1;
	assign oHEX5[7]=1;

endmodule