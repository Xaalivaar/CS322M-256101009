// slave_fsm_2005.v
// 4-phase responder. Latches data when req rises; asserts ack for >=2 cycles,
// and de-asserts ack after req goes low AND the hold time has completed.
// Synchronous, active-high reset. Moore-style ack.

module slave_fsm #(
  parameter ACK_HOLD = 2
)(
  input  wire        clk,
  input  wire        rst,     // synchronous active-high
  input  wire        req,
  input  wire [7:0]  data_in,
  output reg         ack,
  output reg  [7:0]  last_byte
);

  // State encoding (no typedef/enum in 2005)
  localparam S0_IDLE = 1'b0;
  localparam S1_ACK  = 1'b1;

  reg state, state_n;

  // $clog2 replacement: define function
  function integer clog2;
    input integer value;
    integer i;
    begin
      clog2 = 0;
      for (i = value - 1; i > 0; i = i >> 1)
        clog2 = clog2 + 1;
    end
  endfunction

  reg [clog2(ACK_HOLD+1)-1:0] hold, hold_n;
  reg ack_n;
  reg [7:0] last_byte_n;

  // Edge detect for "latch on req"
  reg  req_q;
  wire req_rise = (req && !req_q);

  // Next-state logic
  always @(*) begin
    // defaults
    state_n     = state;
    hold_n      = hold;
    ack_n       = 1'b0;
    last_byte_n = last_byte;

    case (state)
      S0_IDLE: begin
        ack_n = 1'b0;
        if (req) begin
          if (req_rise) begin
            last_byte_n = data_in;
            if (ACK_HOLD==0)
              hold_n = 0;
            else
              hold_n = ACK_HOLD-1;
          end
          state_n = S1_ACK;
          ack_n   = 1'b1;
        end
      end

      S1_ACK: begin
        ack_n = 1'b1;
        if (ACK_HOLD!=0 && hold != 0)
          hold_n = hold - 1;

        if (!req && (ACK_HOLD==0 || hold==0)) begin
          state_n = S0_IDLE;
          ack_n   = 1'b0;
        end

        if (req_rise) begin
          last_byte_n = data_in;
          if (ACK_HOLD==0)
            hold_n = 0;
          else
            hold_n = ACK_HOLD-1;
        end
      end
    endcase
  end

  // Sequential regs
  always @(posedge clk) begin
    if (rst) begin
      state     <= S0_IDLE;
      hold      <= 0;
      ack       <= 1'b0;
      last_byte <= 8'h00;
      req_q     <= 1'b0;
    end else begin
      state     <= state_n;
      hold      <= hold_n;
      ack       <= ack_n;
      last_byte <= last_byte_n;
      req_q     <= req;
    end
  end

endmodule
