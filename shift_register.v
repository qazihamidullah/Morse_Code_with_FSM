//making a shift register 

module shift_register(
              input             clk,
              input             reset,
              input             ld,             // load new value
              input       [3:0] in,
              input             shift,          //when enable it wil do right shift
              output  reg [3:0] out
);

    always @(posedge clk or negedge reset) begin 
      if(~reset)
        out <= 0;
      else if(ld) 
        out <=  in;
      else if(shift)
        out <= out >>1;
    end

endmodule
