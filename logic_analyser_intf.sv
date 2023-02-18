//interface  logic_analyser(input clk, rst);
`define STATE0 SOP
`define STATE1 CMD 
`define STATE2 ADDR
`define STATE3 DATA
`define STATE_DEFAULT DEFAULT
`define STATE0_BITS 1
`define STATE1_BITS 8
`define STATE2_BITS 8*3
`define STATE3_BITS 8*4
interface logic_analyser(input clk,input rst,input in);
parameter NUM_STATES = 4;
parameter NUM_INPUTS = 1;

//bit clk,rst,start;
int i;
//TESTinitial begin
//TEST   repeat(10) @(posedge clk); 
//TEST   repeat (30) begin 
//TEST      @(posedge clk)
//TEST         in = $urandom_range(1,0);
//TEST   end
//TEST   #10 $finish();
//TESTend
//TESTinitial begin
//TEST   #10 rst = 1;
//TEST   forever #10 clk =~clk;
//TESTend

// define the inputs and outputs
//input [NUM_INPUTS-1:0] inputs;
//output [NUM_STATES-1:0] outputs;
reg [NUM_INPUTS-1:0] inputs;
bit [31:0] out;
bit [31:0] result;
bit [31:0] final_result;
// define the state and next state registers
typedef enum bit [127:0] {`STATE_DEFAULT=0,`STATE0=1,`STATE1=2,`STATE2=3,`STATE3=4} fsm_state_e;
//reg [NUM_STATES-1:0] state, next_state;
fsm_state_e state, next_state;


always @(state ) 
begin
   case(state)
      
      `STATE0: begin
         repeat(`STATE0_BITS)  begin
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
         repeat(`STATE1_BITS)  begin
            $display ("dbg0: out %b in %b i %0d ",out,in,i);
            out  =  in<<i| out ; 
            result[`STATE1_BITS-1:0] = {<<{out[`STATE1_BITS-1:0]}}; 
            $display ("dbg1: out %b in %b i %0d ",out,in,i);
            if(i ==`STATE1_BITS-1) final_result <= result;
            $display ($time," Inside %s val out:%0b %h in:%0b",`STATE1,out,out,in);
            @(posedge clk);
            i++;
         end
         $display (" changing the state ");
         next_state = `STATE2;
         out = 0;i=0;result = 0;final_result =0;
      end
      `STATE2: begin
         i=0;
         $display ($time," Inside state2");
         repeat(`STATE2_BITS) begin
           // $display ("dbg0: out %b in %b i %0d ",out,in,i);
            out  =  in<<i| out ;
            result[`STATE2_BITS-1:0] = {<<{out[`STATE2_BITS-1:0]}}; 
           // $display ("dbg1: out %b in %b i %0d ",out,in,i);
            if(i ==`STATE2_BITS-1) final_result <= result;
            $display ($time," Inside %s val out:%0b %h in:%0b",`STATE2,out,out,in);
            @(posedge clk);
            i++;
         end
         $display (" changing the state ");
         next_state = `STATE3;
         out = 0;i=0;result = 0;final_result =0;
      end
      `STATE3: begin
         i=0;
         $display ($time," Inside state3");
         repeat(`STATE3_BITS)  begin
            out  = out | in<<i; 
            result[`STATE3_BITS-1:0] = {<<{out[`STATE3_BITS-1:0]}}; 
            if(i ==`STATE3_BITS-1) final_result <= result;
            $display ($time," Inside %s val out:%0b %h in:%0b",`STATE3,out,out,in);
            @(posedge clk);
            i++;
         end
         next_state = `STATE_DEFAULT;
         out = 0;i=0;result = 0;final_result =0;
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

endinterface
