/**
* Exercise 3.3 
* you can change the code below freely
  * */
module reg_and_arst (
  input  wire clock,
  input  wire areset,
  input  wire x,
  input  wire y,
  output reg  z
);

  always @ (posedge clock, posedge areset) begin
    case (areset) 
      1'b0    : z = x & y;
      default : z = 1'b0;
    endcase
  end
endmodule
