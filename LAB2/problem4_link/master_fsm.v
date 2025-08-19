// master_fsm_2005.v
// 4-byte burst master with 4-phase req/ack handshake.
// Synchronous, active-high reset. Moore-style outputs.

module master_fsm #(
  parameter BURST_BYTES = 4
)(
  input  wire        clk,
  input  wire        rst,         // synchronous, active-high
  input  wire        ack,
  output reg         req,
  output reg  [7:0]  data,
  output reg         done         // 1-cycle pulse at end of burst
);

  // State encoding (no typedef/enum in 2005)
  localparam M0_IDLE       = 2'd0;
  localparam M1_REQ        = 2'd1;
  localparam M2_WAITACKLOW = 2'd2;
  localparam M3_CLEANUP    = 2'd3;

  reg [1:0] state, state_n;

  // $clog2 not available in 2005 — hardcode for BURST_BYTES=4
  // (2 bits needed to count 0..3)
  reg [1:0] cnt, cnt_n;

  // Simple ROM
  reg [7:0] byte_rom [0:BURST_BYTES-1];

  integer i;
  initial begin
    for (i=0;i<BURST_BYTES;i=i+1) byte_rom[i] = 8'hA0 + i[7:0];
  end

  // Output regs
  reg req_n, done_n;
  reg [7:0] data_n;

  // Next-state / output logic
  always @(*) begin
    // defaults
    state_n = state;
    cnt_n   = cnt;
    req_n   = 1'b0;
    done_n  = 1'b0;
    data_n  = byte_rom[cnt];

    case (state)
      M0_IDLE: begin
        if (cnt < BURST_BYTES) begin
          state_n = M1_REQ;
          req_n   = 1'b1;
        end
      end

      M1_REQ: begin
        req_n  = 1'b1;
        if (ack) begin
          state_n = M2_WAITACKLOW;
          req_n   = 1'b0;
        end
      end

      M2_WAITACKLOW: begin
        if (!ack) begin
          if (cnt + 1 < BURST_BYTES) begin
            cnt_n   = cnt + 1;
            data_n  = byte_rom[cnt_n];
            state_n = M1_REQ;
            req_n   = 1'b1;
          end else begin
            state_n = M3_CLEANUP;
            done_n  = 1'b1;
          end
        end
      end

      M3_CLEANUP: begin
        state_n = M0_IDLE;
        done_n  = 1'b0;
        cnt_n   = 2'd0;
      end

      default: state_n = M0_IDLE;
    endcase
  end

  // Sequential regs
  always @(posedge clk) begin
    if (rst) begin
      state <= M0_IDLE;
      cnt   <= 2'd0;
      req   <= 1'b0;
      done  <= 1'b0;
      data  <= 8'h00;
    end else begin
      state <= state_n;
      cnt   <= cnt_n;
      req   <= req_n;
      done  <= done_n;
      data  <= data_n;
    end
  end

endmodule
