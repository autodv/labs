// fv_sync_fifo: formal testbench for sync_fifo.
//
// Inputs are unconstrained except for the reset assumption. Internal signals of
// the DUT are reached with hierarchical references (dut.wr_ptr), the same way a
// bound checker sees them in a commercial flow.
module fv_sync_fifo (
    input logic       clk,
    input logic       rst,
    input logic       wr_en,
    input logic [7:0] wdata,
    input logic       rd_en
);

  localparam int WIDTH = 8;
  localparam int AW    = 2;
  localparam int DEPTH = 1 << AW;

  logic [WIDTH-1:0] rdata;
  logic             full, empty;
  logic [AW:0]      level;

  sync_fifo #(.WIDTH(WIDTH), .AW(AW)) dut (.*);

  logic f_past_valid = 1'b0;
  always_ff @(posedge clk) f_past_valid <= 1'b1;

  always_comb if (!f_past_valid) m_reset_first: assume (rst);

  // ---------------------------------------------------------------------------
  // Provided assertion: the FIFO never holds more than DEPTH entries.
  //   SVA: a_level_le_depth: assert property (@(posedge clk) level <= DEPTH);
  // ---------------------------------------------------------------------------
  always_comb if (f_past_valid) a_level_le_depth: assert (level <= DEPTH);

  // TODO (Task 2): strengthen the proof with an invariant that ties level to
  //                the read and write pointers (dut.wr_ptr, dut.rd_ptr).

  // TODO (Task 3): full and empty agree with level; a write while full and a
  //                read while empty leave level unchanged.

  // ---------------------------------------------------------------------------
  // Data integrity (Tasks 4 and 5). Track one arbitrary entry through the FIFO.
  //
  // A register with no reset whose next value is itself is a free constant:
  // the tool picks its initial value, and it never changes. Commercial tools
  // spell this "rand const" or a free variable with an $stable assumption.
  // ---------------------------------------------------------------------------
  logic [AW:0]      f_ptr;    // pointer value at which the tracked entry is written
  logic [WIDTH-1:0] f_data;   // the data it carries
  always_ff @(posedge clk) begin
    f_ptr  <= f_ptr;
    f_data <= f_data;
  end

  // f_in_fifo is 1 while the tracked entry is stored and not yet read.
  logic f_in_fifo;
  always_ff @(posedge clk)
    if (rst) f_in_fifo <= 1'b0;
    else if (wr_en && !full && dut.wr_ptr == f_ptr) f_in_fifo <= 1'b1;
    else if (rd_en && !empty && dut.rd_ptr == f_ptr) f_in_fifo <= 1'b0;

  // TODO (Task 4): assume the write at f_ptr carries f_data, and assert that
  //                rdata shows f_data while the tracked entry is at the head.

  // TODO (Task 5): invariants that make the data check inductive.

  // TODO (Task 6): covers.

endmodule
