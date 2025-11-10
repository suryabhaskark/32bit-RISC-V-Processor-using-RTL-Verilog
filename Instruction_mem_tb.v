`timescale 1ns/1ns

module InstructionMemory_tb();
    reg clk;
    reg [31:0] PC;
    wire [31:0] instr;

    InstructionMemory #(.DATA_WIDTH(32), .ADDR_WIDTH(8)) DUT (
        .clk(clk),
        .PC(PC),
        .instr(instr)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        PC = 0;

        //$dumpfile("IM_tb.vcd");
        //$dumpvars(0, InstructionMemory_tb);

        #10 PC = 4;
        #10 PC = 8;
        #10 PC = 12;
        #10 PC = 16;
        #10 PC = 20;

        #20 $finish;
    end

endmodule

