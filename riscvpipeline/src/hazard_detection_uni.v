module hazard_detection_unit(
    input logic MemReadE,         // Load in Execute stage
    input logic [4:0] RD_E,       // Destination reg in EX
    input logic [4:0] Rs1_D, Rs2_D, // Source regs in Decode
    input logic PCSrcE,           // Branch taken
    output logic StallF,          // Stall Fetch stage
    output logic StallD,          // Stall Decode stage
    output logic FlushE,          // Flush Execute stage
    output logic FlushD           // Flush Decode stage
);
    // Detect load-use hazard: load followed by dependent instruction
    logic load_use_hazard;
    assign load_use_hazard = MemReadE && 
                             ((RD_E == Rs1_D) || (RD_E == Rs2_D)) && 
                             (RD_E != 5'd0);

    // Default: no stall/flush
    assign StallF = load_use_hazard;
    assign StallD = load_use_hazard;
    assign FlushE = load_use_hazard || PCSrcE;
    assign FlushD = PCSrcE;  // flush wrong-path instruction
endmodule
