`timescale 1ns/1ps

module ALU_tb;

    reg [31:0] srcA;
    reg [31:0] srcB;
    reg [4:0] alu_control;
    wire [31:0] alu_result;
    wire zero;


    ALU DUT (
        .srcA(srcA),
        .srcB(srcB),
        .alu_control(alu_control),
        .alu_result(alu_result),
        .zero(zero)
    );

    initial begin
        
        //$dumpfile("ALU_tb.vcd");
        //$dumpvars(0, ALU_tb);

        // ADD
        srcA = 10; srcB = 5; alu_control = 5'b00000; #10;
        // SUB
        alu_control = 5'b00001; #10;
        // AND
        alu_control = 5'b00010; #10;
        //OR
        alu_control = 5'b00011; #10;
        // XOR
        alu_control = 5'b00100; #10;
        //SLT
        alu_control = 5'b00101; #10;
        // SLTU
        alu_control = 5'b00110; #10;
        // SLL
        alu_control = 5'b00111; #10;
        //SRL
        alu_control = 5'b01000; #10;
        // SRA
        alu_control = 5'b01001; #10;
        // MUL
        alu_control = 5'b01010; #10;
        //DIV
        srcA = 20; srcB = 4; alu_control = 5'b01110; #10;
        // DIV by 0
        srcB = 0; #10;

        $finish;
    end

endmodule

