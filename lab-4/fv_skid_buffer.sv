// fv_skid_buffer: formal testbench for skid_buffer.
//
// Assume-guarantee at the ports: the upstream sender's obligations are
// assumptions (m_*), the buffer's obligations on its downstream port are
// assertions (a_*). If a neighbouring block were verified the same way, each
// assumption here would be an assertion there.
module fv_skid_buffer #(
    parameter int WIDTH = 8
) (
    input logic             clk,
    input logic             rst,
    input logic             s_valid,
    input logic [WIDTH-1:0] s_data,
    input logic             m_ready
);

  logic             s_ready;
  logic             m_valid;
  logic [WIDTH-1:0] m_data;

  skid_buffer #(.WIDTH(WIDTH)) dut (.*);

  logic f_past_valid = 1'b0;
  always_ff @(posedge clk) f_past_valid <= 1'b1;

  always_comb if (!f_past_valid) m_reset_first: assume (rst);

  // Transfers on each port.
  logic s_fire, m_fire;
  assign s_fire = s_valid && s_ready;
  assign m_fire = m_valid && m_ready;

  // ---------------------------------------------------------------------------
  // Provided: upstream protocol (assumption) and downstream protocol (assertion).
  //   SVA: m_s_hold: assume property (@(posedge clk) disable iff (rst)
  //          s_valid && !s_ready |=> s_valid && $stable(s_data));
  //   SVA: a_m_hold: assert property (@(posedge clk) disable iff (rst)
  //          m_valid && !m_ready |=> m_valid && $stable(m_data));
  // ---------------------------------------------------------------------------
  always_ff @(posedge clk) begin
    if (f_past_valid && !$past(rst) && $past(s_valid) && !$past(s_ready))
      m_s_hold: assume (s_valid && s_data == $past(s_data));
    if (f_past_valid && !$past(rst) && $past(m_valid) && !$past(m_ready))
      a_m_hold: assert (m_valid && m_data == $past(m_data));
  end

  // TODO (Task 1): after reset, m_valid is 0.

  // TODO (Task 2): count transfers on both ports; occupancy invariants.

  // TODO (Task 3): data integrity with a tracked transfer (free constants).

  // TODO (Task 4): invariants that make the data check inductive.

  // TODO (Task 7): covers.

endmodule
