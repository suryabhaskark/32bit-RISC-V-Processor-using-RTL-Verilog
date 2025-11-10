`timescale 1ns/1ps

module Data_Memory_tb;

    reg clk;
    reg memRead;
    reg memWrite;
    reg [31:0] address;
    reg [31:0] writeData;
    wire [31:0] readData;

    Data_Memory DUT (
        .clk(clk),
        .memRead(memRead),
        .memWrite(memWrite),
        .address(address),
        .writeData(writeData),
        .readData(readData)
    );


    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        
        //$dumpfile("Data_Memory_tb.vcd");
        //$dumpvars(0, Data_Memory_tb);
        memRead = 0; memWrite = 0; address = 0; writeData = 0;

        // Writing some data
        #10; address = 32'd0; writeData = 32'hAABBCCDD; memWrite = 1; #10;
        memWrite = 0;

        // Read the data back
        #10; memRead = 1; #10;
        memRead = 0;

        // Write at another address
        #10; address = 32'd4; writeData = 32'h11223344; memWrite = 1; #10;
        memWrite = 0;

        // Read new address
        #10; memRead = 1; #10;
        memRead = 0;

        $finish;
    end

endmodule

