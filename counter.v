
module counter(
              input               clk, 
              input               reset,
              input               enable,
              input       [25:0] compare, 
              output reg  [25:0] Q,
              output reg          out_enable
              
);
   
      always @(posedge clk or negedge reset)
      begin
        if (!reset) 
          Q <= 1'd0;
        else if(enable == 1)
          begin			
            if(Q == compare) 
              Q <= 1'd0; 
            else 
              Q <= Q + 1'b1;
          end
      end

		always@(posedge clk or negedge reset)
		begin
			if(!reset)
				out_enable  <=  1'b0;
			else if (enable == 1 && Q == compare)
				out_enable  <=	1'b1;
			else 
				out_enable  <=  1'b0;
		end
endmodule
