module pd (
  input clock,
  input reset
);

  wire [31:0] data_in;
  wire read_write;
  reg  [31:0] PD1_F_PC;
  reg  [31:0] PD1_F_INSN;

  imemory imem_0 (
    .clock(clock),
    .address(PD1_F_PC),
    .data_in(data_in),
    .data_out(PD1_F_INSN),
    .read_write(read_write)
  );

  always @ (posedge clock) begin
    if(reset)
      PD1_F_PC = 32'h01000000;
    else
      PD1_F_PC = PD1_F_PC + 32'd4;
  end

endmodule
