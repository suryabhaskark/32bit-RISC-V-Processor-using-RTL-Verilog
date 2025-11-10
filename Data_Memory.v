module Data_Memory (
    input         clk,
    input         memRead,     // 1 Read from memory
    input         memWrite,      // 1 Write to memory
    input  [31:0] address,       // ALU result
    input  [31:0] writeData,     // Data to write to memory (SW)
    output reg [31:0] readData   // Data read from memory (LW)
);

    // Byte-addressable memory (4KB)
    reg [7:0] memory [0:4095];
  
    // Memory Read
    always @(*) begin
        if (memRead) begin
          if (address[1:0] != 2'b00)
            $display("WARNING: Misaligned LOAD at time %0t, address = %h", $time, address);
            // Word Read
            readData = { memory[address + 3],
                         memory[address + 2],
                         memory[address + 1],
                         memory[address + 0] };
        end else begin
            readData = 32'b0;
        end
    end

    // Memory Write
    always @(posedge clk) begin
        if (memWrite) begin
          if (address[1:0] != 2'b00)
            $display("WARNING: Misaligned STORE at time %0t, address = %h", $time, address);
            // Word Write
            memory[address + 0] <= writeData[7:0];
            memory[address + 1] <= writeData[15:8];
            memory[address + 2] <= writeData[23:16];
            memory[address + 3] <= writeData[31:24];
        end
    end

endmodule
