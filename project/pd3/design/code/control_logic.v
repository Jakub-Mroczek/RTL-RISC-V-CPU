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
  output reg [3:0] ALUSel
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
            7'b0000011: begin
                PCSel = 1'b0;
                RegWEn = 1'b1;
                BrUn = 1'b0;
                ASel = 1'b0;
                BSel = 1'b1;
                ALUSel = 4'b1000;
            end

            // S types
            7'b0100011: begin
                PCSel = 1'b0;
                RegWEn = 1'b0;
                BrUn = 1'b0;
                ASel = 1'b0;
                BSel = 1'b1;
                ALUSel = 4'b1000;
            end

            // B types
            7'b1100011: begin
                RegWEn = 1'b0;
                ASel = 1'b1;
                BSel = 1'b1;
                ALUSel = 4'b0011;

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
            end

            // LUI
            7'b0110111: begin
                PCSel = 1'b0;
                RegWEn = 1'b1;
                BrUn = 1'b0;
                ASel = 1'b1;
                BSel = 1'b1;
                ALUSel = 4'b1000;
            end

            // JALR
            7'b1100111: begin
                PCSel = 1'b1;
                RegWEn = 1'b1;
                BrUn = 1'b0;
                ASel = 1'b1;
                BSel = 1'b1;
                ALUSel = 4'b0010;
            end

            // JAL
            7'b1101111: begin
                PCSel = 1'b1;
                RegWEn = 1'b1;
                BrUn = 1'b0;
                ASel = 1'b1;
                BSel = 1'b1;
                ALUSel = 4'b0001;
            end           

            // By default set everything to NOP condition
            default: begin
                PCSel = 1'b0;
                RegWEn = 1'b1;
                BrUn = 1'b0;
                ASel = 1'b0;
                BSel = 1'b1;
                ALUSel = 4'b0000;
            end
        endcase
    end
endmodule