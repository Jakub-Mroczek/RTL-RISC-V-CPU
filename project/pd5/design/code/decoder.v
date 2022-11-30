module decoder (
  input [31:0] INSN,
  output reg [6:0] OPCODE,
  output reg [4:0] RD,
  output reg [4:0] RS1,
  output reg [4:0] RS2,
  output reg [2:0] FUNCT3,
  output reg [6:0] FUNCT7,
  output reg [31:0] IMM,
  output reg [4:0] SHAMT
);

  always @ (*) begin
    OPCODE = INSN[6:0];

    // $display(OPCODE);

    case(INSN[6:0])

      // R Type
      7'b0110011: begin
        //instruction fields
        RD = INSN[11:7];
        FUNCT3 = INSN[14:12];
        RS1 = INSN[19:15];
        RS2 = INSN[24:20];
        FUNCT7 = INSN[31:25];

        //non-instruction fields
        IMM = 32'b0;
        SHAMT = 5'b0;

        // $display("R-TYPE:: INSN: 0x%0h, RD: 0x%0h, FUNCT3: 0x%0h, RS1: 0x%0h, RS2: 0x%0h, FUNCT7: 0x%0h, IMM: 0x%0h, SHAMT: 0x%0h", INSN, RD, FUNCT3, RS1, RS2, FUNCT7, IMM, SHAMT);
      end

      // I Type load
      7'b0000011: begin
        // instruction fields
        RD = INSN[11:7];
        FUNCT3 = INSN[14:12];
        RS1 = INSN[19:15];
        IMM = {{20{INSN[31]}},INSN[31:20]};

        // non-instruction fields
        RS2 = 5'b0;
        SHAMT = 5'b0;
        FUNCT7 = 7'b0;

        // $display("I-TYPE:: INSN: 0x%0h, RD: 0x%0h, FUNCT3: 0x%0h, RS1: 0x%0h, RS2: 0x%0h, FUNCT7: 0x%0h, IMM: 0x%0h, SHAMT: 0x%0h", INSN, RD, FUNCT3, RS1, RS2, FUNCT7, IMM, SHAMT);
      end

      // I Type
      7'b0010011: begin
        // instruction fields
        RD = INSN[11:7];
        FUNCT3 = INSN[14:12];
        RS1 = INSN[19:15];
        SHAMT = INSN[24:20];
        IMM = {{20{INSN[31]}},INSN[31:20]};

        // non-instruction fields
        RS2 = 5'b0;
        FUNCT7 = 7'b0;

        // $display("I-TYPE:: INSN: 0x%0h, RD: 0x%0h, FUNCT3: 0x%0h, RS1: 0x%0h, RS2: 0x%0h, FUNCT7: 0x%0h, IMM: 0x%0h, SHAMT: 0x%0h", INSN, RD, FUNCT3, RS1, RS2, FUNCT7, IMM, SHAMT);
      end

      // JALR Type (same as I)
      7'b1100111: begin
        // instruction fields
        RD = INSN[11:7];
        FUNCT3 = INSN[14:12];
        RS1 = INSN[19:15];
        IMM = {{20{INSN[31]}},INSN[31:20]};

        // non-instruction fields
        RS2 = 5'b0;
        SHAMT = 5'b0;
        FUNCT7 = 7'b0;

        // $display("JALR-TYPE:: INSN: 0x%0h, RD: 0x%0h, FUNCT3: 0x%0h, RS1: 0x%0h, RS2: 0x%0h, FUNCT7: 0x%0h, IMM: 0x%0h, SHAMT: 0x%0h", INSN, RD, FUNCT3, RS1, RS2, FUNCT7, IMM, SHAMT);
      end

      // S Type
      7'b0100011: begin
        // instruction fields
        FUNCT3 = INSN[14:12];
        RS1 = INSN[19:15];
        RS2 = INSN[24:20];
        IMM = {{20{INSN[31]}},INSN[31:25],INSN[11:7]};
        
        // non-instruction fields
        RD = 5'b0;
        SHAMT = 5'b0;
        FUNCT7 = 7'b0;

        // $display("S-TYPE:: INSN: 0x%0h, RD: 0x%0h, FUNCT3: 0x%0h, RS1: 0x%0h, RS2: 0x%0h, FUNCT7: 0x%0h, IMM: 0x%0h, SHAMT: 0x%0h", INSN, RD, FUNCT3, RS1, RS2, FUNCT7, IMM, SHAMT);
      end

      // B Type
      7'b1100011: begin
        // instruction fields
        FUNCT3 = INSN[14:12];
        RS1 = INSN[19:15];
        RS2 = INSN[24:20];
        IMM = {{19{INSN[31]}},INSN[31],INSN[7],INSN[30:25],INSN[11:8],1'b0};
        
        // non-instruction fields
        RD = 5'b0;
        SHAMT = 5'b0;
        FUNCT7 = 7'b0;

        // $display("B-TYPE:: INSN: 0x%0h, RD: 0x%0h, FUNCT3: 0x%0h, RS1: 0x%0h, RS2: 0x%0h, FUNCT7: 0x%0h, IMM: 0x%0h, SHAMT: 0x%0h", INSN, RD, FUNCT3, RS1, RS2, FUNCT7, IMM, SHAMT);
      end

      // U Type 0
      7'b0010111: begin
        // instruction fields
        RD = INSN[11:7];
        IMM = {INSN[31:12],12'b0};
        
        // non-instruction fields
        SHAMT = 5'b0;
        FUNCT7 = 7'b0;
        RS1 = 5'b0;
        RS2 = 5'b0;
        FUNCT3 = 3'b0;

        // $display("U-TYPE:: INSN: 0x%0h, RD: 0x%0h, FUNCT3: 0x%0h, RS1: 0x%0h, RS2: 0x%0h, FUNCT7: 0x%0h, IMM: 0x%0h, SHAMT: 0x%0h", INSN, RD, FUNCT3, RS1, RS2, FUNCT7, IMM, SHAMT);
      end

      // U Type 1
      7'b0110111: begin
        // instruction fields
        RD = INSN[11:7];
        IMM = {INSN[31:12],12'b0};
        
        // non-instruction fields
        SHAMT = 5'b0;
        FUNCT7 = 7'b0;
        RS1 = 5'b0;
        RS2 = 5'b0;
        FUNCT3 = 3'b0;

        // $display("U-TYPE:: INSN: 0x%0h, RD: 0x%0h, FUNCT3: 0x%0h, RS1: 0x%0h, RS2: 0x%0h, FUNCT7: 0x%0h, IMM: 0x%0h, SHAMT: 0x%0h", INSN, RD, FUNCT3, RS1, RS2, FUNCT7, IMM, SHAMT);
      end

      // J Type (JAL)
      7'b1101111: begin
        // instruction fields
        RD = INSN[11:7];
        IMM = {{11{INSN[31]}},INSN[31],INSN[19:12],INSN[20],INSN[30:21],1'b0};
        
        // non-instruction fields
        SHAMT = 5'b0;
        FUNCT7 = 7'b0;
        RS1 = 5'b0;
        RS2 = 5'b0;
        FUNCT3 = 3'b0;

        // $display("J-TYPE:: INSN: 0x%0h, RD: 0x%0h, FUNCT3: 0x%0h, RS1: 0x%0h, RS2: 0x%0h, FUNCT7: 0x%0h, IMM: 0x%0h, SHAMT: 0x%0h", INSN, RD, FUNCT3, RS1, RS2, FUNCT7, IMM, SHAMT);
      end

      // ECALL Type
      7'b1110011: begin
        RD = 5'b0;
        SHAMT = 5'b0;
        FUNCT7 = 7'b0;
        RS1 = 5'b0;
        RS2 = 5'b0;
        FUNCT3 = 3'b0;
        IMM = 32'b0;

        // $display("ECALL:: INSN: 0x%0h, RD: 0x%0h, FUNCT3: 0x%0h, RS1: 0x%0h, RS2: 0x%0h, FUNCT7: 0x%0h, IMM: 0x%0h, SHAMT: 0x%0h", INSN, RD, FUNCT3, RS1, RS2, FUNCT7, IMM, SHAMT);
      end

      // default case
      default: begin
        RD = 5'b0;
        SHAMT = 5'b0;
        FUNCT7 = 7'b0;
        RS1 = 5'b0;
        RS2 = 5'b0;
        FUNCT3 = 3'b0;
        IMM = 32'b0;

        // $display("DEFAULT:: INSN: 0x%0h, RD: 0x%0h, FUNCT3: 0x%0h, RS1: 0x%0h, RS2: 0x%0h, FUNCT7: 0x%0h, IMM: 0x%0h, SHAMT: 0x%0h", INSN, RD, FUNCT3, RS1, RS2, FUNCT7, IMM, SHAMT);
      end
    endcase
  end
endmodule
