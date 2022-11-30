module control_logic (
  input BrEq,
  input BrLT,
  input [6:0] OPCODE,
  input [4:0] RD,
  input [4:0] RS1,
  input [4:0] RS2,
  input [2:0] FUNCT3,
  input [6:0] FUNCT7,
  input [31:0] IMM,
  input [4:0] SHAMT,
  
  output reg PCSel,
  output reg RegWEn,
  output reg BrUn,
  output reg ASel,
  output reg BSel,
  output reg [3:0] ALUSel,
  output reg [1:0] access_size,
  output reg DMEM_RW,
  output reg [1:0] WBSel
);

    always @ (*) begin
        case(OPCODE)

            // R-types
            7'b0110011: begin
                PCSel = 1'b0;
                RegWEn = 1'b1;
                BrUn = 1'b0;
                ASel = 1'b0;
                BSel = 1'b0;
                access_size = 2'b10;
                DMEM_RW = 1'b0;
                WBSel = 2'b01;

                case(FUNCT3)
                    // ADD/SUB
                    3'b000: begin
                        // SUB
                        if (FUNCT7[5])
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
                        if(FUNCT7[5])
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
                RegWEn = 1'b1;
                BrUn = 1'b0;
                ASel = 1'b0;
                BSel = 1'b1;
                access_size = 2'b10;
                DMEM_RW = 1'b0;
                WBSel = 2'b01;

                case(FUNCT3)
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
                        if(FUNCT7[5])
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
            // Depending on load type memory is read from DMEM differently
            7'b0000011: begin
                PCSel = 1'b0;
                RegWEn = 1'b1;
                BrUn = 1'b0;
                ASel = 1'b0;
                BSel = 1'b1;
                ALUSel = 4'b1000;
                DMEM_RW = 1'b0;
                WBSel = 2'b00;

                case(FUNCT3)
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
            end

            // S types
            7'b0100011: begin
                PCSel = 1'b0;
                RegWEn = 1'b0;
                BrUn = 1'b0;
                ASel = 1'b0;
                BSel = 1'b1;
                ALUSel = 4'b1000;
                DMEM_RW = 1'b1;
                WBSel = 2'b00; //WBSel = 2'bXX;

                case(FUNCT3)
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
            end

            // B types
            7'b1100011: begin
                RegWEn = 1'b0;
                ASel = 1'b1;
                BSel = 1'b1;
                ALUSel = 4'b0011;
                access_size = 2'b10;
                DMEM_RW = 1'b0;
                WBSel = 2'b00; //WBSel = 2'bXX;

                case(FUNCT3)
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


                if(FUNCT3 < 3'b110)
                    BrUn = 1'b0;
                else
                    BrUn = 1'b1;
            end

            // AUIPC
            7'b0010111: begin
                PCSel = 1'b0;
                RegWEn = 1'b1;
                BrUn = 1'b0;
                ASel = 1'b1;
                BSel = 1'b1;
                ALUSel = 4'b1000;
                access_size = 2'b10;
                DMEM_RW = 1'b0;
                WBSel = 2'b01;
            end

            // LUI
            7'b0110111: begin
                PCSel = 1'b0;
                RegWEn = 1'b1;
                BrUn = 1'b0;
                ASel = 1'b1;
                BSel = 1'b1;
                ALUSel = 4'b1001;
                access_size = 2'b10;
                DMEM_RW = 1'b0;
                WBSel = 2'b01;
            end

            // JALR
            7'b1100111: begin
                PCSel = 1'b1;
                RegWEn = 1'b1;
                BrUn = 1'b0;
                ASel = 1'b0;
                BSel = 1'b1;
                ALUSel = 4'b0010;
                access_size = 2'b10;
                DMEM_RW = 1'b0;
                WBSel = 2'b10;
            end

            // JAL
            7'b1101111: begin
                PCSel = 1'b1;
                RegWEn = 1'b1;
                BrUn = 1'b0;
                ASel = 1'b1;
                BSel = 1'b1;
                ALUSel = 4'b0001;
                access_size = 2'b10;
                DMEM_RW = 1'b0;
                WBSel = 2'b10;
            end           

            // By default set everything to NOP condition
            default: begin
                PCSel = 1'b0;
                RegWEn = 1'b1;
                BrUn = 1'b0;
                ASel = 1'b0;
                BSel = 1'b1;
                ALUSel = 4'b0000;
                access_size = 2'b10;
                DMEM_RW = 1'b0;
                WBSel = 2'b00;
            end
        endcase
    end
endmodule