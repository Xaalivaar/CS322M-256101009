module tb;
    reg [3:0] A;
    reg [3:0] B;    // Declare A and B as two buses
    wire C;         // Declare C as wire

    equality dut(
        .a(A),  // Connect A to a
        .b(B),  // Connect B to b
        .equal(C)   // Connect C to equal
    );

    integer i, j;

    initial begin
        $dumpfile("tb.vcd");
        $dumpvars(0, tb);
        // Generating all cases of test file
        for (i = 0; i < 16; i++) begin
            for (j = 0; j < 16; j++) begin
                A = i;
                B = j;
                #10; // For output to settle
            end
        end
        $display("Test is completed");
    end

endmodule  // Close the module