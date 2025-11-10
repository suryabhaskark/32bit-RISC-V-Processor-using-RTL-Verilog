`timescale 1ns/1ns

module tb_Single_Cycle_Processor;
  
  reg clk;
  reg reset;
  
  Single_Cycle_Processor DUT(
    .clk(clk),
    .reset(reset)
  );
  
  initial clk =0;
  always #5 clk = ~clk;
  
  initial begin
    
    reset=1;
    
    #20 reset=0;
    
    #500;
    $finish;
  end


   initial begin
     $monitor("Time=%0t | PC=%h | Next_PC=%h | Instr=%b | Imm=%d | ALU=%d | Zero=%b | PCSrc=%b | BT=%h | x1=%d | x2=%d |",
             $time,
             DUT.pc_curr,
              DUT.next_pc,
             DUT.instr,
             $signed(DUT.imm_out),
             $signed(DUT.alu_result),
             DUT.zero,
             DUT.PCSrc,
             DUT.branch_target,
             DUT.reg_int.reg_array[1],
             DUT.reg_int.reg_array[2]);
  end




             
endmodule
  