`timescale 1ns/1ps

module pc_tb;
    reg clk, reset, PCSrc;
    reg [31:0] branch_target;
    wire [31:0] pc_curr;

    // Instantiate the PC module
    pc DUT (
        .clk(clk),
        .reset(reset),
        .branch_target(branch_target),
        .PCSrc(PCSrc),
        .pc_curr(pc_curr)
    );


    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
      //$dumpfile("PC_tb.vcd");
        //$dumpvars(0, pc_tb);
        reset = 1;
        branch_target = 32'h00000020; // Example branch target
        PCSrc = 0;

        // Release reset after 1 clock
        #12 reset = 0;

        // Normal increment (PCSrc = 0)
        #20 PCSrc = 0;

        // Take branch (PCSrc = 1)
        #10 PCSrc = 1;

        // Back to normal increment
        #10 PCSrc = 0;

        // Change branch target
        #10 branch_target = 32'h00000050;
        PCSrc = 1;

        #20 $stop;
    end

endmodule

