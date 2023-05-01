//setting mask code for the letters so that we can identify which one are valid

module mask_select (
                  input [2:0] in,
                  output reg [3:0] mask_out
);
  
  always @ (*) begin
    case(in)       //1 shows valid bits while the 0 shows invalid bits
        3'b000:      mask_out = 4'b0011;    //A morse code 
        3'b001:      mask_out = 4'b1111;    //B morse code
        3'b010:      mask_out = 4'b1111;    //C morse code
        3'b011:      mask_out = 4'b0111;    //D morse code
        3'b100:      mask_out = 4'b0001;    //E morse code
        3'b101:      mask_out = 4'b1111;    //F morse code
        3'b110:      mask_out = 4'b0111;    //G morse code
        3'b110:      mask_out = 4'b1111;    //H morse code
        default:     mask_out = 4'b1111;
    endcase
  end
endmodule
