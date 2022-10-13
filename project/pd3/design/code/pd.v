module pd (
  input clock,
  input reset
);

  // fetch
  wire [31:0] data_in;
  wire read_write;
  assign read_write = 1'b0; //always read
  reg  [31:0] PD3_F_PC = 32'h01000000;
  reg  [31:0] PD3_F_INSN;

  // decode
  reg [6:0] PD3_D_OPCODE;
  reg [31:0] PD3_D_PC = 32'h01000000;
  reg [4:0] PD3_D_RD;
  reg [4:0] PD3_D_RS1; 
  reg [4:0] PD3_D_RS2; 
  reg [2:0] PD3_D_FUNCT3;
  reg [6:0] PD3_D_FUNCT7;
  reg [31:0] PD3_D_IMM;
  reg [4:0] PD3_D_SHAMT;

  // register file
  wire PD3_R_WRITE_ENABLE;
  wire [4:0] PD3_R_READ_RS1;
  wire [4:0] PD3_R_READ_RS2;
  wire [4:0] PD3_R_WRITE_DESTINATION;
  wire [31:0] PD3_R_WRITE_DATA;
  reg [31:0] PD3_R_READ_RS1_DATA;
  reg [31:0] PD3_R_READ_RS2_DATA;

  // execute
  reg [31:0] PD3_E_PC = 32'h01000000;
  reg [31:0] PD3_E_ALU_RES;
  reg PD3_E_BR_TAKEN;

  // branch compare
  wire BrUn;
  wire BrEq;
  wire BrLT;

  // A and B select
  wire ASel;
  wire BSel;
  wire [3:0] ALUSel;

  // assign address from instructions to register file inputs
  assign PD3_R_WRITE_DESTINATION = PD3_D_RD;
  assign PD3_R_READ_RS1 = PD3_D_RS1;
  assign PD3_R_READ_RS2 = PD3_D_RS2;

  imemory imem_0 (
    .clock(clock),
    .address(PD3_F_PC),
    .data_in(data_in),
    .data_out(PD3_F_INSN),
    .read_write(read_write)
  );

  decoder dec_0(
    .INSN(PD3_F_INSN),
    .OPCODE(PD3_D_OPCODE),
    .RD(PD3_D_RD),
    .RS1(PD3_D_RS1),
    .RS2(PD3_D_RS2),
    .FUNCT3(PD3_D_FUNCT3),
    .FUNCT7(PD3_D_FUNCT7),
    .IMM(PD3_D_IMM),
    .SHAMT(PD3_D_SHAMT)
  );

  register_file reg_0 (
    .clock(clock),
    .RegWEn(PD3_R_WRITE_ENABLE),
    .addr_rs1(PD3_R_READ_RS1),
    .addr_rs2(PD3_R_READ_RS2),
    .addr_rd(PD3_R_WRITE_DESTINATION),
    .data_rd(PD3_R_WRITE_DATA),
    .data_rs1(PD3_R_READ_RS1_DATA),
    .data_rs2(PD3_R_READ_RS2_DATA)
  );

  branch_comp branch_comp_0 (
    .data_rs1(PD3_R_READ_RS1_DATA),
    .data_rs2(PD3_R_READ_RS2_DATA),
    .BrUn(BrUn),
    .BrEq(BrEq),
    .BrLT(BrLT)
  );

  control_logic control_logic_0 (
    .BrEq(BrEq),
    .BrLT(BrLT),
    .OPCODE(PD3_D_OPCODE),
    .RD(PD3_D_RD),
    .RS1(PD3_D_RS1),
    .RS2(PD3_D_RS2),
    .FUNCT3(PD3_D_FUNCT3),
    .FUNCT7(PD3_D_FUNCT7),
    .IMM(PD3_D_IMM),
    .SHAMT(PD3_D_SHAMT),
    .PCSel(PD3_E_BR_TAKEN),
    .RegWEn(PD3_R_WRITE_ENABLE),
    .BrUn(BrUn),
    .ASel(ASel),
    .BSel(BSel),
    .ALUSel(ALUSel)
  );

  pc pc_0 (
    .clock(clock),
    .reset(reset),
    .PCSel(PD3_E_BR_TAKEN),
    .alu_res(PD3_E_ALU_RES),
    .pc_out_F(PD3_F_PC),
    .pc_out_D(PD3_D_PC),
    .pc_out_E(PD3_E_PC)
  );

  alu alu_0 (
    .ASel(ASel),
    .BSel(BSel),
    .ALUSel(ALUSel),
    .pc(PD3_E_PC),
    .rs1(PD3_R_READ_RS1_DATA),
    .rs2(PD3_R_READ_RS2_DATA),
    .imm(PD3_D_IMM),
    .alu_res(PD3_E_ALU_RES)
  );

endmodule
