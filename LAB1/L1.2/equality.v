module equality(
    input [3:0] a,
    input [3:0] b,
    output equal
);

    // if a = b then send 1 else 0
    assign equal = (a == b ? 1 : 0);
endmodule