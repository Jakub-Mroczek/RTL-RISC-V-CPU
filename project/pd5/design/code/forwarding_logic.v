module forwarding_logic (
    input BrEq,
    input BrLT,
    input [6:0] D_INSN_OPCODE,
    input [4:0] D_INSN_RD,
    input [4:0] D_INSN_RS1, 
    input [4:0] D_INSN_RS2,
    input [2:0] D_INSN_FUNCT3,
    input [6:0] D_INSN_FUNCT7,
    input [31:0] D_INSN_IMM,
    input [4:0] D_INSN_SHAMT,
    input [6:0] X_INSN_OPCODE,
    input [4:0] X_INSN_RD,
    input [4:0] X_INSN_RS1,
    input [4:0] X_INSN_RS2,
    input [2:0] X_INSN_FUNCT3,
    input [6:0] X_INSN_FUNCT7,
    input [31:0] X_INSN_IMM,
    input [4:0] X_INSN_SHAMT,
    input [6:0] M_INSN_OPCODE,
    input [4:0] M_INSN_RD,
    input [4:0] M_INSN_RS1,
    input [4:0] M_INSN_RS2,
    input [2:0] M_INSN_FUNCT3,
    input [6:0] M_INSN_FUNCT7,
    input [31:0] M_INSN_IMM,
    input [4:0] M_INSN_SHAMT,
    input [6:0] W_INSN_OPCODE,
    input [4:0] W_INSN_RD,
    input [4:0] W_INSN_RS1,
    input [4:0] W_INSN_RS2,
    input [2:0] W_INSN_FUNCT3,
    input [6:0] W_INSN_FUNCT7,
    input [31:0] W_INSN_IMM,
    input [4:0] W_INSN_SHAMT,
    
    output reg [1:0] ALU_A_SEL,
    output reg [1:0] ALU_B_SEL,
    output DMEM_DATA_SEL,
    output reg PCSel,
    output reg RegWEn,
    output reg BrUn,
    output reg [3:0] ALUSel,
    output reg [1:0] access_size,
    output reg DMEM_RW,
    output reg [1:0] WBSel,
    // output reg [1:0] WALU_B_SEL,
    output reg stall
);

    // execute logic
    always @ (*) begin
        case(X_INSN_OPCODE)
            // R-types
            7'b0110011: begin
                PCSel = 1'b0;
                BrUn = 1'b0;
                stall = 1'b0;
                access_size = 2'b10;

                // M/X bypass
                if(X_INSN_RS1 == M_INSN_RD)
                    ALU_A_SEL = 2'b10;
                else if(X_INSN_RS1 == W_INSN_RD)
                    ALU_A_SEL = 2'b11;
                else
                    ALU_A_SEL = 2'b00;

                // W/X bypass
                if(X_INSN_RS2 == M_INSN_RD)
                    ALU_B_SEL = 2'b10;
                else if(X_INSN_RS2 == W_INSN_RD)
                    ALU_B_SEL = 2'b11;
                else
                    ALU_B_SEL = 2'b00;

                case(X_INSN_FUNCT3)
                    // ADD/SUB
                    3'b000: begin
                        // SUB
                        if (X_INSN_FUNCT7[5])
                            ALUSel = 4'b0100;
                        // ADD/ADDI
                        else
                            ALUSel = 4'b1000;
                    end
                    // SLL
                    3'b001:
                        ALUSel = 4'b1110;
                    // SLT
                    3'b010:
                        ALUSel = 4'b1100;       
                    // SLTU          
                    3'b011:
                        ALUSel = 4'b0110;     
                    // XOR          
                    3'b100:
                        ALUSel = 4'b1010;  
                    // SRL/SRA         
                    3'b101: begin
                        // SRA
                        if(X_INSN_FUNCT7[5])
                            ALUSel = 4'b1011;  
                        // SRL
                        else
                            ALUSel = 4'b0111;  
                    end
                    // OR          
                    3'b110:
                        ALUSel = 4'b0000;         
                    // AND          
                    3'b111:
                        ALUSel = 4'b1111;    
                   default:
                        ALUSel = 4'b1000;             
                endcase
            end 
            // I types
            7'b0010011: begin
                PCSel = 1'b0;
                BrUn = 1'b0;
                ALU_B_SEL = 2'b01;
                stall = 1'b0;
                access_size = 2'b10;

                if(X_INSN_RS1 == M_INSN_RD)
                    ALU_A_SEL = 2'b10;
                else if(X_INSN_RS1 == W_INSN_RD)
                    ALU_A_SEL = 2'b11;
                else
                    ALU_A_SEL = 2'b00;

                case(X_INSN_FUNCT3)
                    // ADDI
                    3'b000:
                        ALUSel = 4'b1000;
                    // SLLI   
                    3'b001:
                        ALUSel = 4'b1110;
                    // SLTI
                    3'b010:
                        ALUSel = 4'b1100;
                    // SLTIU
                    3'b011:
                        ALUSel = 4'b0110;
                    // XORI
                    3'b100:
                        ALUSel = 4'b1010;
                    // SRLI/SRAI
                    3'b101: begin
                        // SRAI
                        if(X_INSN_FUNCT7[5])
                            ALUSel = 4'b1011;  
                        // SRLI
                        else
                            ALUSel = 4'b0111;  
                    end
                    // ORI
                    3'b110:
                        ALUSel = 4'b0000;
                    // ANDI
                    3'b111:
                        ALUSel = 4'b1111;
                    default:
                        ALUSel = 4'b1000;
                endcase

            end
            // I types but now they're loading wowza
            7'b0000011: begin
                PCSel = 1'b0;
                BrUn = 1'b0;
                ALUSel = 4'b1000;
                ALU_B_SEL = 2'b01;

                case(X_INSN_FUNCT3)
                    // LB
                    3'b000: begin
                        access_size = 2'b00;
                    end
                    // LH
                    3'b001: begin
                        access_size = 2'b01;
                    end
                    // LW
                    3'b010: begin   
                        access_size = 2'b10;               
                    end
                    // LBU
                    3'b100: begin  
                        access_size = 2'b00;                 
                    end
                    // LHU
                    3'b101: begin
                        access_size = 2'b01;
                    end
                    default:      
                        access_size = 2'b10;      
                endcase

                // M/X bypass
                if(X_INSN_RS1 == M_INSN_RD)
                    ALU_A_SEL = 2'b10;
                else if(X_INSN_RS1 == W_INSN_RD)
                    ALU_A_SEL = 2'b11;
                else
                    ALU_A_SEL = 2'b00;

                // load stall case
                if(X_INSN_RD == D_INSN_RS1)
                    stall = 1'b1;
                else if((X_INSN_RD == D_INSN_RS2) && (D_INSN_OPCODE != 7'b0100011))
                    stall = 1'b1;
                else
                    stall = 1'b0;
                
            end
            // S types
            7'b0100011: begin
                PCSel = 1'b0;
                BrUn = 1'b0;
                ALUSel = 4'b1000;
                ALU_A_SEL = 2'b00;
                ALU_B_SEL = 2'b01;
                stall = 1'b0;

                case(X_INSN_FUNCT3)
                    // SB
                    3'b000: begin
                        access_size = 2'b00;
                    end
                    // SH
                    3'b001: begin
                        access_size = 2'b01;
                    end
                    // SW
                    3'b010: begin   
                        access_size = 2'b10;               
                    end
                    default:      
                        access_size = 2'b10;      
                endcase   

                if(X_INSN_RS1 == M_INSN_RD)
                    ALU_A_SEL = 2'b10;
                else if(X_INSN_RS1 == W_INSN_RD)
                    ALU_A_SEL = 2'b11;
                else
                    ALU_A_SEL = 2'b00;
            end
            // B types
            7'b1100011: begin
                ALUSel = 4'b0011;
                ALU_A_SEL = 2'b01;
                ALU_B_SEL = 2'b01;
                stall = 1'b0;
                access_size = 2'b10;

                case(X_INSN_FUNCT3)
                    // BEQ
                    3'b000: begin
                        if(BrEq)
                            PCSel = 1'b1;
                        else
                            PCSel = 1'b0;
                    end
                    // BNE
                    3'b001: begin
                        if(!BrEq)
                            PCSel = 1'b1;
                        else
                            PCSel = 1'b0;
                    end
                    // BLT
                    3'b100: begin
                        if(BrLT)
                            PCSel = 1'b1;
                        else
                            PCSel = 1'b0;
                    end
                    // BGE
                    3'b101: begin
                        if(!BrLT)
                            PCSel = 1'b1;
                        else
                            PCSel = 1'b0;
                    end
                    // BLTU
                    3'b110: begin
                        if(BrLT)
                            PCSel = 1'b1;
                        else
                            PCSel = 1'b0;
                    end
                    // BGEU
                    3'b111: begin
                        if(!BrLT)
                            PCSel = 1'b1;
                        else
                            PCSel = 1'b0;
                    end
                    default: 
                        PCSel = 1'b0;
                endcase

                if(X_INSN_FUNCT3 < 3'b110)
                    BrUn = 1'b0;
                else
                    BrUn = 1'b1;
            end
            // AUIPC
            7'b0010111: begin
                PCSel = 1'b0;
                BrUn = 1'b0;
                ALUSel = 4'b1000;
                ALU_A_SEL = 2'b01;
                ALU_B_SEL = 2'b01;
                stall = 1'b0;
                access_size = 2'b10;
            end
            // LUI
            7'b0110111: begin
                PCSel = 1'b0;
                BrUn = 1'b0;
                ALUSel = 4'b1001;
                ALU_A_SEL = 2'b01;
                ALU_B_SEL = 2'b01;
                stall = 1'b0;
                access_size = 2'b10;
            end
            // JALR
            7'b1100111: begin
                PCSel = 1'b1;
                BrUn = 1'b0;
                ALUSel = 4'b0010;
                ALU_B_SEL = 2'b01;
                stall = 1'b0;
                access_size = 2'b10;

                if(X_INSN_RS1 == M_INSN_RD)
                    ALU_A_SEL = 2'b10;
                else if(X_INSN_RS1 == W_INSN_RD)
                    ALU_A_SEL = 2'b11;
                else
                    ALU_A_SEL = 2'b00;

            end
            // JAL
            7'b1101111: begin
                PCSel = 1'b1;
                BrUn = 1'b0;
                ALUSel = 4'b0001;
                ALU_A_SEL = 2'b01;
                ALU_B_SEL = 2'b01;
                stall = 1'b0;
                access_size = 2'b10;
            end           
            // By default set everything to NOP condition
            default: begin
                PCSel = 1'b0;
                BrUn = 1'b0;
                ALUSel = 4'b0101;
                ALU_A_SEL = 2'b01;
                ALU_B_SEL = 2'b01;
                stall = 1'b0;
                access_size = 2'b10;
            end
        endcase
    end

    // writeback logic
    always @ (*) begin
        case(M_INSN_OPCODE)
            // R-types
            7'b0110011: begin
                RegWEn = 1'b1;
                WBSel = 2'b01;
            end 
            // I types
            7'b0010011: begin
                RegWEn = 1'b1;
                WBSel = 2'b01;
            end
            // I types but now they're loading wowza
            7'b0000011: begin
                RegWEn = 1'b1;
                WBSel = 2'b00;
            end
            // S types
            7'b0100011: begin
                RegWEn = 1'b0;
                WBSel = 2'b00; //WBSel = 2'bXX;
            end
            // B types
            7'b1100011: begin
                RegWEn = 1'b0;
                WBSel = 2'b00; //WBSel = 2'bXX;
            end
            // AUIPC
            7'b0010111: begin
                RegWEn = 1'b1;
                WBSel = 2'b01;
            end
            // LUI
            7'b0110111: begin
                RegWEn = 1'b1;
                WBSel = 2'b01;
            end
            // JALR
            7'b1100111: begin
                RegWEn = 1'b1;
                WBSel = 2'b10;
            end
            // JAL
            7'b1101111: begin
                RegWEn = 1'b1;
                WBSel = 2'b10;
            end           
            // By default set everything to NOP condition
            default: begin
                RegWEn = 1'b0;
                WBSel = 2'b00;
            end
        endcase
    end

endmodule