module ALU (
    input  [31:0] srcA,     // Operand 1 (rs1)
    input  [31:0] srcB,       // Operand 2 (rs2 or immediate)
    input  [4:0]  alu_control,  // From ALU_Control
    output reg [31:0] alu_result,
    output        zero,   // For branch decisions
  output        less
);
	
    wire signed [31:0] sA = srcA;
    wire signed [31:0] sB = srcB;
    wire signed   [63:0] signed_mul = sA * sB;
    wire         [63:0] unsigned_mul = srcA * srcB;
	wire signed [63:0] mixed_mul    = sA * $signed({1'b0,srcB});
  assign zero = (srcA == srcB);
  assign less = (sA < sB);

  
    always @(*) begin
        case (alu_control)
            5'b00000: alu_result = srcA + srcB; // ADD / ADDI / LW/SW
            5'b00001: alu_result = srcA - srcB;     // SUB / Branch compare
            5'b00010: alu_result = srcA & srcB;  // AND / ANDI
            5'b00011: alu_result = srcA | srcB;   // OR / ORI
            5'b00100: alu_result = srcA ^ srcB;    // XOR / XORI
            5'b00101: alu_result = (sA < sB) ? 32'b1 : 32'b0;  // SLT / SLTI (signed)
            5'b00110: alu_result = (srcA < srcB) ? 32'b1 : 32'b0; // SLTU / SLTIU (unsigned)
            5'b00111: alu_result = srcA << srcB[4:0];         // SLL / SLLI
            5'b01000: alu_result = srcA >> srcB[4:0];         // SRL / SRLI
            5'b01001: alu_result = sA >>> srcB[4:0];         // SRA / SRAI

            // RV32M Extension
            5'b01010: alu_result = signed_mul[31:0];                     // MUL
            5'b01011: alu_result = signed_mul[63:32];                  // MULH (signed × signed, upper 32)
            5'b01100: alu_result = mixed_mul[63:32];    // MULHSU (signed × unsigned)
            5'b01101: alu_result = unsigned_mul[63:32];           // MULHU (unsigned × unsigned)
            5'b01110: alu_result = (srcB != 0) ? sA / sB : 32'hFFFFFFFF;  // DIV (signed)
            5'b01111: alu_result = (srcB != 0) ? srcA / srcB : 32'hFFFFFFFF; // DIVU (unsigned)
            5'b10000: alu_result = (srcB != 0) ? sA % sB : sA;            // REM (signed)
            5'b10001: alu_result = (srcB != 0) ? srcA % srcB : srcA;      // REMU (unsigned)

            default:  alu_result = 32'b0;
        endcase
    end

endmodule
