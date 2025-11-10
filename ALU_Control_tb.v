`timescale 1ns/1ps

module ALU_Control_tb;

    reg [1:0] ALUOp;
    reg [2:0] funct3;
    reg [6:0] funct7;
    wire [4:0] alu_control;


    ALU_Control DUT (
        .ALUOp(ALUOp),
        .funct3(funct3),
        .funct7(funct7),
        .alu_control(alu_control)
    );

    initial begin
      
        //$dumpfile("ALU_Control_tb.vcd");
        //$dumpvars(0, ALU_Control_tb);

        // R-type ADD
        ALUOp = 2'b10; funct7 = 7'b0000000; funct3 = 3'b000; #10;
        // R-type SUB
        funct7 = 7'b0100000; funct3 = 3'b000; #10;
        // AND
        funct7 = 7'b0000000; funct3 = 3'b111; #10;
        // OR
        funct3 = 3'b110; #10;
        // XOR
        funct3 = 3'b100; #10;
        // SLT
        funct3 = 3'b010; #10;
        // SLL
        funct3 = 3'b001; #10;
        // SRL
        funct3 = 3'b101; #10;
        // SRA
        funct7 = 7'b0100000; #10;

        //I-type ADDI
        ALUOp = 2'b11; funct3 = 3'b000; funct7 = 7'b0000000; #10;
        //I-type ANDI
        funct3 = 3'b111; #10;
        // I-type ORI
        funct3 = 3'b110; #10;
        // I-type SRAI
        funct3 = 3'b101; funct7 = 7'b0100000; #10;
        
        // LW/SW (ALUOp=00, should always ADD)
        ALUOp = 2'b00; #10;
        // Branch (ALUOp=01, should always SUB)
        ALUOp = 2'b01; #10;

        $finish;
    end

endmodule

