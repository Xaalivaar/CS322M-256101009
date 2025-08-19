module tb_seq_detect_mealy;
    reg clk;
    reg rst;
    reg din;
    wire y;

    // Instantiate the DUT (Device Under Test)
    seq_detect_mealy dut(
        .clk(clk),
        .rst(rst),
        .din(din),
        .y(y)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100 MHz clock
    end

    // Test sequence
    initial begin
        // Initialize signals
        rst = 1;
        din = 0;
        #10 rst = 0; // Release reset

        // Drive a bitstream with overlaps
        // Example: 11011011101
        #10 din = 1; // S0 -> S1
        #10 din = 1; // S1 -> S2
        #10 din = 0; // S2 -> S3
        #10 din = 1; // S3 -> S4 (y=1)
        #10 din = 1; // S4 -> S2 (overlap)
        #10 din = 0; // S2 -> S3
        #10 din = 1; // S3 -> S4 (y=1)
        #10 din = 1; // S4 -> S2 (overlap)
        #10 din = 0; // S2 -> S3
        #10 din = 1; // S3 -> S4 (y=1)
        #10 din = 0; // S4 -> S0
        #10 din = 0; // S0 -> S0

        // Finish simulation
        #10 $finish;
    end

    // Dump waveform data
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_seq_detect_mealy);
    end
endmodule
