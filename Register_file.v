module Register_File (
    input               clk,
  input               reset,
    input               reg_write_en,         // Control signal for write
    input       [4:0]   reg_write_dest,       // Destination register (rd)
    input       [31:0]  reg_write_data,       // Data to write
    input       [4:0]   reg_read_addr_1,      // Source register 1 (rs1)
    input       [4:0]   reg_read_addr_2,      // Source register 2 (rs2)
    output      [31:0]  reg_read_data_1,      // Data from rs1
    output      [31:0]  reg_read_data_2       // Data from rs2
);

    reg [31:0] reg_array [31:0];

     integer i;
 

    // Register Reset on rising edge
    always @(posedge clk or posedge reset) begin
    if (reset) begin
        integer i;
        for (i = 0; i < 32; i = i + 1)
            reg_array[i] <= 32'd0;
    end else if (reg_write_en && reg_write_dest != 0) begin
        reg_array[reg_write_dest] <= reg_write_data;
    end
end

    // Reads (combinational)
    assign reg_read_data_1 = (reg_read_addr_1 == 0) ? 32'd0 : reg_array[reg_read_addr_1];
    assign reg_read_data_2 = (reg_read_addr_2 == 0) ? 32'd0 : reg_array[reg_read_addr_2];

endmodule
