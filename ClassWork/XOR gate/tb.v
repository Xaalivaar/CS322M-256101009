module tb;
    reg A, B;  // Declare A and B as reg
    wire C;    // Declare C as wire

    myxor dut(
        .a(A),  // Connect A to a
        .b(B),  // Connect B to b
        .y(C)   // Connect C to y
    );

    initial begin
        $dumpfile("tb.vcd");
        $dumpvars(0, tb);
        A = 0; B = 0;  // Use A and B for assignments
        #10;
        A = 0; B = 1;
        #10;
        A = 1; B = 0;
        #10;
        A = 1; B = 1;
        #10;
        $display("Test is completed");
    end

endmodule  // Close the module