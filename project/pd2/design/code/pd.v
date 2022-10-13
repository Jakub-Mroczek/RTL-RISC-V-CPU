module pd(
  input clock,
  input reset
);

  //fetch
  wire [31:0] data_in;
  wire read_write;
  //always read
  assign read_write = 1'b0;
  reg  [31:0] PD2_F_PC = 32'h01000000;
  reg  [31:0] PD2_F_INSN;

  //decode
  reg [6:0] PD2_D_OPCODE;
  reg [31:0] PD2_D_PC;
  reg [4:0] PD2_D_RD;
  reg [4:0] PD2_D_RS1; 
  reg [4:0] PD2_D_RS2; 
  reg [2:0] PD2_D_FUNCT3;
  reg [6:0] PD2_D_FUNCT7;
  reg [31:0] PD2_D_IMM;
  reg [4:0] PD2_D_SHAMT;

  imemory imem_0 (
    .clock(clock),
    .address(PD2_F_PC),
    .data_in(data_in),
    .data_out(PD2_F_INSN),
    .read_write(read_write)
  );

  decoder dec_0(
    .INSN(PD2_F_INSN),
    .OPCODE(PD2_D_OPCODE),
    .RD(PD2_D_RD),
    .RS1(PD2_D_RS1),
    .RS2(PD2_D_RS2),
    .FUNCT3(PD2_D_FUNCT3),
    .FUNCT7(PD2_D_FUNCT7),
    .IMM(PD2_D_IMM),
    .SHAMT(PD2_D_SHAMT)
  );

  always @ (posedge clock) begin
    if(reset) begin
      PD2_F_PC <= 32'h01000000;
    end
    else begin
      PD2_F_PC <= PD2_F_PC + 32'd4;
    end
  end

endmodule
