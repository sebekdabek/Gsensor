module SEG7_LUT	(	oSEG,iDIG	); // param udostepniony, 
input	[3:0]	iDIG; // to co ma byc wyswietlone na wyswietlaczu
output	[6:0]	oSEG;
reg		[6:0]	oSEG;

always @(iDIG)
begin
		case(iDIG)
		4'h1: oSEG = 7'b1111001;	// ---1----
		4'h2: oSEG = 7'b0100100; 	// |	  |
		4'h3: oSEG = 7'b0110000; 	// 6	  2
		4'h4: oSEG = 7'b0011001; 	// |	  |
		4'h5: oSEG = 7'b0010010; 	// ---7----
		4'h6: oSEG = 7'b0000010; 	// |	  |
		4'h7: oSEG = 7'b1111000; 	// 5	  3
		4'h8: oSEG = 7'b0000000; 	// |	  |
		4'h9: oSEG = 7'b0011000; 	// ---4----
		4'ha: oSEG = 7'b1111111; // black screen 
		4'hb: oSEG = 7'b0100011; // dot at bottom
		4'hc: oSEG = 7'b1111111;
		4'hd: oSEG = 7'b1111111;
		4'he: oSEG = 7'b1111111;
		4'hf: oSEG = 7'b0111111; // minus
		4'h0: oSEG = 7'b1000000; // zero
		endcase
end

endmodule
