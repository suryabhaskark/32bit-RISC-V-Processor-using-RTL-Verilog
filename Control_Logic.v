module Control_Logic (
    input  [6:0] opcode,
    output reg Branch,
    output reg MemRead,
    output reg MemtoReg,
    output reg [1:0] ALUOp,
    output reg MemWrite,
    output reg ALUSrc,
    output reg RegWrite,
    output reg Jump
);
    // Opcode mapping
    localparam OPCODE_R_TYPE = 7'b0110011;
    localparam OPCODE_I_TYPE = 7'b0010011;  
    localparam OPCODE_LOAD   = 7'b0000011;  
    localparam OPCODE_STORE  = 7'b0100011;  
    localparam OPCODE_BRANCH = 7'b1100011;
    localparam OPCODE_LUI    = 7'b0110111;
    localparam OPCODE_AUIPC  = 7'b0010111;
    localparam OPCODE_JAL    = 7'b1101111;
    localparam OPCODE_JALR   = 7'b1100111;

    always @(*) begin
        // Default Initial values
        Branch   = 0;
        MemRead  = 0;
        MemtoReg = 0;
        ALUOp    = 2'b00;
        MemWrite = 0;
        ALUSrc   = 0;
        RegWrite = 0;
        Jump     = 0;

        case (opcode)
            OPCODE_R_TYPE: begin
                RegWrite = 1;
                ALUOp    = 2'b10; // for R-type, ALU control decides actual op
                ALUSrc   = 0;
            end

            OPCODE_I_TYPE: begin
                RegWrite = 1;
                ALUOp    = 2'b11; // ALU immediate ops
                ALUSrc   = 1;
            end

            OPCODE_LOAD: begin
                RegWrite = 1;
                MemRead  = 1;
                MemtoReg = 1;
                ALUSrc   = 1;
                ALUOp    = 2'b00; // usually just add base + imm
            end

            OPCODE_STORE: begin
                MemWrite = 1;
                ALUSrc   = 1;
                ALUOp    = 2'b00; // store: address calculation (base+offset)
            end

            OPCODE_BRANCH: begin
                Branch   = 1;
                ALUOp    = 2'b01; // branch uses ALU to compare rs1 and rs2
            end

            OPCODE_LUI, OPCODE_AUIPC: begin
                RegWrite = 1;
                ALUSrc   = 1; // immediate type operation
                ALUOp    = 2'b00;
            end

            OPCODE_JAL: begin
                RegWrite = 1;
                ALUSrc   = 0;
                ALUOp    = 2'b00;
                Jump     = 1;
            end
          
          OPCODE_JALR: begin
                RegWrite = 1;
                ALUSrc   = 1;
                ALUOp    = 2'b00;
                Jump     = 1;
            end

            default: begin
                // NOP 
            end
        endcase
    end
endmodule
