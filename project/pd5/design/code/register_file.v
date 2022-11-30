module register_file (
  input clock,
  input RegWEn,
  input [4:0] addr_rs1,
  input [4:0] addr_rs2,
  input [4:0] addr_rd,
  input [31:0] data_rd,
  output reg [31:0] data_rs1,
  output reg [31:0] data_rs2
);

    reg [31:0] registers [31:0];

    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            if (i == 2)
                registers[i] = `MEM_DEPTH + 32'h01000000;
            else
                registers[i] = 32'b0;
        end
    end

    // Reading register file
    always @ (*) begin
        data_rs1 = registers[addr_rs1];
        data_rs2 = registers[addr_rs2];
    end

    // Writing to memory
    always @ (posedge clock) begin
        if (RegWEn) begin
            if (addr_rd == 5'b0)
                registers[addr_rd] <= 32'b0;
            else
                registers[addr_rd] <= data_rd;
        end
    end
endmodule