`timescale 1ns/1ps

module tb_traffic_light;

  reg clk;
  reg rst;
  reg tick;
  wire ns_g, ns_y, ns_r;
  wire ew_g, ew_y, ew_r;

  // DUT instantiation
  traffic_light dut (
    .clk(clk),
    .rst(rst),
    .tick(tick),
    .ns_g(ns_g), .ns_y(ns_y), .ns_r(ns_r),
    .ew_g(ew_g), .ew_y(ew_y), .ew_r(ew_r)
  );

  // Clock generator: 10 ns period
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Tick generator: pulse once every 20 cycles (~200 ns here)
  integer cyc;
  initial begin
    cyc  = 0;
    tick = 0;
  end

  always @(posedge clk) begin
    cyc = cyc + 1;
    if (cyc % 2 == 0)
      tick <= 1;
    else
      tick <= 0;
  end

  // Stimulus
  initial begin
    // VCD dump for GTKWave
    $dumpfile("traffic.vcd");
    $dumpvars(0, tb_traffic_light);

    // Reset sequence
    rst = 1;
    #20;        // hold reset a couple cycles
    rst = 0;

    // Run long enough to observe multiple cycles
    #2000;

    $finish;
  end

endmodule
