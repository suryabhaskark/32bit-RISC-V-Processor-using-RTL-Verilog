`timescale 1ns/1ps

module ImmGen_tb;
    reg [31:0] instr;
    wire [31:0] imm;

    ImmGen DUT (
        .instr(instr),
        .imm(imm)
    );

    initial begin

        //$dumpfile("immgen.vcd");
        //$dumpvars(0, ImmGen_tb);

        // Test I-type (addi)
        instr = 32'b000000000101_00001_000_00010_0010011; // addi x2, x1, 5
        #10;

        // Test Load (lw)
        instr = 32'b000000001010_00001_010_00011_0000011; // lw x3, 10(x1)
        #10;

        // Test Store (sw)
        instr = 32'b0000000_00101_00001_010_00010_0100011; // sw x5, 2(x1)
        #10;

        // Test Branch (beq)
        instr = 32'b1_000000_00010_00001_000_00000_1100011; // beq x1, x2, offset
        #10;

        // Test LUI
        instr = 32'b10101010101010101010_00001_0110111; // LUI x1, 0xAAAAA
        #10;

        // Test AUIPC
        instr = 32'b10101010101010101010_00001_0010111; // AUIPC x1, 0xAAAAA
        #10;

        // Test JAL
        instr = 32'b1_01010101_0101_0101_0_00001_1101111; // jal x1, offset
        #10;

        $finish;
    end

endmodule

