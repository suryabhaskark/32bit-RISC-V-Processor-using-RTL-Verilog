module ALU_Control (
    input      [1:0] ALUOp,       // From Control Logic
    input      [2:0] funct3,      // From instr[14:12]
    input      [6:0] funct7,      // From instr[31:25]
    output reg [4:0] alu_control  // Output to ALU
);

    always @(*) begin
        case (ALUOp)
            2'b00: alu_control = 5'b00000; // LW/SW: ADD
            2'b01: alu_control = 5'b00001; // Branch: SUB
            2'b10: begin  // R-type + M-extension
                case ({funct7, funct3})
                    // RV32I R-type
                    {7'b0000000, 3'b000}: alu_control = 5'b00000; // ADD
                    {7'b0100000, 3'b000}: alu_control = 5'b00001; // SUB
                    {7'b0000000, 3'b111}: alu_control = 5'b00010; // AND
                    {7'b0000000, 3'b110}: alu_control = 5'b00011; // OR
                    {7'b0000000, 3'b100}: alu_control = 5'b00100; // XOR
                    {7'b0000000, 3'b010}: alu_control = 5'b00101; // SLT
                    {7'b0000000, 3'b011}: alu_control = 5'b00110; // SLTU
                    {7'b0000000, 3'b001}: alu_control = 5'b00111; // SLL
                    {7'b0000000, 3'b101}: alu_control = 5'b01000; // SRL
                    {7'b0100000, 3'b101}: alu_control = 5'b01001; // SRA

                    // RV32M 
                    {7'b0000001, 3'b000}: alu_control = 5'b01010; // MUL
                    {7'b0000001, 3'b001}: alu_control = 5'b01011; // MULH
                    {7'b0000001, 3'b010}: alu_control = 5'b01100; // MULHSU
                    {7'b0000001, 3'b011}: alu_control = 5'b01101; // MULHU
                    {7'b0000001, 3'b100}: alu_control = 5'b01110; // DIV
                    {7'b0000001, 3'b101}: alu_control = 5'b01111; // DIVU
                    {7'b0000001, 3'b110}: alu_control = 5'b10000; // REM
                    {7'b0000001, 3'b111}: alu_control = 5'b10001; // REMU

                    default: alu_control = 5'b00000; // Default ADD
                endcase
            end

            2'b11: begin // I-type
                case (funct3)
                    3'b000: alu_control = 5'b00000; // ADDI
                    3'b111: alu_control = 5'b00010; // ANDI
                    3'b110: alu_control = 5'b00011; // ORI
                    3'b100: alu_control = 5'b00100; // XORI
                    3'b010: alu_control = 5'b00101; // SLTI
                    3'b011: alu_control = 5'b00110; // SLTIU
                    3'b001: alu_control = 5'b00111; // SLLI
                    3'b101: begin
                        if (funct7 == 7'b0000000)
                            alu_control = 5'b01000; // SRLI
                        else if (funct7 == 7'b0100000)
                            alu_control = 5'b01001; // SRAI
                        else
                            alu_control = 5'b00000; // Default
                    end
                    default: alu_control = 5'b00000; // Default ADD
                endcase
            end

            default: alu_control = 5'b00000; // Default ADD
        endcase
    end

endmodule
