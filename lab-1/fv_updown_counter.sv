// fv_updown_counter: formal testbench for updown_counter.
//
// The inputs of this wrapper (rst, inc, dec) are left unconstrained, so the
// formal tool may drive any value on every cycle. Assumptions narrow that down
// to legal stimulus; assertions state what the design must do; covers ask the
// tool to show that something can happen.
//
// Property style used in these labs
//   Runnable here:   always_ff @(posedge clk) if (<guard>) a_name: assert (<expr>);
//   Commercial SVA:  a_name: assert property (@(posedge clk) disable iff (rst) <seq>);
// The SVA form is given in a comment above each runnable property.
module fv_updown_counter (
    input logic clk,
    input logic rst,
    input logic inc,
    input logic dec
);

  localparam int WIDTH = 4;
  localparam logic [WIDTH-1:0] MAX = 4'd9;

  logic [WIDTH-1:0] count;
  logic             at_max;
  logic             at_min;

  updown_counter #(.WIDTH(WIDTH), .MAX(MAX)) dut (.*);

  // ---------------------------------------------------------------------------
  // f_past_valid is 0 in the first cycle and 1 forever after. Guard every
  // $past() with it: in cycle 0 there is no past, and $past returns a value the
  // tool is free to choose.
  // ---------------------------------------------------------------------------
  logic f_past_valid = 1'b0;
  always_ff @(posedge clk) f_past_valid <= 1'b1;

  // Start from reset: the design is in an arbitrary state in cycle 0.
  always_comb if (!f_past_valid) m_reset_first: assume (rst);

  // ---------------------------------------------------------------------------
  // Provided assertion: count never exceeds MAX.
  //   SVA: a_count_le_max: assert property (@(posedge clk) count <= MAX);
  // An invariant (true in every cycle) is checked in always_comb, so a failure
  // is reported on the step whose values break it.
  // ---------------------------------------------------------------------------
  always_comb if (f_past_valid) a_count_le_max: assert (count <= MAX);

  // TODO (Task 2): at_max and at_min agree with count.

  // TODO (Task 3): reset behaviour.

  // TODO (Task 4): increment, decrement and hold behaviour.

  // TODO (Task 5): covers.

endmodule
