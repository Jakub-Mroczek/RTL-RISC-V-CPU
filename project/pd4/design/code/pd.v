module pd (
  input clock,
  input reset
);
  // // this came with pd.v dunno why they did it like this
  // reg [31:0] pc;
  // always @(posedge clock) begin
  //   if(reset) pc <= 0;
  //   else pc <= pc + 1;
  // end
   
  // fetch
  wire [31:0] data_in;
  wire read_write;
  assign read_write = 1'b0; //always read
  reg  [31:0] PD4_F_PC = 32'h01000000;
  reg  [31:0] PD4_F_INSN;

  // decode
  reg [6:0] PD4_D_OPCODE;
  reg [31:0] PD4_D_PC = 32'h01000000;
  reg [4:0] PD4_D_RD;
  reg [4:0] PD4_D_RS1; 
  reg [4:0] PD4_D_RS2; 
  reg [2:0] PD4_D_FUNCT3;
  reg [6:0] PD4_D_FUNCT7;
  reg [31:0] PD4_D_IMM;
  reg [4:0] PD4_D_SHAMT;

  // register file
  wire PD4_R_WRITE_ENABLE;
  wire [4:0] PD4_R_READ_RS1;
  wire [4:0] PD4_R_READ_RS2;
  wire [4:0] PD4_R_WRITE_DESTINATION;
  reg [31:0] PD4_R_READ_RS1_DATA;
  reg [31:0] PD4_R_READ_RS2_DATA;

  // execute
  reg [31:0] PD4_E_PC = 32'h01000000;
  reg [31:0] PD4_E_ALU_RES;
  reg PD4_E_BR_TAKEN;

  // branch compare
  wire BrUn;
  wire BrEq;
  wire BrLT;

  // A and B select
  wire ASel;
  wire BSel;
  wire [3:0] ALUSel;

  // DMEM
  reg [31:0] PD4_M_PC = 32'h01000000;
  wire [31:0] PD4_M_ADDRESS;
  wire PD4_M_RW;
  wire [1:0] PD4_M_SIZE_ENCODED;
  reg [31:0] PD4_M_DATA;

  // Writeback
  reg [31:0] PD4_W_PC = 32'h01000000;
  wire [1:0] PD4_W_ENABLE;
  wire [4:0] PD4_W_DESTINATION;
  wire [31:0] PD4_W_DATA;

  // assign address from instructions to register file inputs
  assign PD4_R_WRITE_DESTINATION = PD4_D_RD;
  assign PD4_R_READ_RS1 = PD4_D_RS1;
  assign PD4_R_READ_RS2 = PD4_D_RS2;

  imemory imem_0 (
    .clock(clock),
    .address(PD4_F_PC),
    .data_in(data_in),
    .data_out(PD4_F_INSN),
    .read_write(read_write)
  );

  dmemory dmem_0 (
    .clock(clock),
    .address(PD4_M_ADDRESS),
    .data_in(PD4_R_READ_RS2_DATA),
    .data_out(PD4_M_DATA),
    .read_write(PD4_M_RW),
    .access_size(PD4_M_SIZE_ENCODED)
  );

  decoder dec_0(
    .INSN(PD4_F_INSN),
    .OPCODE(PD4_D_OPCODE),
    .RD(PD4_D_RD),
    .RS1(PD4_D_RS1),
    .RS2(PD4_D_RS2),
    .FUNCT3(PD4_D_FUNCT3),
    .FUNCT7(PD4_D_FUNCT7),
    .IMM(PD4_D_IMM),
    .SHAMT(PD4_D_SHAMT)
  );
  
  register_file reg_0 (
    .clock(clock),
    .RegWEn(PD4_R_WRITE_ENABLE),
    .addr_rs1(PD4_R_READ_RS1),
    .addr_rs2(PD4_R_READ_RS2),
    .addr_rd(PD4_R_WRITE_DESTINATION),
    .data_rd(PD4_W_DATA),
    .data_rs1(PD4_R_READ_RS1_DATA),
    .data_rs2(PD4_R_READ_RS2_DATA)
  );

  branch_comp branch_comp_0 (
    .data_rs1(PD4_R_READ_RS1_DATA),
    .data_rs2(PD4_R_READ_RS2_DATA),
    .BrUn(BrUn),
    .BrEq(BrEq),
    .BrLT(BrLT)
  );

  control_logic control_logic_0 (
    .BrEq(BrEq),
    .BrLT(BrLT),
    .OPCODE(PD4_D_OPCODE),
    .RD(PD4_D_RD),
    .RS1(PD4_D_RS1),
    .RS2(PD4_D_RS2),
    .FUNCT3(PD4_D_FUNCT3),
    .FUNCT7(PD4_D_FUNCT7),
    .IMM(PD4_D_IMM),
    .SHAMT(PD4_D_SHAMT),
    .PCSel(PD4_E_BR_TAKEN),
    .RegWEn(PD4_R_WRITE_ENABLE),
    .BrUn(BrUn),
    .ASel(ASel),
    .BSel(BSel),
    .ALUSel(ALUSel),
    .access_size(PD4_M_SIZE_ENCODED),
    .DMEM_RW(PD4_M_RW),
    .WBSel(PD4_W_ENABLE)
  );

  pc pc_0 (
    .clock(clock),
    .reset(reset),
    .PCSel(PD4_E_BR_TAKEN),
    .alu_res(PD4_E_ALU_RES),
    .pc_out_F(PD4_F_PC),
    .pc_out_D(PD4_D_PC),
    .pc_out_E(PD4_E_PC),
    .pc_out_M(PD4_M_PC),
    .pc_out_W(PD4_W_PC)
  );

  alu alu_0 (
    .ASel(ASel),
    .BSel(BSel),
    .ALUSel(ALUSel),
    .pc(PD4_E_PC),
    .rs1(PD4_R_READ_RS1_DATA),
    .rs2(PD4_R_READ_RS2_DATA),
    .imm(PD4_D_IMM),
    .alu_res(PD4_E_ALU_RES)
  );

  write_back write_back_0 (
    .clock(clock),
    .wb_sel(PD4_W_ENABLE),
    .pc(PD4_W_PC),
    .alu_res(PD4_E_ALU_RES),
    .dmem_data_out(PD4_M_DATA),
    .write_back_data_out(PD4_W_DATA)
  );

endmodule
