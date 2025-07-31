module mycomp(
    input a,
    input b,
    output o1, // a big
    output o2, // equal
    output o3  // a small
);

    assign o1 = (a > b) ? 1 : 0; 
    assign o2 = (a == b) ? 1 : 0;
    assign o3 = (a < b) ? 1 : 0; 

endmodule
