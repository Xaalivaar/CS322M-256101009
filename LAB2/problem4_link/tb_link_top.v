// tb_link_top_2005.v: testbench
`timescale 1ns/1ps

module tb_link_top;

  reg clk;
  reg rst;
  wire done;

  // Instantiate DUT
  link_top dut(.clk(clk), .rst(rst), .done(done));

  // Clock generation: 10ns period
  always #5 clk = ~clk;

  // Init signals, drive reset then run
  initial begin
    clk = 0;
    rst = 1;

    $dumpfile("wave.vcd");
    $dumpvars(0, tb_link_top);

    repeat (2) @(posedge clk);
    rst <= 1;
    @(posedge clk);
    rst <= 0;

    // run long enough for the 4 transfers to complete
    wait(done === 1'b1);
    @(posedge clk);
    $display("DONE observed at time %t", $time);
    repeat (4) @(posedge clk);
    $finish;
  end

  // Helpful monitors
  initial begin
    $display("t    req ack data  done  stateM stateS");
    $monitor("%t   %b   %b  0x%h   %b     %d      %d",
      $time,
      dut.u_master.req,
      dut.u_slave.ack,
      dut.u_master.data,
      dut.u_master.done,
      dut.u_master.state,
      dut.u_slave.state);
  end

endmodule
