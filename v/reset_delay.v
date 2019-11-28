module	reset_delay(iRSTN, iCLK, oRST);
input		    iRSTN;
input		    iCLK;
output reg	oRST;

reg  [20:0] cont; 

always @(posedge iCLK or negedge iRSTN)
  
  // reset applied
  if (!iRSTN) 
  begin
    cont     <= 21'b0; 
    oRST     <= 1'b1;
  end
  
  
  else if (!cont[20]) // cont[20] = 0; 
  begin
    cont <= cont + 21'b1; // cont++;
    oRST <= 1'b1; // oRST = 1;
  end
  
  // cont[20] = 1
  else
    oRST <= 1'b0;
  
endmodule
