//interface  logic_analyser(input clk, rst);
`define STATE0 SOP
`define STATE1 CMD 
`define STATE2 ADDR
`define STATE3 EOF
`define STATE_DEFAULT DEFAULT
module top();
parameter NUM_STATES = 4;
parameter NUM_INPUTS = 1;

bit clk,rst,start;
int i;
bit in = 1;
initial begin
   repeat(10) @(posedge clk); 
   repeat (30) begin 
      @(posedge clk)
         in = $urandom_range(1,0);
   end
   #10 $finish();
end
initial begin
   #10 rst = 1;
   forever #10 clk =~clk;
end

// define the inputs and outputs
//input [NUM_INPUTS-1:0] inputs;
//output [NUM_STATES-1:0] outputs;
reg [NUM_INPUTS-1:0] inputs;
bit [31:0] out;

// define the state and next state registers
typedef enum bit [127:0] {`STATE_DEFAULT=0,`STATE0=1,`STATE1=2,`STATE2=3,`STATE3=4} fsm_state_e;
//reg [NUM_STATES-1:0] state, next_state;
fsm_state_e state, next_state;


always @(state ) 
begin
   case(state)
      
      `STATE0: begin
         repeat(1)  begin
            out  = out | in<<i;
            $display ($time," Inside %s val out:%0b %h in:%0b",`STATE0,out,out,in);
            i++;
            //@(posedge clk);
         end
         next_state = `STATE1;
         out = 0;i=0;
      end
      `STATE1: begin
         i=0;
         $display ($time," Inside state1");
         repeat(8)  begin
            out[0:7]  = out[0:7] | in<<i; 
            $display ($time," Inside %s val out:%0b %h in:%0b",`STATE1,out,out,in);
            @(posedge clk);
            i++;
         end
         $display (" changing the state ");
         next_state = `STATE2;
         out = 0;i=0;
      end
      `STATE2: begin
         i=0;
         $display ($time," Inside state2");
         repeat(4) begin
            out[0:3]  = out[0:3] | in<<i; 
            $display ($time," Inside %s val out:%0b %h in:%0b",`STATE2,out,out,in);
            @(posedge clk);
            i++;
         end
         $display (" changing the state ");
         next_state = `STATE3;
         out = 0;i=0;
      end
      `STATE3: begin
         i=0;
         $display ($time," Inside state3");
         repeat(2)  begin
            out  = out | in<<i; 
            $display ($time," Inside %s val out:%0b %h in:%0b",`STATE3,out,out,in);
            @(posedge clk);
            i++;
         end
         next_state = `STATE_DEFAULT;
         out = 0;i=0;
         start = 0;
      end

   endcase
end

always @(posedge clk)
begin
   if (!rst ) begin 
      state  <=`STATE_DEFAULT; 
      $display ($time," Inside rst state ");
   end
   else if (state==`STATE_DEFAULT ) begin
      @(negedge in);
      state <=`STATE0;
      $display ($time," Got the negedge ");
   end
   else begin
      state <= next_state;
      //$display ($time," Inside next_state %s",state);
   end
end
always @(posedge clk) begin
//   if (!in) start = 1;
end

endmodule
