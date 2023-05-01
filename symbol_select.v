//symbol and mask code selection logic 

module symbol_select(
                  input [2:0] in,
                  output reg [3:0] symbol_out
);

    always @ (*) begin

      case(in) 
        3'b000:      symbol_out = 4'b0010;    //A morse code 
        3'b001:      symbol_out = 4'b0001;    //B morse code
        3'b010:      symbol_out = 4'b0101;    //C morse code
        3'b011:      symbol_out = 4'b0001;    //D morse code
        3'b100:      symbol_out = 4'b0000;    //E morse code
        3'b101:      symbol_out = 4'b0100;    //F morse code
        3'b110:      symbol_out = 4'b0011;    //G morse code
        3'b111:      symbol_out = 4'b0000;    //H morse code
        default:     symbol_out = 4'b1111;
      endcase

    end

endmodule 


