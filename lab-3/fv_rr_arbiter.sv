// fv_rr_arbiter: formal testbench for rr_arbiter.
//
// Per-requester properties live in a generate loop (g_req). Each copy gets its
// own hierarchical name, such as g_req[2].a_name, so a failure names the
// requester. A labeled assertion inside a plain procedural for loop would give
// every copy the same name, which Yosys rejects.
module fv_rr_arbiter (
    input logic       clk,
    input logic       rst,
    input logic [3:0] req
);

  localparam int N = 4;

  logic [N-1:0] gnt;

  rr_arbiter #(.N(N)) dut (.*);

  logic f_past_valid = 1'b0;
  always_ff @(posedge clk) f_past_valid <= 1'b1;

  always_comb if (!f_past_valid) m_reset_first: assume (rst);

  // ---------------------------------------------------------------------------
  // Provided assertion: at most one grant.
  //   SVA: a_onehot0: assert property (@(posedge clk) disable iff (rst) $onehot0(gnt));
  // ---------------------------------------------------------------------------
  always_comb if (f_past_valid && !rst) a_onehot0: assert ($onehot0(gnt));

  // TODO (Task 1): only requesting bits are granted; work conserving.

  // TODO (Task 2): requester protocol assumption (hold req until granted).

  // TODO (Task 3): bounded wait (fairness), one copy per requester.

  // TODO (Task 4): covers.

endmodule
