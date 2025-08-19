`timescale 1ns/1ps

module tb_vending_mealy;

  reg        clk;
  reg        rst;
  reg  [1:0] coin;
  wire       dispense;
  wire       chg5;

  // DUT instantiation
  vending_mealy dut (
    .clk(clk),
    .rst(rst),
    .coin(coin),
    .dispense(dispense),
    .chg5(chg5)
  );

  // Clock: 100 MHz (10 ns period)
  initial clk = 1'b0;
  always  #5 clk = ~clk;

  // Helper task
  task step(input [1:0] c);
    begin
      coin = c;
      @(posedge clk);
      $display("[%0t] coin=%b -> dispense=%0d chg5=%0d",
               $time, coin, dispense, chg5);
      coin = 2'b00; // back to idle
    end
  endtask

  // Stimulus
  initial begin
    $dumpfile("vending_mealy_tb.vcd");
    $dumpvars(0, tb_vending_mealy);

    coin = 2'b00;
    rst  = 1'b1;
    repeat (2) @(posedge clk);
    rst  = 1'b0;

    // A) 10,10 => vend
    $display("\n-- A) 10,10 -> vend --");
    step(2'b10);
    step(2'b10);

    // B) 5,5,5,5 => vend
    $display("\n-- B) 5,5,5,5 -> vend --");
    step(2'b01);
    step(2'b01);
    step(2'b01);
    step(2'b01);

    // C) 10,5,10 => vend + change
    $display("\n-- C) 10,5,10 -> vend + change --");
    step(2'b10);
    step(2'b01);
    step(2'b10);

    // D) 5,10,5 => vend
    $display("\n-- D) 5,10,5 -> vend --");
    step(2'b01);
    @(posedge clk);
    step(2'b10);
    @(posedge clk);
    step(2'b01);

    repeat (3) @(posedge clk);
    $finish;
  end

endmodule
