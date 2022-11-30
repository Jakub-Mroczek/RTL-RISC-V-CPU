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
  reg  [31:0] PD5_F_PC = 32'h01000000;
  reg  [31:0] PD5_F_INSN = 0;

  // decode
  reg [31:0] PD5_D_PC = 32'h01000000;
  wire [6:0] PD5_D_OPCODE = D_INSN_OPCODE;
  wire [4:0] PD5_D_RD = D_INSN_RD;
  wire [4:0] PD5_D_RS1 = D_INSN_RS1; 
  wire [4:0] PD5_D_RS2 = D_INSN_RS2; 
  wire [2:0] PD5_D_FUNCT3 = D_INSN_FUNCT3;
  wire [6:0] PD5_D_FUNCT7 = D_INSN_FUNCT7;
  wire [31:0] PD5_D_IMM = D_INSN_IMM;
  wire [4:0] PD5_D_SHAMT = D_INSN_SHAMT;

  // register file
  wire PD5_R_WRITE_ENABLE;
  wire [4:0] PD5_R_READ_RS1 = PD5_D_RS1;
  wire [4:0] PD5_R_READ_RS2 = PD5_D_RS2;
  wire [4:0] PD5_R_WRITE_DESTINATION = PD5_D_RD;
  reg [31:0] PD5_R_READ_RS1_DATA;
  reg [31:0] PD5_R_READ_RS2_DATA;

  // execute
  reg [31:0] PD5_E_PC = 32'h01000000;
  reg [31:0] PD5_E_ALU_RES;
  reg PD5_E_BR_TAKEN;

  // ALU
  wire [31:0] ALU_INPUT_A;
  wire [31:0] ALU_INPUT_B;
  wire [1:0] ALU_A_SEL;
  wire [1:0] ALU_B_SEL;
  wire [3:0] ALUSel;  

  // branch compare
  wire BrUn;
  wire BrEq;
  wire BrLT;

  // DMEM
  reg [31:0] PD5_M_PC = 32'h01000000;
  wire [31:0] PD5_M_ADDRESS;
  wire PD5_M_RW;
  wire [1:0] PD5_M_SIZE_ENCODED;
  reg [31:0] PD5_M_DATA;
  wire DMEM_DATA_SEL;

  // Writeback
  reg [31:0] PD5_W_PC = 32'h01000000;
  wire [1:0] PD5_W_ENABLE;
  wire [4:0] PD5_W_DESTINATION;
  wire [31:0] PD5_W_DATA;

  // Pipeline
  wire stall;

  // F/D registers
  reg [31:0] D_INSN = 0;
  reg [6:0] D_INSN_OPCODE;
  reg [4:0] D_INSN_RD;
  reg [4:0] D_INSN_RS1; 
  reg [4:0] D_INSN_RS2; 
  reg [2:0] D_INSN_FUNCT3;
  reg [6:0] D_INSN_FUNCT7;
  reg [31:0] D_INSN_IMM;
  reg [4:0] D_INSN_SHAMT;

  always @(posedge clock) begin
    if(reset) begin
      D_INSN <= 0;
    end
    else begin
      D_INSN <= PD5_F_INSN;
    end
  end

  // D/X registers
  reg [31:0] X_RS1;
  reg [31:0] X_RS2;
  reg [6:0] X_INSN_OPCODE;
  reg [4:0] X_INSN_RD;
  reg [4:0] X_INSN_RS1; 
  reg [4:0] X_INSN_RS2; 
  reg [2:0] X_INSN_FUNCT3;
  reg [6:0] X_INSN_FUNCT7;
  reg [31:0] X_INSN_IMM;
  reg [4:0] X_INSN_SHAMT;

  always @(posedge clock) begin
    if(reset) begin
      X_RS1 <= 0;
      X_RS2 <= 0;
      X_INSN_OPCODE <= 0;
      X_INSN_RD <= 0;
      X_INSN_RS1 <= 0; 
      X_INSN_RS2 <= 0; 
      X_INSN_FUNCT3 <= 0;
      X_INSN_FUNCT7 <= 0;
      X_INSN_IMM <= 0;
      X_INSN_SHAMT <= 0;
    end
    else begin
      X_RS1 <= PD5_R_READ_RS1_DATA;
      X_RS2 <= PD5_R_READ_RS2_DATA;
      X_INSN_OPCODE <= D_INSN_OPCODE;
      X_INSN_RD <= D_INSN_RD;
      X_INSN_RS1 <= D_INSN_RS1; 
      X_INSN_RS2 <= D_INSN_RS2; 
      X_INSN_FUNCT3 <= D_INSN_FUNCT3;
      X_INSN_FUNCT7 <= D_INSN_FUNCT7;
      X_INSN_IMM <= D_INSN_IMM;
      X_INSN_SHAMT <= D_INSN_SHAMT;
    end
  end

  // X/M registers
  reg [31:0] M_ALU;
  reg [31:0] M_RS2;
  reg [6:0] M_INSN_OPCODE;
  reg [4:0] M_INSN_RD;
  reg [4:0] M_INSN_RS1; 
  reg [4:0] M_INSN_RS2; 
  reg [2:0] M_INSN_FUNCT3;
  reg [6:0] M_INSN_FUNCT7;
  reg [31:0] M_INSN_IMM;
  reg [4:0] M_INSN_SHAMT;

  always @(posedge clock) begin
    if(reset) begin
      M_ALU <= 0;
      M_RS2 <= 0;
      M_INSN_OPCODE <= 0;
      M_INSN_RD <= 0;
      M_INSN_RS1 <= 0; 
      M_INSN_RS2 <= 0; 
      M_INSN_FUNCT3 <= 0;
      M_INSN_FUNCT7 <= 0;
      M_INSN_IMM <= 0;
      M_INSN_SHAMT <= 0;
    end
    else begin
      M_ALU <= PD5_E_ALU_RES;
      M_RS2 <= X_RS2;
      M_INSN_OPCODE <= X_INSN_OPCODE;
      M_INSN_RD <= X_INSN_RD;
      M_INSN_RS1 <= X_INSN_RS1; 
      M_INSN_RS2 <= X_INSN_RS2; 
      M_INSN_FUNCT3 <= X_INSN_FUNCT3;
      M_INSN_FUNCT7 <= X_INSN_FUNCT7;
      M_INSN_IMM <= X_INSN_IMM;
      M_INSN_SHAMT <= X_INSN_SHAMT;
    end
  end

  // M/W registers
  reg [6:0] W_INSN_OPCODE;
  reg [4:0] W_INSN_RD;
  reg [4:0] W_INSN_RS1; 
  reg [4:0] W_INSN_RS2; 
  reg [2:0] W_INSN_FUNCT3;
  reg [6:0] W_INSN_FUNCT7;
  reg [31:0] W_INSN_IMM;
  reg [4:0] W_INSN_SHAMT;
  reg [31:0] W_ALU;

  always @(posedge clock) begin
    if(reset) begin
      W_INSN_OPCODE <= 0;
      W_INSN_RD <= 0;
      W_INSN_RS1 <= 0; 
      W_INSN_RS2 <= 0; 
      W_INSN_FUNCT3 <= 0;
      W_INSN_FUNCT7 <= 0;
      W_INSN_IMM <= 0;
      W_INSN_SHAMT <= 0;
      W_ALU <= 0;
    end
    else begin
      W_INSN_OPCODE <= M_INSN_OPCODE;
      W_INSN_RD <= M_INSN_RD;
      W_INSN_RS1 <= M_INSN_RS1; 
      W_INSN_RS2 <= M_INSN_RS2; 
      W_INSN_FUNCT3 <= M_INSN_FUNCT3;
      W_INSN_FUNCT7 <= M_INSN_FUNCT7;
      W_INSN_IMM <= M_INSN_IMM;
      W_INSN_SHAMT <= M_INSN_SHAMT;
      W_ALU <= M_ALU;
    end
  end

  // Modules
  imemory imem_0 (
    .clock(clock),
    .address(PD5_F_PC),
    .data_in(data_in),
    .data_out(PD5_F_INSN),
    .read_write(read_write)
  );

  dmemory dmem_0 (
    .clock(clock),
    .address(PD5_M_ADDRESS),
    .data_in(PD5_R_READ_RS2_DATA),
    .data_out(PD5_M_DATA),
    .read_write(PD5_M_RW),
    .access_size(PD5_M_SIZE_ENCODED)
  );

  decoder dec_0(
    .INSN(D_INSN),
    .OPCODE(D_INSN_OPCODE),
    .RD(D_INSN_RD),
    .RS1(D_INSN_RS1),
    .RS2(D_INSN_RS2),
    .FUNCT3(D_INSN_FUNCT3),
    .FUNCT7(D_INSN_FUNCT7),
    .IMM(D_INSN_IMM),
    .SHAMT(D_INSN_SHAMT)
  );
  
  register_file reg_0 (
    .clock(clock),
    .RegWEn(PD5_R_WRITE_ENABLE),
    .addr_rs1(PD5_R_READ_RS1),
    .addr_rs2(PD5_R_READ_RS2),
    .addr_rd(PD5_R_WRITE_DESTINATION),
    .data_rd(PD5_W_DATA),
    .data_rs1(PD5_R_READ_RS1_DATA),
    .data_rs2(PD5_R_READ_RS2_DATA)
  );

  branch_comp branch_comp_0 (
    .data_rs1(X_RS1),
    .data_rs2(X_RS2),
    .BrUn(BrUn),
    .BrEq(BrEq),
    .BrLT(BrLT)
  );

  // control_logic control_logic_0 (
  //   .BrEq(BrEq),
  //   .BrLT(BrLT),
  //   .OPCODE(PD5_D_OPCODE),
  //   .RD(PD5_D_RD),
  //   .RS1(PD5_D_RS1),
  //   .RS2(PD5_D_RS2),
  //   .FUNCT3(PD5_D_FUNCT3),
  //   .FUNCT7(PD5_D_FUNCT7),
  //   .IMM(PD5_D_IMM),
  //   .SHAMT(PD5_D_SHAMT),
  //   .PCSel(PD5_E_BR_TAKEN),
  //   .RegWEn(PD5_R_WRITE_ENABLE),
  //   .BrUn(BrUn),
  //   .ASel(ASel),
  //   .BSel(BSel),
  //   .ALUSel(ALUSel),
  //   .access_size(PD5_M_SIZE_ENCODED),
  //   .DMEM_RW(PD5_M_RW),
  //   .WBSel(PD5_W_ENABLE)
  // );

  pc pc_0 (
    .clock(clock),
    .reset(reset),
    .PCSel(PD5_E_BR_TAKEN),
    .alu_res(PD5_E_ALU_RES),
    .pc_out_F(PD5_F_PC),
    .pc_out_D(PD5_D_PC),
    .pc_out_E(PD5_E_PC),
    .pc_out_M(PD5_M_PC),
    .pc_out_W(PD5_W_PC)
  );

  alu alu_0 (
    .ALUSel(ALUSel),
    .input_a(ALU_INPUT_A),
    .input_b(ALU_INPUT_B),
    .alu_res(PD5_E_ALU_RES)
  );

  alu_a_mux alu_a_mux_0 (
    .ALU_A_SEL(ALU_A_SEL),
    .rs1(X_RS1),
    .pc(PD5_E_PC),
    .mem_res(M_ALU),
    .wb_res(W_ALU),
    .output_a(ALU_INPUT_A)
  );

  alu_b_mux alu_b_mux_0 (
    .ALU_B_SEL(ALU_B_SEL),
    .rs2(X_RS2),
    .imm(X_INSN_IMM),
    .mem_res(M_ALU),
    .wb_res(W_ALU),
    .output_b(ALU_INPUT_B)
  );

  // alu_mux_old alu_mux_old_0 (
  //   .ASel(ASel),
  //   .BSel(BSel),
  //   .pc(PD5_E_PC),
  //   .rs1(PD5_R_READ_RS1_DATA),
  //   .rs2(PD5_R_READ_RS2_DATA),
  //   .imm(PD5_D_IMM),
  //   .output_a(ALU_INPUT_A),
  //   .output_b(ALU_INPUT_B)
  // );

  write_back write_back_0 (
    .clock(clock),
    .wb_sel(PD5_W_ENABLE),
    .pc(PD5_W_PC),
    .alu_res(PD5_E_ALU_RES),
    .dmem_data_out(PD5_M_DATA),
    .write_back_data_out(PD5_W_DATA)
  );


  forwarding_logic forwarding_logic_0 (
    .BrEq(BrEq),
    .BrLT(BrLT),
    .D_INSN_OPCODE(D_INSN_OPCODE),
    .D_INSN_RD(D_INSN_RD),
    .D_INSN_RS1(D_INSN_RS1),
    .D_INSN_RS2(D_INSN_RS2),
    .D_INSN_FUNCT3(D_INSN_FUNCT3),
    .D_INSN_FUNCT7(D_INSN_FUNCT7),
    .D_INSN_IMM(D_INSN_IMM),
    .D_INSN_SHAMT(D_INSN_SHAMT),
    .X_INSN_OPCODE(X_INSN_OPCODE),
    .X_INSN_RD(X_INSN_RD),
    .X_INSN_RS1(X_INSN_RS1),
    .X_INSN_RS2(X_INSN_RS2),
    .X_INSN_FUNCT3(X_INSN_FUNCT3),
    .X_INSN_FUNCT7(X_INSN_FUNCT7),
    .X_INSN_IMM(X_INSN_IMM),
    .X_INSN_SHAMT(X_INSN_SHAMT),
    .M_INSN_OPCODE(M_INSN_OPCODE),
    .M_INSN_RD(M_INSN_RD),
    .M_INSN_RS1(M_INSN_RS1),
    .M_INSN_RS2(M_INSN_RS2),
    .M_INSN_FUNCT3(M_INSN_FUNCT3),
    .M_INSN_FUNCT7(M_INSN_FUNCT7),
    .M_INSN_IMM(M_INSN_IMM),
    .M_INSN_SHAMT(M_INSN_SHAMT),
    .W_INSN_OPCODE(W_INSN_OPCODE),
    .W_INSN_RD(W_INSN_RD),
    .W_INSN_RS1(W_INSN_RS1),
    .W_INSN_RS2(W_INSN_RS2),
    .W_INSN_FUNCT3(W_INSN_FUNCT3),
    .W_INSN_FUNCT7(W_INSN_FUNCT7),
    .W_INSN_IMM(W_INSN_IMM),
    .W_INSN_SHAMT(W_INSN_SHAMT),

    .ALU_A_SEL(ALU_A_SEL),
    .ALU_B_SEL(ALU_B_SEL),
    .DMEM_DATA_SEL(DMEM_DATA_SEL),
    .PCSel(PD5_E_BR_TAKEN),
    .RegWEn(PD5_R_WRITE_ENABLE),
    .BrUn(BrUn),
    .ALUSel(ALUSel),
    .access_size(PD5_M_SIZE_ENCODED),
    .DMEM_RW(PD5_M_RW),
    // .WBSel(PD5_W_ENABLE),
    // .WALU_B_SEL(),
    .stall(stall)
  );

endmodule
