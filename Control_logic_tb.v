`timescale 1ns/1ps

module Control_Logic_tb;

    reg [6:0] opcode;
    wire Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite;
    wire [1:0] ALUOp;

    Control_Logic DUT (
        .opcode(opcode),
        .Branch(Branch),
        .MemRead(MemRead),
        .MemtoReg(MemtoReg),
        .ALUOp(ALUOp),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite)
    );

    initial begin
        //$dumpfile("Control_Logic_tb.vcd");
        //$dumpvars(0, Control_Logic_tb);


        opcode = 7'b0110011; // R-type
        #10;
        opcode = 7'b0010011; // I-type
        #10;
        opcode = 7'b0000011; // Load
        #10;
        opcode = 7'b0100011; // Store
        #10;
        opcode = 7'b1100011; // Branch
        #10;
        opcode = 7'b0110111; // LUI
        #10;
        opcode = 7'b0010111; // AUIPC
        #10;
        opcode = 7'b1101111; // JAL
        #10;
        opcode = 7'b1100111; // JALR
        #10;

        $finish;
    end

endmodule

