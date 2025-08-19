`timescale 1ns/1ps

module vending_mealy(
  input  wire        clk,
  input  wire        rst,       // synchronous, active-high
  input  wire [1:0]  coin,      // 01=5, 10=10, 00=idle (11 ignored)
  output reg         dispense,  // 1-cycle pulse when vending
  output reg         chg5       // 1-cycle pulse when returning 5
);

  // ----------------------------------------------------------
  // State encoding (2 bits)
  // ----------------------------------------------------------
  localparam S0  = 2'd0;  // total = 0
  localparam S5  = 2'd1;  // total = 5
  localparam S10 = 2'd2;  // total = 10
  localparam S15 = 2'd3;  // total = 15

  reg [1:0] state, next;
  reg dispense_d, chg5_d;

  // ----------------------------------------------------------
  // Next-state + Mealy outputs
  // ----------------------------------------------------------
  always @(*) begin
    // defaults
    next        = state;
    dispense_d  = 1'b0;
    chg5_d      = 1'b0;

    case (state)
      // --------------------------
      S0: begin
        case (coin)
          2'b01: next = S5;    // +5
          2'b10: next = S10;   // +10
          default: next = S0;
        endcase
      end
      // --------------------------
      S5: begin
        case (coin)
          2'b01: next = S10;   // +5
          2'b10: next = S15;   // +10
          default: next = S5;
        endcase
      end
      // --------------------------
      S10: begin
        case (coin)
          2'b01: next = S15;                 // +5
          2'b10: begin                       // +10 -> vend (20)
            next       = S0;
            dispense_d = 1'b1;
            chg5_d     = 1'b0;
          end
          default: next = S10;
        endcase
      end
      // --------------------------
      S15: begin
        case (coin)
          2'b01: begin                       // +5 -> vend (20)
            next       = S0;
            dispense_d = 1'b1;
            chg5_d     = 1'b0;
          end
          2'b10: begin                       // +10 -> vend (25) + change
            next       = S0;
            dispense_d = 1'b1;
            chg5_d     = 1'b1;
          end
          default: next = S15;
        endcase
      end
      // --------------------------
      default: next = S0;
    endcase
  end

  // ----------------------------------------------------------
  // Sequential update: state + registered outputs
  // ----------------------------------------------------------
  always @(posedge clk) begin
    if (rst) begin
      state     <= S0;
      dispense  <= 1'b0;
      chg5      <= 1'b0;
    end else begin
      state     <= next;
      dispense  <= dispense_d;
      chg5      <= chg5_d;
    end
  end

endmodule
