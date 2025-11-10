module InstructionMemory #( 
  parameter DATA_WIDTH = 32, 
  parameter ADDR_WIDTH = 8 )
  (
   input [31:0] PC, 
   output reg [DATA_WIDTH-1:0] instr ); 
  
  localparam MEM_SIZE = 2 ** ADDR_WIDTH; 
  reg [DATA_WIDTH-1:0] memory [0:MEM_SIZE-1]; // ROM 
  
  initial begin
    $readmemb("test.prog.txt", memory);
end

  always @(*) 
    begin 
      instr = memory[PC[ADDR_WIDTH+1:2]]; 
    end 
endmodule