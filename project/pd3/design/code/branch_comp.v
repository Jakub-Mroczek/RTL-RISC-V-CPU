module branch_comp (
  input [31:0] data_rs1,
  input [31:0] data_rs2,
  input BrUn,
  output reg BrEq,
  output reg BrLT
);

    always @ (*) begin
        // set BrEq
        if (data_rs1 == data_rs2) begin
            BrEq = 1'b1;
            BrLT = 1'b0;
        end
        else begin
            BrEq = 1'b0;

            // set BrLt
            // unsigned compare
            if (BrUn) begin
                if(data_rs1 < data_rs2)
                    BrLT = 1'b1;
                else
                    BrLT = 1'b0;
            end

            // signed compare
            else begin
                if(data_rs1[31] == 1 && data_rs2[31] == 0)
                    BrLT = 1'b1;
                else if(data_rs1[31] == 0 && data_rs2[31] == 1)
                    BrLT = 1'b0;
                else begin
                    if(data_rs1 < data_rs2)
                        BrLT = 1'b1;
                    else
                        BrLT = 1'b0;
                end
            end
        end
    end
endmodule