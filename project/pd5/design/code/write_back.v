module write_back (
    input clock,
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