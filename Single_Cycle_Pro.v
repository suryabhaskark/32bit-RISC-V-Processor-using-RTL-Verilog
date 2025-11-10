`include "Instruction_mem.v"
`include "pc_module.v"
`include "immgen.v"
`include "Register_file.v"
`include "Control_Logic.v"
`include "ALU_Control.v"
`include "ALU.v"
`include "Data_Memory.v"


module Single_Cycle_Processor( 
  input clk, 
  input reset 
);
  
  // PC and Instruction
    wire [31:0] pc_curr;
    wire [31:0] instr;
    wire [31:0] next_pc;
  
  //Imm_gen output
  wire [31:0] imm_out;
  
   // Control signals
    wire Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite;
    wire [1:0] ALUOp;
  
  //Register file output
  wire [31:0] read_data1, read_data2;
  
  // ALU control and result
    wire [4:0] alu_control;
    wire [31:0] alu_srcB, alu_result;
    wire zero;
  	wire less;
  
  // Data memory
  wire [31:0] read_data, data_mux_out;
  
  // Branch target, PCSrc and Jump
    wire [31:0] branch_target;
    wire PCSrc;
  	wire Jump;
    wire [31:0] pc_plus_4 = pc_curr + 4;
	wire [31:0] jump_target;
  
  pc PC_int(
    .clk(clk),
    .reset(reset),
    .branch_target(branch_target),
    .jump_target(jump_target),
    .PCSrc(PCSrc),
    .Jump(Jump),
    .pc_curr(pc_curr)
  );
  
  InstructionMemory imm_int(
    .PC(pc_curr),
    .instr(instr)
  );
  
  Control_Logic conlog_int(
    .opcode(instr[6:0]),
    .Branch(Branch),
    .MemRead(MemRead),
    .MemtoReg(MemtoReg),
    .ALUOp(ALUOp),
    .MemWrite(MemWrite),
    .ALUSrc(ALUSrc),
    .RegWrite(RegWrite),
    .Jump(Jump)
  );
  
  ImmGen immgen_int(
    .instr(instr),
    .imm(imm_out)
  );
  
  //Data memory Mux
  assign data_mux_out = (Jump) ? pc_plus_4 :
                      (MemtoReg ? read_data : alu_result);
  
  Register_File reg_int(
    .clk(clk),
    .reset(reset),
    .reg_write_en(RegWrite),   
    .reg_write_dest(instr[11:7]), 
    .reg_write_data(data_mux_out),  
    .reg_read_addr_1(instr[19:15]), 
    .reg_read_addr_2(instr[24:20]),
    .reg_read_data_1(read_data1),
    .reg_read_data_2(read_data2)
  );
  
  
  ALU_Control alucont_int(
    .ALUOp(ALUOp),
    .funct3(instr[14:12]),
    .funct7(instr[31:25]),
    .alu_control(alu_control)
  );
  
  // ALU Source MUX
  assign alu_srcB = (ALUSrc) ? imm_out : read_data2;
  
  ALU alu_int(
    .srcA(read_data1),
    .srcB(alu_srcB),
    .alu_control(alu_control),
    .alu_result(alu_result),
    .zero(zero),
    .less(less)
  );
  
  Data_Memory datamem_int(
    .clk(clk),
    .memRead(MemRead),
    .memWrite(MemWrite),
    .address(alu_result),
    .writeData(read_data2),
    .readData(read_data)
  );
  
  // Branch Target Calculation
  assign branch_target = pc_curr + $signed(imm_out);
  
  assign jump_target = (instr[6:0] == 7'b1100111) ?   // JALR
                     ((read_data1 + $signed(imm_out)) & ~32'b1) :
                     (pc_curr + $signed(imm_out));  // JAL

  
  // Branch Decision Logic
  assign PCSrc = Branch & (
    (instr[14:12] == 3'b000 && zero) ||             // beq
    (instr[14:12] == 3'b001 && !zero) ||            // bne
    (instr[14:12] == 3'b100 && less) ||  // blt
    (instr[14:12] == 3'b101 && !less)      // bge
);
  

assign next_pc = Jump ? jump_target : (PCSrc ? branch_target : pc_plus_4);


endmodule