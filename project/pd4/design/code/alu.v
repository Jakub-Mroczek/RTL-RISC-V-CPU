module alu (
  input ASel,
  input BSel,
  input [3:0] ALUSel,
  input [31:0] pc,
  input [31:0] rs1,
  input [31:0] rs2,
  input [31:0] imm,
  output reg [31:0] alu_res
);

    reg [31:0] input_a;
    reg [31:0] input_b;

    always @ (*) begin
        // ASel between pc and rs1
        if (ASel) 
            input_a = pc;
        else 
            input_a = rs1;

        // BSel between rs2 and imm
        if (BSel) 
            input_b = imm;
        else 
            input_b = rs2;
    end

    // ALU mode
    always @(*) begin
        case (ALUSel) 
            // ADD/ADDI/AUIPC
            4'b1000: begin
                alu_res = input_a + input_b;
            end
            // SUB
            4'b0100: begin
                alu_res = input_a - input_b;
            end

            // SLL/SLLI (shift left logic)
            4'b1110: begin
                alu_res = input_a << input_b[4:0];
            end
            // SRL/SRLI (shift right logic)
            4'b0111: begin
                alu_res = input_a >> input_b[4:0];
            end
            // SRA/SRAI (shift right arithmetic)
            4'b1011: begin
                alu_res = input_a >>> input_b[4:0];
            end
  
            // SLT/SLTI (signed compare)
            4'b1100: begin           
                if(input_a[31] == 1 && input_b[31] == 0)
                    alu_res = 32'b1;
                else if(input_a[31] == 0 && input_b[31] == 1)
                    alu_res = 32'b0;
                else begin
                    if(input_a < input_b)
                        alu_res = 32'b1;
                    else
                        alu_res = 32'b0;
                end
            end
            // SLTU/SLTIU (unsigned compare)
            4'b0110: begin           
                if(input_a < input_b)
                    alu_res = 32'b1;
                else
                    alu_res = 32'b0;
            end

            // AND/ANDI
            4'b1111: begin
                alu_res = input_a & input_b;
            end
            // OR/ORI
            4'b0000: begin
                alu_res = input_a | input_b;
            end
            // XOR/XORI
            4'b1010: begin
                alu_res = input_a ^ input_b;
            end
            // JAL
            4'b0001: begin
                alu_res = input_a + input_b;
            end
            // LUI
            4'b1001: begin
                alu_res = input_b;
                // $display("[LUI] time:%t, %b, %d", $time, alu_res, alu_res);
            end            
            // JALR
            4'b0010: begin
                alu_res = input_a + input_b;
                alu_res = {alu_res[31:1], 1'b0};
            end
            // Branch
            4'b0011: begin
                alu_res = input_a + input_b;
            end
            // default
            default: begin
                alu_res = 32'b0;
            end
        endcase
    end
endmodule
                