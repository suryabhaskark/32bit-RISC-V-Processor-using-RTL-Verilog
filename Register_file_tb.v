`timescale 1ns/1ns

module RegisterFile_tb;
    reg clk;
    reg reg_write_en;
    reg [4:0] reg_write_dest;
    reg [31:0] reg_write_data;
    reg [4:0] reg_read_addr_1;
    reg [4:0] reg_read_addr_2;
    wire [31:0] reg_read_data_1;
    wire [31:0] reg_read_data_2;

    // Instantiate the Register File
    Register_File DUT (
        .clk(clk),
        .reg_write_en(reg_write_en),
        .reg_write_dest(reg_write_dest),
        .reg_write_data(reg_write_data),
        .reg_read_addr_1(reg_read_addr_1),
        .reg_read_addr_2(reg_read_addr_2),
        .reg_read_data_1(reg_read_data_1),
        .reg_read_data_2(reg_read_data_2)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
      //$dumpfile("registerfile_tb.vcd");
        //$dumpvars(0, RegisterFile_tb);
        // Initialize inputs
        reg_write_en = 0;
        reg_write_dest = 0;
        reg_write_data = 0;
        reg_read_addr_1 = 0;
        reg_read_addr_2 = 0;

        #10;

        // Write 100 to register 1
        reg_write_en = 1;
        reg_write_dest = 5'd1;
        reg_write_data = 32'd100;
        #10;

        // Write 200 to register 2
        reg_write_dest = 5'd2;
        reg_write_data = 32'd200;
        #10;

        // Disable write, read registers 1 and 2
        reg_write_en = 0;
        reg_read_addr_1 = 5'd1;
        reg_read_addr_2 = 5'd2;
        #10;

        // Trying to write to x0 (should remain 0)
        reg_write_en = 1;
        reg_write_dest = 5'd0;
        reg_write_data = 32'd999;
        #10;

        // Read x0
        reg_write_en = 0;
        reg_read_addr_1 = 5'd0;
        #10;

        $finish;
    end

endmodule

