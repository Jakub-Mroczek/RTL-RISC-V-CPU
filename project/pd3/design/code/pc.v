module pc (
    input clock,
    input reset,
    input PCSel,
    input [31:0] alu_res,
    output reg [31:0] pc_out_F,
    output reg [31:0] pc_out_D,
    output reg [31:0] pc_out_E
);

    // PC select mux
    always @ (posedge clock) begin
        if (reset) begin
            pc_out_F <= 32'h01000000;
            pc_out_D <= 32'h01000000;
            pc_out_E <= 32'h01000000;
        end

        else begin
            
            if (PCSel) begin
                pc_out_F <= alu_res;
                pc_out_D <= alu_res;
                pc_out_E <= alu_res;
            end

            else begin
                pc_out_F <= pc_out_F + 32'd4;
                pc_out_D <= pc_out_D + 32'd4;
                pc_out_E <= pc_out_E + 32'd4;
            end
        end
    end
endmodule