module pc(
  input clk,
  input reset,
  input [31:0] branch_target,
  input [31:0] jump_target,
  input PCSrc,
  input Jump,
  output reg[31:0] pc_curr
);
always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc_curr <= 32'b0;
        end
        else begin
          if(Jump) begin
            pc_curr <= jump_target;
          end
          else if (PCSrc) begin
                pc_curr <= branch_target;    // Branch
          end
            else begin
                pc_curr <= pc_curr + 4;         // Normal next instruction
            end
        end
    end
endmodule

  