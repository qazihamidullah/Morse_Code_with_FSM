//the top file of Morse code with FSM

module Task4 (
			input CLOCK_50,
			input [1:0] KEY,
        //input clk,
        //input reset,
        //input start,            //when start the morse code will display
        input [2:0] SW,         //for inputting letters 
        output reg [0:0] LEDR

);
    wire          clk;
    wire          reset;
    wire          start;
    wire          dot, dot_en;             //when high next-state will be S1
    wire          dash, dash_en;            //when high next_state will be S2
    wire          full_pause;      //finish display and go to idle state
    wire [25:0]   dot_slow_out, dash_slow_out;
    wire [3:0]    symbol_out;
    wire [3:0]    mask_out;
    wire [3:0]    letter_shifted;
    wire [3:0]    mask_shifted;
    reg          do_shift;
    wire          slow_counter_enable;    //comes from 3 bit counter
    wire          dot_count_complete;         //comes from dot counter
    wire          dash_count_complete;         //comes from dash counter
   
   
    assign clk   = CLOCK_50;
    assign reset = KEY[0];
    assign start = ~KEY[1];         //to display the Morse code
    


      //selecting among the eight letters 
    symbol_select symbol_select_inst(
                                  .in(SW[2:0]),
                                  .symbol_out(symbol_out)
    );

    //selecting mask code for the specific letter 
    mask_select mask_select_inst(
                              .in(SW[2:0]),
                              .mask_out(mask_out)
    );

    
    //shift register for letters
    shift_register shift_reg_inst1(
                            .clk  (clk)           ,
                            .reset(reset)         ,
                            .ld   (start)         ,             // load new value
                            .in   (symbol_out)    ,     
                            .shift(do_shift)      ,          //when enable it wil do right shift
                            .out  (letter_shifted)    
    );

    //shift register for mask code
    shift_register shift_reg_inst2(
                            .clk  (clk)           ,
                            .reset(reset)         ,
                            .ld   (start)         ,             // load new value
                            .in   (mask_out)      ,     
                            .shift(do_shift)      ,          //when enable it wil do right shift
                            .out  (mask_shifted)    
    );

//for 0.5 seconds display we should use 25000 000
    counter slow_counter(
                        .clk(clk), 
                        .reset(reset),
                        .enable(dot_en),
                        .compare(25000000), //GENERATE 0.5 SECONDS DELAY
                        .Q(dot_slow_out),
                        .out_enable(dot_count_complete)            //goes in the enable of three bit counter  
    );


    //for 1.5 seconds display we should use 75000 000
    counter slow_counter1(
                        .clk(clk), 
                        .reset(reset),
                        .enable(dash_en),
                        .compare(75000000), //GENERATE 1.5 SECONDS DELAY
                        .Q(dash_slow_out),
                        .out_enable(dash_count_complete)            //goes in the enable of three bit counter  
    );

      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      ///////////////////////////////    FSM   //////////////////////////////////////////////////////////////
      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      ///////////////////////////////////////////////////////////////////////////////////////////////////////

    //state variables
    reg [1:0] state, next_state;  

    parameter S0 = 2'b00;             //idle state
    parameter S1 = 2'b01;             //dot state
    parameter S2 = 2'b10;             //dash state
    parameter S3 = 2'b11;             //pause state

    //some assignments 
   assign dot = mask_shifted[0] && !letter_shifted[0];    //to go to state S1
   assign dash = mask_shifted[0] && letter_shifted[0];    //to go to state S2
   assign  full_pause = ~mask_shifted[0];                 //to go to idle state finished S0




    //next state logic
    always @(*) begin
      case (state)
        S0:       begin     
                  if(dot)
                    next_state = S1;   //dot state
                  else if(dash)
                    next_state = S2;   //dash state
                  else
                    next_state = S0;   //idle state
        end
        S1:      begin
                if(dot_count_complete)
                  next_state = S3;     //pause state
                else 
                  next_state = S1;     //dot state
        end        
        S2:     begin
                if(dash_count_complete)
                  next_state = S3;     //pause state
                else 
                  next_state = S2;     //dash state
        end        
        S3:     begin
                if(dot_count_complete && dot)
                  next_state = S1;     //dot state
                else if(dot_count_complete && dash)
                  next_state = S2;     //dash state
                else if(dot_count_complete )
                  next_state = S0;     //idle state
                else
                  next_state = S3;      //pause state
        end
        default: next_state = S0;       //idle state
      endcase
    end


    //state register 
    always @ (posedge clk or negedge reset) begin
      if(!reset)
        state <= S0;
      else
        state <= next_state;
    end

      //controlling do_shift of the shift registers 
      always @(*) begin
        case (state)
          S0:         do_shift = 0;
          S1:         do_shift = (next_state == S3) ? 1 :0;      //shift when pause state is the next state
          S2:         do_shift = (next_state == S3) ? 1 :0; 
          default:    do_shift = 0;
        endcase
      end

      assign  dot_en  =   (state==S1) || (state==S3);
      assign  dash_en  =   (state==S2) ;
      

     



    //output logic
    always @(*) begin
      case(state)
      S0:       LEDR[0] = 1'b0;     //off led 
      S1:       LEDR[0] = 1'b1;     //on led
      S2:       LEDR[0] = 1'b1;     //on led
      S3:       LEDR[0] = 1'b0;     //off led 
      default:  LEDR[0] = 1'b0;     //off led
      endcase
    end

endmodule
