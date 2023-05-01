//testbench

module tb();

  reg clk, reset, start;
  reg [2:0] sw;
  wire LEDR;

  Task4 Task4_inst(
            .clk(clk),
            .reset(reset),
            .start(start),            //when start the morse code will display
            .SW(sw),               //for inputting letters 
            .LEDR(LEDR)
);

    initial begin
       #0
       clk = 0;
       reset = 0;
       start = 0;
       sw = 3'b000;

       #10
       reset = 1;
       start = 1;

       #10
       start = 0;

       #1000000
       $stop();
    end

    always
    #10
    clk = ~clk;

endmodule
