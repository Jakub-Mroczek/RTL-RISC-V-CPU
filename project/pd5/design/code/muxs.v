module alu_mux_old (
    input ASel,
    input BSel,
    input [31:0] pc,
    input [31:0] rs1,
    input [31:0] rs2,
    input [31:0] imm,
    output [31:0] output_a,
    output [31:0] output_b
);
    reg [31:0] output_a_reg;
    reg [31:0] output_b_reg;
    assign output_a = output_a_reg;
    assign output_b = output_b_reg;

    always @ (*) begin
        // ASel between pc and rs1
        if (ASel) 
            output_a_reg = pc;
        else 
            output_a_reg = rs1;

        // BSel between rs2 and imm
        if (BSel) 
            output_b_reg = imm;
        else 
            output_b_reg = rs2;
    end
endmodule

module alu_a_mux (
    input [1:0] ALU_A_SEL,
    input [31:0] rs1,
    input [31:0] pc,
    input [31:0] mem_res,
    input [31:0] wb_res,
    output reg [31:0] output_a
);

    always @ (*) begin
        
        case(ALU_A_SEL)

        // RS1
        2'b00: begin
            output_a = rs1;
        end
        // PC
        2'b01: begin
            output_a = pc;
        end
        // from memory
        2'b10: begin
            output_a = mem_res;
        end
        // from writeback
        2'b11: begin
            output_a = wb_res;
        end                        
        default: begin
            output_a = rs1;
        end
        endcase
    end
endmodule

module alu_b_mux (
    input [1:0] ALU_B_SEL,
    input [31:0] rs2,
    input [31:0] imm,
    input [31:0] mem_res,
    input [31:0] wb_res,
    output reg [31:0] output_b
);

    always @ (*) begin
        
        case(ALU_B_SEL)

        // RS2
        2'b00: begin
            output_b = rs2;
        end
        // IMM
        2'b01: begin
            output_b = imm;
        end
        // from memory
        2'b10: begin
            output_b = mem_res;
        end
        // from writeback
        2'b11: begin
            output_b = wb_res;
        end                        
        default: begin
            output_b = rs2;
        end
        endcase
    end
endmodule

module wb_mux (
    input [1:0] wb_sel,
    input [31:0] pc,
    input [31:0] alu_res,
    input [31:0] dmem_data_out,
    output reg [31:0] write_back_data_out
);

    always @ (*) begin
        case (wb_sel)

            // PC
            2'b10: begin
                write_back_data_out = pc;
            end

            // ALU
            2'b01: begin
                write_back_data_out = alu_res;
            end

            // DMEM
            2'b00: begin
                write_back_data_out = dmem_data_out;
            end

            // default
            default: begin
                write_back_data_out = 32'h00000000;
            end
        endcase
    end
endmodule