/**
* Exercise 3.4
* you can change the code below freely
  * */
module reg_and_reg (
  input  wire clock,
  input  wire reset,
  input  wire x,
  input  wire y,
  output reg  z
);

  reg x_reg, y_reg;

  always @ (posedge clock) begin
    x_reg <= x;
    y_reg <= y;

    if (reset) 
      z <= 1'b0;
    else  
      z <= x_reg & y_reg;
  end
endmodule
