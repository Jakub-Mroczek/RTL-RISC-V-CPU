module pd0 (
  input clock,
  input reset
);

  /* demonstrating the usage of assign_and */
  reg assign_and_x;
  reg assign_and_y;
  wire assign_and_z;

  assign_and assign_and_0 (
    .x(assign_and_x),
    .y(assign_and_y),
    .z(assign_and_z)
  );

  /* Exercise 3.3 module/probes */
  wire EX33_areset;
  wire EX33_x;
  wire EX33_y;
  reg  EX33_z;

  reg_and_arst reg_and_arst_0 (
    .clock(clock),
    .areset(EX33_areset),
    .x(EX33_x),
    .y(EX33_y),
    .z(EX33_z)
  );

  /* Exercise 3.4 module/probes */
  wire EX34_x;
  wire EX34_y;
  reg  EX34_z;

  reg_and_reg reg_and_reg_0 (
    .clock(clock),
    .reset(reset),
    .x(EX34_x),
    .y(EX34_y),
    .z(EX34_z)
  );
  
endmodule
