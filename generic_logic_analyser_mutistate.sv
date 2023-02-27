// Code your testbench here
// or browse Examples
module top();

  parameter  [3:0] state_table[3:0] = '{
    {3,0},
    {2,3},
    {1,2},
    {0,1}
  }; 
  bit [3:0]foo[3:0];// [0:1][0:2];
  bit [3:0]wait_table[3:0];// [0:1][0:2];
  int q[$],i;
  bit[4:0] state,next_state;
  bit clk,rst;
  bit [31:0] out;
  bit [31:0] result;
  bit [31:0] final_result;
  bit in; 
initial begin
   repeat(10) @(posedge clk); 
   rst = 1;
   repeat (30) begin 
      @(posedge clk)
         in = $urandom_range(1,0);
   end
   #10 $finish();
end

  initial begin
     forever #10 clk =~clk;
  end
  always @(clk) begin
     repeat (wait_table[state]) begin
       // @(posedge clk);
        out  =  in<<i| out ; 
        result[3:0] = {<<{out[3:0]}}; 
        $display ("dbg1: out %b in %b i %0d ",out,in,i);
        if(i ==(wait_table[state]-1)) final_result = result;
        @(posedge clk);
        $display ($time," Inside %s val out:%0b %h in:%0b final_result %0b",state,out,out,in,final_result);
        i++;
     end
     next_state = foo[state];
     $display (" next_state %0d state %0d",next_state,state);
     final_result =0;out = 0;result = 0;
        i=0;
  end
  always @(posedge clk) begin
     if (rst==0) begin
        next_state = 0;
        $display (" rst state %d next_state %d",state,next_state);
     end
     else begin
        state = next_state;
        $display (" state %d next_state %d",state,next_state);
     end 
  end
  
  initial 
    begin
      foo =state_table;
      foreach(foo[i]) begin
        //foo[i]=i+1;
        $display (" foo %p",foo);
      end
      foreach (wait_table[j]) begin
         wait_table[j] = 4;
      end
    end
endmodule
